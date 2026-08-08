# syntax=docker/dockerfile:1
#
# Capibara Colonial Marines — CMU-14 dedicated server image.
# See docs/deployment-docker.md for the operator guide.

# ---------- Build ----------
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

# git: submodule fetch. python3: RobustToolbox MSBuild targets invoke it for
# build-info tooling. unzip: unpack the packaged server.
RUN apt-get update \
 && apt-get install -y --no-install-recommends git python3 unzip \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Dokploy's checkout (source + .git + .gitmodules). See .dockerignore — Resources/
# is deliberately re-included past the bin/obj rules.
COPY . .

# Fetch the engine + its 5 nested submodules ourselves (all public space-wizards
# repos, no auth). Does NOT depend on Dokploy populating submodules. RSI.NET comes
# along because the solution-wide restore reaches Content.Scripts.
RUN git submodule update --init --recursive

# Plain `dotnet restore` — do NOT add `--runtime linux-x64 /p:TargetOs=Linux`.
# .github/workflows/publish.yml uses those flags only for its server-linux-x64 matrix
# entry, which then packages with --no-restore and WITHOUT --hybrid-acz. Here
# --hybrid-acz makes Content.Packaging/ServerPackaging.cs also build Content.Client,
# which is RID-agnostic and a RID-pinned restore does not satisfy. Because we omit
# --no-restore below, Content.Packaging's inner build/publish restore what they need.
#
# --hybrid-acz embeds Content.Client.zip in the server dir so the launcher
# self-downloads the client from this server instead of needing a CDN.
RUN dotnet restore \
 && dotnet build Content.Packaging --configuration Release --no-restore \
 && dotnet run --project Content.Packaging server --platform linux-x64 --hybrid-acz

RUN mkdir -p /app && unzip -o release/SS14.Server_linux-x64.zip -d /app

# ---------- Runtime ----------
FROM mcr.microsoft.com/dotnet/runtime:10.0 AS runtime

# The server is framework-dependent (ServerPackaging passes --self-contained false),
# so the runtime image is required. ICU ships with this Debian-based image and es-ES
# needs it — never set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT and never switch to an
# -alpine tag without adding icu-libs, or number/date/plural formatting silently
# degrades. freetype/fontconfig are added defensively for the engine.
RUN apt-get update \
 && apt-get install -y --no-install-recommends libfreetype6 fontconfig \
 && rm -rf /var/lib/apt/lists/*

RUN useradd --system --create-home --uid 10001 ss14
WORKDIR /app

# --chown on COPY rather than a later `chown -R`: /app is ~1 GB (Audio and Maps are
# NOT stripped from server packages, and --hybrid-acz embeds a client zip on top), so
# a recursive chown would duplicate the whole tree into a second layer.
COPY --from=build --chown=ss14:ss14 /app /app
COPY --chown=ss14:ss14 Docker/server_config.prod.toml /app/server_config.toml
COPY --chown=ss14:ss14 entrypoint.sh /app/entrypoint.sh

# sed: strip any CR in case entrypoint.sh was checked out with CRLF, or the shebang
# fails with a misleading "no such file or directory".
# chmod: the zip format does not preserve the unix exec bit on Robust.Server.
RUN sed -i 's/\r$//' /app/entrypoint.sh \
 && chmod +x /app/entrypoint.sh /app/Robust.Server \
 && mkdir -p /data \
 && chown ss14:ss14 /data

USER ss14

# UDP = gameplay (must be a direct host port; Traefik cannot proxy UDP).
# TCP = status/launcher/ACZ (frontable by Dokploy/Traefik with HTTPS).
EXPOSE 1212/udp 1212/tcp

ENTRYPOINT ["/app/entrypoint.sh"]
