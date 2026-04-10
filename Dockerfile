FROM ubuntu:noble

RUN if id -u 1000 >/dev/null 2>&1; then userdel -r "$(id -nu 1000)" || true; fi \
 && if getent group 1000 >/dev/null 2>&1; then groupdel "$(getent group 1000 | cut -d: -f1)" || true; fi

RUN apt-get update && apt-get install -y wget curl && rm -rf /var/lib/apt/lists/*

COPY ./setup-scripts/core.sh /usr/local/bin/core.sh && rm -rf /var/lib/apt/lists/*
RUN chmod +x /usr/local/bin/core.sh && bash -c "source /usr/local/bin/core.sh && sandbox"
RUN echo 'PS1='"'"'${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '"'"'' >> /home/user/.bashrc

# # claude code
# RUN curl -fsSL https://claude.ai/install.sh | bash

# # codex code
# RUN npm install -g @openai/codex

# # copilot
# RUN curl -fsSL https://gh.io/copilot-install | bash

# # open code
# RUN curl -fsSL https://opencode.ai/install | bash

# # hermes agent
# RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

USER 1000:1000

WORKDIR /home/user

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash", "-l"]