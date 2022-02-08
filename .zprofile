# Add pyenv to the path
export PYENV_ROOT="$HOME/src/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# only run pip with virtualenv and use the active env
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true
