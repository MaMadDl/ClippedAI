from flask import Flask, request, jsonify
from main import task_queue

app = Flask(__name__)

@app.route("/run", methods=["POST"])
def enqueue():
    data = request.get_json(force=True)

    task_id = str(uuid.uuid4())

    payload = {
        "video_file": data["video_file"],
        "max_clips": int(data.get("max_clips", 2)),
        "reuse_transcription": bool(data.get("reuse_transcription", True))
    }

    task_queue.put((task_id, payload))

    print(f"[QUEUE] Enqueued task {task_id}")

    return jsonify({
        "task_id": task_id,
        "status": "queued"
    })


@app.route("/result/<task_id>", methods=["GET"])
def result(task_id):
    if task_id not in results_store:
        return jsonify({"status": "pending"}), 202
    return jsonify(results_store[task_id])


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)