const utils = @import("build_helper.zig");
const BuildCtx = utils.BuildCtx;
const add_entry = utils.add_entry;

pub fn build(ctx: *BuildCtx) void {
    add_entry(ctx.ort, ctx.b, "onnxruntime/core/util", true) catch @panic("add framework failed");
}
