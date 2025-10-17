#!/usr/bin/env bash
# --------------------------------------------
# Kafka Mini Bus - Project Initializer
# --------------------------------------------

set -e

PROJECT_NAME="kafka-mini-bus"

echo "🚀 Creating $PROJECT_NAME project structure..."

mkdir -p $PROJECT_NAME/{bin,docker,src,docs}

cat > $PROJECT_NAME/docker/docker-compose.yml <<'EOF'
version: "3.8"
services:
  kafka:
    image: bitnami/kafka:3.7
    container_name: kafka
    ports:
      - "9092:9092"
      - "9093:9093"
    environment:
      - KAFKA_ENABLE_KRAFT=yes
      - KAFKA_CFG_NODE_ID=1
      - KAFKA_CFG_PROCESS_ROLES=broker,controller
      - KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER
      - KAFKA_CFG_LISTENERS=PLAINTEXT://:9092,INTERNAL://:9093,CONTROLLER://:9094
      - KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092,INTERNAL://kafka:9093
      - KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,INTERNAL:PLAINTEXT,CONTROLLER:PLAINTEXT
      - KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=1@kafka:9094
      - KAFKA_CFG_NUM_PARTITIONS=3
      - KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE=true
      - KAFKA_CFG_TRANSACTION_STATE_LOG_MIN_ISR=1
      - KAFKA_CFG_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1
    volumes:
      - kafka_data:/bitnami/kafka

  ui:
    image: provectuslabs/kafka-ui:latest
    container_name: kafka-ui
    depends_on: [kafka]
    ports:
      - "8080:8080"
    environment:
      - KAFKA_CLUSTERS_0_NAME=local
      - KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka:9093

volumes:
  kafka_data:
EOF

