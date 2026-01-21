const std = @import("std");
const str = @import("./types.zig").str;

fn range(len: usize) []const void {
    return @as([*]void, undefined)[0..len];
}

pub fn Matrix(comptime T: type) type {
    return struct {
        data: []T,
        rows: usize,
        cols: usize,
        allocator: std.mem.Allocator,

        const Self = @This();

        /// Initialize the matrix and allocate memory
        pub fn init(allocator: std.mem.Allocator, rows: usize, cols: usize) !Self {
            const data = try allocator.alloc(T, rows * cols);
            return Self{
                .data = data,
                .rows = rows,
                .cols = cols,
                .allocator = allocator,
            };
        }

        /// Clean up memory
        pub fn deinit(self: Self) void {
            self.allocator.free(self.data);
        }

        /// Helper to get a pointer to an element at (row, col)
        pub fn at(self: Self, r: usize, c: usize) *T {
            return &self.data[r * self.cols + c];
        }

        /// Fill the entire matrix with a single value
        pub fn fill(self: Self, value: T) void {
            @memset(self.data, value);
        }

        pub fn print(self: Self) void {
            for (range(self.rows), 0..) |_, r| {
                for (range(self.cols), 0..) |_, c| {
                    std.debug.print("{} ", .{self.at(r, c).*});
                }
                std.debug.print("\n", .{});
            }
        }
        
        // pub fn transpose(self: Self) Self{
        //     
        // }
    };
}
