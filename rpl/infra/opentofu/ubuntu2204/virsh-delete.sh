for vm in master rpl_worker_1 rpl_worker_2; do
    virsh shutdown $vm
    virsh undefine --remove-all-storage $vm
done

virsh list --all
