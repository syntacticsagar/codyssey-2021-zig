const std = @import("std");

const test_allocator = std.testing.allocator;
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const data = @embedFile("../data/day02.txt");

const commands = enum(u8) { forward, up, down };

pub fn main() anyerror!void {
    var lines = tokenize(u8, data, "\r\n");
    std.log.info("Data: ", .{});

    var horz: usize = 0;
    var aim: usize = 0;
    var depth: usize = 0;

    while(lines.next()) |line| {
        var instructions = split(u8, line, " ");
        const command = std.meta.stringToEnum(commands, instructions.next().?).?;
        const step = std.fmt.parseInt(usize, instructions.next().?, 10) catch unreachable;

        switch(command) {
            commands.forward => { horz += step; depth += aim * step; },
            commands.up => { aim -= step; },
            commands.down => { aim += step; }
        }
    }

    std.log.info("result {}", .{horz * depth});
}
