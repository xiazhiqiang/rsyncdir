# 目录结构及文件说明

- log文件夹: `以天为单位存放处理日志`
- rsync_config.sh: `配置文件`
- rsync_dir.sh: `同步目录脚本`
- delete_log.sh: `删除日志文件`

# 部署服务器同步目录脚本

## 1、设置主服务器ssh免密码登陆到各从服务器

- 在主服务器上生成rsa

		ssh-keygen -t rsa


- 将主服务器公共密钥id_rsa.pub拷贝或追加到各从服务器的authorized_keys中

  若从服务器不存在authorized_keys文件，则拷贝

		scp .ssh/id_rsa.pub xxx@abc.com:~/.ssh/authorized_keys
		
		
  若从服务器存在authorized_keys文件，则追加

		scp .ssh/id_rsa.pub xxx@abc.com:~/tmp/
		cat id_rsa.pub >> ~/.ssh/authorized_keys


## 2、将rsyncdir目录整体拷贝到主服务器下至少具有执行权限的目录中

## 3、修改rsync_dir.sh、delete_log.sh中的$dir路径

### 1）利用主服务器系统$HOME变量修改路径（文件所示）

- 若未定义，修改.bashrc或者.bash_profile，添加$HOME变量定义

		export HOME=/aaa/bbb
		source ~/.bashrc或source ~/.bash_profile //使配置生效


- 若定义，输出检查是否是主服务器的用户目录。若不符合要求，请自行修改$dir变量为实际环境中的绝对路径

### 2）直接pwd输出rsyncdir在主服务器中的绝对路径，将绝对路径替换$dir变量值

## 4、修改config配置

- master_server: 主服务器用户名和域名

		例如：user01@master.hostname.com

- master_rsync_dir: 主服务器同步的目录，绝对路径
- slave_server: 从服务器用户名和域名，若有多个，在括号内用空格分隔
- slave_rsync_dir: 从服务器同步目录，与slave_server对应

## 5、备份服务器上的欲同步目录，以防丢失重要文件

## 6、命令行执行一次同步脚本并检查log日志状态是否成功

		sh rsync_dir.sh
		cd log
		vim 20151111
				
## 7、执行一次同步脚本成功后，添加crontab定时执行脚本

		0 * * * * source ~/.bashrc && sh aaa/bbb/rsync_dir.sh >> /dev/null