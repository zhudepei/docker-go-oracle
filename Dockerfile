FROM golang:1.17

RUN apt-get update && apt-get install -y pkg-config libaio1 unzip cron gcc

ENV CLIENT_FILENAME instantclient_12_2.zip
COPY ./${CLIENT_FILENAME} .
COPY ./oci8.pc /usr/lib/pkgconfig/oci8.pc

ENV LD_LIBRARY_PATH /usr/lib:/usr/local/lib:/usr/instantclient_12_2

# to build the application with mattn/go-oci8, it is necessary to extract all files, including the SDK.
RUN unzip ${CLIENT_FILENAME} -d /usr &&  \
    ln -s /usr/instantclient_12_2/libclntsh.so.12.1 /usr/instantclient_12_2/libclntsh.so && \
    ln -s /usr/instantclient_12_2/libclntshcore.so.12.1 /usr/instantclient_12_2/libclntshcore.so && \
    ln -s /usr/instantclient_12_2/libocci.so.12.1 /usr/instantclient_12_2/libocci.so

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/timezone
 
RUN GOPROXY=https://goproxy.cn go get -u github.com/mattn/go-oci8