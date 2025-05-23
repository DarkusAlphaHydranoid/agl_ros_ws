# Generated by superflore -- DO NOT EDIT
#
# Copyright Open Source Robotics Foundation

inherit ros_distro_iron
inherit ros_superflore_generated

DESCRIPTION = "Package for extracting the factory calibration from a UR robot and change it such that it can be used by ur_description to gain a correct URDF"
AUTHOR = "Felix Exner <exner@fzi.de>"
ROS_AUTHOR = "Lovro Ivanov <lovro.ivanov@gmail.com>"
HOMEPAGE = "https://wiki.ros.org"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://package.xml;beginline=10;endline=10;md5=4633480cdd27d7906aaf3ef4b72014b2"

ROS_CN = "ur_robot_driver"
ROS_BPN = "ur_calibration"

ROS_BUILD_DEPENDS = " \
    libeigen \
    rclcpp \
    ur-client-library \
    ur-robot-driver \
    yaml-cpp \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
"

ROS_EXPORT_DEPENDS = " \
    libeigen \
    rclcpp \
    ur-client-library \
    ur-robot-driver \
    yaml-cpp \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    libeigen \
    rclcpp \
    ur-client-library \
    ur-robot-driver \
    yaml-cpp \
"

# Currently informational only -- see http://www.ros.org/reps/rep-0149.html#dependency-tags.
ROS_TEST_DEPENDS = " \
    ament-cmake-gmock \
    ament-cmake-gtest \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
# Bitbake doesn't support the "export" concept, so build them as if we needed them to build this package (even though we actually
# don't) so that they're guaranteed to have been staged should this package appear in another's DEPENDS.
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

# matches with: https://github.com/ros2-gbp/Universal_Robots_ROS2_Driver-release/archive/release/iron/ur_calibration/2.3.10-1.tar.gz
ROS_BRANCH ?= "branch=release/iron/ur_calibration"
SRC_URI = "git://github.com/ros2-gbp/Universal_Robots_ROS2_Driver-release;${ROS_BRANCH};protocol=https"
SRCREV = "3c1a3de2f7b79fe3bc9144706482975bfe3f8642"
S = "${WORKDIR}/git"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
