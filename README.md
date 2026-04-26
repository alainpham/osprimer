# Install scripts for ubuntu servers & desktops

## AI Sandbox Container

```sh
docker build -t alainpham/aisandbox:latest .

docker push alainpham/aisandbox:latest

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
    alainpham/aisandbox:latest sleep infinity

docker exec -it aisandbox bash
```

## Running llama cpp for local AI

# Gemma
```
llama-server \
    -hf unsloth/gemma-4-26B-A4B-it-GGUF:UD-Q4_K_XL \
    --temp 1.0 \
    --top-p 0.95 \
    --top-k 64 \
    --chat-template-kwargs '{"enable_thinking":false}'

# 26B
llama-server -hf ggml-org/gemma-4-26B-A4B-it-GGUF:Q4_K_M --host 0.0.0.0 --reasoning off

# E4B
llama-server -hf ggml-org/gemma-4-E4B-it-GGUF:Q4_K_M --host 0.0.0.0 --reasoning off
    --temp 1.0 \
    --top-p 0.95 \
    --top-k 64 

# E2B
llama-server -hf ggml-org/gemma-4-E2B-it-GGUF:Q8_0 --host 0.0.0.0 --reasoning off \
    --temp 1.0 \
    --top-p 0.95 \
    --top-k 64 \
    -ngl 99 -c 32768 --jinja 


llama-server -hf unsloth/Qwen3-Coder-Next-GGUF:UD-Q4_K_M  --host 0.0.0.0 --ctx-size 16384 \
    --temp 1.0 --top-p 0.95 --min-p 0.01 --top-k 40


llama-server -hf ggml-org/gemma-4-E2B-it-GGUF:Q8_0 --host 0.0.0.0 --reasoning off 

```

## Install windows

```PS1
powershell -ExecutionPolicy Bypass -File setup-scripts\windows-setup.ps1
```