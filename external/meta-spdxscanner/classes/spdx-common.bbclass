# This class supplys common functions.

HOSTTOOLS += "xz"
SPDX_DEPLOY_DIR ??= "${DEPLOY_DIR}/spdx"
SPDX_TOPDIR ?= "${WORKDIR}/spdx_sstate_dir"
SPDX_OUTDIR ?= "${SPDX_TOPDIR}/${TARGET_SYS}/${PF}/"
SPDX_WORKDIR ?= "${WORKDIR}/spdx_temp/"

SPDX_EXCLUDE_NATIVE ??= "1"
SPDX_EXCLUDE_SDK ??= "1"
SPDX_EXCLUDE_PACKAGES ??= ""


do_spdx[dirs] = "${WORKDIR}"

LICENSELISTVERSION = "2.6"

# If ${S} isn't actually the top-level source directory, set SPDX_S to point at
# the real top-level directory.
SPDX_S ?= "${S}"

#addtask do_spdx before do_configure after do_patch

# Exclude package based on variables.
# SPDX_EXCLUDE_NATIVE ??= "1"
# SPDX_EXCLUDE_SDK ??= "1"
# SPDX_EXCLUDE_PACKAGES ??= ""
def excluded_package(d, pn):
    assume_provided = (d.getVar("ASSUME_PROVIDED") or "").split()
    if pn in assume_provided:
        for p in d.getVar("PROVIDES").split():
            if p != pn:
                pn = p
                break
    # We just archive gcc-source for all the gcc related recipes
    if d.getVar('BPN') in ['gcc', 'libgcc'] \
            and not pn.startswith('gcc-source'):
        bb.debug(1, 'archiver: %s is excluded, covered by gcc-source' % pn)
        return True
    # TARGET_SYS in ARCHIVER_ARCH will break the stamp for gcc-source in multiconfig
    if pn.startswith('gcc-source'):
        d.setVar('ARCHIVER_ARCH', "allarch")

    # The following: do_fetch, do_unpack and do_patch tasks have been deleted,
    # so avoid archiving do_spdx here.
    # -native is for the host aka during the build
    if pn.endswith('-native') and d.getVar("SPDX_EXCLUDE_NATIVE") == "1":
        return True
    # nativesdk- is for the developer SDK
    if pn.startswith('nativesdk-') and d.getVar("SPDX_EXCLUDE_SDK") == "1":
        return True
    # packagegroups have no files to scan
    if pn.startswith('packagegroup'):
        return True
    if pn.startswith('glibc-locale'):
        return True
    for p in d.getVar("SPDX_EXCLUDE_PACKAGES").split():
        if p in pn:
            return True
    return False

def exclude_useless_paths(tarinfo):
    if tarinfo.isdir():
        if tarinfo.name.endswith('/temp') or tarinfo.name.endswith('/patches') or tarinfo.name.endswith('/.pc'):
            return None
        elif tarinfo.name == 'temp' or tarinfo.name == 'patches' or tarinfo.name == '.pc':
            return None
    return tarinfo

def get_tar_name(d, suffix):
    """
    get the name of tarball
    """

    if suffix:
        filename = '%s-%s.tar.xz' % (d.getVar('PF'), suffix)
    else:
        filename = '%s.tar.xz' % d.getVar('PF')

    return filename

def spdx_create_tarball(d, srcdir, suffix, ar_outdir):
    """
    create the tarball from srcdir
    """
    import tarfile, shutil

    srcdir = os.path.realpath(srcdir)
    bb.utils.mkdirhier(ar_outdir)

    filename = get_tar_name(d, suffix)
    tarname = os.path.join(ar_outdir, filename)
    bb.note('Creating %s' % tarname)
    tar = tarfile.open(tarname, 'w:xz')
    tar.add(srcdir, arcname=os.path.basename(srcdir), filter=exclude_useless_paths)
    tar.close()
    shutil.rmtree(srcdir)
 
    info = {}
    info['pn'] = (d.getVar( 'PN') or "")
    info['pv'] = (d.getVar( 'PKGV') or "")
    info['pr'] = (d.getVar( 'PR') or "")

    if d.getVar('SAVE_SPDX_ACHIVE'):
        manifest_dir = (d.getVar('SPDX_DEPLOY_DIR') or "")
        if not os.path.exists( manifest_dir ):
            bb.utils.mkdirhier( manifest_dir )
        info['outfile'] = os.path.join(manifest_dir, filename)
        create_manifest(info,tarname)
 
    return tarname

