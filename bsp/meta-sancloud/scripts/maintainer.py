#! /usr/bin/env python3
# Copyright (c) 2021-2022 SanCloud Ltd
# SPDX-License-Identifier: MIT

import argparse
import os
import re
import subprocess
import sys
import tarfile

try:
    from git_acquire.acquire import Acquisition
except ModuleNotFoundError:
    print("Please install git-acquire before using this script")
    sys.exit(1)


def run(cmd, **kwargs):
    return subprocess.run(cmd, shell=True, check=True, **kwargs)


def capture(cmd, **kwargs):
    return run(cmd, capture_output=True, **kwargs).stdout.decode("utf-8")


def do_acquire_layers(args):
    if args.series == "dunfell":
        layers = (
            Acquisition("https://git.yoctoproject.org/poky", "yocto-3.1.18", "layers/poky",
                        patches=["patches/poky/0001-licenses-Handle-newer-SPDX-license-names.patch"]),
            Acquisition("https://git.openembedded.org/meta-openembedded", "f22bf6efaae61a8fd9272be64e7d75223c58922e", "layers/meta-openembedded"),
            Acquisition("https://git.yoctoproject.org/git/meta-ti", "08.03.00.005", "layers/meta-ti"),
            Acquisition("https://github.com/EmbeddedAndroid/meta-rtlwifi.git", "98b2b2c34f186050e6092bc4f17ecb69aef6148a", "layers/meta-rtlwifi"),
        )
        if args.distro == "poky":
            layers += (
                Acquisition("https://git.yoctoproject.org/git/meta-arm", "69547052727a461f33967e64630aa03b34a7eadd", "layers/meta-arm"),
            )
        elif args.distro == "arago":
            layers += (
                Acquisition("https://git.yoctoproject.org/git/meta-arm", "c4f04f3fb66f8f4365b08b553af8206372e90a63", "layers/meta-arm"),
                Acquisition("https://git.yoctoproject.org/git/meta-arago", "08.03.00.005", "layers/meta-arago"),
                Acquisition("https://github.com/meta-qt5/meta-qt5.git", "5ef3a0ffd3324937252790266e2b2e64d33ef34f", "layers/meta-qt5"),
                Acquisition("https://git.yoctoproject.org/git/meta-virtualization", "a63a54df3170fed387f810f23cdc2f483ad587df", "layers/meta-virtualization")
            )
    elif args.series == "kirkstone":
        layers = (
            Acquisition("https://git.yoctoproject.org/poky", "yocto-4.0.3", "layers/poky"),
            Acquisition("https://git.openembedded.org/meta-openembedded", "8f96c05f6d82fde052f2cb1652c13922814accb0", "layers/meta-openembedded"),
            Acquisition("https://git.yoctoproject.org/git/meta-ti", "2124e7ecd88d1aded320e86da62785c3ab171b27", "layers/meta-ti"),
            Acquisition("https://github.com/EmbeddedAndroid/meta-rtlwifi.git", "98b2b2c34f186050e6092bc4f17ecb69aef6148a", "layers/meta-rtlwifi",
                        patches=[
                            "patches/meta-rtlwifi/0001-rtl8723bu-Fixes-for-kirkstone-support.patch",
                            "patches/meta-rtlwifi/0002-layer.conf-Mark-layer-as-compatible-with-kirkstone.patch",
                        ]),
            Acquisition("https://git.yoctoproject.org/git/meta-arm", "8c97ddc4233d658c6c74a14e501cb2b0022c9097", "layers/meta-arm"),
        )
        if args.distro == "arago":
            layers += (
                Acquisition("https://git.yoctoproject.org/git/meta-arago", "8b34c5edde16d291ec0b3388fe6f03244f89327c", "layers/meta-arago"),
                Acquisition("https://github.com/meta-qt5/meta-qt5.git", "5b71df60e523423b9df6793de9387f87a149ac42", "layers/meta-qt5"),
                Acquisition("https://git.yoctoproject.org/git/meta-virtualization", "e11d5b630e6b5626b58b742b80f5bdf277a44168", "layers/meta-virtualization")
            )
    for layer in layers:
        print(f"Acquiring {layer.local_path}")
        layer.acquire()


