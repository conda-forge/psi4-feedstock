## install
#SHARE=${PREFIX}/share/cmake/psi4/
#mkdir -p ${SHARE}
#
if [ "$(uname)" == "Darwin" ]; then
#    cp psi4PluginCacheosx.cmake t_plug0
#    sed "s/@HOST@/${HOST}/g" psi4DepsClangCache.cmake > ${SHARE}/psi4DepsClangCache.cmake
elif [ "$(uname)" == "Linux" ]; then
#    cp psi4PluginCachelinux.cmake t_plug0
#    sed "s/@HOST@/${HOST}/g" psi4DepsGNUCache.cmake > ${SHARE}/psi4DepsGNUCache.cmake
#    sed "s/@HOST@/${HOST}/g" psi4DepsIntelCache.cmake > ${SHARE}/psi4DepsIntelCache.cmake
#    sed "s/@HOST@/${HOST}/g" psi4DepsIntelMultiarchCache.cmake > ${SHARE}/psi4DepsIntelMultiarchCache.cmake
fi
#sed "s;@PYMOD_INSTALL_LIBDIR@;/python${PY_VER}/site-packages;g" t_plug0 > t_plug1
#sed "s/@HOST@/${HOST}/g" t_plug1 > t_plug2
#
#cp psi4-path-advisor.py ${PREFIX}/bin/psi4-path-advisor
#cp t_plug2 ${SHARE}/psi4PluginCache.cmake
#sed "s/@PY_VER@/${PY_VER}/g" psi4DepsCache.cmake > ${SHARE}/psi4DepsCache.cmake
#cp psi4DepsDisableCache.cmake ${SHARE}
#sed "s/@SHLIB_EXT@/${SHLIB_EXT}/g" psi4DepsMKLCache.cmake > ${SHARE}/psi4DepsMKLCache.cmake

# NEW
sed "s;@PY_VER@;${PY_VER};g" psi4PluginCache.cmake > t_plug1
sed "s;@HOST@;${HOST};g" psi4PluginCache.cmake > t_plug1
sed "s;@HOST@;${HOST};g" t_plug1 > t_plug2
# END

# psi4PluginCache.cmake
# ---------------------
#
# This module sets some likely variable values to initialize the CMake cache in your plugin.
# See ``psi4 --plugin-compile`` for use.
#

set(CMAKE_C_COMPILER          "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-gcc" CACHE STRING "") 
set(CMAKE_CXX_COMPILER        "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-g++" CACHE STRING "")
# NOT SET set(CMAKE_Fortran_COMPILER    "/opt/anaconda1anaconda2anaconda3/bin/@HOST@-gfortran" CACHE STRING "")

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

