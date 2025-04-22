sudo incus launch images:ubuntu/22.04/cloud master \
    --vm \
    -c limits.cpu=4 \
    -c limits.memory=8GB \
    -c user.user-data="$(cat cloud-init.yaml)"

sudo incus config set master agent.required true
sudo incus restart master