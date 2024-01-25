su - minecraft <<EOF
screen -S minecraft-server -X stuff "stop$(printf \\r)"
EOF
