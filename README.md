# Zig Build.zig 0.17 - Documentação Completa

Guia completo e atualizado da API `build.zig` do Zig 0.17.x, cobrindo todas as funções, tipos, opções e padrões de uso para compilar bibliotecas, executáveis e testes.

## Motivo

A API de build do Zig mudou drasticamente entre versões. Na 0.17:
- `addSharedLibrary` foi removida
- `addLibrary` com `.linkage = .dynamic` substituiu
- `root_source_file` agora requer `b.createModule()` + `root_module`
- Muitos builtins mudaram de assinatura (`@ptrToInt`, `@intCast`, `@bitCast`)

Esta documentação preenche a lacuna deixada pela documentação oficial incompleta.

## Conteúdo

```
zig-build-docs/
├── README.md
├── LICENSE
├── src/
│   ├── overview.md          # Visão geral do sistema de build
│   ├── std.Build.md         # Referência completa de std.Build
│   ├── std.Build.Module.md  # Referência de Module.CreateOptions
│   ├── library-options.md   # Opções de biblioteca (static/dynamic)
│   ├── executable-options.md# Opções de executável
│   ├── test-options.md      # Opções de teste
│   ├── builtins.md          # Builtins usados em build.zig
│   └── examples/            # Exemplos práticos
│       ├── dynamic-lib.zig  # Shared library (.dylib/.so)
│       ├── static-lib.zig   # Static library (.a)
│       ├── executable.zig   # Executável simples
│       └── zig-swift.zig    # Biblioteca para link com Swift
└── templates/
    ├── build.zig            # Template básico
    └── build.zig.zon        # Package file
```

## Principais mudanças na 0.17

### Antes (0.11-0.14)
```zig
const lib = b.addSharedLibrary(.{
    .name = "mylib",
    .root_source_file = b.path("src/lib.zig"),
    .target = target,
    .optimize = optimize,
});
```

### Depois (0.17)
```zig
const module = b.createModule(.{
    .root_source_file = b.path("src/lib.zig"),
    .target = target,
    .optimize = optimize,
});
const lib = b.addLibrary(.{
    .name = "mylib",
    .root_module = module,
    .linkage = .dynamic,
});
```

## Exemplos

### Shared Library para Swift

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.createModule(.{
        .root_source_file = b.path("src/agent.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "vanderley-core",
        .root_module = module,
        .linkage = .dynamic,
    });

    b.installArtifact(lib);
}
```

### Exportando funções com C ABI

```zig
export fn vanderley_version() [*]const u8 {
    return "vanderley-desktop 0.1.0";
}

export fn vanderley_agent_count() c_int {
    return 0;
}
```

## Licença

MIT
