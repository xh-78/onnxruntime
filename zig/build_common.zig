const utils = @import("build_helper.zig");
const BuildCtx = utils.BuildCtx;
const add_entry = utils.add_entry;

fn addCSourceFiles(ctx: *BuildCtx, files: []const []const u8) void {
    const root_path = ctx.b.path("onnxruntime");
    const cflags = &.{};
    ctx.ort.addCSourceFiles(.{ .root = root_path, .flags = cflags, .files = files });
}

pub fn build(ctx: *BuildCtx) void {
    add_entry(ctx.ort, ctx.b, "onnxruntime/core/common", true) catch @panic("failed");
    add_entry(ctx.ort, ctx.b, "onnxruntime/core/quantization", true) catch @panic("failed");
    ctx.ort.addCSourceFiles(.{ .root = ctx.b.path("onnxruntime/core/platform"), .flags = &.{}, .files = &.{
        "env.cc",
        "env_time.cc",
        "path_lib.cc",
        "telemetry.cc",
        "logging/make_platform_default_log_sink.cc",
    } });
    if (ctx.target.result.os.tag == .windows) {
        ctx.ort.addCSourceFiles(.{ .root = ctx.b.path("onnxruntime/core/platform/windows"), .flags = &.{}, .files = &.{
            "env.cc",
            "env_time.cc",
            "hardware_core_enumerator.cc",
            "stacktrace.cc",
            "telemetry.cc",
            "logging/etw_sink.cc",
        } });
    } else {
        add_entry(ctx.ort, ctx.b, "onnxruntime/core/platform/posix", true) catch @panic("add posix failed");
        if (ctx.target.result.isAndroid()) {
            add_entry(ctx.ort, ctx.b, "onnxruntime/core/platform/android/logging", true) catch @panic("add android failed");
        }
        if (ctx.target.result.isDarwin()) {
            @panic("not supported yet");
        }
    }
}
