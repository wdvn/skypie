const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const Matrix = @import("../matrix.zig").Matrix;
const str = @import("../types.zig").str;

// --- Tests ---
fn f32ToStr(n: *f32) str {
    const buf: []u8 = undefined;
    return std.fmt.bufPrint(buf, "{}", .{n.*}) catch "";
}

test "Matrix: basic initialization and deinit" {
    const allocator = testing.allocator; // Specialized allocator that detects leaks
    var mat = try Matrix(i32).init(allocator, 5, 10);
    defer mat.deinit();

    try testing.expectEqual(mat.rows, 5);
    try testing.expectEqual(mat.cols, 10);
    try testing.expectEqual(mat.data.len, 50);
}

test "Matrix: fill and access" {
    std.debug.print("i am here", .{});
    const allocator = testing.allocator;
    var mat = try Matrix(f32).init(allocator, 2, 2);
    defer mat.deinit();

    mat.fill(1.5);

    try testing.expectEqual(mat.at(0, 0).*, 1.5);
    try testing.expectEqual(mat.at(1, 1).*, 1.5);

    mat.at(0, 1).* = 42.0;
    try testing.expectEqual(mat.at(0, 1).*, 42.0);
    mat.print(f32ToStr);
}

test "Matrix: indexing logic" {
    const allocator = testing.allocator;
    var mat = try Matrix(u8).init(allocator, 3, 3);
    defer mat.deinit();

    // Manually setting values to check flat-array mapping
    mat.at(0, 0).* = 1;
    mat.at(0, 1).* = 2;
    mat.at(1, 0).* = 3;

    // Check raw data indices: (row * cols + col)
    try testing.expectEqual(mat.data[0], 1); // (0,0) -> 0*3 + 0 = 0
    try testing.expectEqual(mat.data[1], 2); // (0,1) -> 0*3 + 1 = 1
    try testing.expectEqual(mat.data[3], 3); // (1,0) -> 1*3 + 0 = 3
}
