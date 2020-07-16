FROM openjdk:8

RUN echo 'alias la="ls -lha"' >> ~/.bashrc

RUN apt-get update && \
	apt-get install -y maven && \
	apt-get install -y build-essential && \
	apt-get install -y libxml2-utils && \
    curl -L https://cpanmin.us | perl - App::cpanminus

WORKDIR /ppgsi

# install defects4j
RUN git clone https://github.com/rjust/defects4j.git
WORKDIR defects4j
RUN cpanm --installdeps . && \
	./init.sh
ENV PATH="${PATH}:/ppgsi/defects4j/framework/bin"

WORKDIR /ppgsi

# install ba-dua
RUN git clone https://github.com/saeg/ba-dua.git
WORKDIR ba-dua
RUN git checkout e3d85d0 && \
	mvn clean install

WORKDIR /ppgsi

# install jaguar-df
RUN git clone https://github.com/marioconcilio/jaguar-df.git
WORKDIR jaguar-df
RUN make build_core

WORKDIR /ppgsi

# copy scripts
ADD run_jaguar.sh run_jaguar.sh
ADD run_badua.sh run_badua.sh
ADD checkout_project.sh checkout_project.sh
ADD projects.d4j projects.d4j
ADD versions.d4j versions.d4j
