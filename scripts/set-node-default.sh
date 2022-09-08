# NOTE: NVM default alias is hella slow.
# See: https://github.com/creationix/nvm/issues/860

if [ -z "$NVM_SH" ]; then
  echo "NVM doesn't seem to be configured.."
  exit 1
fi

. $NVM_SH

if [ -z "$NVM_BIN" ]; then
  nvm use --lts
fi

echo "export PATH=\$PATH:$NVM_BIN" > $HOME/.nvm_default
echo "Set default Node path to $NVM_BIN"
echo "You will need to re-source ~/.bashrc for changes to take effect"
