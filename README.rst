@borgstrom dot-files
====================
These are my_ dot-files. I check them out and symlink them into place.

* OS X work station
* UNIX servers
* Bash shell
* vim + MacVim for editing
* Write lots of Python
* Use screen (I haven't had a compelling reason to switch to tmux yet)

Bash
----
I tried ZSH & Prezto (`my fork of prezto`_) but since it means I have to install
ZSH on every server I work on to get a consistent shell experience, I went back
to bash 'cause it's everywhere and I didn't find zsh that much better an
experience in the shell.

Link the ``.bashrc`` file into your home dir.

Prompt
~~~~~~

.. Prompt:: http://i.imgur.com/jfYidAv.png

VIM
---
Don't use VIM? Too bad for you. It's the best editing experience and you're
missing out.

I use Pathogen_ for loading bundles and all of my bundles are stored as GIT
submodules. Checkout this repository with the ``--recursive`` flag so they all
get checked out as well.

Solarized Terminal w/Monaco 13pt
--------------------------------
``Solarized Dark - Monaco 13.terminal`` is my customized version of the OS X
`solarized terminal`_ files by Tomislav Filipčić. The only change is that the
font size has been set to 13pt from 11pt because I have a huge monitor and
don't want to squint when I work in the terminal.

SSH
---
My ``.ssh/rc`` file puts our SSH auth sock from the agent forwarding into a
predictable location so that screen can re-use our agent authentication.

Link it into your ``.ssh`` dir. This only needs to be done on machines that
you ssh *into*, it doesn't need to be done on your workstation.

Screen
------
My screen config sets up a hardstatus and points to a specific SSH auth sock
for agent forwarding.

.. _my: https://github.com/borgstrom/
.. _my fork of prezto: https://github.com/borgstrom/prezto
.. _Pathogen: https://github.com/tpope/vim-pathogen
.. _solarized terminal: https://github.com/tomislav/osx-terminal.app-colors-solarized
