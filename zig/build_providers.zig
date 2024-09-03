const utils = @import("build_helper.zig");
const BuildCtx = utils.BuildCtx;
const add_entry = utils.add_entry;

fn providers_cpu(ctx: *BuildCtx) !void {
    try add_entry(ctx.ort, ctx.b, "onnxruntime/core/providers/cpu", true);
}

pub fn build(ctx: *BuildCtx) void {
    providers_cpu(ctx) catch @panic("add cpu provider failed");
}
