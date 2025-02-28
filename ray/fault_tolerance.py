import numpy as np
import os
import ray
import ray.exceptions
import time

ray.init(address="ray://192.168.122.10:10001",ignore_reinit_error=True)

@ray.remote(max_retries=1)
def potentially_fail(failure_probability):
    time.sleep(0.2)
    if np.random.random() < failure_probability:
        os._exit(0)
    return 0

for _ in range(3):
    try:
        # If this task crashes, Ray will retry it up to one additional
        # time. If either of the attempts succeeds, the call to ray.get
        # below will return normally. Otherwise, it will raise an
        # exception.
        ray.get(potentially_fail.remote(0.8))
        print('SUCCESS')
    except ray.exceptions.WorkerCrashedError:
        print('FAILURE')