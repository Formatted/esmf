#  $Id: build_rules.mk,v 1.11 2004/12/17 21:01:38 nscollins Exp $
#
#  Darwin.absoft.default.mk
#


#
#  Make sure that ESMF_PREC is set to 32
#
ESMF_PREC = 32

#
# Default MPI setting.
#
ifndef ESMF_COMM
export ESMF_COMM := mpiuni
endif
ifeq ($(ESMF_COMM),default)
export ESMF_COMM := mpiuni
endif


############################################################
#
#  The following naming convention is used:
#     XXX_LIB - location of library XXX
#     XXX_INCLUDE - directory for include files needed for library XXX
#
# Location of BLAS and LAPACK.  See ${ESMF_DIR}/docs/instllation.html
# for information on retrieving them.
#
#
ifeq ($(ESMF_NO_IOCODE),true)
BLAS_LIB         =
LAPACK_LIB       =
NETCDF_LIB       = -lnetcdf_stubs
NETCDF_INCLUDE   = -I${ESMF_DIR}/src/Infrastructure/stubs/netcdf_stubs
HDF_LIB          =
HDF_INCLUDE      =
else
BLAS_LIB         = -L/sw/lib -latlas
LAPACK_LIB       = -L/sw/lib -llapack
NETCDF_LIB       = -L/sw/lib -lnetcdf
NETCDF_INCLUDE   = -I/sw/include
HDF_LIB          = -L/sw/lib/ -lmfhdf -ldf -ljpeg -lz
HDF_INCLUDE      = -I/sw/include
endif

# Location of MPI (Message Passing Interface) software

# comment in one or the other, depending on whether you have
# installed the mpich or lam library.  (the first sections assume
# it is installed under /usr/local - change MPI_HOME if other dir.)

ifeq ($(ESMF_COMM),lam)
# with lam-mpi installed in /usr/local:
MPI_HOME       = /usr/local
MPI_LIB        = -L${MPI_HOME}/lib -lmpi -llam
MPI_INCLUDE    = -I${MPI_HOME}/include 
MPIRUN         = ${MPI_HOME}/bin/mpirun
endif

ifeq ($(ESMF_COMM),mpich)
# with mpich installed in /usr/local:
MPI_HOME       =  /usr/local
MPI_LIB        = -lmpich -lpmpich
MPI_INCLUDE    = -I${MPI_HOME}/include -DESMF_MPICH=1
MPIRUN         =  ${MPI_HOME}/bin/mpirun
ESMC_MPIRUN    =  mpirun
endif

ifeq ($(ESMF_COMM),mpiuni)
# without mpich or lam installed:
MPI_HOME       = ${ESMF_DIR}/src/Infrastructure/stubs/mpiuni
MPI_LIB        = -lmpiuni
MPI_INCLUDE    = -I${MPI_HOME}
MPIRUN         =  ${MPI_HOME}/mpirun
endif

# if you are using ESMF with any VTK (visualization tool kit) code on the Mac,
# set ESMF_VTK to include these libraries.
ifeq ($(ESMF_VTK),1)
MPI_LIB += -L/usr/local/lib/vtk -L/usr/X11R6/lib -lvtkRendering -lvtkIO \
           -lvtkGraphics -lvtkImaging -lSM -lICE \
           -lX11 -lXext -framework Carbon -lvtkftgl \
           -framework AGL -framework OpenGL -lvtkfreetype \
           -lXt -lvtkFiltering -lvtkCommon -framework AppKit -lpthread \
           -lm -lvtkpng -lvtktiff -lvtkzlib -lvtkjpeg -lvtkexpat 
endif

# MP_LIB is for openMP
#MP_LIB          = 
#MP_INCLUDE      = 
# For pthreads (or omp)
THREAD_LIB      = 


