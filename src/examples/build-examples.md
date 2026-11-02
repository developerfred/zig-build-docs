# Zig 0.17 - Shared Library (C ABI) para Swift

Este arquivo resolve o Problema 1: `addSharedLibrary` não existe mais na 0.17.

## build.zig - Shared Library Dinâmica

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // PASSO 1: Criar módulo (obrigatório na 0.17)
    const module = b.createModule(.{
        .root_source_file = b.path("src/agent.zig"),
        .target = target,
        .optimize = optimize,
    });

    // PASSO 2: Adicionar biblioteca com linkage dinâmico
    const lib = b.addLibrary(.{
        .name = "vanderley-core",
        .root_module = module,
        .linkage = .dynamic,
    });

    b.installArtifact(lib);
}
```

## build.zig - Executável

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "vanderley-app",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);
}
```

## build.zig - Biblioteca Estática

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.createModule(.{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "mylib",
        .root_module = module,
        .linkage = .static,
    });

    b.installArtifact(lib);
}
```

## build.zig.zon - Package File

```zon
.{
    .name = "vanderley-core",
    .version = "0.1.0",
    .dependencies = .{},
}
```

## Comparação: Antes (0.11-0.14) vs Depois (0.17)

| Item | Antes (0.11-0.14) | Depois (0.17) |
|------|-------------------|---------------|
| Shared Library | `b.addSharedLibrary(.{...})` | `b.addLibrary(.{..., .linkage = .dynamic})` |
| Static Library | `b.addStaticLibrary(.{...})` | `b.addLibrary(.{..., .linkage = .static})` |
| Executável | `b.addExecutable(.{...})` | `b.addExecutable(.{...})` |
| Arquivo fonte | `.root_source_file = b.path(...)` | Mesmo, mas dentro de `createModule` |
| Módulo | Não necessário | Obrigatório: `b.createModule(.{...})` |

## Como compilar

```bash
# Shared library
zig build

# Instalar
zig build --prefix /usr/local

# Limpar cache
rm -rf zig-out .zig-cache
```

## Arquivos deste exemplo

- `src/examples/dynamic-lib.zig` - Este build.zig
- `src/examples/static-lib.zig` - Biblioteca estática
- `src/examples/executable.zig` - Executável
- `templates/build.zig` - Template para copiar
- `templates/build.zig.zon` - Package file
