FROM centos:6.9
MAINTAINER ninecrow <ninecrow@yeah.net>


RUN yum update -y \
    && yum install -y tar.x86_64 wget net-tools vim openssh-server openssh-clients sudo\
    && yum clean all
	
#ssh设置
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config \
    && useradd admin \
    && echo "admin:admin" | chpasswd \
    && echo "admin  ALL=(ALL)    ALL" >> /etc/sudoers

RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key \
    && sudo chkconfig sshd on

#JDK设置
ARG JDK_VER=8 
ARG JDK_UPD=171
ARG JDK_BUILD=11
ARG JDK_ED=${JDK_VER}u${JDK_UPD}
ARG JDK_SIG=512cd62ec5174c3487ac17c61aaa89e8
ARG JDK_SHA=b6dd2837efaaec4109b36cfbb94a774db100029f98b0d78be68c27bec0275982
ARG JDK_FILE_SAVE_PATH=/opt/jdk
ARG JDK_FILE_EXTRACT_DIR=jdk1.${JDK_VER}.0_${JDK_UPD}
ARG JDK_FILE_NAME=jdk-${JDK_ED}-linux-x64.tar.gz
ARG JAVA_HOME=${JDK_FILE_SAVE_PATH}/${JDK_FILE_EXTRACT_DIR}

#ENV JRE_HOME=${JAVA_HOME}/jre
#ENV CLASSPATH=.:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
#ENV PATH=${PATH}:${JAVA_HOME}/bin:${JRE_HOME}/bin

RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/profile \
    && echo "export JRE_HOME=${JAVA_HOME}/jre" >> /etc/profile \
    && echo "export CLASSPATH=.:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar" >> /etc/profile \
    && echo "export PATH=${PATH}:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin" >> /etc/profile \
    && mkdir -p ${JAVA_HOME} 

#调试用先下载好，copy到容器
#COPY ${JDK_FILE_NAME}  ${JDK_FILE_SAVE_PATH}/${JDK_FILE_NAME}

#github dockhub 自动生成image用
WORKDIR ${JDK_FILE_SAVE_PATH}

RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JDK_ED}-b${JDK_BUILD}/${JDK_SIG}/${JDK_FILE_NAME} \
    && echo "${JDK_SHA}  ${JDK_FILE_NAME}" > ${JDK_FILE_SAVE_PATH}/sha256 \
    && sha256sum -c ${JDK_FILE_SAVE_PATH}/sha256 \
    && tar -xvf ${JDK_FILE_NAME} -C ${JAVA_HOME} --strip-components=1 \
    && alternatives --install /usr/bin/java java ${JAVA_HOME}/bin/java 1 \
    && alternatives --install /usr/bin/javac javac ${JAVA_HOME}/bin/javac 1 \
    && alternatives --install /usr/bin/jar jar ${JAVA_HOME}/bin/jar 1 \
    && rm -f ${JDK_FILE_NAME} \
    && rm -f ${JAVA_HOME}/*.zip 

WORKDIR / 
RUN echo "root:Pass@word" | chpasswd

ADD entrypoint.sh /entrypoint.sh
RUN sudo chmod a+x /entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
