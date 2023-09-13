## Rust lang

Run executable with rustc

```
rustc main.rs
./main
```

Create binary with Cargo

```rust
cargo new hello_world --bin
```

Or even better


```rust
mkdir 02_example
cd 02_example
cargo init --name example
```


Adding a dependenvy

```sh
cargo add serde
```

Build release

```
cargo build --release
```

Expand macros

```
cargo expand
```
