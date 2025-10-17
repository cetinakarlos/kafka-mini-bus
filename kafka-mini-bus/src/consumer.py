from confluent_kafka import Consumer
import json, sys

group = sys.argv[1] if len(sys.argv)>1 else "workers"
c = Consumer({
    "bootstrap.servers": "localhost:9092",
    "group.id": group,
    "auto.offset.reset": "earliest",
    "enable.auto.commit": False
})
c.subscribe(["demo.events"])

try:
    while True:
        msg = c.poll(1.0)
        if not msg: 
            continue
        if msg.error():
            print("err:", msg.error()); continue
        key = msg.key().decode() if msg.key() else None
        val = json.loads(msg.value().decode())
        # Simula error para DLQ si quieres
        print(f"[{group}] ✔ processed key={key} value={val}")
        c.commit(asynchronous=False)   # confirma (estilo SQS)
except KeyboardInterrupt:
    pass
finally:
    c.close()
