FROM centos
MAINTAINER d9magai

ENV SRC_DIR /opt/src
ENV MPSS_SRC_DIR $SRC_DIR/mpss_src
ENV OPENCL_RUNTIME_SRC_DIR $SRC_DIR/openclruntime_src
ENV INTEL_CODE_BUILDER_SRC_DIR $SRC_DIR/intelcodebuilder_src

ENV MPSS_ARCHIVE mpss-3.4.2-linux.tar
ENV OPENCL_RUNTIME_ARCHIVE opencl_runtime_14.2_x64_4.5.0.8.tgz
ENV INTEL_CODE_BUILDER_ARCHIVE intel_code_builder_for_opencl_2015_5.0.0.62_x64.tgz

ENV USER root
RUN ldconfig

RUN yum update -y && yum install -y \
    tar \
    numactl-libs \
    redhat-lsb-core \
    fontconfig-devel \
    freetype-devel \
    libICE-devel \
    libpng12-devel \
    libSM-devel \
    libX11-devel \
    libXext-devel \
    libXrender-devel \
    && yum clean all

RUN mkdir -p $MPSS_SRC_DIR \
    && cd $MPSS_SRC_DIR \
    && curl -sL http://registrationcenter.intel.com/irc_nas/5017/$MPSS_ARCHIVE -o $MPSS_ARCHIVE \
    && tar xf $MPSS_ARCHIVE \
    && cd `tar tf $MPSS_ARCHIVE | head -1` \
    && yum localinstall -y mpss-coi* libscif* \
    && rm -rf $MPSS_SRC_DIR

RUN mkdir -p $OPENCL_RUNTIME_SRC_DIR \
    && cd $OPENCL_RUNTIME_SRC_DIR \
    && curl -sL http://registrationcenter.intel.com/irc_nas/4181/$OPENCL_RUNTIME_ARCHIVE -o $OPENCL_RUNTIME_ARCHIVE \
    && tar xf $OPENCL_RUNTIME_ARCHIVE \
    && cd `tar ztf $OPENCL_RUNTIME_ARCHIVE | head -1` \
    && sed "s/ACCEPT_EULA=decline/ACCEPT_EULA=accept/g" silent.cfg > accept.cfg \
    && ./install.sh -s accept.cfg \
    && rm -rf $OPENCL_RUNTIME_SRC_DIR

RUN mkdir -p $INTEL_CODE_BUILDER_SRC_DIR \
    && cd $INTEL_CODE_BUILDER_SRC_DIR \
    && curl -sL http://registrationcenter.intel.com/irc_nas/5193/$INTEL_CODE_BUILDER_ARCHIVE -o $INTEL_CODE_BUILDER_ARCHIVE \
    && tar xf $INTEL_CODE_BUILDER_ARCHIVE \
    && cd `tar ztf $INTEL_CODE_BUILDER_ARCHIVE | head -1` \
    && sed "s/ACCEPT_EULA=decline/ACCEPT_EULA=accept/g" silent.cfg > accept.cfg \
    && ./install.sh -s accept.cfg \
    && rm -rf $INTEL_CODE_BUILDER_SRC_DIR

