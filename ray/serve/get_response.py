import requests
import numpy as np

resp = requests.get(
    "http://localhost:8000/", json={"array": np.random.randn(28 * 28).tolist()}
)
print(resp.json())