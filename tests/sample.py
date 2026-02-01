"""User management module for handling authentication and user data"""

from dataclasses import dataclass, field
from typing import Optional, List, Dict, Any
from datetime import datetime
import re


@dataclass
class User:
    """Represents a user in the system"""
    id: int
    name: str
    email: str
    role: str = 'user'
    active: bool = True
    metadata: Dict[str, Any] = field(default_factory=dict)

    def __post_init__(self):
        if not self._validate_email(self.email):
            raise ValueError(f"Invalid email: {self.email}")

    @staticmethod
    def _validate_email(email: str) -> bool:
        """Validates email format using regex"""
        pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
        return re.match(pattern, email) is not None


class UserService:
    """Service for managing user operations"""
    
    MAX_USERS = 1000

    def __init__(self):
        self.users: Dict[int, User] = {}
        self._initialize_users()

    def _initialize_users(self) -> None:
        """Initialize with default users"""
        default_users = [
            User(1, 'Alice', 'alice@example.com', role='admin'),
            User(2, 'Bob', 'bob@example.com'),
            User(3, 'Charlie', 'charlie@example.com', active=False)
        ]
        for user in default_users:
            self.users[user.id] = user

    def get_user(self, user_id: int) -> Optional[User]:
        """Retrieve user by ID"""
        return self.users.get(user_id)

    def find_users(self, **filters) -> List[User]:
        """Find users matching the given filters"""
        results = []
        
        for user in self.users.values():
            match = True
            for key, value in filters.items():
                if not hasattr(user, key) or getattr(user, key) != value:
                    match = False
                    break
            if match:
                results.append(user)
        
        return results

    def create_user(self, name: str, email: str, **kwargs) -> User:
        """Create a new user"""
        user_id = max(self.users.keys(), default=0) + 1
        new_user = User(
            id=user_id,
            name=name,
            email=email,
            metadata={'created_at': datetime.now().isoformat()},
            **kwargs
        )
        self.users[user_id] = new_user
        return new_user


# Example usage
if __name__ == '__main__':
    service = UserService()
    
    # Find all active users
    active_users = service.find_users(active=True)
    print(f"Found {len(active_users)} active users")
    
    # Get specific user
    user = service.get_user(1)
    if user:
        print(f"User: {user.name} ({user.email}) - Role: {user.role}")
    
    # Create new user
    new_user = service.create_user('Diana', 'diana@example.com', role='user')
    print(f"Created user: {new_user.name} with ID {new_user.id}")
