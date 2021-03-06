FROM alpine:latest

MAINTAINER https://github.com/deebsman

ARG user="toolbox"
ARG system="\
  bash\
  ca-certificates\
  sudo\
  exa\
  busybox-extras\
  "
ARG tools="\
  curl\
  vim\
  openssl\
  nmap\
  httpie\
  jq\
  mtr\
  git\
  go\
  sc\
  terraform\
  ansible\
  packer\
  mysql-client\
  "

ARG gotools="\
github.com/dundee/gdu/v5/cmd/gdu@latest\
"

RUN apk update && apk add $system && apk add $tools
RUN echo $tools > /etc/tools
RUN echo -e "echo -n 'apk: '; cat /etc/tools\necho -n 'go: '; ls /home/toolbox/go/bin" > /usr/local/bin/toollist && chmod a+x /usr/local/bin/toollist
RUN adduser -D $user
RUN echo "$user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user && chmod 0440 /etc/sudoers.d/$user
USER $user
RUN go install $gotools
RUN echo "alias ll='ls -l'" >> /home/$user/.bashrc
RUN echo "export GOPATH="$HOME/go"" >> /home/$user/.bashrc
RUN echo "export PATH="$PATH:$HOME/go/bin"" >> /home/$user/.bashrc
WORKDIR /home/$user/host
