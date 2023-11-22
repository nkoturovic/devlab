// const std = @import("std");

pub fn main() u8 {
    const r = comptime f()[1];
    return r[1];
}

const Node = struct {
    next: ?*const Node = null,
    name: []const u8,
};

fn f() [10][]const u8 {
    const node_a = Node{
        .name = "Node A",
    };

    const node_b = Node{
        .next = &node_a,
        .name = "Node B",
    };

    const node_c = Node{
        .next = &node_b,
        .name = "Node C",
    };

    const result = comptime blk: {
        var str: [10][]const u8 = undefined;
        var i = 0;
        var it: ?*const Node = &node_c;
        inline while (it) |node| {
            str[i] = node.name;
            it = it.?.next;
            i += 1;
        }
        break :blk str;
    };

    // inline for (result) |str| {
    //@compileLog(str[0..]);
    //}
    return result;
}
