const std = @import("std");

const test_allocator = std.testing.allocator;
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const data = @embedFile("input.txt");


fn main_1(input: []const u8) anyerror!void {
    var lines = tokenize(u8, input, "\r\n");
    var counts = [1]isize{0} ** 12;

    while(lines.next()) |bin| {
        for(bin) |b, idx| {
            if(b == '1'){
                counts[idx] += 1;
            } else {
                counts[idx] -= 1;
            }
        }
    }
    
    var gamma: u12 = 0;
    for(counts) |count, idx| {
        if(count > 0) {
            gamma |= @as(u12, 1) << @intCast(u4, idx);
        }
    }
    gamma = @bitReverse(u12, gamma);
    std.log.info("Gamma:   {b:0>12}", .{ gamma });
    std.log.info("Epsilon: {b:0>12}", . { ~gamma });
    std.log.info("result:  {}", . { gamma * @as(u64,~gamma) });
}

fn most_common_bit(a: [][]const u8, size: usize, bit_position: u8, most: bool) u8 {
    var count: isize = 0;

    for(a) |n, i| {
        if(i >= size){
            break;
        }
        if(n[bit_position] == '1'){
            count += 1;
        }else {
            count -= 1;
        }
    }

    if(count >= 0) {
        if(most) return '1' else return '0';
    } else {
        if(most) return '0' else return '1';
    }
}

fn criteria(numbers: [][]const u8, size: usize, most: bool) ?[]const u8 {
    var bit_position:u8 = 0;
    var remaining: usize = size;
    while(remaining > 1){
        var common = most_common_bit(numbers, remaining, bit_position, most);
        var i: usize = 0;
        while(i <= remaining) {
            if(remaining == 1){
                break;
            }
            while(numbers[i][bit_position] != common) {
                if(i >= remaining) break;  
                numbers[i] = numbers[remaining - 1];
                remaining -= 1;
            }
            i += 1;
        }
        bit_position += 1;
    }
    return numbers[0];
}

fn main_2(input: []const u8) anyerror!u64 {
    var lines = tokenize(u8, input, "\r\n");
    var oxygen: [1000][]const u8 = undefined;
    var co2: [1000][]const u8 = undefined;
    var count: usize = 0;

    while(lines.next()) |line| {
        oxygen[count] = line;
        co2[count] = line;
        count += 1;
    }

    std.log.info("count {}", .{ count });

    var oxygen_str = criteria(&oxygen, count, true);
    var co2_str = criteria(&co2, count,false);

    var result:u64 = (try std.fmt.parseInt(u64, oxygen_str.?, 2)) * (try std.fmt.parseInt(u64, co2_str.?, 2));
    std.log.info("oxygen {s}", .{ oxygen_str });
    std.log.info("co2    {s}", . { co2_str });
    return result;
}

pub fn main() anyerror!void {
    // try main_1();
    var result = try main_2(data);
    std.log.info("result {}", . { result });
}

test "example" {
    const input = @embedFile("test.txt");
    const result = try main_2(input);
    std.log.info("result {}", .{ result });
    try std.testing.expectEqual(@as(u64, 230), result);
}
