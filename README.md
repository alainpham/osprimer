# Install scripts for ubuntu servers & desktops

## Sandbox Container

```sh
docker build -t sandbox .


docker run -d \
    --name sandbox \
    -v ~/workspaces/ai/slop/:/home/user/slop \
    -v ~/workspaces/ai/home/.claude:/home/user/.claude \
    -v ~/workspaces/ai/home/.codex:/home/user/.codex \
    -v ~/workspaces/ai/home/.copilot/:/home/user/.copilot \
    -v ~/workspaces/ai/home/.opencode/:/home/user/.opencode \
    -v ~/workspaces/ai/home/.hermes:/home/user/.hermes \
    sandbox sleep infinity

docker exec -it sandbox bash
```
