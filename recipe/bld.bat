
REM echo __version_long = '%PSI4_PRETEND_VERSIONLONG%' > psi4\metadata.py

cmake %CMAKE_ARGS% ^
  -G "Ninja" ^
  -S %SRC_DIR% ^
  -B build ^
  -D CMAKE_BUILD_TYPE=Release ^
  -D CMAKE_INSTALL_PREFIX="%PREFIX%" ^
  -D CMAKE_C_COMPILER=clang-cl ^
  -D CMAKE_C_FLAGS="%CFLAGS%" ^
  -D CMAKE_CXX_COMPILER=clang-cl ^
  -D CMAKE_CXX_FLAGS="%CXXFLAGS%" ^
  -D CMAKE_INSTALL_LIBDIR="Library\\lib" ^
  -D CMAKE_INSTALL_INCLUDEDIR="Library\\include" ^
  -D CMAKE_INSTALL_BINDIR="Scripts" ^
  -D CMAKE_INSTALL_DATADIR="Library\\share" ^
  -D PYMOD_INSTALL_LIBDIR="/../../Lib/site-packages" ^
  -D psi4_INSTALL_CMAKEDIR="Library\\share\\cmake\\psi4" ^
  -D TargetLAPACK_INSTALL_CMAKEDIR="Library\\share\\cmake\\TargetLAPACK" ^
  -D TargetHDF5_INSTALL_CMAKEDIR="Library\\share\\cmake\\TargetHDF5" ^
  -D Python_EXECUTABLE="%PYTHON%" ^
  -D LAPACK_LIBRARIES="%PREFIX%\\Library\\lib\\mkl_rt.lib" ^
  -D BUILD_SHARED_LIBS=OFF ^
  -D ENABLE_OPENMP=ON ^
  -D CMAKE_INSIST_FIND_PACKAGE_gau2grid=ON ^
  -D MAX_AM_ERI=5 ^
  -D CMAKE_INSIST_FIND_PACKAGE_Libint2=ON ^
  -D CMAKE_INSIST_FIND_PACKAGE_pybind11=ON ^
  -D CMAKE_INSIST_FIND_PACKAGE_Libxc=ON ^
  -D CMAKE_INSIST_FIND_PACKAGE_qcelemental=ON ^
  -D CMAKE_INSIST_FIND_PACKAGE_qcengine=ON ^
  -D CMAKE_INSIST_FIND_PACKAGE_optking=ON ^
  -D CMAKE_INSIST_FIND_PACKAGE_qcmanybody=ON ^
  -D psi4_SKIP_ENABLE_Fortran=ON ^
  -D ENABLE_dkh=OFF ^
  -D CMAKE_INSIST_FIND_PACKAGE_dkh=OFF ^
  -D ENABLE_ecpint=OFF ^
  -D CMAKE_INSIST_FIND_PACKAGE_ecpint=OFF ^
  -D ENABLE_PCMSolver=OFF ^
  -D CMAKE_INSIST_FIND_PACKAGE_PCMSolver=OFF ^
  -D ENABLE_XHOST=OFF ^
  -D CMAKE_VERBOSE_MAKEFILE=OFF ^
  -D CMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"
if errorlevel 1 exit 1

::set CMAKE_BUILD_PARALLEL_LEVEL=1
cmake --build build ^
      --config Release ^
      --target install
if errorlevel 1 exit 1

REM pytest in conda testing stage

objdump.exe -p %PREFIX%\Library\bin\gg.dll | findstr /i "DLL Name libgcc libstdc++ winpthread"
objdump.exe -p %PREFIX%\Library\bin\xc.dll | findstr /i "DLL Name libgcc libstdc++ winpthread"
:: objdump.exe -p %PREFIX%\Library\bin\libdkh.dll | findstr /i "DLL Name libgcc libstdc++ winpthread"
:: objdump.exe -p %PREFIX%\Library\bin\libpcm.dll | findstr /i "DLL Name libgcc libstdc++ winpthread"
:: objdump.exe -p %PREFIX%\Library\bin\ecpint.dll | findstr /i "DLL Name libgcc libstdc++ winpthread"

echo "LIBLIB Psi4"
objdump.exe -p %PREFIX%\Lib\site-packages\psi4\core.cp313-win_amd64.pyd
echo "LIBLIB Gau2Grid"
objdump.exe -p %PREFIX%\Library\bin\gg.dll
echo "LIBLIB XC"
objdump.exe -p %PREFIX%\Library\bin\xc.dll
:: echo "LIBLIB DKH"
:: objdump.exe -p %PREFIX%\Library\bin\libdkh.dll
:: echo "LIBLIB PCM"
:: objdump.exe -p %PREFIX%\Library\bin\libpcm.dll
:: echo "LIBLIB ECPINT"
:: objdump.exe -p %PREFIX%\Library\bin\ecpint.dll

:: Relocate python module to expected location (if positioning through PYMOD_INSTALL_LIBDIR="/" and CMAKE_INSTALL_BINDIR="Library\bin")
::copy /y "%PREFIX%\Library\bin\psi4" "%PREFIX%\Scripts"
::if errorlevel 1 exit 1
:: xcopy /f /i /s /y "%PREFIX%\Library\lib\psi4" "%SP_DIR%\psi4"
:: if errorlevel 1 exit 1
:: del /S /Q "%PREFIX%\Library\lib\psi4"
:: if errorlevel 1 exit 1

:: Probe linking - only available with m2w64-binutils package - add dep in meta.yaml or defer to test stage
:: [Apr 2025] now m2w64-binutils can't be solved for. use %OBJDUMP% w/o -p and never completes
:: objdump.exe -p %PREFIX%\Lib\site-packages\psi4\core.*.pyd | findstr /i "dll"
:: objdump.exe -p %PREFIX%\Library\bin\mkl_rt.*.dll | findstr /i "dll"

:: Probe import libraries
:: echo Intel
:: lib /list %SRC_DIR%\external_src\conda\win\2019.1\libiomp5md.lib
:: echo LLVM
:: lib /list "C:/Program Files (x86)/Microsoft Visual Studio/2019/Enterprise/VC/Tools/Llvm/x64/lib/libiomp5md.lib"
:: echo end

:: Expired
::  -D OpenMP_LIBRARY_DIRS="%SRC_DIR%\\external_src\\conda\\win\\2019.1"
::  Library/lib/libiomp5md.lib

:: Info
::   set LIB=%PREFIX%\Library\lib;%LIB%
::   intel-openmp
::    %PREFIX%/opt/compiler/include/omp.h
::    %PREFIX%/Library/lib/libiomp5md.lib
::   llvm-openmp
::    %PREFIX%/Library/include/omp.h
::    %PREFIX%/Library/lib/libomp.lib
::   clang-cl -Xclang -fopenmp -E -showIncludes %SRC_DIR%\psi4\src\psi4\libsapt_solver\sapt.cc | findstr /i omp.h
