# modules/services/ollama.nix — Ollama local LLM, chạy qua RTX 3060 (CUDA)
{ pkgs, ... }:
{
  services.ollama = {
    enable  = true;
    package = pkgs.ollama-cuda;
    environmentVariables = {
      OLLAMA_NUM_GPU                     = "15";
      __NV_PRIME_RENDER_OFFLOAD          = "1";
      __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
      __GLX_VENDOR_LIBRARY_NAME          = "nvidia";
      __VK_LAYER_NV_optimus              = "NVIDIA_only";
    };
  };
}
