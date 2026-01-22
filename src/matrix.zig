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
                    std.debug.print(" {} ", .{self.at(r, c).*});
                }
                std.debug.print("\n", .{});
            }
        }

        pub fn printFlat(self: Self) void {
            for (self.data) |v| {
                std.debug.print(" {}", .{v});
            }
            std.debug.print("\n", .{});
        }

        // pub fn trace(self: Self) f32{
        //     // int limit = min(rows, cols);
        //     // for (int i = 0; i < limit; i++) {
        //     //     // Phần tử đường chéo nằm ở: matrix[i * (cols + 1)]
        //     // }
        // }

        //TODO: Apply matrix tiling
        // Transpose the matrix
        pub fn transpose(self: Self) !Self {
            const new_data = try self.allocator.alloc(T, self.rows * self.cols);
            for (0..self.rows) |r| {
                for (0..self.cols) |c| {
                    new_data[c * self.rows + r] = self.data[r * self.cols + c];
                }
            }
            return Self{
                .allocator = self.allocator,
                .data = new_data,
                .rows = self.cols, 
                .cols = self.rows,
            };
        }
        //
        // Reshape: convert matrix(m,n) => matrix(n,m)
        // Transpose 
        // Flatten/Ravel: convert multiple dimensions => 1D array
        // Concatenate/Stack: Ghép nhiều ma trận lại với nhau theo hàng hoặc theo cột.
        // Trace: Tính tổng các phần tử trên đường chéo chính.
        // "Unpack" (Interleave)
        // Tile-based Transpose
        // Matrix Tiling
    };
}
