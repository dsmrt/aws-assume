FROM ubuntu

LABEL "com.github.actions.name"="Test Helpers"
LABEL "com.github.actions.description"="Tests the helpers"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="http://github.com/dsmrt/aws-assume"

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
