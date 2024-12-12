db = db.getSiblingDB("TopicstoreDb");

db.createCollection("Topics");

db.Topics.insertOne({
  "_id": ObjectId("5fa2ca6abe7a379ec4234883"),
  "topicName": "Contenedores"
});

// Añadir 4 registros más
db.Topics.insertMany([
  {
    "_id": ObjectId("64ab9cdbe6a9172efc12d124"),
    "topicName": "Virtualización"
  },
  {
    "_id": ObjectId("78b12dc0f5c9a4e3f8112fa6"),
    "topicName": "Kubernetes"
  },
  {
    "_id": ObjectId("8a3c1a2b75c4a0e5d631b12d"),
    "topicName": "Microservicios"
  },
  {
    "_id": ObjectId("93e1bfb9a3d7c5f890b01c4d"),
    "topicName": "DevOps"
  }
]);