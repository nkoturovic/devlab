const std = @import("std");

const Length = struct {
    const validation_type = []const u8;

    from: usize,
    to: usize,
    fn validate(self: *const Length, str: validation_type) bool {
        if (str.len < self.from or str.len > self.to) {
            return false;
        } else {
            return true;
        }
    }

    fn err_message(self: *const Length) []const u8 {
        return std.fmt.comptimePrint("Length must be between {} and {}", .{ self.from, self.to });
    }
};

const Capitalized = struct {
    const validation_type = []const u8;

    fn validate(_: *const Capitalized, str: validation_type) bool {
        if (str.len > 0) {
            return std.ascii.isUpper(str[0]);
        } else {
            return true;
        }
    }

    fn err_message(_: *const Capitalized) []const u8 {
        return "String should be capitalize";
    }
};

fn Valid(comptime typ: type, comptime cnstr: anytype) type {
    return struct {
        const constraints = cnstr;
        var errors: [constraints.len][]const u8 = undefined;

        value: typ,

        fn validate(self: *const @This()) ?[][]const u8 {
            var errCount: usize = 0;
            // NOTE: having the array defined here would make a dangling
            // reference after slice is returned from the function
            // var errors: [constraints.len][]const u8 = undefined;
            inline for (constraints) |c| {
                if (!c.validate(self.value)) {
                    errors[errCount] = comptime c.err_message();
                    errCount += 1;
                }
            }

            if (errCount > 0) {
                return errors[0..errCount];
            }
            return null;
        }
    };
}

const User = struct { firstname: Valid([]const u8, .{ Length{ .from = 2, .to = 4 }, Capitalized{} }), lastname: Valid([]const u8, .{Capitalized}) };

pub fn main() !void {
    const constraints = .{
        Length{ .from = 1, .to = 4 },
        Capitalized{},
    };

    const str = "Hello world";

    comptime var results: [constraints.len][]const u8 = undefined;

    inline for (constraints, 0..) |c, i| {
        results[i] = comptime std.fmt.comptimePrint("{s} -> {}", .{ @typeName(@TypeOf(c)), c.validate(str) });
    }

    std.debug.print("{s}\n", .{results});

    const u = User{ .firstname = .{ .value = "nebojsa" }, .lastname = .{ .value = "Koturovic" } };
    if (u.firstname.validate()) |errors| {
        std.debug.print("Firstname errors:\n", .{});
        for (errors) |e| {
            std.debug.print("  * {s}\n", .{e});
        }
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
