{ kubenix, ... }:
{
  kubernetes.helm.releases.example = {
    chart = kubenix.lib.helm.fetch {
      repo = "https://charts.longhorn.io";
      chart = "longhorn";
      version = "v1.10.0";
      sha256 = "5uTooqwshCePn2K+Io6SXTVOkg8g0FctXumSoCGLlpo=";
    };

    values.persistence.defaultClassReplicaCount = 2;
    values.namespaceOverride = "longhorn-system";
  };
}