FROM skaro-base:latest

COPY ./compute_start.sh /opt/start.sh
CMD ["/opt/start.sh"]
