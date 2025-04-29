ssh -J daniel@10.21.73.122 root@192.168.122.50 \
  -L 10001:localhost:10001 \
  -L 8265:localhost:8265 \
  -L 6379:localhost:6379 \
  -L 8080:localhost:8081
