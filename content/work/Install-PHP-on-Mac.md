# Mac 10.9 下搭建php开发环境

- pubdate:2014-02-21
- tags: work


-----------


网上文章很多，但要么过旧要么不全，所以我新写了一个，增加了10.9下存在的新问题的解决办法。


主要内容包括：
启动Apache
运行PHP
安装MySQL
使用phpMyAdmin
配置PHP的MCrypt扩展库
设置虚拟主机


## 启动Apache

打开“终端（terminal）”，然后（注意：sudo需要的密码就是系统的root帐号密码）
运行“sudo apachectl start”，再输入帐号密码，这样Apache就运行了。
运行“sudo apachectl －v”，你会看到Mac OS X 10.9中的Apache版本号：
Server version: Apache/2.2.24 (Unix)
Server built:   Aug 24 2013 21:10:43
这样在浏览器中输入“http://localhost”，就可以看到出现一个内容为“It works!”的页面，它位于“/Library（资源库）/WebServer/Documents/”下，这是Apache的默认根目录。
注意：开启了Apache就是开启了“Web共享”，这时联网的用户就会通过“http://[本地IP]/”来访问“/Library（资源库）/WebServer/Documents/”目录，通过“http://[本地IP]/~[用户名]”来访问“/Users/[用户名]/Sites/”目录，可以通过设置“系统偏好设置”的“安全（Security）”中的“防火墙（Firewall）”来禁止这种访问。



## 运行PHP

在终端中运行“sudo vi /etc/apache2/httpd.conf”，打开Apache的配置文件。（如果不习惯操作终端和vi的可以设置在Finder中显示所有的系统隐藏文件，记得需要重启Finder，这样就可以找到对应文件，随心所欲编辑了，但需要注意的是某些文件的修改需要开启root帐号，但整体上还是在终端上使用sudo来临时获取root权限比较安全。）
找到“#LoadModule php5_module libexec/apache2/libphp5.so”，把前面的#号去掉，保存（在命令行输入:w）并退出vi（在命令行输入:q）。
运行“sudo cp /etc/php.ini.default /etc/php.ini”，这样就可以通过php.ini来配置各种PHP功能了。
现在 PHP 应该已经开始工作了，你可以在用户级根目录下(~/Sites/)放一个PHP测试文件，代码如下：
<?php phpinfo(); ?>


##安装MySQL
 
Mountain Lion 中并没有集成 Mysql，需要手动安装。你可以点击这个链接下载 MySQL 的安装包，请下载 Mac OS X ver. 10.6 (x86, 64-bit), DMG Archive(可以在 Mountain Lion 下正常工作)。
点击下载之后，会跳转到一个注册/登录页面，你不需要注册也不需要登录，直接点登录框下面的：No thanks, just take me to the downloads! 就可以跳过这个步骤直接开始下载了，整个 DMG 包大约是113MB。

下载完DMG之后，双击你会提取出三个文件和一个 RedMe.txt 文档。这三个文件分别是：

mysql5.5.xxx.pkg
MySQLstartupitem.pkg
MySQLPrefPane
你需要逐一安装这三个文件，双击之后系统可能会提示你由于该软件包来自身份不明的开发者，不能安装。遇到这种情况，你可以按住 command 键，然后右键点击安装文件，再点击右键菜单中的”打开”，这样就可以绕过这个安全限制了(当然你也可以在系统偏好设置——安全性与隐私——通用中改成可打开”任何来源”的应用程序)。

三个文件都安装完成之后，进入「系统偏好设置」，在面板的最下面你会看到一个 MySQL 的设置项，点击它之后就可以启动MySQL，或者你也可以通过下面的命令开启：

sudo /usr/local/mysql/support-files/mysql.server start

如果你想查看 MySQL 的版本，可以用下面这个命令：

/usr/local/mysql/bin/mysql -v

运行上面这个命令之后，会直接从命令行中登录到 MySQL，输入命令 \q 即可退出。

到这里 MySQL 已经配置完成，并且可以运行。但为了更加方便使用，你最好再设置一下系统环境变量，也就是让 mysql 这个命令在任何路径都可以直接启动(不需要输入一长串的准确路径)。

设置环境变量也很方便，直接用命令(这里笔者用 vi 编辑器举例)：

vi ~/.zshrc

然后按字母 i 进入编辑模式，将下面的这句代码贴进去：

export PATH="$PATH:/usr/local/mysql/bin"

然后按 esc 退出编辑器，再输入 :wq(别忘了冒号)保存退出。

接下来还要重新加载一下 Shell 以让上面的环境变量生效：

source ~/.zshrc

之后你就可以在终端的任意目录使用 mysql 命令了，你可以运行 mysql -v 试试。

最后一步，你还应该给你的 MySQL 设置一个 root 用户密码，命令如下：

mysqladmin -u root password '这里填你要设置的密码'

(请记住密码一定要用半角单引号包起来)

上面的 mysqladmin 命令，我没有写完整路径。因为上面我们已经设置了环境变量，如果你没有设置环境变量的话，就需要用/usr/local/mysql/bin/mysqladmin ******** 来运行。


##使用phpMyAdmin
 
