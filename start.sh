screen -dmS $user java -Xms512M -Xmx1G -jar server.jar nogui
ttyd -W -p 8080 screen -x $user