def get_tarball_name(d, srcdir, suffix, ar_outdir):
    """
    get the tarball file path
    """
    import tarfile, shutil

    srcdir = os.path.realpath(srcdir)

    filename = get_tar_name(d, suffix)
    tarname = os.path.join(ar_outdir, filename)
    return tarname

# Run do_unpack and do_patch
def spdx_get_src(d):
    import shutil
    spdx_workdir = d.getVar('SPDX_WORKDIR')
    spdx_sysroot_native = d.getVar('STAGING_DIR_NATIVE')
    pn = d.getVar('PN')
    
    # The kernel class functions require it to be on work-shared, so we dont change WORKDIR
    if not is_work_shared(d):
        # Change the WORKDIR to make do_unpack do_patch run in another dir.
        d.setVar('WORKDIR', spdx_workdir)
        # Restore the original path to recipe's native sysroot (it's relative to WORKDIR).
        d.setVar('STAGING_DIR_NATIVE', spdx_sysroot_native)

        # The changed 'WORKDIR' also caused 'B' changed, create dir 'B' for the
        # possibly requiring of the following tasks (such as some recipes's
        # do_patch required 'B' existed).
        bb.utils.mkdirhier(d.getVar('B'))

        bb.build.exec_func('do_unpack', d)
    # Copy source of kernel to spdx_workdir
    if is_work_shared(d):
        d.setVar('WORKDIR', spdx_workdir)
        d.setVar('STAGING_DIR_NATIVE', spdx_sysroot_native)
        src_dir = spdx_workdir + "/" + d.getVar('PN')+ "-" + d.getVar('PV') + "-" + d.getVar('PR')
        bb.utils.mkdirhier(src_dir)
        if bb.data.inherits_class('kernel',d):
            share_src = d.getVar('STAGING_KERNEL_DIR')
        if pn.startswith('gcc-source'):
            gcc_source_path = d.getVar('TMPDIR') + "/work-shared"
            gcc_pv = d.getVar('PV')
            gcc_pr = d.getVar('PR') 
            share_src = gcc_source_path + "/gcc-" + gcc_pv + "-" + gcc_pr + "/gcc-" + gcc_pv + "/"
        cmd_copy_share = "cp -rf " + share_src + "/* " + src_dir + "/"
        cmd_copy_kernel_result = os.popen(cmd_copy_share).read()
        bb.note("cmd_copy_kernel_result = " + cmd_copy_kernel_result)
        
        git_path = src_dir + "/.git"
        if os.path.exists(git_path):
            remove_dir_tree(git_path)

    # Make sure gcc and kernel sources are patched only once
    if not (d.getVar('SRC_URI') == "" or is_work_shared(d)):
        if bb.data.inherits_class('dos2unix', d):
            d.setVar('WORKDIR', spdx_workdir)
            bb.build.exec_func('do_convert_crlf_to_lf', d)
        bb.build.exec_func('do_patch', d)
        

    # Some userland has no source.
    if not os.path.exists( spdx_workdir ):
        bb.utils.mkdirhier(spdx_workdir)

def create_manifest(info,sstatefile):
    import shutil
    shutil.copyfile(sstatefile,info['outfile'])

def get_cached_spdx( sstatefile ):
    import subprocess

    if not os.path.exists( sstatefile ):
        return None
    
    try:
        output = subprocess.check_output(['grep', "PackageVerificationCode", sstatefile])
    except subprocess.CalledProcessError as e:
        bb.error("Index creation command '%s' failed with return code %d:\n%s" % (e.cmd, e.returncode, e.output))
        return None
    cached_spdx_info=output.decode('utf-8').split(': ')
    return cached_spdx_info[1]