def do_setup_build_dir(args):
    project_root = os.path.realpath(os.getcwd())
    do_acquire_layers(args)
    print("Setting up bblayers.conf")
    cmd = (
        f'source layers/poky/oe-init-build-env "{args.build_path}" && '
        'bitbake-layers add-layer '
        f'"{project_root}/layers/meta-openembedded/meta-oe" '
        f'"{project_root}/layers/meta-openembedded/meta-python" '
        f'"{project_root}/layers/meta-openembedded/meta-networking" '
        f'"{project_root}/layers/meta-arm/meta-arm-toolchain" '
        f'"{project_root}/layers/meta-arm/meta-arm" '
        f'"{project_root}/layers/meta-rtlwifi" '
    )
    if args.distro == "arago":
        cmd += (
            f'"{project_root}/layers/meta-openembedded/meta-filesystems" '
            f'"{project_root}/layers/meta-qt5" '
            f'"{project_root}/layers/meta-virtualization" '
            f'"{project_root}/layers/meta-arago/meta-arago-extras" '
            f'"{project_root}/layers/meta-arago/meta-arago-distro" '
        )
    if args.series == "dunfell":
        cmd += f'"{project_root}/layers/meta-ti" '
    elif args.series == "kirkstone":
        cmd += (
            f'"{project_root}/layers/meta-ti/meta-ti-bsp" '
            #f'"{project_root}/layers/meta-ti/meta-ti-extras" '
        )
    cmd += f'"{project_root}"'
    run(cmd)

    if args.site_conf:
        path = os.path.realpath(args.site_conf)
        print(f"Setting up site.conf -> {path}")
        run(f"ln -sfn {path} {args.build_path}/conf/site.conf")

    print("Setting up auto.conf")
    with open(f"{args.build_path}/conf/auto.conf", "w") as f:
        f.write(f'DISTRO = "{args.distro}"\n')
        f.write(f'MACHINE = "bbe"\n')
        if args.kernel_provider:
            f.write(f'BBE_KERNEL_PROVIDER = "{args.kernel_provider}"\n')
        if args.distro == "arago":
            f.write('PACKAGE_CLASSES = "package_ipk"\n')
        f.write("\n")
        f.write('BB_NUMBER_THREADS = "8"\n')
        f.write('PARALLEL_MAKE = "-j8"\n')
        f.write("\n")
        f.write("require conf/include/sancloud-enable-archiver.inc\n")
        f.write("require conf/include/sancloud-mirrors.inc\n")
        if args.series == "kirkstone":
            f.write('INHERIT += "create-spdx"\n')
            f.write('DISTRO_FEATURES:remove = "opengl"\n')


def do_build(args):
    if not args.skip_setup:
        do_setup_build_dir(args)
    print(f"Building {args.target}")
    if args.command:
        maybe_cmd = f"-c {args.command}"
    else:
        maybe_cmd = ""
    run(f'source layers/poky/oe-init-build-env "{args.build_path}" && bitbake {args.target} {maybe_cmd}')


def do_clean(args):
    run("rm -rf build* release")


def do_set_version(args):
    with open("conf/layer.conf", "r+") as f:
        text = re.sub(r"(SANCLOUD_BSP_VERSION =).*\n", rf'\1 "{args.version}"\n', f.read())
        f.seek(0)
        f.write(text)
        f.truncate()
    msg = "Release" if args.release else "Bump version to"
    run(f'git commit -asm "{msg} {args.version}"')


