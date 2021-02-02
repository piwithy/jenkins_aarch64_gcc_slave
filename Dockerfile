FROM ubuntu:20.04

LABEL maintainer="Pierre-Yves Jezegou <jezegoup@gmail.com>"

# Make sure the package repository is up to date.
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update
    #echo "upgrade" && \
RUN  export DEBIAN_FRONTEND=noninteractive && apt-get install -qy git build-essential gcc make cmake gdb

#installing CROSS COMPILER && GGC10
RUN apt install -y software-properties-common && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/ppa && \
    apt update && \
    apt install -y gcc-10 g++-10 gcc-10-aarch64-linux-gnu g++-10-aarch64-linux-gnu

# Install a basic SSH server
RUN  apt-get install -qy openssh-server && \
     sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
     mkdir -p /var/run/sshd
# Cleanup old packages
RUN  apt-get -qy autoremove
# Add user jenkins to the image
RUN  adduser --quiet jenkins && \
# Set password for the jenkins user (you may want to alter this).
    echo "jenkins:jenkins" | chpasswd && \
    mkdir /home/jenkins/.m2

#ADD settings.xml /home/jenkins/.m2/
# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
