![image](images/confluent-logo-300-2.png)

* [Overview](#overview)
* [Confluent README content](#confluent-readme-content)
  * [Stream Processing](#stream-processing)
  * [Build Your Own](#build-your-own)
  * [Additional Demos](#additional-demos)


# Overview

This is a curated list of demos that showcase Apache Kafka® event stream processing on the Confluent Platform, an event stream processing platform that enables you to process, organize, and manage massive amounts of streaming data across cloud, on-prem, and serverless deployments.

<p align="center">
<a href="http://www.youtube.com/watch?v=muQBd6gry0U" target="_blank"><img src="images/examples-video-thumbnail.jpg" width="360" height="270" border="10" /></a>
</p>

Solace is supporting Kafka in the Solace Event Portal. [Solace Event Portal for Kafka](https://solace.com/products/portal/kafka/) In this fork, the Microservices Ecosystem example within Stream Processing has been adapted to run outside of 
the Confluent Cloud in order to demonstrate Event Portal integration.

# Solace adaption of the Microservices Ecosystem example

The full description of the Microservices ecosystem tutorial is [here](https://docs.confluent.io/platform/current/tutorials/examples/microservices-orders/docs/index.html#tutorial-introduction-to-streaming-application-development)

This adaption launches the following in Docker/Podman:

## Prerequisites
* Linux
* Repository checked out to Linux
* Podman or Docker
* Podman-compose or docker-compose
* Optional:
  * An existing Kafka deployment with KSQL and Schema Registry
  * Administrative credentials to allow deployment of tutorial artifacts

cd microservices-orders

Edit local-env.sh and gen-configs.sh

## Launching the demo

cd microservices-orders

source ./local-env.sh

If using a local Kafka deployment:
* podman-compose -f docker-compose-kafka.yml up -d
* Wait for the Kafka environment to come up

./start-local.sh

## Accessing the demo

UI for Apache Kafka is at http://localhost:8080/

Kibana, which provides visual access to Elasticsearch contents, is at: http://localhost:5601/


## Stopping the demo

podman-compose -f docker-compose-local.yml down

If using a local Kafka deployment:
* podman-compose -f docker-compose-kafka.yml down

podman volume rm -a

# Confluent README content

# Where to start

The best demo to start with is [cp-demo](https://github.com/confluentinc/cp-demo) which spins up a Kafka event streaming application using ksqlDB for stream processing, with many security features enabled, in an end-to-end streaming ETL pipeline with a source connector pulling from live data and a sink connector connecting to Elasticsearch and Kibana for visualizations.
`cp-demo` also comes with a tutorial and is a great configuration reference for Confluent Platform.

<p align="center"><img src="https://raw.githubusercontent.com/confluentinc/cp-demo/5.4.1-post/docs/images/cp-demo-overview.jpg" width="600"></p>


# Stream Processing

[Microservices ecosystem](microservices-orders/README.md)

[Microservices orders Demo Application](https://github.com/confluentinc/kafka-streams-examples/tree/5.2.2-post/src/main/java/io/confluent/examples/streams/microservices) integrated into the Confluent Platform <br><img src="microservices-orders/docs/images/microservices-demo.jpg" width="450">


# Build Your Own

As a next step, you may want to build your own custom demo or test environment.
We have several resources that launch just the services in Confluent Cloud or on prem, with no pre-configured connectors, data sources, topics, schemas, etc.
Using these as a foundation, you can then add any connectors or applications.
You can find the documentation and instructions for these "build-your-own" resources at [https://docs.confluent.io/platform/current/tutorials/build-your-own-demos.html](https://docs.confluent.io/platform/current/tutorials/build-your-own-demos.html?utm_source=github&utm_medium=demo&utm_campaign=ch.examples_type.community_content.top).

# Additional Demos

Here are additional GitHub repos that offer an incredible set of nearly a hundred other Apache Kafka demos.
They are not maintained on a per-release basis like the demos in this repo, but they are an invaluable resource.

* [Learn: Apache Kafka Demos and Examples](https://developer.confluent.io/demos-examples/)
* [confluentinc/demo-scene](https://github.com/confluentinc/demo-scene/blob/master/README.md), the most popular demos include:

  * [Workshop: Apache Kafka and ksqlDB in Action: Let’s Build a Streaming Data Pipeline!](https://github.com/confluentinc/demo-scene/tree/master/build-a-streaming-pipeline/workshop)
  * [Introduction to ksqlDB](https://github.com/confluentinc/demo-scene/tree/master/introduction-to-ksqldb)
  * [Kafka Connect Zero to Hero](https://github.com/confluentinc/demo-scene/tree/master/kafka-connect-zero-to-hero)

* [vdesabou/kafka-docker-playground](https://github.com/vdesabou/kafka-docker-playground/blob/master/README.md)
