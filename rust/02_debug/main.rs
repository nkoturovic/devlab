#[derive(Debug)]
struct User {
    username: String,
    first_name: Option<String>,
    last_name: Option<String>,
}

fn main() {
    let u = User {
        username: String::from("kotur"),
        first_name: Some(String::from("kotur")),
        last_name: Some(String::from("Nebojsa"))
    };

    println!("{:#?}", u);
}
