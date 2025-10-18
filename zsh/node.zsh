if [ -x "$(command -v npm)" ]; then
    mkdir -p ~/.npm-global
    npm config set prefix '~/.npm-global'
    export PATH=~/.npm-global/bin:$PATH
fi
