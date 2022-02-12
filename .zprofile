# Add pyenv to the path
if [ -d $HOME/src/pyenv ]; then
	export PYENV_ROOT="$HOME/src/pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init --path)"
fi

# only run pip with virtualenv and use the active env
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true
