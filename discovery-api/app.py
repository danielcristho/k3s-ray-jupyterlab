from flask import Flask, jsonify
import requests
import time

app = Flask(__name__)

@app.route("/all-nodes")
def all_nodes():
    return _get_nodes(filtered=False)

@app.route("/health-check")
def health_check():
    return jsonify({"status": "ok", "message": "Hello, from RAY API Discovery!"}), 200


@app.route("/available-nodes")
def available_nodes():
    return _get_nodes(filtered=True)

def _get_nodes(filtered=True):
    dashboard_url = "http://172.17.0.2:8265"
    summary_endpoint = "/nodes?view=summary"

    try:
        resp = requests.get(f"{dashboard_url}{summary_endpoint}", timeout=3)
        resp.raise_for_status()
        summary = resp.json()["data"]["summary"]

        result = []
        for node in summary:
            raylet = node.get("raylet", {})
            start_time_ms = 0
            now = time.time()
            uptime_minutes = None

            try:
                start_time_ms = float(raylet.get("startTimeMs", 0))
                now = float(node.get("now", time.time()))
                uptime_minutes = round((now - (start_time_ms / 1000)) / 60, 2)
            except (ValueError, TypeError):
                uptime_minutes = None
            resources = raylet.get("resourcesTotal", {})
            try:
                cpu = float(resources.get("CPU", 0))
            except (ValueError, TypeError):
                cpu = 0.0
            try:
                mem = float(resources.get("memory", 0))
                memory_total_gb = round(mem / 1e9, 2)
            except (ValueError, TypeError):
                memory_total_gb = 0.0
            try:
                obj_mem = float(resources.get("object_store_memory", 0))
                object_store_memory_gb = round(obj_mem / 1e9, 2)
            except (ValueError, TypeError):
                object_store_memory_gb = 0.0
            try:
                gpu_list = node.get("gpus", [])
                gpu_total = len(gpu_list)
                has_gpu = gpu_total > 0
            except Exception:
                gpu_total = 0
                has_gpu = False

            result.append({
                "node_id": raylet.get("nodeId", "unknown"),
                "ip": node.get("ip", "unknown"),
                "hostname": node.get("hostname", "unknown"),
                "is_head": raylet.get("isHeadNode", False),
                "start_time": time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(start_time_ms / 1000)) if start_time_ms else None,
                "uptime_minutes": uptime_minutes,
                "cpu_total": cpu,
                "gpu_total": gpu_total,
                "has_gpu": has_gpu,
                "memory_total_gb": memory_total_gb,
                "object_store_memory_gb": object_store_memory_gb
            })

        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
