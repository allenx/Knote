# Knote -Version 1.0

Knote is your personal knowledge handler.


The current version is having problems with searching the database, and I don't know how to solve it coz everyone on StackOverflow says my code is right.

Oh please DO NOTICE This:
You can only run it on a 4.7 inch screen iPhone (iPhone 6 and iPhone 6s) only.
I did not use Auto Layout. Sorry. I didn't know how, actually.

To @xnth97
# What Knote is capable of:
1. 新增、修改、归档你的笔记
2. 登陆界面的登录按钮用第三方代码实现了 Material Design 的动效（即按下去的时候按钮上浮一个像素，从点按处扩散出水波纹）
3. 在笔记列表下，背景有Parallax特效（类iOS 7以后的homescreen）
4. 当笔记列表条数大于本屏幕所能显示条数时，上下滚动笔记本列表将会有每一个卡片翻转的动效
5. 点击每个卡片的感叹号按钮，可以使笔记卡片翻转，切换到笔记的详细信息视图（该功能目前只能看动效，详细信息界面因为 storyboard 图层的层级关系没有调好，以及没有加入数据库，故还不能使用）
6. 点击卡片或新建笔记后的编辑界面，拥有一个模糊透明的背景
7. 点击右上角 Archive 图标，能够进入 Archive 界面，这个界面的背景图通过 AFNetworking 与随机 URL 获得，因为预设的 URL 库是 Blogspot 上面的，所以要翻墙才能加载出来
8. 在登陆界面按下 Microsoft 图标，能够进入最开始构想的界面，即实现如 Google Keep 的动态卡片（自动调整大小与颜色） 

# What Knote is lacking in functionality:
1. 登陆的功能没有实现
2. 主界面的搜索功能因为无法正确识别输入字符串，没有实现。至今不知问题所在，StackOverflow 上面的人都觉得没啥问题，就是不知道为什么会无法搜索
3. 在编辑界面下的模糊背景特效，比较消耗 CPU，手机用久了发烫严重……
4. 无法正确存储带单引号的字符串，有解决方案，成功解决后，有一次应用崩了，重写了应用，就暂时还没有解决该问题
5. 没有用Auto Layout，只能在 iPhone 6/iPhone 6s 上运行
