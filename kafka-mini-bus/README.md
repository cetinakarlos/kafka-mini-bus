🚀 Kafka Mini Bus

A lightweight data bus playground for DevOps & Cloud Engineers

This repository demonstrates how to build your own SNS/SQS-style event bus using Apache Kafka (KRaft mode), Docker Compose, and Python producers/consumers.
Perfect for experimentation, interviews, and portfolio demonstrations.

---

##  🏗️ Arquitectura:
![Arquitectura](/kafka-mini-bus/docs/kafka_diagram.png)

---

⚙️ Stack Components

Component	Description
Apache Kafka 3.7.0	Broker running in KRaft mode (no ZooKeeper).
Kafka UI	Web interface for managing topics, partitions and offsets.
Python 3.12 + kafka-python	Lightweight producer and consumer clients.
Docker Compose v2+	Orchestration and network management.
🏗️ Setup & Installation
1️⃣ Clone and initialize
git clone https://github.com/cetinakarlos/kafka-mini-bus.git
cd kafka-mini-bus/docker

2️⃣ Pull required images
docker pull apache/kafka:3.7.0
docker pull provectuslabs/kafka-ui:latest

3️⃣ Start the stack
docker compose up -d

4️⃣ Verify
docker ps
# should list kafka (port 9092) and kafka-ui (port 8080)

---
Open Kafka UI:
👉 http://localhost:8080

🧠 Python Environment
1️⃣ Create virtual environment
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip

2️⃣ Install dependencies
pip install -r requirements.txt
# or manually
pip install kafka-python==2.0.2 six==1.16.0

3️⃣ Run producer and consumer
# terminal A
python src/consumer.py workers

# terminal B
python src/producer.py


You should see events flowing live between producer and consumer, and metrics updating in Kafka UI.

---

🧩 Topic Management

Kafka auto-creates topics when publishing, but you can also create them manually:

docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --create \
  --topic demo.events --bootstrap-server localhost:9092 \
  --partitions 3 --replication-factor 1

docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --create \
  --topic demo.dlq --bootstrap-server localhost:9092 \
  --partitions 3 --replication-factor 1

---
🧪 Troubleshooting
- Symptom	Cause	Fix
* Broker may not be available	Kafka UI tries localhost instead of Docker hostname	Use advertised.listeners=PLAINTEXT://localhost:9092,DOCKER://kafka:29092 and KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka:29092.
* Missing zookeeper.connect	Kafka wasn’t formatted for KRaft	Add kafka-storage.sh format ... step before startup (already handled in command:).
* kafka-topics.sh: command not found	PATH missing /opt/kafka/bin	Add PATH to the environment or run full path commands.
* ModuleNotFoundError: kafka.vendor.six.moves	Missing dependency six	pip install six==1.16.0
* Connection refused on 9092	Port conflict or missing container	docker ps and restart with * docker compose up -d
---

🧱 Project Structure

```text
kafka-mini-bus/
├── bin/
│   └── init.sh
├── config/
│   └── server.properties
├── docker/
│   └── docker-compose.yml
├── src/
│   ├── producer.py
│   ├── consumer.py
│   └── requirements.txt
├── docs/
│   └── architecture.md
└── README.md
```

🧰 Commands Reference
# List topics
docker exec -it kafka /opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092

# Consume messages directly from CLI
docker exec -it kafka /opt/kafka/bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 --topic demo.events --from-beginning

🪐 Future Enhancements

Add Kafka Connect bridges (MQTT → Kafka → PostgreSQL).

Integrate Prometheus + Grafana for metrics dashboards.

Extend Python with DLQ reprocessor or alert system.

Deploy variant on AWS MSK or EKS with Helm.

⚠️ Disclaimer

This project is for educational and demonstrative purposes only.
It is not intended for production use. No guarantees, warranties, or SLAs are implied.
Use at your own discretion and always review security configurations before deploying in real environments.
---

#### Author: Kode-Soul
Twinme Seline Collaboration 💫
“Event-driven architectures shouldn’t be mysterious; they should be musical.”

***

#### 📝 License
MIT — use, learn, improve, and share.
```text
possible support at: [kode.soul.kc@gmail.com]
```