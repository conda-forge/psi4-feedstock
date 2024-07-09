if [ "$(uname)" == "Darwin" ]; then
    ARCH_ARGS=""

    # c-f-provided CMAKE_ARGS handles CMAKE_OSX_DEPLOYMENT_TARGET, CMAKE_OSX_SYSROOT
    # avoid "error: 'value' is unavailable: introduced in macOS 10.13"
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

    cp external_src/psi4PluginCacheosx.cmake t_plug0
fi
if [ "$(uname)" == "Linux" ]; then
    ARCH_ARGS=""

    # c-f/staged-recipes and c-f/*-feedstock on Linux is inside a non-psi4 git repo, messing up psi4's version computation.
    #   The "staged-recipes" and "feedstock_root" skip patterns are now in psi4. Diagnostics below in case any other circs crop up.
    git rev-parse --is-inside-work-tree
    git rev-parse --show-toplevel

    cp external_src/psi4PluginCachelinux.cmake t_plug0
fi

if [[ "${target_platform}" == "osx-arm64" ]]; then
    export LAPACK_LIBRARIES="${PREFIX}/lib/liblapack${SHLIB_EXT};${PREFIX}/lib/libblas${SHLIB_EXT}"
else
    export LAPACK_LIBRARIES="${PREFIX}/lib/libmkl_rt${SHLIB_EXT}"
fi

#echo '__version_long = '"'$PSI4_PRETEND_VERSIONLONG'" > psi4/metadata.py

# Note: bizarrely, Linux (but not Mac) using `-G Ninja` hangs on [205/1223] at
#   c-f/staged-recipes Azure CI --- thus the fallback to GNU Make.

${BUILD_PREFIX}/bin/cmake ${CMAKE_ARGS} ${ARCH_ARGS} \
  -S ${SRC_DIR} \
  -B build \
  -D CMAKE_INSTALL_PREFIX=${PREFIX} \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_C_COMPILER=${CC} \
  -D CMAKE_CXX_COMPILER=${CXX} \
  -D CMAKE_C_FLAGS="${CFLAGS}" \
  -D CMAKE_CXX_FLAGS="${CXXFLAGS}" \
  -D CMAKE_Fortran_COMPILER=${FC} \
  -D CMAKE_Fortran_FLAGS="${FFLAGS}" \
  -D CMAKE_INSTALL_LIBDIR=lib \
  -D PYMOD_INSTALL_LIBDIR="/python${PY_VER}/site-packages" \
  -D Python_EXECUTABLE=${PYTHON} \
  -D CMAKE_INSIST_FIND_PACKAGE_gau2grid=ON \
  -D MAX_AM_ERI=5 \
  -D CMAKE_INSIST_FIND_PACKAGE_Libint2=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_pybind11=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_Libxc=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_qcelemental=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_qcengine=ON \
  -D psi4_SKIP_ENABLE_Fortran=ON \
  -D ENABLE_dkh=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_dkh=ON \
  -D ENABLE_ecpint=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_ecpint=ON \
  -D ENABLE_PCMSolver=ON \
  -D CMAKE_INSIST_FIND_PACKAGE_PCMSolver=ON \
  -D ENABLE_OPENMP=ON \
  -D ENABLE_XHOST=OFF \
  -D ENABLE_GENERIC=OFF \
  -D LAPACK_LIBRARIES="${LAPACK_LIBRARIES}" \
  -D CMAKE_VERBOSE_MAKEFILE=OFF \
  -D CMAKE_PREFIX_PATH="${PREFIX}"

# addons when ready for c-f
#  -D ENABLE_ambit=ON \
#  -D CMAKE_INSIST_FIND_PACKAGE_ambit=ON \
#  -D ENABLE_CheMPS2=ON \
#  -D CMAKE_INSIST_FIND_PACKAGE_CheMPS2=ON \
#  -D ENABLE_gdma=ON \
#  -D CMAKE_INSIST_FIND_PACKAGE_gdma=ON \
#  -D ENABLE_simint=ON \
#  -D SIMINT_VECTOR=sse \
#  -D CMAKE_INSIST_FIND_PACKAGE_simint=ON \
#  -D ENABLE_Einsums=ON \
#  -D CMAKE_INSIST_FIND_PACKAGE_Einsums=ON \

cmake --build build --target install -j${CPU_COUNT}

# replace conda-build-bound Cache file
sed "s;@PY_VER@;${PY_VER};g" t_plug0 > t_plug1
sed "s;@HOST@;${HOST};g" t_plug1 > t_plug2
cp t_plug2 ${PREFIX}/share/cmake/psi4/psi4PluginCache.cmake
cat ${PREFIX}/share/cmake/psi4/psi4PluginCache.cmake

if [[ "${target_platform}" == "osx-arm64" ]]; then
    # tests don't run for this cross-compile, so this is best chance for inspection
    otool -L ${PREFIX}/lib/python${PY_VER}/site-packages/psi4/core*
fi

# pytest in conda testing stage