def do_release_build(args):
    os.makedirs("release", exist_ok=True)
    with open("release/RELEASE_NOTES.txt", "w") as f:
        f.write(f"SanCloud BSP {args.version}\n")
        text = capture(f"markdown-extract -n ^{args.version} ChangeLog.md")
        f.write(text)

    run('git archive --format=tar.gz '
        f'--prefix=meta-sancloud-v{args.version}/ '
        f'--output=release/meta-sancloud-v{args.version}.tar.gz '
        'HEAD')

    run('docker run -it --rm -v "$(pwd):/workdir" '
        'gitlab-registry.sancloud.co.uk/bsp/build-containers/poky-build:latest '
        '--workdir=/workdir ./scripts/maintainer.py build -p build-poky')
    with tarfile.open(f"release/bbe-base-image-v{args.version}.tar", mode="w", dereference=True) as tf:
        tf.add("build-poky/tmp/deploy/images/bbe/core-image-base-bbe.wic.xz", "bbe-base-image.wic.xz")
        tf.add("build-poky/tmp/deploy/images/bbe/core-image-base-bbe.wic.bmap", "bbe-base-image.wic.bmap")
    run("rsync -a build-poky/tmp/deploy/sources/mirror/ release/sources/")

    run('docker run -it --rm -v "$(pwd):/workdir" '
        'gitlab-registry.sancloud.co.uk/bsp/build-containers/arago-build:latest '
        '--workdir=/workdir ./scripts/maintainer.py build -p build-arago -d arago -t tisdk-default-image')
    with tarfile.open(f"release/bbe-tisdk-image-v{args.version}.tar", mode="w", dereference=True) as tf:
        tf.add("build-arago/tmp-external-arm-glibc/deploy/images/bbe/tisdk-default-image-bbe.wic.xz", "bbe-tisdk-image.wic.xz")
        tf.add("build-arago/tmp-external-arm-glibc/deploy/images/bbe/tisdk-default-image-bbe.wic.bmap", "bbe-tisdk-image.wic.bmap")
    run("rsync -a build-arago/tmp-external-arm-glibc/deploy/sources/mirror/ release/sources/")

    file_list = (
        f"RELEASE_NOTES.txt meta-sancloud-v{args.version}.tar.gz "
        f"bbe-base-image-v{args.version}.tar bbe-tisdk-image-v{args.version}.tar"
        )
    with open("release/SHA256SUMS", "w") as f:
        text = capture(
            f"sha256sum {file_list}",
            cwd="release",
        )
        f.write(text)
    with open("release/B3SUMS", "w") as f:
        text = capture(
            f"b3sum {file_list}",
            cwd="release",
        )
        f.write(text)
    if args.sign:
        run("gpg --detach-sign -a release/SHA256SUMS")
        run("gpg --detach-sign -a release/B3SUMS")


def do_release_tag(args):
    run(f"git tag -a -F release/RELEASE_NOTES.txt v{args.version} {args.commit}")


def do_release_push(args):
    commit = capture(f"git rev-parse v{args.version}~0")
    file_list = (
        f"RELEASE_NOTES.txt meta-sancloud-v{args.version}.tar.gz "
        f"bbe-base-image-v{args.version}.tar bbe-tisdk-image-v{args.version}.tar "
        "SHA256SUMS B3SUMS"
        )
    if not args.no_gitlab:
        run("git push origin")
        run(f"git push origin v{args.version}")
        run(f"git push origin {commit}:refs/heads/release")
        run(f"glab release create v{args.version} -n v{args.version} "
            f"-F RELEASE_NOTES.txt {file_list}",
            cwd="release")
    if not args.no_github:
        run("git push gh")
        run(f"git push gh v{args.version}")
        run(f"git push gh {commit}:refs/heads/release")
        run(f"gh release create v{args.version} -n v{args.version} "
            f"-F RELEASE_NOTES.txt {file_list}",
            cwd="release")
    if not args.no_source_mirror:
        run("rclone copy release/sources yocto-source-mirror:")


def do_release_signatures(args):
    file_list = "SHA256SUMS.asc B3SUMS.asc"
    if not args.no_gitlab:
        run(f"glab release upload v{args.version} {file_list}",
            cwd="release")
    if not args.no_github:
        run(f"gh release upload v{args.version} {file_list}",
            cwd="release")


def do_release(args):
    args.release = True
    do_clean(args)
    do_set_version(args)
    args.commit = capture("git rev-parse HEAD").strip()
    do_release_build(args)
    do_release_tag(args)
    do_release_push(args)


