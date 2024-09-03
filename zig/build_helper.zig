const std = @import("std");

pub const BuildCtx = struct {
    ort: *std.Build.Step.Compile,
    b: *std.Build,
    target: std.Build.ResolvedTarget,
};

fn handle_entry(b: *std.Build, base_dir: []const u8, c: *std.Build.Step.Compile, entry: std.fs.Dir.Entry) !void {
    switch (entry.kind) {
        .file => {
            const found = std.mem.endsWith(u8, entry.name, ".cc");
            const real_path = try std.fs.path.join(b.allocator, &.{ base_dir, entry.name });
            if (found) {
                c.addCSourceFile(.{
                    .file = std.Build.LazyPath{ .src_path = .{ .owner = b, .sub_path = real_path } },
                    .flags = &.{},
                });
            }
        },
        .directory => {},
        else => {},
    }
}

pub fn add_entry(c: *std.Build.Step.Compile, b: *std.Build, base_dir: []const u8, recursive: bool) !void {
    var dir = try std.fs.cwd().openDir(base_dir, .{ .iterate = true });
    defer dir.close();
    if (recursive) {
        var walker = try dir.walk(b.allocator);
        defer walker.deinit();

        while (try walker.next()) |entry| {
            switch (entry.kind) {
                .file => {
                    const found = std.mem.endsWith(u8, entry.basename, ".cc");
                    const real_path = try std.fs.path.join(b.allocator, &.{ base_dir, entry.path });
                    if (found) {
                        c.addCSourceFile(.{
                            .file = std.Build.LazyPath{ .src_path = .{ .owner = b, .sub_path = real_path } },
                            .flags = &.{},
                        });
                    }
                },
                .directory => {},
                else => {},
            }
        }
    } else {
        var iter = dir.iterate();
        while (try iter.next()) |entry| {
            try handle_entry(b, base_dir, c, entry);
        }
    }
}
