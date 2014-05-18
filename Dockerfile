FROM google/debian:wheezy

#############
# Add an addtional source for the latest glibc
RUN sed -i '1i deb http://ftp.us.debian.org/debian/ jessie main' /etc/apt/sources.list

# Update sources
RUN apt-get update

# Download latest glibc
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libc6 libc6-dev libc6-dbg git screen unzip vim wget

# Change working directory
WORKDIR /tmp

# Create opt directory
RUN mkdir -p /opt

# Download the latest dart sdk
RUN wget http://storage.googleapis.com/dart-archive/channels/dev/release/latest/sdk/dartsdk-linux-x64-release.zip -O dartsdk-linux-x64-release.zip

# Unpack the dart sdk
RUN unzip -d /opt/ dartsdk-linux-x64-release.zip

# Make the sdk readable 
# sudo chmod -R go+rx /dart-sdk

# Setup path to include dart-sdk/bin
ENV PATH /opt/dart-sdk/bin:$PATH
#############

EXPOSE 8080

RUN mkdir -p /opt/app
ADD . /opt/app

WORKDIR /opt/app
RUN pub install
ENTRYPOINT ["dart"]
CMD ["bin/server.dart"]

