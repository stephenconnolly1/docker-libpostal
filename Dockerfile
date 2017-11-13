FROM centos:latest

# Install python 3.6.0 and pip3 and python-dev headers for pypostal
RUN yum -y update
RUN yum -y install yum-utils
RUN yum -y install gcc make git curl autoconf automake libtool pkgconfig
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install python36u python36u-devel python36u-pip

# Install libpostal
RUN git clone https://github.com/openvenues/libpostal && cd libpostal && ./bootstrap.sh && ./configure --prefix=/usr --datadir=/opt/libpostaldata && make && make install

# Install pypostal
RUN pip3.6 install postal

# Create a 'data' volume for mounting external post data
VOLUME /data

# Create a 'source' volume for mounting external python source files.
VOLUME /src

# bash as a default command (but allow to be overridden by anything else supplied on CMD line)
CMD bash
