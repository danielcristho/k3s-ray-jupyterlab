sudo incus launch images:ubuntu/22.04/cloud vm-cloud \
    --vm \
    -c limits.cpu=4 \
    -c limits.memory=8GB \
    -c security.agent.certified=true \
    -c user.user-data="$(cat cloud-init.yaml)"