phpMyAdmin是用PHP开发的管理MySQL的程序，非常的流行和实用。能够实用phpMyAdmin管理MySQL是检验前面几步成果的非常有效方式。
下载phpMyAdmin。选择合适的版本，比如我选择的是phpMyAdmin-3.3.2-all-languages.tar.bz2这个版本。
把“下载（downloads）”中的phpMyAdmin-3.32-all-languages文件夹复制到“/Users/[用户名]/Sites”中，名改名为phpmyadmin。
复制“/Users/[用户名]/Sites/phpmyadmin/”中的config.sample.inc.php，并命名为config.inc.php
打开config.inc.php,做如下修改：
用于Cookie加密，随意的长字符串
$cfg['blowfish_secret'] = ''; 
 
当phpMyAdmin中出现“#2002 无法登录 MySQL 服务器”时，
请把localhost改成127.0.0.1就ok了，
这是因为MySQL守护程序做了IP绑定（bind-address =127.0.0.1）造成的
$cfg['Servers'][$i]['host'] = 'localhost';
 
把false改成true，这样就可以访问无密码的MySQL了，
即使MySQL设置了密码也可以这样设置，然后在登录phpMyAdmin时输入密码
$cfg['Servers'][$i]['AllowNoPassword'] = false;
这样就可以通过http://localhost/~[用户名]/phpmyadmin访问phpMyAdmin了。这个时候就看到一个提示“无法加载 mcrypt 扩展，请检查您的 PHP 配置。”，这就涉及到下一节安装MCrypt扩展了。


##配置PHP的MCrypt扩展
 
MCrypt是一个功能强大的加密算法扩展库，它包括有22种算法，phpMyAdmin依赖这个PHP扩展库。但是它在Mac OS X下的安装却不那么友善，具体如下：
下载并解压libmcrypt-2.5.8.tar.bz2。
在终端执行如下命令（注意如下命令需要安装xcode支持）：
cd ~/Downloads/libmcrypt-2.5.8/
./configure --disable-posix-threads --enable-static
make
sudo make install
下载并解压PHP源码文件php-5.3.1.tar.bz2。Mac OS X 10.6.3中预装的PHP版本是5.3.1，而现在最新的PHP版本是5.3.2，你需要依据自己的实际情况选择对应的版本。
在终端执行如下命令：
cd ~/Downloads/php-5.3.1/ext/mcrypt
ln -s /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk/usr/include /usr/include
sudo ln -s /usr/local/Cellar/autoconf/2.69/bin/autoconf /usr/bin/autoconf
sudo ln -s /usr/local/Cellar/autoconf/2.69/bin/autoheader /usr/bin/autoheader
phpize
./configure
make
cd modules
sudo cp mcrypt.so /usr/lib/php/extensions/no-debug-non-zts-20090626/
打开php.ini
sudo vi /etc/php.ini
在php.ini中加入如下代码，并保存后退出，然后重启Apache
extension=/usr/lib/php/extensions/no-debug-non-zts-20090626/mcrypt.so
当你再访问http://localhost/~[用户名]/phpmyadmin时，你会发现“无法加载 mcrypt 扩展，请检查您的 PHP 配置。”的提示没有了，这就表示MCrypt扩展库安装成功了。


##设置虚拟主机
 
在终端运行“sudo vi /etc/apache2/httpd.conf”，打开Apche的配置文件
在httpd.conf中找到“#Include /private/etc/apache2/extra/httpd-vhosts.conf”，去掉前面的“＃”，保存并退出。
运行“sudo apachectl restart”，重启Apache后就开启了它的虚拟主机配置功能。
运行“sudo vi /etc/apache2/extra/httpd-vhosts.conf”，这样就打开了配置虚拟主机的文件httpd-vhost.conf，配置你需要的虚拟主机了。需要注意的是该文件默认开启了两个作为例子的虚拟主机：
<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot "/usr/docs/dummy-host.example.com"
    ServerName dummy-host.example.com
    ErrorLog "/private/var/log/apache2/dummy-host.example.com-error_log"
    CustomLog "/private/var/log/apache2/dummy-host.example.com-access_log" common
</VirtualHost>
<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host2.example.com
    DocumentRoot "/usr/docs/dummy-host2.example.com"
    ServerName dummy-host2.example.com
    ErrorLog "/private/var/log/apache2/dummy-host2.example.com-error_log"
    CustomLog "/private/var/log/apache2/dummy-host2.example.com-access_log" common
</VirtualHost> 
而实际上，这两个虚拟主机是不存在的，在没有配置任何其他虚拟主机时，可能会导致访问localhost时出现如下提示：
Forbidden
You don't have permission to access /index.php on this server
最简单的办法就是在它们每行前面加上#，注释掉就好了，这样既能参考又不导致其他问题。
增加如下配置
<VirtualHost *:80>
    DocumentRoot "/Users/[用户名]/Sites"
    ServerName sites
    ErrorLog "/private/var/log/apache2/sites-error_log"
    CustomLog "/private/var/log/apache2/sites-access_log" common
</VirtualHost> 
保存退出，并重启Apache。
运行“sudo vi /etc/hosts”，打开hosts配置文件，加入”127.0.0.1 sites“，这样就可以配置完成sites虚拟主机了，这样就可以用“http://sites”访问了，其内容和“http://localhost/~[用户名]”完全一致。
这是利用Mac OS X 10.6.3中原生支持的方式来实现的配置，也可以参考“Mac OS X Leopard: 配置Apache, PHP, SQLite, MySQL, and phpMyAdmin(一) ”和“Mac OS X Leopard: 配置Apache, PHP, SQLite, MySQL, and phpMyAdmin(二) ”。实际上，你还可以使用XAMPP或MacPorts这种第三方提供的集成方案来实现简单的安装和使用。