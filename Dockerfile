FROM ubuntu

EXPOSE 8097
EXPOSE 8098
EXPOSE 8099

CMD apt-get update
CMD apt-get install -y curl
CMD /bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/chrmi/dev/master/init_system.sh)"

RUN useradd -m -s /bin/bash d
USER d
WORKDIR /home/d

ENV TERM screen-256color

ENV USER=d
ENV GOPATH="/home/d/pub/go"
ENV PATH="/usr/lib/go/bin:/home/d/.cargo/bin:/home/d/pub/go/bin:/home/d/.local/bin:${PATH}"

CMD /bin/bash -c "$(curl -sSL https://raw.githubusercontent.com/chrmi/dev/master/init_user.sh)"
