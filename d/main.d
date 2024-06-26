struct S {
    int x, y;
}

void main()
{
    import std.stdio;
    import std.json;

    S s = { x: 3, y: 5 };

    writeln("Hello, world without explicit compilations!");
    writeln("{}", JSONValue(s));
}
