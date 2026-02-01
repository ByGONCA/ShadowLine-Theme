// sample.js
const greeting = "Hello, ShadowLine";
const count = 3;

function add(a, b) {
  return a + b;
}

const items = [1, 2, 3].map((n) => ({ id: n, label: `Item ${n}` }));

class Greeter {
  constructor(name) {
    this.name = name;
  }
  greet() {
    return `${greeting}, ${this.name}!`;
  }
}

console.log(new Greeter("World").greet());
