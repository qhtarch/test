# Linux 键盘设置

一般情况下大多数人使用键盘不需要对其进行改键和其它设置。

某些人针对其使用习惯也许会更改键盘的映射，甚至使用特殊的键盘比如 HHKB。

我对于键盘的要求不太高，只要是标准的87键机械键盘就行，它的键盘分布是标准的，同时长度不会过长，没有冗余的数字键盘空间。这里并没有鄙视薄膜键盘的意思，主要是薄膜键盘的键盘分布很多都是不规范的(这对于有一致性的输入体验的程序员来讲是很难接受的), 同时小键盘的存在也是多余的。

在此前提下，我需要将 Capslock 改为 Ctrl，我想不管我是 vim 用户还是 emacs 用户，这种改动的效益是显而易见的。有些 vim 用户将 Capslock 改为 Esc，其实是大材小用了，在 vim 和很多类 vim 的环境中，Ctrl-[ 可以用来替代 Esc。

偶尔，我会将 Menu 键改为右 Win 键，主要是因为目前我桌面环境使用的 i3 window manager，传统的 Alt 键是作为 Mod 键的，但 Alt 键在 readline 和其它很多地方要使用到，因此将 Win 键作为 Mod 键是顺理成章的了，左 Win 键因为使用习惯自然是主键，右 Win 键用的不多，但有时作为辅助 Mod 键也是不错的，就如同左右 Shift/Alt 键那样。问题是大多数键盘没有右 Win 键，倒是可能有 Menu 键，因此我需要将 Menu 键改为右 Win 键。

因此，我的 Linux 键盘按键映射的配置，主要是 1～2 个键。

我使用的 Linux distro 是 Arch Linux，经常地，会接触 virtual console，当然，更多的时间是花在 terminal emulator 中。历史中，console 是作为系统管理的 terminal，但现在这些物理终端在个人电脑的使用中是不存在了，这些使用接口转而用程序来模拟，它们原来的区别已不存在了，现在它们的主要区别是否使用图形环境。它们都是命令行的使用接口，但前者是非图形界面的，后者本质上是一个窗口程序。

这两者的这种区别，导致了键盘映射配置的不同。

## virtual console

使用 showkey 程序来查询键的 keycode，查看 keymaps 和 loadkeys 的 man 文档编写 map 文件，使用 loadkeys 或编写配置文件来是改键生效。

在 virtual console 中，我一般改 Capslock 键，有时候改右 Alt 键，因为右 Alt 键似乎不如预期。

```sh
sudo mkdir -p /usr/local/share/kbd/keymaps
sudo vim /usr/local/share/kbd/keymaps/personal.map

# 编辑 personal.map
keymaps 0-255
keycode 58 = Control
keycode 100 = Alt

# 编辑完成，使用 loadkeys
sudo loadkeys /usr/local/share/kbd/keymaps/personal.map
# 或者，设置重启后会自动生效
sudo vim /etc/vconsole.conf
# vconsole.conf
KEYMAP=/usr/local/share/kbd/keymaps/personal.map

# 注意，这个路径只是模拟 /usr/share/kbd/keymaps 的，实际可以使用其它路径。
# keymaps 0-255 的目的是避免 Ctrl 本身和其他 modifier 键改变 Ctrl 自身的含义
```

##  terminal emulator

terminal emulator，就是图形环境中的一个提供 shell 操作接口的窗口程序。

我使用的是 X11，因此使用 xev 来获取 keycode，使用 setxkbmap 或 xmodmap 来设置键映射。

```sh
# 直接在终端输入
setxkbmap -option ctrl:nocaps

# 或者将其写入 ~/.xprofile
# 然后在 ~/.xinitrc 中写入
[[ -f ~/.xprofile ]] && . ~/.xprofile
```

所幸的是 setxkbmap 的 option 提供了一些设定好的映射，直接拿来用了。而对于将 menu 改为右 Win 键的设置似乎没有，使用 xmodmap 可以方便的实现这一点。

```
# 通过 xev 获得 menu 键的 keycode 135
# 编辑 ~/.Xmodmap
keycode 135 = Super_R Super_R
# 编辑完成后
xmodmap ~/.Xmodmap
# 或者，~/.xinitrc
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
```

通过这些基本的方法就能完成键映射，更详细的配置可以查看以上命令的文档。当然，如果操作系统本身提供了工具来设置改键，比如 gnome-tweak-tools，也是可以使用的，不过以上方法更为基本和通用一些。

## typematic delay

额外的，除了改键，有时候我们需要对按键的延迟进行设置，意思是，在我们需要对某个键连击时，比如 vim 中连续的翻行或翻页，一直按下某个键到它开始连续反应的这段时间是可以设置的。

有时候，系统默认的这段时间过长，比如 X11 的默认设置是 660ms，我一般将它改短。

```sh
# termianal emulator 中输入
xset r rate 200 30
# 或将其写入 ~/.xprofile


# virtual console 中输入
kbdrate -d 200 -r 30
# 或自定义 systemd service
```

200 表示 200ms，30 表示 30 hz。
