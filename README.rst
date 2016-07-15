@borgstrom dot-files
====================

These are my_ dot-files. I check them out and symlink them into place.

* OS X work station
* UNIX servers
* Bash shell
* vim + MacVim for editing
* Write lots of Python
* tmux

How to use them
---------------
Fork them to your own repo.

Check them out into a workspace.  I use `~/Projects`::

    cd ~/Projects
    git clone git@github.com:borgstrom/dot-files.git

Install them::

    cd dot-files
    ./install-dot-files.sh

Bash
----
I tried ZSH & Prezto (`my fork of prezto`_) but since it means I have to install
ZSH on every server I work on to get a consistent shell experience, I went back
to bash 'cause it's everywhere and I didn't find zsh that much better an
experience in the shell.

Prompt
~~~~~~

.. image:: http://i.imgur.com/jfYidAv.png

VIM
---
Don't use VIM? Too bad for you. It's the best editing experience and you're
missing out.

I use Pathogen_ for loading bundles and all of my bundles are stored as GIT
submodules. Checkout this repository with the ``--recursive`` flag so they all
get checked out as well.  (If you use my bashrc you can simply run
``update-dot-files``)

Solarized Terminal w/Hack 13pt
--------------------------------
``Solarized Dark - Hack.terminal`` is my customized version of the OS X
`solarized terminal`_ files by Tomislav Filipčić. The only change is that the
font has been changed to the open source `hack font`_ and the size has been set
to 13pt from 11pt because I have a huge monitor and don't want to squint when I
work in the terminal.

Make sure you grab and install the `hack font`_ before using this.

SSH
---
My ``.ssh/rc`` file puts our SSH auth sock from the agent forwarding into a
predictable location so that screen can re-use our agent authentication.

Link it into your ``.ssh`` dir. This only needs to be done on machines that
you ssh *into*, it doesn't need to be done on your workstation.

Tmux
----
I couldn't get used to C-b as the modifier, so I set it back to C-a so my screen
muscle memory is happy.  This also sets up status lines that match the rest of
my shell.

.. _my: http://borgstrom.ca/
.. _my fork of prezto: https://github.com/borgstrom/prezto
.. _Pathogen: https://github.com/tpope/vim-pathogen
.. _solarized terminal: https://github.com/tomislav/osx-terminal.app-colors-solarized
.. _hack font: http://sourcefoundry.org/hack/
