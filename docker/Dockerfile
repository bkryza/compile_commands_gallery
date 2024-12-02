FROM fedora:41
LABEL org.opencontainers.image.authors="bkryza@gmail.com"
LABEL org.opencontainers.image.documentation="https://github.com/bkryza/compile_commands_gallery"

# Install the basics
RUN dnf -y update && \
    dnf -y install wget make clang clang-tidy python3-pip which moreutils jq git lua unzip zstd vim cowsay && \
    dnf clean all

# Install clang-uml
RUN wget https://github.com/bkryza/clang-uml/releases/download/0.5.6/clang-uml-0.5.6-1.fc41.x86_64.rpm && \
    dnf -y install ./clang-uml-0.5.6-1.fc41.x86_64.rpm && \
    rm clang-uml-0.5.6-1.fc41.x86_64.rpm && \
    dnf clean all

# Install cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.31.1/cmake-3.31.1-linux-x86_64.tar.gz && \
    tar -zxf cmake-3.31.1-linux-x86_64.tar.gz --strip-components=1 -C /usr && \
    rm -rf cmake-3.31.1-linux-x86_64.tar.gz

# Install B2
RUN git clone https://github.com/bfgroup/b2 && \
    cd b2 && \
    git checkout 7954ee6e55e9b5a3b89245470b21eca9a489843a && \
    ./bootstrap.sh && \
    ./b2 install --prefix=/usr && \
    cd .. && \
    rm -rf b2

# Install Bazel
RUN wget https://github.com/bazelbuild/bazel/releases/download/7.4.1/bazel-7.4.1-linux-x86_64 && \
    mv bazel-7.4.1-linux-x86_64 /usr/bin/bazel && \
    chmod +x /usr/bin/bazel

# Install kiron1/bazel-compile-commands
RUN git clone https://github.com/kiron1/bazel-compile-commands && \
    cd bazel-compile-commands && \
    bazel build --config=gnu //bcc:bazel-compile-commands && \
    cp bazel-bin/bcc/bazel-compile-commands /usr/bin/ && \
    cd .. && \
    rm -rf bazel-compile-commands && \
    rm -rf /root/.cache/bazel

# Install Buck2
RUN wget https://github.com/facebook/buck2/releases/download/2024-11-15/buck2-x86_64-unknown-linux-gnu.zst && \
    zstd -d buck2-x86_64-unknown-linux-gnu.zst && \
    mv buck2-x86_64-unknown-linux-gnu /usr/bin/buck2 && \
    chmod +x /usr/bin/buck2 && \
    rm -rf buck2-x86_64-unknown-linux-gnu.zst

# Install Build2
RUN wget https://stage.build2.org/1/build2/build2-0.18.0-a.0.20241126062707.2164f1544357.tar.gz && \
    tar zxf build2-0.18.0-a.0.20241126062707.2164f1544357.tar.gz && \
    cd build2-0.18.0-a.0.20241126062707.2164f1544357 && \
    wget https://stage.build2.org/1/build2/libbutl-0.18.0-a.0.20241112122352.98bef49e83a6.tar.gz && \
    tar zxf libbutl-0.18.0-a.0.20241112122352.98bef49e83a6.tar.gz && \
    ./bootstrap.sh g++ && \
    build2/b-boot config.cxx=g++ config.bin.lib=static build2/exe{b} && \
    build2/b-boot configure config.config.hermetic=true config.cxx=g++ config.cc.coptions=-O3 config.bin.rpath=/usr/lib config.install.root=/usr/ && \
    build2/b-boot install && \
    cd .. && \
    rm -rf build2-0.18.0-a.0.20241126062707.2164f1544357 build2-0.18.0-a.0.20241126062707.2164f1544357.tar.gz

# Install Bear
RUN dnf -y install bear && \
    dnf clean all

# Install compiledb
RUN pip3 install compiledb

# Install FASTBuild
RUN wget https://www.fastbuild.org/downloads/v1.13/FASTBuild-Linux-x64-v1.13.zip && \
    unzip FASTBuild-Linux-x64-v1.13.zip && \
    mv fbuild /usr/bin/ && \
    mv fbuildworker /usr/bin && \
    chmod +x /usr/bin/fbuild && \
    chmod +x /usr/bin/fbuildworker && \
    rm -rf FASTBuild-Linux-x64-v1.13.zip LICENSE.txt

# Install meson
RUN pip3 install meson

# Install ninja
RUN dnf -y install ninja-build && \
    dnf clean all

# Install Premake
RUN dnf -y install premake && \
    dnf clean all

# Install Qbs
RUN dnf -y install qbs && \
    dnf clean all

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
RUN dnf -y install xmake && \
    dnf clean all && \
    echo "export XMAKE_ROOT=y" >> /root/.bashrc

# Setup start cmd
ADD start.sh .
RUN chmod +x start.sh

ENV TERM=xterm-256color

CMD ["bash", "-c", "./start.sh && cd compile_commands_gallery && bash -l"]