#Find InfoInLicenseFile and fill into PackageLicenseInfoInLicenseFile.
def find_infoinlicensefile(sstatefile):
    import subprocess
    import linecache
    import re

    info_in_license_file = ""
    line_nums = []
    key_words = ["NOTICE", "README", "readme", "COPYING", "LICENSE"]

    for key_word in key_words:
        search_cmd = "grep -n 'FileName: .*" + key_word + "' " + sstatefile 
        search_output = subprocess.Popen(search_cmd, shell=True, stdout=subprocess.PIPE).communicate()[0]
        bb.note("Search result: " + str(search_output))
        if search_output:
            bb.note("Found " + key_word +" file.")
            for line in search_output.decode('utf-8').splitlines():
                num = line.split(":")[0]
                line_nums.append(num)
        else:
            bb.note("No license info files found.")
    for line_num in line_nums:
        line_spdx = linecache.getline(sstatefile, int(line_num))
        file_path = line_spdx.split(": ")[1]
        base_file_name = os.path.basename(file_path)
        if base_file_name.startswith("NOTICE"):
            bb.note("Found NOTICE file " + base_file_name)
        elif base_file_name.startswith("readme"):
            bb.note("Found readme file " + base_file_name)
        elif base_file_name.startswith("README"):
            bb.note("Found README file " + base_file_name)
        elif base_file_name.find("COPYING")>=0:
            bb.note("Found COPYING file " + base_file_name)
        elif base_file_name.find("LICENSE")>=0:
            bb.note("Found LICENSE file: " + base_file_name)
        else:
            continue
        linecache.clearcache()
        line_no = int(line_num) + 1
        line_spdx = linecache.getline(sstatefile, line_no)
        while not re.match(r'[a-zA-Z]',line_spdx) is None:
            if not line_spdx.startswith("LicenseInfoInFile"):
                line_no = line_no + 1
                linecache.clearcache()
                line_spdx = linecache.getline(sstatefile, int(line_no))
                continue
            license = line_spdx.split(": ")[1]
            license = license.split("\n")[0]
            bb.note("file path = " + file_path)
            file_path = file_path.split("\n")[0]
            bb.note("file path = " + file_path)
            path_list = file_path.split('/')
            if len(file_path.split('/')) < 3:
                file_path_simple = file_path.split('/',1)[1]
            elif len(file_path.split('/')) < 4:
                file_path_simple = file_path.split('/',2)[2]
            elif len(file_path.split('/')) < 5:
                file_path_simple = file_path.split('/',3)[3]
            else:
                file_path_simple = file_path.split('/',4)[4]
            
            #license_in_file = file_path + ": " + license
            license_in_file = "%s%s%s%s" % ("PackageLicenseInfoInLicenseFile: ",file_path_simple,": ",license)
            license_in_file.replace('\n', '').replace('\r', '')
            info_in_license_file = info_in_license_file + license_in_file + "\n"
            line_no = line_no + 1
            linecache.clearcache()
            line_spdx = linecache.getline(sstatefile, int(line_no))
    linecache.clearcache()
    return info_in_license_file
            
