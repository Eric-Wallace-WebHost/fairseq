source activate torch-xla-0.5 
export TPU_IP_ADDRESS=10.245.0.2;
export XRT_TPU_CONFIG="tpu_worker;0;$TPU_IP_ADDRESS:8470";
