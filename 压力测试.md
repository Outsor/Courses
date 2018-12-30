# Course Select [![Build Status](https://travis-ci.org/PENGZhaoqing/CourseSelect.svg?branch=master)](https://travis-ci.org/PENGZhaoqing/CourseSelect)

### 本机部署：
以下的部署步骤在Mac和Linux环境下均可执行：

* [ ] 如果不使用MiniTest进行代码覆盖率测试可以忽略这条。首先自行安装9.6版本以下的postsql数据库，如果大于9.6会导致MiniTest出错。
* [ ] ruby版本使用2.4.4   rails 版本使用4.2.8
接着执行以下代码：
```
$ git clone https://github.com/chengmonk/Courses.git
$ cd Courses
$ bundle install
$ rake db:migrate
$ rake db:seed
$ rails s 
```
* * *

### Heroku云部署
本项目已经在Heroku上进行了部署 ([演示Demo戳这里](https://csiie.herokuapp.com/ ))

tips：Heroku的注册和登录可能需要科学上网，请自备梯子。

1.将编好的程序托管在github上

2.创建Heroku账号以及Heroku app

3.`heroku login` 以后添加新`app：heroku creat [appname]`

4.heroku会自动将自己添加进git的remote仓库中，如果没有的话可以手动添加heroku分支：`heroku git:remote -a csiie`

5.运行`git push heroku master` 向heroku云端进行部署，稍等片刻。从各种环境都会自动进行部署。

6.运行`heroku open`，就可以从heroku域名去访问我们所创建的网站了。


* * *

### 目前功能：

* 多角色登陆（学生，老师，管理员）
* 学生动态选课，退课
* 老师动态增加，删除课程
* 老师对课程下的学生添加、修改成绩
* 权限控制：老师和学生只能看到自己相关课程信息

* * *
 
### 添加功能：
* 处理选课冲突
* 控制选课人数
* 支持多条件课程查询功能
* 设置/删除学位课
* 统计选课学分
* 根据选课结果显示课程表 
* 增加选课时间段的控制功能
* 系统公告
* 绑定用户邮箱（实现注册激活，忘记密码等）
* 邮件自动推送成绩
* 采用国科大真实选课数据，共有1100+条课程记录。

* * *

### 总体测试结果截图
<img src="/lib/测试结果.png" width="700">  
  

* * *

#### 系统压力测试
结果如下：
```
4584 fetches, 1026 max parallel, 1.28786e+06 bytes, in 10.0035 seconds
280.947 mean bytes/connection
458.238 fetches/sec, 128741 bytes/sec
msecs/connect: 310.481 mean, 1359.88 max, 262.762 min
msecs/first-response: 4800.2 mean, 8508 max, 362.847 min
4191 bad byte counts
HTTP response codes:
  code 200 -- 695
```

* * *

### 功能介绍
#### 面向所有用户的邮件系统
##### 用户注册激活
根据我们的需求分析，然后设计了如下的用户注册激活功能流程图：  
  
<img src="/lib/邮件激活流程图.png" width="700">  
  
以下为程序运行截图：  
  
<img src="/lib/active/1.png" width="700">  
点击完右上角注册按钮后，进入注册页面，填写注册信息，完成后点击注册按钮。  
  
<img src="/lib/active/2.png" width="700">  
系统校验注册信息，都符合后存储到数据库中，并且给用户发一封激活邮件，邮件发送成功后，返回到主页。  
  
<img src="/lib/active/3.png" width="700">  
登录注册时所用的邮箱，会收到以上内容，点击邮件中的链接将账户激活。    
<img src="/lib/active/4.png" width="700">  
点击链接后，成功激活会返回如上图的提示。
  
##### 用户找回密码
根据我们的需求分析，然后设计了如下的用户找回密码功能流程图：  
  
<img src="/lib/邮件重置密码.png" width="700">  
  
以下为程序运行截图：  
  
<img src="/lib/reset/1.png" width="700">  
如果在登录的时候忘记密码，就点击下方的忘记密码链接。  
  
<img src="/lib/reset/3.png" width="700">  
在文本框内输入注册时所使用的邮箱  
  
<img src="/lib/reset/4.png" width="700">  
发送邮件成功后，系统会反馈会一个提示  
  
<img src="/lib/reset/5.png" width="700">  
这是邮箱中收到的内容，点开链接进行重置密码的页面  
  
<img src="/lib/reset/6.png" width="700">  
将修改的密码输入之后点击“重置密码”  
  
<img src="/lib/reset/7.png" width="700">  
修改成功  
  
#### 系统管理员功能
  
拥有公告的增删改查权限，普通用户只有查询功能。
  
<img src="/lib/notice/1.png" width="700">  
这是主页上显示的公告内容，无论是否登录都可以点击进行查看。  
  
<img src="/lib/notice/2.png" width="700">  
管理员未登录的状态只能对公告进行查看。  
  
<img src="/lib/notice/3.png" width="700">  
管理员登录以后便多了编辑的选项。  
  
<img src="/lib/notice/4.png" width="700">  
进入编辑的选项后，可以对公告进行增删改查的操作。  

#### 学生功能
成绩邮件通知，当教师操作学生的成绩时，对应的学生能够及时通过邮件来知道自己的成绩，如果有何疑问也可以及时与任课老师取得联系。  
<img src="/lib/gp1.png" width="700">  
进入成绩管理界面对学生的成绩进行修改。

<img src="/lib/gp2.png" width="700">  
点击提交之后会更新学生的成绩，并且会给学生发送一封包含成绩的邮件。这些操作都完成后会在上方进行提示。  
  
<img src="/lib/gp3.png" width="700">  
这是在邮件中收到的信息。  

<img src="/lib/gp4.png" width="700">
进入选课系统查询自己的成绩。 
  
<img src="/lib/dfq/1.png" width="700">  
<img src="/lib/dfq/2.png" width="700">  
课程查询功能：支持多条件查询，如按照学院、课程类型、课程时间、课程名称。
  
<img src="/lib/dfq/3.png" width="700">  
冲突控制：时间冲突控制（包括节次和周次的冲突）、选课人数控制、已选课程冲突  
  
<img src="/lib/dfq/4.png" width="700">   
学位课设置：选课过程中可设置学位课，在已选课程里修改学位课设置(选课结束后不能修改)  
  
<img src="/lib/dfq/5.png" width="700">   
成绩查询：支持按学期查询  
  
<img src="/lib/ly/1.png" width="700">   
课表生成功能  
学生角色在选课后，可以自动生成本学期已选课程的课表，并可根据选课阶段的增删改情况更新课表。课表中显示内容依次为课程名称、课程学分、授课教师、授课地点、授课周数。  
  
<img src="/lib/ly/2.png" width="700">   
<img src="/lib/ly/3.png" width="700">   
<img src="/lib/ly/4.png" width="700">   
<img src="/lib/ly/5.png" width="700">   
学分统计功能  
学生角色可以随时查看所有已选课程学分以及当前所得学分。该界面针对学硕、专硕和直博类型学生分别设计了不同的培养方案。在左侧菜单栏中可以显示已选总学分。  
  
#### 教师功能
  
<img src="/lib/dfq/6.png" width="700">  
查看课程：查看当前学期的课程和下学期预计增加的课程
  
<img src="/lib/dfq/7.png" width="700">  
增加新课程：在增课时间内可增加新课程
  
<img src="/lib/dfq/8.png" width="700">  
成绩管理：为本学期所授课程下的学生填写成绩，并以邮件通知

#### 系统功能

* * *

## 使用

1.学生登陆：

账号：`student1@test.com`

密码：`password`

2.老师登陆：

账号：`teacher1@test.com`

密码：`password`


3.管理员登陆：

账号：`admin@qq.com`

密码：`password`

账号中数字都可以替换成2,3...等等







