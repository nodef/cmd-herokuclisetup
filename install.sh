#!/bin/bash
url=$(cat url.txt)
if [ -e ~/.netrc ]; then done="1"; fi
if [ -e ~/_netrc ]; then done="1"; fi

# download
if [[ "${done}" != "1" ]]; then
  cd ~
  mkdir heroku-tmp
  cd heroku-tmp
  wget ${url} -O heroku.tar.gz
  tar -xvzf heroku.tar.gz
  mv $(ls|head -n 1) ~/.heroku
  rm heroku.tar.gz
  cd ..
  rmdir heroku-tmp
fi

# login
if [[ "${done}" != "1" ]]; then
  f=".netrc"
  echo "" >${f}
  echo "machine api.heroku.com" >>${f}
  echo "  password ${HEROKU_CLI_PASSWORD}" >>${f}
  echo "  login ${HEROKU_CLI_LOGIN}" >>${f}
  echo "machine git.heroku.com" >>${f}
  echo "  password ${HEROKU_CLI_PASSWORD}" >>${f}
  echo "  login ${HEROKU_CLI_LOGIN}" >>${f}
  cp .netrc _netrc
fi

# expose
if [ -e heroku.txt ]; then
  echo '#!/bin/bash' >heroku.sh
  echo 'heroku "$@"' >>heroku.sh
fi
if [ ! -e heroku.cmd ]; then
  tr -d '\r' <heroku.sh >heroku.cmd
  rm heroku.sh
  mv heroku.cmd heroku.sh
fi
chmod +x heroku.sh
if [ ! -e ~/heroku ]; then
  cp heroku.sh ~/heroku
fi

# test
~/heroku --version
