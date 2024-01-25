#!/bin/bash

# Obtener los PID de las sesiones de screen
pids=$(pgrep -l screen | awk '{print $1}')

# Iterar sobre los PID y enviar la señal de terminación
for pid in $pids; do
    echo "Matando el proceso screen con PID $pid"
    kill -TERM $pid
done
