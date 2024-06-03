const std = @import("std");
const clap = @import("clap");

fn isString(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .Pointer => |ptr| ptr.child == u8,
        else => false,
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const params = comptime clap.parseParamsComptime(
        \\-h, --help             Display this help and exit.
        \\-f, --foo <str>        An option parameter, which takes a value.
        \\-b, --bar <i32>        An option parameter, which takes a value.
        \\<str>...
        \\
    );

    // Initialize our diagnostics, which can be used for reporting useful errors.
    // This is optional. You can also pass `.{}` to `clap.parse` if you don't
    // care about the extra information `Diagnostics` provides.
    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
        .allocator = gpa.allocator(),
    }) catch |err| {
        // Report useful error and exit
        diag.report(std.io.getStdErr().writer(), err) catch {};
        std.process.exit(1);
        return err;
    };
    defer res.deinit();

    if (res.args.help != 0) {
        std.debug.print("--help\n", .{});
    }

    inline for (std.meta.fields(@TypeOf(res.args))[1..]) |f| {
        if (@field(res.args, f.name)) |arg| {
            const fmt = comptime blk: {
                if (isString(@TypeOf((arg)))) {
                    break :blk "{s} -> {s}\n";
                } else {
                    break :blk "{s} -> {any}\n";
                }
            };
            std.debug.print(fmt, .{f.name, arg});
        }
    }

    for (res.positionals) |pos|
        std.debug.print("{s}\n", .{pos});
}
