FROM skaro-base:latest

COPY ./web_start.sh /opt/start.sh
CMD ["/opt/start.sh"]
