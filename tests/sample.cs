// sample.cs
using System;
using System.Collections.Generic;

public record User(int Id, string Name);

public class Program {
    public static int Add(int a, int b) => a + b;

    public static void Main() {
        var users = new List<User> { new(1, "Ada"), new(2, "Linus") };
        Console.WriteLine(users[0]);
        Console.WriteLine(Add(2, 3));
    }
}
