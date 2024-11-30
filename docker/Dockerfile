FROM fedora:41
LABEL org.opencontainers.image.authors="bkryza@gmail.com"
LABEL org.opencontainers.image.documentation="https://github.com/bkryza/compile_commands_gallery"

# Install the basics
RUN dnf -y install wget make clang clang-tidy python3-pip which moreutils jq git lua

# Install clang-uml
RUN wget https://github.com/bkryza/clang-uml/releases/download/0.5.6/clang-uml-0.5.6-1.fc41.x86_64.rpm && \
    dnf -y install ./clang-uml-0.5.6-1.fc41.x86_64.rpm && \
    rm clang-uml-0.5.6-1.fc41.x86_64.rpm

# Install cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.31.1/cmake-3.31.1-linux-x86_64.tar.gz && \
    tar -zxf cmake-3.31.1-linux-x86_64.tar.gz --strip-components=1 -C /usr && \
    rm -rf cmake-3.31.1-linux-x86_64.tar.gz

RUN wget https://github.com/bfgroup/b2/releases/download/5.2.1/b2-5.2.1.tar.bz2 && \
    tar jxf b2-5.2.1.tar.bz2 && \
    cd b2-5.2.1 && \
    ./bootstrap.sh && \
    ./b2 install --prefix=/usr && \
    cd .. && \
    rm -rf b2-5.2.1.tar.bz2 b2-5.2.1

# Install Bear
RUN dnf -y install bear

# Install compiledb
RUN pip3 install compiledb

# Install meson
RUN pip3 install meson

# Install ninja
RUN dnf -y install ninja-build

# Install Premake
RUN dnf -y install premake

# Install Qbs
RUN dnf -y install qbs

# Install SCons
RUN pip3 install scons

# Install Waf
RUN wget https://waf.io/waf-2.1.4.tar.bz2 && \
    tar jxf waf-2.1.4.tar.bz2 && \
    cd waf-2.1.4 && \
    python waf-light --tools=clang_compilation_database && \
    chmod +x waf && \
    cp waf /usr/bin && \
    cd .. && \
    rm -rf waf-2.1.4 waf-2.1.4.tar.bz2

# Install xmake
RUN dnf -y install xmake

ADD start.sh .
RUN chmod +x start.sh

ENV TERM xterm-256color
#... more stuff
CMD ["bash", "-l"]
