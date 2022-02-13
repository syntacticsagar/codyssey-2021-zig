const std = @import("std");

const test_allocator = std.testing.allocator;
const data = @embedFile("input.txt");

pub fn main() anyerror!void {
    var count: u32 = 0;
    var part_1: u32 = 0;
    var part_2: u32 = 0;
    var window: [3]i64 = .{ 0, 0, 0 };

    var lines = std.mem.tokenize(u8, data, "\r\n");
    std.log.info("Data: ", .{});
    while(lines.next()) |line| {
        const num = std.fmt.parseInt(i64, line, 10) catch unreachable;

        if(count >= 1 and num > window[2]){
            part_1 += 1;
        }

        if(count >= 3 and num > window[0]){
            part_2 += 1;
        }

        window[0] = window[1];
        window[1] = window[2];
        window[2] = num;
        count += 1;
    }

    std.log.info("part1: {} and part2: {}", .{part_1, part_2});
}
