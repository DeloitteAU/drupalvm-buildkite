FROM geerlingguy/drupal-vm

LABEL maintainer="Yusuf Hasan Miyan"

ENV BUILDKITE_AGENT_TOKEN ''

ENV BUILDKITE_AGENT_TAGS 'docker=true,platform=linux,queue=drupal,type=drupalvm'

COPY drupal-vm-playbook-overrides.yml /etc/ansible/drupal-vm/local.config.yml

# Install buildkite-agent, php dependencies & prestissimo
RUN echo deb https://apt.buildkite.com/buildkite-agent stable main > /etc/apt/sources.list.d/buildkite-agent.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 32A37959C2FA5C3C99EFBC32A79206696452D198 && \
    apt-get update && \
    apt-get install -y buildkite-agent iptables php7.1-bz2 && \
    ansible-playbook /etc/ansible/drupal-vm/provisioning/playbook.yml && \
    rm -rf /var/lib/apt/lists/* && \
    sudo -u buildkite-agent -H bash -c 'composer global require hirak/prestissimo'

# Install nvm for the buildkite-agent user.
RUN sudo -u buildkite-agent -H bash -c 'curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash' && \
    echo 'export PATH=~/.local/bin:$PATH\n\
    export NVM_DIR="$HOME/.nvm"\n\
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"\n\
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"\n'\
    >> ~buildkite-agent/.profile;

ADD boot.sh /boot.sh

ENTRYPOINT /boot.sh
