// sample.rs
#[derive(Debug)]
struct User {
    id: i32,
    name: String,
}

fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn main() {
    let users = vec![
        User { id: 1, name: "Ada".into() },
        User { id: 2, name: "Linus".into() },
    ];
    println!("{:?}", users[0]);
    println!("{}", add(2, 3));
}
