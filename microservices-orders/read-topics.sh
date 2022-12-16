#!/bin/bash

################################

echo -e "\n*** Sampling messages in Kafka topics and ksqlDB ***\n"

# Topic customers: populated by Kafka Connect that uses the JDBC source connector to read customer data from a sqlite3 database
echo -e "\n-----customers topic-----"
$CONTAINER_ENGINE-compose -f docker-compose-local.yml exec connect kafka-avro-console-consumer --bootstrap-server $BOOTSTRAP_SERVERS --property schema.registry.url=$SCHEMA_REGISTRY_URL --from-beginning --timeout-ms 10000 --max-messages 5 --topic customers

# Topic orders: populated by a POST to the OrdersService service. A unique order is requested 1 per second
echo -e "\n-----orders topic-----"
$CONTAINER_ENGINE-compose -f docker-compose-local.yml exec connect kafka-avro-console-consumer --bootstrap-server $BOOTSTRAP_SERVERS --property schema.registry.url=$SCHEMA_REGISTRY_URL --from-beginning --timeout-ms 10000 --max-messages 5 --topic orders
 
# Topic payments: populated by PostOrdersAndPayments writing to the topic after placing an order. One payment is made per order
echo -e "\n-----payments topic-----"
$CONTAINER_ENGINE-compose -f docker-compose-local.yml exec connect kafka-avro-console-consumer --bootstrap-server $BOOTSTRAP_SERVERS --property schema.registry.url=$SCHEMA_REGISTRY_URL --from-beginning --timeout-ms 10000 --max-messages 5 --topic payments
 
# Topic order-validations: PASS/FAIL for each "checkType": ORDER_DETAILS_CHECK (OrderDetailsService), FRAUD_CHECK (FraudService), INVENTORY_CHECK (InventoryService)
echo -e "\n-----order-validations topic-----"
$CONTAINER_ENGINE-compose -f docker-compose-local.yml exec connect kafka-avro-console-consumer --bootstrap-server $BOOTSTRAP_SERVERS --property schema.registry.url=$SCHEMA_REGISTRY_URL --from-beginning --timeout-ms 10000 --max-messages 5 --topic order-validations

# Topic warehouse-inventory: initial inventory in stock
echo -e "\n-----warehouse-inventory topic-----"
$CONTAINER_ENGINE-compose -f docker-compose-local.yml exec connect kafka-console-consumer --bootstrap-server $BOOTSTRAP_SERVERS --timeout-ms 10000 --max-messages 2 --from-beginning --property print.key=true --property value.deserializer=org.apache.kafka.common.serialization.IntegerDeserializer --topic warehouse-inventory
 
# Topic InventoryService-store-of-reserved-stock-changelog: table backing the reserved inventory
# It maxes out when orders = initial inventory
echo -e "\n-----InventoryService-store-of-reserved-stock-changelog topic-----"
$CONTAINER_ENGINE-compose -f docker-compose-local.yml exec connect kafka-console-consumer --bootstrap-server $BOOTSTRAP_SERVERS --from-beginning --timeout-ms 10000 --property print.key=true --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer --from-beginning --max-messages 5 --topic InventoryService-store-of-reserved-stock-changelog
  
# Topic platinum: dynamic routing
echo -e "\n-----platinum topic-----"
$CONTAINER_ENGINE-compose -f docker-compose-local.yml exec connect kafka-avro-console-consumer --bootstrap-server $BOOTSTRAP_SERVERS --property schema.registry.url=$SCHEMA_REGISTRY_URL --from-beginning --timeout-ms 30000 --max-messages 5 --topic platinum
 
# Sample ksqlDB
echo -e "\n-----Query ksqlDB-----"
echo -e "\n-----orders_enriched stream (expect approximately 10 seconds)-----"
curl --http1.1 -X POST $KSQLDB_EXTERNAL_ENDPOINT/query -H "Accept: application/vnd.ksql.v1+json" -H "Content-Type: application/vnd.ksql.v1+json" -d '{"ksql": "SELECT * FROM orders_enriched EMIT CHANGES LIMIT 2;", "streamsProperties": {"ksql.streams.auto.offset.reset":"earliest"}}' | awk NF
 
echo -e "\n-----FRAUD_ORDER stream (expect approximately 35 seconds)-----"
curl --http1.1  -X POST $KSQLDB_EXTERNAL_ENDPOINT/query -H "Accept: application/vnd.ksql.v1+json" -H "Content-Type: application/vnd.ksql.v1+json" -d '{"ksql": "SELECT * FROM FRAUD_ORDER EMIT CHANGES LIMIT 2;", "streamsProperties": {"ksql.streams.auto.offset.reset":"earliest"}}' | awk NF

