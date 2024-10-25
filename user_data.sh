#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
#asi es generico, en el problema la variable iba vacia y se asociaba al un cluster "default" y eso era el problema mas grande.