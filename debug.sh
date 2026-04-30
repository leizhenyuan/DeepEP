gdbserver1="gdbserver :44554"
gdbserver2="gdbserver :44555"

mpirun -disable-auto-cleanup \
    -np 1 $gdbserver1 python tests/test_xpu_notify_dispatch.py --use-mpi --test direct : \
    -np 1 $gdbserver2 python tests/test_xpu_notify_dispatch.py --use-mpi --test direct


#gdb target remote :44554


