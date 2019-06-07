FROM ubuntu

LABEL "com.github.actions.name"="Test Installer"
LABEL "com.github.actions.description"="Tests the Installer"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="red"

LABEL "repository"="http://github.com/dsmrt/aws-assume"

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
