FROM ubuntu:latest
RUN apt-get update && apt-get install -y curl ca-certificates
RUN curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
RUN ibmcloud plugin install power-iaas
COPY detach-subnet.sh /app/
WORKDIR /app
RUN chmod +x detach-subnet.sh 
CMD ["sh", "-c", "./detach-subnet.sh"]