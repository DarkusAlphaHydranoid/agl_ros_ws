# Generated by superflore -- DO NOT EDIT
#
# Copyright Open Source Robotics Foundation

inherit ros_distro_iron
inherit ros_superflore_generated

DESCRIPTION = "Controller based on PID implememenation from control_toolbox package."
AUTHOR = "Bence Magyar <bence.magyar.robotics@gmail.com>"
ROS_AUTHOR = "Denis Štogl <denis.stogl@stoglrobotics.de>"
HOMEPAGE = "https://wiki.ros.org"
SECTION = "devel"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://package.xml;beginline=10;endline=10;md5=82f0323c08605e5b6f343b05213cf7cc"

ROS_CN = "ros2_controllers"
ROS_BPN = "pid_controller"

ROS_BUILD_DEPENDS = " \
    angles \
    backward-ros \
    control-msgs \
    control-toolbox \
    controller-interface \
    generate-parameter-library \
    hardware-interface \
    parameter-traits \
    pluginlib \
    rclcpp \
    rclcpp-lifecycle \
    realtime-tools \
    std-srvs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
"

ROS_EXPORT_DEPENDS = " \
    angles \
    backward-ros \
    control-msgs \
    control-toolbox \
    controller-interface \
    hardware-interface \
    parameter-traits \
    pluginlib \
    rclcpp \
    rclcpp-lifecycle \
    realtime-tools \
    std-srvs \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    angles \
    backward-ros \
    control-msgs \
    control-toolbox \
    controller-interface \
    hardware-interface \
    parameter-traits \
    pluginlib \
    rclcpp \
    rclcpp-lifecycle \
    realtime-tools \
    std-srvs \
"

# Currently informational only -- see http://www.ros.org/reps/rep-0149.html#dependency-tags.
ROS_TEST_DEPENDS = " \
    ament-cmake-gmock \
    controller-manager \
    hardware-interface-testing \
    ros2-control-test-assets \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
# Bitbake doesn't support the "export" concept, so build them as if we needed them to build this package (even though we actually
# don't) so that they're guaranteed to have been staged should this package appear in another's DEPENDS.
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

# matches with: https://github.com/ros2-gbp/ros2_controllers-release/archive/release/iron/pid_controller/3.26.3-1.tar.gz
ROS_BRANCH ?= "branch=release/iron/pid_controller"
SRC_URI = "git://github.com/ros2-gbp/ros2_controllers-release;${ROS_BRANCH};protocol=https"
SRCREV = "e55465f0ffe6965299f5443ad8ab7751ec094c5a"
S = "${WORKDIR}/git"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