## Add necessary information into spdx file
def write_cached_spdx( info,sstatefile, ver_code ):
    import subprocess
    import re

    infoinlicensefile=""

    def sed_replace(dest_sed_cmd,key_word,replace_info):
        dest_sed_cmd = dest_sed_cmd + "-e 's#^" + key_word + ".*#" + \
            key_word + replace_info + "#' "
        return dest_sed_cmd

    def sed_replace_aline(dest_sed_cmd,origin_line,dest_line):
        dest_sed_cmd = dest_sed_cmd + "-e 's#^" + origin_line + ".*#" + \
            dest_line + "#' "
        return dest_sed_cmd

    def sed_insert(dest_sed_cmd,key_word,new_line):
        dest_sed_cmd = dest_sed_cmd + "-e '/^" + key_word \
            + r"/a\\" + new_line + "' "
        return dest_sed_cmd

    def sed_insert_front(dest_sed_cmd,key_word,new_line):
        dest_sed_cmd = dest_sed_cmd + "-e '/^" + key_word \
            + r"/i\\" + new_line + "' "
        return dest_sed_cmd


    ## Delet ^M in doc format
    subprocess.call("sed -i -e 's#\r##g' %s" % sstatefile, shell=True)
    
    ## Document level information
    subprocess.call("sed -i '/SPDXID: SPDXRef-DOCUMENT/d' %s" % sstatefile, shell=True)
    subprocess.call("sed -i '/DocumentName: \/srv\/fossology\/repository\/report/d' %s" % sstatefile, shell=True)
    subprocess.call("sed -i '/DocumentNamespace: http:/i SPDXID: SPDXRef-DOCUMENT' %s" % sstatefile, shell=True)
    
    sed_cmd = r"sed -i " 
    spdx_DocumentComment = "<text>SPDX for " + info['pn'] + " version " \ 
        + info['pv'] + "</text>"
    sed_cmd = sed_insert(sed_cmd,"SPDXID: SPDXRef-DOCUMENT","DocumentName: " + info['pn']+"-"+info['pv'])

    ## Creator information
    sed_cmd = sed_replace(sed_cmd,"Creator: Tool: ",info['creator']['Tool'])

    ## Package level information
    sed_cmd = sed_replace_aline(sed_cmd, "SPDXVersion: SPDX-2.2", "SPDXVersion: SPDX-2.3")
    sed_cmd = sed_replace(sed_cmd, "PackageName: ", info['pn'])
    sed_cmd = sed_replace_aline(sed_cmd, "SPDXID: SPDXRef-", "SPDXID: SPDXRef-" + info['pkg_spdx_id'])
    sed_cmd = sed_replace(sed_cmd, "Relationship: SPDXRef-DOCUMENT DESCRIBES SPDXRef-", info['pkg_spdx_id'])
    sed_cmd = sed_insert(sed_cmd, "PackageName: ", "PackageVersion: " + info['pv'])
    sed_cmd = sed_replace(sed_cmd, "PackageDownloadLocation: ",info['package_download_location'])
    sed_cmd = sed_insert(sed_cmd, "PackageDownloadLocation: ", "PackageHomePage: " + info['package_homepage'])
    sed_cmd = sed_insert(sed_cmd, "PackageDownloadLocation: ", "PackageSummary: " + "<text>" + info['package_summary'] + "</text>")
    sed_cmd = sed_replace(sed_cmd, "PackageVerificationCode: ",ver_code)
    sed_cmd = sed_insert(sed_cmd, "PackageVerificationCode: ", "PackageDescription: " + 
        "<text>" + info['pn'] + " version " + info['pv'] + "</text>")
    sed_cmd = sed_insert(sed_cmd, "PackageVerificationCode: ", "PackageComment: <text>\\nModificationRecord: " + info['modified'] + "\\n" + "</text>")
    for contain in info['package_contains'].split( ):
        sed_cmd = sed_insert(sed_cmd, "PackageComment:"," \\n\\n## Relationships\\nRelationship: " + info['pn'] + " CONTAINS " + contain)
    for static_link in info['package_static_link'].split( ):
        sed_cmd = sed_insert(sed_cmd, "PackageComment:"," \\n\\n## Relationships\\nRelationship: " + info['pn'] + " STATIC_LINK " + static_link)
    sed_cmd = sed_insert(sed_cmd, "PackageVerificationCode: ", "BuiltDate: " + info['build_time'])
    sed_cmd = sed_insert(sed_cmd, "PackageVerificationCode: ", "ReleaseDate: " + info['release_date'])
    sed_cmd = sed_insert(sed_cmd, "PackageVerificationCode: ", "PrimaryPackagePurpose: " + info['purpose'])
    depends = info['depends_on']
    for depend in re.split(r'\s*[,\s\n\r]\s*', depends):
        sed_cmd = sed_insert_front(sed_cmd, "PackageCopyrightText: ", "Relationship: SPDXRef-" + info['pn'] + " DEPENDS_ON SPDXRef-" + depend)
    bb.note("sed_cmd = " + sed_cmd)
    sed_cmd = sed_cmd + sstatefile
    subprocess.call("%s" % sed_cmd, shell=True)
    
    infoinlicensefile = find_infoinlicensefile(sstatefile)
    for oneline_infoinlicensefile in infoinlicensefile.splitlines():
        bb.note("find_infoinlicensefile: " + oneline_infoinlicensefile)
        sed_cmd = r"sed -i -e 's#\r$##' "
        sed_cmd = sed_insert(sed_cmd, "ModificationRecord: ", oneline_infoinlicensefile)
        sed_cmd = sed_cmd + sstatefile
        subprocess.call("%s" % sed_cmd, shell=True)
    
    with open(sstatefile, encoding="utf-8", mode="a") as file:
        file.write(info['external_refs'])

def is_work_shared(d):
    pn = d.getVar('PN')
    return bb.data.inherits_class('kernel', d) or pn.startswith('gcc-source')

def remove_dir_tree(dir_name):
    import shutil
    try:
        shutil.rmtree(dir_name)
    except:
        pass

def remove_file(file_name):
    try:
        os.remove(file_name)
    except OSError as e:
        pass

def list_files(dir ):
    for root, subFolders, files in os.walk(dir):
        for f in files:
            rel_root = os.path.relpath(root, dir)
            yield rel_root, f
    return

def hash_file(file_name):
    """
    Return the hex string representation of the SHA1 checksum of the filename
    """
    try:
        import hashlib
    except ImportError:
        return None
    
    sha1 = hashlib.sha1()
    with open( file_name, "rb" ) as f:
        for line in f:
            sha1.update(line)
    return sha1.hexdigest()

def hash_string(data):
    import hashlib
    sha1 = hashlib.sha1()
    sha1.update(data.encode('utf-8'))
    return sha1.hexdigest()

def get_ver_code(dirname):
    chksums = []
    for f_dir, f in list_files(dirname):
        try:
            stats = os.stat(os.path.join(dirname,f_dir,f))
        except OSError as e:
            bb.note( "Stat failed" + str(e) + "\n")
            continue
        chksums.append(hash_file(os.path.join(dirname,f_dir,f)))
    ver_code_string = ''.join(chksums).lower()
    ver_code = hash_string(ver_code_string)
    return ver_code

