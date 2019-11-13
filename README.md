Tutorial Demos
==============

Tightly couled / in situ
------------------------
These are stand alone, they run the simulation tighlty coupled to a back end.
The back end is selected vi an XML file passed into the bridge during start up.
Hence the major difference between these is that XML file.

1. `in_situ_catalyst.sh` -- renders data using Catalyst
2. `in_situ_libsim.sh` -- renders data using Libsim

Loosely coupled / in transit
----------------------------
These require two mpiexec commands. The first runs the simulation configured to
send data through ADIOS. The second job runs the end point configured to
receive data from the simulation and push it to one of the back ends. The back
end is selected via an XML file passed into the end point during start up.
Hence the major diffence between these is that XML file. We used the same
XML file in the end-point as in the tightly coupled demos.

1. `in_transit_catalyst.sh` -- renders incoming data using Catalyst
2. `in_transit_libsim.sh` -- renders incoming data using Libsim

Other
-----
clean.sh -- a script to remove output files

