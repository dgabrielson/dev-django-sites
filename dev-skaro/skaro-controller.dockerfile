FROM skaro-base:latest

COPY ./controller_start.sh /opt/start.sh
CMD ["/opt/start.sh"]
