FROM alpine
LABEL "name"="bash"
LABEL "repository"="https://github.com/cloudvaio/workflow-forge-trigger"
LABEL "version"="0.0.1"
LABEL com.github.actions.name="Workflow Forge Trigger"
LABEL com.github.actions.description="A Github workflow action to invoke a CloudVA Forge Trigger and wait for its result"
RUN apk add --no-cache bash curl openssl util-linux xxd jq
COPY LICENSE README.md /
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
