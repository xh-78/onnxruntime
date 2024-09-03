const utils = @import("build_helper.zig");
const BuildCtx = utils.BuildCtx;
const add_entry = utils.add_entry;

pub fn build(ctx: *BuildCtx) void {
    add_entry(ctx.ort, ctx.b, "onnxruntime/core/optimizer", false) catch @panic("add optimizer failed");
    add_entry(ctx.ort, ctx.b, "onnxruntime/core/optimizer/compute_optimizer", false) catch @panic("add compute optimizer failed");
    add_entry(ctx.ort, ctx.b, "onnxruntime/core/optimizer/layout_transformation", false) catch @panic("add layout transformation failed");
    add_entry(ctx.ort, ctx.b, "onnxruntime/core/optimizer/qdq_transformer", false) catch @panic("add qdq_transformer failed");
    add_entry(ctx.ort, ctx.b, "onnxruntime/core/optimizer/selectors_actions", false) catch @panic("add selectors_actions failed");
    add_entry(ctx.ort, ctx.b, "onnxruntime/core/optimizer/transpose_optimization", false) catch @panic("add transpose_optimization failed");
}


