cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

add_definitions(-std=c++11)

set(CXX_FLAGS "-Wall" "-pedantic")
set(CMAKE_CXX_FLAGS, "${CXX_FLAGS}")

project(camera_fusion)

find_package(OpenCV 4.1 REQUIRED)

include_directories(${OpenCV_INCLUDE_DIRS})
link_directories(${OpenCV_LIBRARY_DIRS})
add_definitions(${OpenCV_DEFINITIONS})

# add matrix_utils header lib
add_library(matrix_utils INTERFACE)
target_include_directories(matrix_utils INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
target_sources(matrix_utils INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/src/matrix_utils.hpp
)

# Executables for exercises
add_executable (show_lidar_top_view src/show_lidar_top_view.cpp src/structIO.cpp)
target_link_libraries (show_lidar_top_view ${OpenCV_LIBRARIES})

add_executable (project_lidar_to_camera src/project_lidar_to_camera.cpp src/structIO.cpp)
target_link_libraries (project_lidar_to_camera ${OpenCV_LIBRARIES} matrix_utils)
