FROM centos:latest

# Install python 3.6.0 and pip3 and python-dev headers for pypostal
RUN yum -y update
RUN yum -y install \
    gcc \
    make \
    git \
    curl \
    autoconf \
    automake \
    libtool \
    pkgconfig \
    yum-utils \
    https://centos7.iuscommunity.org/ius-release.rpm

RUN yum -y install \
    python36u \
    python36u-devel \
    python36u-pip \
    postgresql

# Install libpostal
RUN git clone https://github.com/openvenues/libpostal && \
    cd libpostal && \
    ./bootstrap.sh && \
    ./configure --prefix=/usr --datadir=/opt/libpostaldata && \
    make && \
    make install

# Install pypostal
RUN pip3.6 install postal \
    happybase \
    pandas \
    jsonschema \
    numpy \
    psycopg2 \ 
    SQLAlchemy \
    xlrd \
    matplotlib \
    scipy \
    statsmodels \
    patsy

# Create symlinks for the C objects (so we dont need to set LD_LIBRARY_PATH).
RUN ln -s /usr/lib/libpostal.a /usr/lib64/libpostal.a
RUN ln -s /usr/lib/libpostal.la /usr/lib64/libpostal.la
RUN ln -s /usr/lib/libpostal.so /usr/lib64/libpostal.so
RUN ln -s /usr/lib/libpostal.so.1 /usr/lib64/libpostal.so.1
RUN ln -s /usr/lib/libpostal.so.1.0.0 /usr/lib64/libpostal.so.1.0.0

# Create a 'data' volume for mounting external post data
VOLUME /data

# Create a 'source' volume for mounting external python source files.
VOLUME /src

# bash as a default command (but allow to be overridden by anything else supplied on CMD line)
CMD bash
