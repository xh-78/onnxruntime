const utils = @import("build_helper.zig");
const BuildCtx = utils.BuildCtx;

pub fn build(ctx: *BuildCtx) void {
    ctx.ort.addCSourceFiles(.{
        .root = ctx.b.path("onnxruntime/core/flatbuffers/"),
        .flags = &.{"-Ideps/flatbuffers/include"},
        .files = &.{
            "flatbuffers_utils.cc",
        },
    });
}


