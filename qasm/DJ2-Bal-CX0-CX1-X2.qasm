OPENQASM 2.0;
include "qelib1.inc";

qreg q[3];
creg c[3];

id q[0];
id q[1];
x q[2];
h q[0];
h q[1];
h q[2];
barrier q[0],q[1],q[2];
cx q[0],q[2];
cx q[1],q[2];
x q[2];
barrier q[0],q[1],q[2];
h q[0];
h q[1];
h q[2];
x q[0];
x q[1];
ccx q[0],q[1],q[2];
measure q[2] -> c[2];