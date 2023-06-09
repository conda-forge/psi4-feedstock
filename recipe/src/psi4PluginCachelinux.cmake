# psi4PluginCache.cmake
# ---------------------
#
# This module sets some likely variable values to initialize the CMake cache in your plugin.
# See ``psi4 --plugin-compile`` for use.
#

set(CMAKE_C_COMPILER          "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-gcc" CACHE STRING "") 
set(CMAKE_CXX_COMPILER        "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-g++" CACHE STRING "")
set(CMAKE_Fortran_COMPILER    "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-gfortran" CACHE STRING "")

set(CMAKE_C_FLAGS             "-march=native" CACHE STRING "")
set(CMAKE_CXX_FLAGS           "-march=native" CACHE STRING "")
set(CMAKE_Fortran_FLAGS       "-march=native" CACHE STRING "")

set(ENABLE_OPENMP             ON CACHE BOOL "")
set(OpenMP_LIBRARY_DIRS       "/opt/anaconda1anaconda2anaconda3/lib" CACHE STRING "")

set(CMAKE_INSTALL_LIBDIR      "lib" CACHE STRING "")
set(CMAKE_INSTALL_BINDIR      "bin" CACHE STRING "")
set(CMAKE_INSTALL_DATADIR     "share" CACHE STRING "")
set(CMAKE_INSTALL_INCLUDEDIR  "include" CACHE STRING "")
set(PYMOD_INSTALL_LIBDIR      "/python@PY_VER@/site-packages" CACHE STRING "")

set(CMAKE_INSTALL_MESSAGE     "LAZY" CACHE STRING "")
set(pybind11_DIR              "/opt/anaconda1anaconda2anaconda3/lib/python@PY_VER@/site-packages/pybind11/share/cmake/pybind11" CACHE PATH "")
set(Python_VERSION_MAJORMINOR "@PY_VER@" CACHE STRING "")
set(Python_EXECUTABLE         "/opt/anaconda1anaconda2anaconda3/bin/python" CACHE STRING "")

