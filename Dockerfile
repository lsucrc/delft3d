#Version 1.1
#add the base image
FROM crcbase

USER crcuser
#download the delft3d package
WORKDIR /model
RUN wget http://lsu.ngchc.org/project/crc/models/delft3d/delft3d-5.01.00.2163.tgz 
RUN tar -zxvf delft3d-5.01.00.2163.tgz 

#compile
WORKDIR delft3d-5.01.00.2163/src
RUN ./build.sh -gnu 
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/model/delft3d-5.01.00.2163/src/lib

#run test case in parallel
WORKDIR /model/delft3d-5.01.00.2163/examples/01_standard
RUN mpirun -x LD_PRELOAD=/usr/lib64/openmpi/lib/libmpi.so -np 4 ../../bin/lnx/flow2d3d/bin/d_hydro.exe ./config_flow2d3d.xml