############################################################
AR		   = ar
AR_FLAGS	   = cr
RM		   = rm -f
OMAKE		   = ${MAKE}
RANLIB		   = ranlib
SHELL		   = /bin/sh
SED		   = /usr/bin/sed
SH_LD		   = cc
#
# C and Fortran
#
C_CC		   = cc
C_FC		   = f95 
C_FC_MOD           = -p
C_CLINKER_SLFLAG   = -Wl,-rpath,
C_FLINKER_SLFLAG   = -Wl,-rpath,
C_CLINKER	   = cc
C_FLINKER	   = f95
C_CCV		   = ${C_CC} --version
C_FCV              = f90fe -V    # docs say f95 -V should work but causes error
C_SYS_LIB	   = ${MPI_LIB} -ldl -lc -lg2c -lm
#C_SYS_LIB	   = -ldl -lc /usr/lib/libf2c.a -lm  #Use /usr/lib/libf2c.a if that's what your f77 uses.
# ---------------------------- BOPT - g options ----------------------------
G_COPTFLAGS	   = -g
G_FOPTFLAGS	   = -g 
# ----------------------------- BOPT - O options -----------------------------
O_COPTFLAGS	   = -O 
O_FOPTFLAGS	   = -O
#
# Fortran compiler
#
FFLAGS          = -YEXT_NAMES=LCS -s
F_FREECPP       = -ffree
F_FIXCPP        = -ffixed
F_FREENOCPP     = -ffree
F_FIXNOCPP      = -ffixed
#
# C++ compiler 
#
CXX_CC		   = g++ -fPIC
CXX_FC		   = f95 -YEXT_NAMES=LCS -s
CXX_CLINKER_SLFLAG = -Wl,-rpath,
CXX_FLINKER_SLFLAG = -Wl,-rpath,
CXX_CLINKER	   = g++
CXX_FLINKER	   = g++
CXX_CCV		   = ${CXX_CC} --version
LOCAL_INCLUDE      =
#CXX_SYS_LIB	   = -ldl -lc -lf2c -lm
CXX_SYS_LIB	   = ${MPI_LIB} -ldl -lc -lg2c -lm
#CXX_SYS_LIB	   = -ldl -lc /usr/lib/libf2c.a -lm
#C_F90CXXLD         = f95 
C_F90CXXLD         = g++
C_F90CXXLIBS       = ${MPI_LIB} -lstdc++ -L/Applications/Absoft/lib -lf90math -lfio -lf77math
#C_F90CXXLIBS       = ${MPI_LIB} -lstdc++ -L/Applications/Absoft/lib -lf90math -lfio -lf77math -lU77
#C_CXXF90LD         = f95
C_CXXF90LD         = g++
#C_CXXF90LIBS       = ${MPI_LIB}  
C_CXXF90LIBS       = ${MPI_LIB} -lstdc++ -L/Applications/Absoft/lib -lf90math -lfio -lf77math 
#C_CXXF90LIBS       = ${MPI_LIB} -lstdc++ -L/Applications/Absoft/lib -lf90math -lfio -lf77math -lU77
# ------------------------- BOPT - g_c++ options ------------------------------
GCXX_COPTFLAGS	   = -g 
GCXX_FOPTFLAGS	   = -g
# ------------------------- BOPT - O_c++ options ------------------------------
OCXX_COPTFLAGS	   = -O 
OCXX_FOPTFLAGS	   = -O
# -------------------------- BOPT - g_complex options ------------------------
GCOMP_COPTFLAGS	   = -g
GCOMP_FOPTFLAGS	   = -g
# --------------------------- BOPT - O_complex options -------------------------
OCOMP_COPTFLAGS	   = -O
OCOMP_FOPTFLAGS	   = -O
##############################################################################

PARCH		   = mac_osx

SL_LIBS_TO_MAKE = 

SL_SUFFIX   = 
SL_LIBOPTS  = 
SL_LINKOPTS = 
SL_F_LINKER = $(F90CXXLD)
SL_C_LINKER = $(CXXF90LD)
SL_LIB_LINKER = $(CXXF90LD)

