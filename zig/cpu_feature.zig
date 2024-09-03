const std = @import("std");

pub fn have_x86_feat(t: std.Target, feat: std.Target.x86.Feature) bool {
    return switch (t.cpu.arch) {
        .x86, .x86_64 => std.Target.x86.featureSetHas(t.cpu.features, feat),
        else => false,
    };
}

pub fn have_x86_feat_all(t: std.Target, feats: anytype) bool {
    inline for (feats) |feat| {
        if (!have_x86_feat(t, feat)) {
            return false;
        }
    }
    return true;
}

pub fn have_arm_feat(t: std.Target, feat: std.Target.arm.Feature) bool {
    return switch (t.cpu.arch) {
        .arm, .armeb => std.Target.arm.featureSetHas(t.cpu.features, feat),
        else => false,
    };
}

pub fn have_arm_feat_all(t: std.Target, feats: anytype) bool {
    inline for (feats) |feat| {
        if (!have_arm_feat(t, feat)) {
            return false;
        }
    }
    return true;
}

pub fn have_aarch64_feat(t: std.Target, feat: std.Target.aarch64.Feature) bool {
    return switch (t.cpu.arch) {
        .aarch64,
        .aarch64_be,
        => std.Target.aarch64.featureSetHas(t.cpu.features, feat),

        else => false,
    };
}

pub fn have_aarch64_feat_all(t: std.Target, feats: anytype) bool {
    inline for (feats) |feat| {
        if (!have_aarch64_feat(t, feat)) {
            return false;
        }
    }
    return true;
}
