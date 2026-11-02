const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Escolha uma das opções abaixo:

    // Opção A: Shared Library (.dylib no macOS, .so no Linux)
    const lib = b.addLibrary(.{
        .name = "seu-nome",
        .root_module = module,
        .linkage = .dynamic,
    });

    // Opção B: Executável
    // const exe = b.addExecutable(.{
    //     .name = "seu-nome",
    //     .root_module = module,
    // });

    b.installArtifact(lib);
}
