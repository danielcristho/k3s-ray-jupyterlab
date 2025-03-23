import os
import ray

RAY_ADDRESS = os.getenv("RAY_ADDRESS", "ray://192.168.122.10:10001")

try:
    ray.init(address=RAY_ADDRESS, ignore_reinit_error=True)
    print(f"Connected to Ray cluster at {RAY_ADDRESS}")
except Exception as e:
    print(f"Failed to connect to Ray cluster: {e}")