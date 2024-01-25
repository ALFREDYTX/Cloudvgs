su - minecraft <<EOF
screen -S name-server -X stuff "stop$(printf \\r)"
EOF
