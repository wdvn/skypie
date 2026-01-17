const std = @import("std");
const str = @import("./types.zig").str;

pub const String = struct {
    data: []u8,
    pub fn cast(v: anytype) str {
        return switch (v) {
            true => "true",
            false => "false",
            else => "",
        };
    }
};
