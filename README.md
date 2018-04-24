## Home Folder Config Files/Dotfiles

### VIM

Before opening VIM for the first time, run:

```bash
mkdir -p .vim/bundle
cd .vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git
vim +PluginInstall +qall
```

### st (simple terminal)

https://st.suckless.org

The following works as of st 0.8.1.

Font configuration:

```c
static char *font = "Bitstream Vera Sans Mono:pixelsize=13:antialias=true:autohint=true";
```

Color configuration, mirroring my XTerm colorscheme:

```c
/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {
	/* 8 normal colors */
	"#2e3436",  // black
	"#cc0000",  // red
	"#91e045",  // green
	"#c4a000",  // yellow
	"#005fdb",  // blue
	"#75507b",  // magenta
	"#06989a",  // cyan
	"#d3d7cf",  // white

	/* 8 bright colors */
	"#555753",
	"#ef2929",
	"#8ae234",
	"#fce94f",
	"#729fcf",
	"#ad7fa8",
	"#34e2e2",
	"#eeeeec",

	[255] = 0,

	/* more colors can be added after 255 to use with DefaultXX */
	"#b6cab6",
	"#2f2f2f",
};

/*
 * Default colors (colorname index)
 * foreground, background, cursor, reverse cursor
 */
unsigned int defaultfg = 256;
unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;
static unsigned int defaultrcs = 257;
```

