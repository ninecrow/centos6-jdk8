centos6-jdk8
=====

### image信息
		OS:centos6.9 (official)
		JDK:jdk-8u171-linux-x64
&nbsp;
### jdk默认参数
		build 时候通过修改以下参数，可以修改生成image的jdk版本
		ARG JDK_VER=8 
		ARG JDK_UPD=171
		ARG JDK_BUILD=11
		ARG JDK_ED=${JDK_VER}u${JDK_UPD}
		ARG JDK_SIG=512cd62ec5174c3487ac17c61aaa89e8
		ARG JDK_SHA=b6dd2837efaaec4109b36cfbb94a774db100029f98b0d78be68c27bec0275982
&nbsp;
#### image build example：
		docker build -t  <imagename>   \
		--build-arg JDK_VER=8  \
		--build-arg JDK_UDP=171 \
		--build-arg JDK_BUILD=11 \
		--build-arg JDK_SIG=512cd62ec5174c3487ac17c61aaa89e8 \
		--bulid-arg JDK_SHA=b6dd2837efaaec4109b36cfbb94a774db100029f98b0d78be68c27bec0275982 \
		.
&nbsp;		
#### 参数说明
		JDK_SIG：是jdk下载链接中[/8u171-b11]和[/jdk-8u71-jdk-8u171-linux-x64.tar.gz]之间的32个字符
		http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz
		
		JDK_SHA: 是https://www.oracle.com/webfolder/s/digest/8u172checksum.html中响应下载版本的SHA256字符串，用以验证下载文件完整无修改。
&nbsp;
#### 容器启动
		jdk没有后台进程，需要通过给container内的脚本[enptypoint.sh -d]带入[-d] 运行循环进程解决；
&nbsp;	
		example:
		docker run -idt --name jdk <imagename>  -d
		
&nbsp;		
#### 进入容器
		容器启动后，可以通过ssh登陆，或者直接在host内通过[docker exec]命令方式进入；
		最后添加[-l]参数，login方式启动bash， 会加载/etc/profile的配置参数；
&nbsp;	
		example:
		docker exec -it <imagename>  /bin/bash -l