def do_no_command(args):
    print("Missing command! Try `./scripts/maintainer.py --help`")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.set_defaults(cmd_fn=do_no_command)
    subparsers = parser.add_subparsers(
        dest="cmd", title="Maintainer commands", metavar="command"
    )

    build_cmd = subparsers.add_parser(name="build", help="Perform build")
    build_cmd.set_defaults(cmd_fn=do_build)
    build_cmd.add_argument(
        "-d", "--distro", default="poky", help="Distribution to build (poky or arago)"
    )
    build_cmd.add_argument(
        "-s", "--series", default="dunfell", help="Yocto release series to build for (dunfell or kirkstone)"
    )
    build_cmd.add_argument(
        "-i", "--site-conf", help="Site-specific configuration file"
    )
    build_cmd.add_argument(
        "-p", "--build-path", default="build", help="Directory in which to perform build"
    )
    build_cmd.add_argument(
        "-k", "--kernel-provider", help="Alternative kernel provider for build (e.g. mainline, stable, rt)"
    )
    build_cmd.add_argument(
        "-t", "--target", default="core-image-base", help="Recipe to build"
    )
    build_cmd.add_argument(
        "-S", "--skip-setup", action="store_true", help="Skip build directory setup"
    )
    build_cmd.add_argument(
        "-c", "--command", help="Recipe command to run (e.g. fetch, populate_sdk)"
    )

    clean_cmd = subparsers.add_parser(
        name="clean", help="Remove build output from the source tree"
    )
    clean_cmd.set_defaults(cmd_fn=do_clean)

    setup_build_dir_cmd = subparsers.add_parser(name="setup-build-dir", help="Setup a build directory")
    setup_build_dir_cmd.set_defaults(cmd_fn=do_setup_build_dir)
    setup_build_dir_cmd.add_argument(
        "-d", "--distro", default="poky", help="Distribution to build (poky or arago)"
    )
    setup_build_dir_cmd.add_argument(
        "-i", "--site-conf", help="Site-specific configuration file"
    )
    setup_build_dir_cmd.add_argument(
        "-p", "--build-path", default="build", help="Directory in which to perform build"
    )
    setup_build_dir_cmd.add_argument(
        "-k", "--kernel-provider", help="Alternative kernel provider for build (e.g. mainline, stable, rt)"
    )

    acquire_layers_cmd = subparsers.add_parser(name="acquire-layers", help="Fetch and checkout Yocto layers")
    acquire_layers_cmd.set_defaults(cmd_fn=do_acquire_layers)
    acquire_layers_cmd.add_argument(
        "-d", "--distro", default="poky", help="Distribution to build (poky or arago)"
    )

    set_version_cmd = subparsers.add_parser(
        name="set-version", help="Set version string & commit"
    )
    set_version_cmd.set_defaults(cmd_fn=do_set_version)
    set_version_cmd.add_argument("version", help="New version string")
    set_version_cmd.add_argument("-r", "--release", action="store_true", help="This version bump is for a release")

    release_cmd = subparsers.add_parser(
        name="release", help="Release a new version of this project"
    )
    release_cmd.set_defaults(cmd_fn=do_release)
    release_cmd.add_argument("version", help="Version string for the new release")
    release_cmd.add_argument(
        "-s", "--sign", action="store_true", help="Sign release with gpg"
    )
    release_cmd.add_argument(
        "--no-gitlab",
        action="store_true",
        help="Disable push to SanCloud gitlab instance",
    )
    release_cmd.add_argument(
        "--no-github",
        action="store_true",
        help="Disable push to public github repositories",
    )
    release_cmd.add_argument(
        "--no-source-mirror",
        action="store_true",
        help="Disable pushing sources to mirror",
    )

    release_build_cmd = subparsers.add_parser(name="release-build", help="Perform release build")
    release_build_cmd.set_defaults(cmd_fn=do_release_build)
    release_build_cmd.add_argument("version", help="Release to build (must already be checked out)")
    release_build_cmd.add_argument(
        "-s", "--sign", action="store_true", help="Sign release with gpg"
    )

    release_tag_cmd = subparsers.add_parser(
        name="release-tag", help="Tag a new release of this project"
    )
    release_tag_cmd.set_defaults(cmd_fn=do_release_tag)
    release_tag_cmd.add_argument("version", help="Version string for the new release (must already be built)")
    release_tag_cmd.add_argument("commit", help="Commit to tag")

    release_push_cmd = subparsers.add_parser(
        name="release-push", help="Push a release to GitHub and/or GitLab"
    )
    release_push_cmd.set_defaults(cmd_fn=do_release_push)
    release_push_cmd.add_argument("version", help="Release to push (must already be tagged and built)")
    release_push_cmd.add_argument(
        "--no-gitlab",
        action="store_true",
        help="Disable push to SanCloud gitlab instance",
    )
    release_push_cmd.add_argument(
        "--no-github",
        action="store_true",
        help="Disable push to public github repositories",
    )
    release_push_cmd.add_argument(
        "--no-source-mirror",
        action="store_true",
        help="Disable pushing sources to mirror",
    )

    release_signatures_cmd = subparsers.add_parser(
        name="release-signatures", help="Push release signatures to GitHub and/or GitLab"
    )
    release_signatures_cmd.set_defaults(cmd_fn=do_release_signatures)
    release_signatures_cmd.add_argument("version", help="Release to push signatures for (must already be released)")
    release_signatures_cmd.add_argument(
        "--no-gitlab",
        action="store_true",
        help="Disable pushing signatures to SanCloud gitlab instance",
    )
    release_signatures_cmd.add_argument(
        "--no-github",
        action="store_true",
        help="Disable pushing signatures to public github repositories",
    )

    return parser.parse_args()


def main():
    args = parse_args()
    args.cmd_fn(args)


if __name__ == "__main__":
    main()
