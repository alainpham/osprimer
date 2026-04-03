# Install scripts for ubuntu servers & desktops

## AI Sandbox Container

```sh
docker build -t aisandbox .

mkdir -p ~/workspaces/ai/slop/
mkdir -p ~/workspaces/ai/home/claude
mkdir -p ~/workspaces/ai/home/codex
mkdir -p ~/workspaces/ai/home/copilot
mkdir -p ~/workspaces/ai/home/opencode
mkdir -p ~/workspaces/ai/home/hermes


docker run -d \
    --name aisandbox \
    -v ~/workspaces/ai/slop/:/home/user/slop \
    -v ~/workspaces/ai/home/claude:/home/user/.claude \
    -v ~/workspaces/ai/home/codex:/home/user/.codex \
    -v ~/workspaces/ai/home/copilot/:/home/user/.copilot \
    -v ~/workspaces/ai/home/opencode/:/home/user/.opencode \
    -v ~/workspaces/ai/home/hermes:/home/user/.hermes \
    aisandbox sleep infinity

docker exec -it aisandbox bash
```
