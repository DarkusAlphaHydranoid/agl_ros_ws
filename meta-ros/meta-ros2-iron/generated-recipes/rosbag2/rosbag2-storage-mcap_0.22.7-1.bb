# Generated by superflore -- DO NOT EDIT
#
# Copyright Open Source Robotics Foundation

inherit ros_distro_iron
inherit ros_superflore_generated

DESCRIPTION = "rosbag2 storage plugin using the MCAP file format"
AUTHOR = "Foxglove <ros-tooling@foxglove.dev>"
HOMEPAGE = "https://wiki.ros.org"
SECTION = "devel"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://package.xml;beginline=10;endline=10;md5=82f0323c08605e5b6f343b05213cf7cc"

ROS_CN = "rosbag2"
ROS_BPN = "rosbag2_storage_mcap"

ROS_BUILD_DEPENDS = " \
    ament-index-cpp \
    mcap-vendor \
    pluginlib \
    rcutils \
    rosbag2-storage \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
    ament-cmake-python-native \
"

ROS_EXPORT_DEPENDS = " \
    ament-index-cpp \
    mcap-vendor \
    pluginlib \
    rcutils \
    rosbag2-storage \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    ament-index-cpp \
    mcap-vendor \
    pluginlib \
    rcutils \
    rosbag2-storage \
"

# Currently informational only -- see http://www.ros.org/reps/rep-0149.html#dependency-tags.
ROS_TEST_DEPENDS = " \
    ament-cmake-clang-format \
    ament-cmake-gmock \
    ament-lint-auto \
    ament-lint-common \
    rosbag2-test-common \
    std-msgs \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
# Bitbake doesn't support the "export" concept, so build them as if we needed them to build this package (even though we actually
# don't) so that they're guaranteed to have been staged should this package appear in another's DEPENDS.
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

# matches with: https://github.com/ros2-gbp/rosbag2-release/archive/release/iron/rosbag2_storage_mcap/0.22.7-1.tar.gz
ROS_BRANCH ?= "branch=release/iron/rosbag2_storage_mcap"
SRC_URI = "git://github.com/ros2-gbp/rosbag2-release;${ROS_BRANCH};protocol=https"
SRCREV = "ffa209c43124fc36d8c610929e8f1bbaf958dde3"
S = "${WORKDIR}/git"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
