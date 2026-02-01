/* UserService - Handles user management and authentication */

interface Database {
  connect(): void;
}

interface User {
  id: number;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'guest';
  metadata?: Record<string, any>;
}

type Result<T> = 
  | { success: true; data: T }
  | { success: false; error: string };

class UserService {
  private users: Map<number, User> = new Map();
  private readonly MAX_USERS = 1000;

  constructor(private db: Database) {
    this.initializeUsers();
  }

  /**
   * Fetches a user by their unique ID
   * @param id - The user's ID
   * @returns Result containing user or error
   */
  async getUser(id: number): Promise<Result<User>> {
    try {
      const user = this.users.get(id);
      if (!user) {
        return { success: false, error: `User ${id} not found` };
      }
      return { success: true, data: user };
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Unknown error';
      return { success: false, error: message };
    }
  }

  // Create a new user with validation
  createUser(name: string, email: string): Result<User> {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    if (!emailRegex.test(email)) {
      return { success: false, error: 'Invalid email format' };
    }

    const id = this.users.size + 1;
    const newUser: User = {
      id,
      name,
      email,
      role: 'user',
      metadata: { createdAt: new Date().toISOString() }
    };

    this.users.set(id, newUser);
    return { success: true, data: newUser };
  }

  private initializeUsers(): void {
    const defaultUsers: User[] = [
      { id: 1, name: 'Alice', email: 'alice@example.com', role: 'admin' },
      { id: 2, name: 'Bob', email: 'bob@example.com', role: 'user' },
    ];

    defaultUsers.forEach(user => this.users.set(user.id, user));
  }
}

// Example usage
async function main() {
  const db: Database = { connect: () => console.log('Connected') };
  const service = new UserService(db);
  const result = await service.getUser(1);

  if (result.success) {
    console.log(`Found user: ${result.data.name}`);
  } else {
    console.error(`Error: ${result.error}`);
  }
}

export { UserService, User, Result };
