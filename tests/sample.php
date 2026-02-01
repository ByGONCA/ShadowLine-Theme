<?php
// sample.php

declare(strict_types=1);

class User {
    public function __construct(public int $id, public string $name) {}
}

function add(int $a, int $b): int {
    return $a + $b;
}

$users = [new User(1, "Ada"), new User(2, "Linus")];
var_dump($users[0]);
echo add(2, 3) . PHP_EOL;