python do_spdx_creat_tarball(){
    import shutil

    spdx_outdir = d.getVar('SPDX_OUTDIR')

    spdx_workdir = d.getVar('SPDX_WORKDIR')
    spdx_temp_dir = os.path.join(spdx_workdir, "temp")
    temp_dir = os.path.join(d.getVar('WORKDIR'), "temp")
    bb.utils.mkdirhier(spdx_workdir)

    spdx_get_src(d)

    if os.path.isdir(spdx_temp_dir):
        for f_dir, f in list_files(spdx_temp_dir):
            temp_file = os.path.join(spdx_temp_dir,f_dir,f)
            shutil.copy(temp_file, temp_dir)

    bb.note("Creat tarball for  " + spdx_outdir)
    tar_file = spdx_create_tarball(d, d.getVar('WORKDIR'), 'patched', spdx_outdir)
}
# For scancode-tk.bbclass, just 
python do_spdx_get_src(){
    import shutil

    spdx_outdir = d.getVar('SPDX_OUTDIR')

    spdx_workdir = d.getVar('SPDX_WORKDIR')
    spdx_temp_dir = os.path.join(spdx_workdir, "temp")
    temp_dir = os.path.join(d.getVar('WORKDIR'), "temp")
    bb.utils.mkdirhier(spdx_workdir)

    spdx_get_src(d)

    if os.path.isdir(spdx_temp_dir):
        for f_dir, f in list_files(spdx_temp_dir):
            temp_file = os.path.join(spdx_temp_dir,f_dir,f)
            shutil.copy(temp_file, temp_dir)
    bb.note("temp_dir = " + spdx_temp_dir)
}

#For SPDX2.3
def get_external_refs(d):
    from oe.cve_check import get_patched_cves
    external_refs = "##------------------------- \n"
    external_refs += "## Security Information \n"
    external_refs += "##------------------------- \n"
    external_refs += "\"externalRefs\" : ["
    unpatched_cves = []
    nvd_link = "https://nvd.nist.gov/vuln/detail/"
    with bb.utils.fileslocked([d.getVar("CVE_CHECK_DB_FILE_LOCK")], shared=True):
        if os.path.exists(d.getVar("CVE_CHECK_DB_FILE")):
            try:
                patched_cves = get_patched_cves(d)
            except FileNotFoundError:
                bb.fatal("Failure in searching patches")
            ignored, patched, unpatched, status = check_cves(d, patched_cves)
            if patched or unpatched or (d.getVar("CVE_CHECK_COVERAGE") == "1" and status):
                cve_data = get_cve_info(d, patched + unpatched + ignored)
                #cve_write_data(d, patched, unpatched, ignored, cve_data, status)
        else:
            bb.note("No CVE database found, skipping CVE check")
            return " "
    if not patched+unpatched+ignored:
        return " "

    for cve in sorted(cve_data):
        is_patched = cve in patched
        is_ignored = cve in ignored

        status = "unpatched"
        if is_ignored:
            status = "ignored"
        elif is_patched:
            status = "fix"
        else:
            # default value of status is Unpatched
            unpatched_cves.append(cve)
        external_refs += "{\n"
        external_refs += "\"referenceCategory\" : \"SECURITY\",\n"
        external_refs += "\"referenceLocator\" : \"https://nvd.nist.gov/vuln/detail/%s\",\n" % cve
        external_refs += "\"referenceType\" : \"%s\"\n" % status
        external_refs += "},"

    external_refs += "]"
    #bb.warn("external_refs  = " + external_refs)    
    return external_refs

def get_pkgpurpose(d):
    section = d.getVar("SECTION")
    if section in "libs":
        return "LIBRARY"
    else:
        return "APPLICATION "

def get_build_date(d):
    from datetime import datetime, timezone

    build_time = datetime.now(tz=timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    return build_time

def get_depends_on(d):
    import re

    depends = re.split(r'\s*[\s]\s*',d.getVar("DEPENDS"))
    depends_spdx = ""
    for depend in depends:
        bb.note("depend = " + depend)
        if depend.endswith("-native"):
            bb.note("Don't show *-native in depends relationship.\n")
        else:
            depends_spdx += depend + ","
    depends_spdx = depends_spdx.strip(',')
    return depends_spdx


def get_spdxid_pkg(d):
    if d.getVar("PROVIDES"):
        pid = d.getVar("PROVIDES")
    else:
        pid = d.getVar("PN")
    bb.note("SPDX ID of pkg = " + pid)
    return pid

