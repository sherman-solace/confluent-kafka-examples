.. _client-examples-csharp:

.NET: Code Example for |ak-tm|
==============================

In this tutorial, you will run a .NET client application that produces messages to and consumes messages from an |ak-tm| cluster.

.. include:: includes/client-example-overview.rst


Prerequisites
-------------

Client
~~~~~~

- `.NET Core 2.1 <https://dotnet.microsoft.com/download>`__ or higher to run the client application

.. include:: includes/certs-truststore.rst

Kafka Cluster
~~~~~~~~~~~~~

.. include:: includes/client-example-prerequisites.rst

Setup
-----

#. .. include:: includes/clients-checkout.rst

#. Change directory to the example for .NET.

   .. sourcecode:: bash

      cd clients/cloud/csharp/

#. .. include:: includes/client-example-create-file-librdkafka.rst


Basic Producer and Consumer
---------------------------

.. include:: includes/producer-consumer-description.rst


Produce Records
~~~~~~~~~~~~~~~

#. Build the client example application

   .. code:: shell

       dotnet build

#. Run the example application, passing in arguments for:
 	
   - whether to produce or consume (produce)
   - the topic name
   - the local file with configuration parameters to connect to your |ak| cluster

   .. code:: shell

      # Run the producer
      dotnet run produce test1 $HOME/.confluent/librdkafka.config

#. Verify that the producer sent all the messages. You should see:

   .. code:: shell

      Producing record: alice {"count":0}
      Producing record: alice {"count":1}
      Producing record: alice {"count":2}
      Producing record: alice {"count":3}
      Producing record: alice {"count":4}
      Producing record: alice {"count":5}
      Producing record: alice {"count":6}
      Producing record: alice {"count":7}
      Producing record: alice {"count":8}
      Producing record: alice {"count":9}
      Produced record to topic test1 partition [0] @ offset 0
      Produced record to topic test1 partition [0] @ offset 1
      Produced record to topic test1 partition [0] @ offset 2
      Produced record to topic test1 partition [0] @ offset 3
      Produced record to topic test1 partition [0] @ offset 4
      Produced record to topic test1 partition [0] @ offset 5
      Produced record to topic test1 partition [0] @ offset 6
      Produced record to topic test1 partition [0] @ offset 7
      Produced record to topic test1 partition [0] @ offset 8
      Produced record to topic test1 partition [0] @ offset 9
      10 messages were produced to topic test1

#. View the :devx-examples:`producer code|clients/cloud/csharp/Program.cs`.


Consume Records
~~~~~~~~~~~~~~~

#. Run the example application, passing in arguments for:

   - whether to produce or consume (consume)
   - the topic name: same topic name as used above
   - the local file with configuration parameters to connect to your |ak| cluster

   .. code:: shell

      # Run the consumer
      dotnet run consume test1 $HOME/.confluent/librdkafka.config

#. Verify that the consumer sent all the messages. You should see:

   ::

      Consumed record with key alice and value {"count":0}, and updated total count to 0
      Consumed record with key alice and value {"count":1}, and updated total count to 1
      Consumed record with key alice and value {"count":2}, and updated total count to 3
      Consumed record with key alice and value {"count":3}, and updated total count to 6
      Consumed record with key alice and value {"count":4}, and updated total count to 10
      Consumed record with key alice and value {"count":5}, and updated total count to 15
      Consumed record with key alice and value {"count":6}, and updated total count to 21
      Consumed record with key alice and value {"count":7}, and updated total count to 28
      Consumed record with key alice and value {"count":8}, and updated total count to 36
      Consumed record with key alice and value {"count":9}, and updated total count to 45

#. When you are done, press ``<ctrl>-c``.

#. View the :devx-examples:`consumer code|clients/cloud/csharp/Program.cs`.

Suggested Resources
-------------------

* `How to build your first Apache Kafka Streams Application <https://kafka-tutorials.confluent.io/creating-first-apache-kafka-streams-application/confluent.html>`__
* `Getting started with Apache Kafka and your favorite language <https://developer.confluent.io/get-started/>`__
