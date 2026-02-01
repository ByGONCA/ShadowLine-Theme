# frozen_string_literal: true

# User management service for handling user operations
# Provides CRUD operations and validation

require 'date'

# User model with validation
class User
  attr_accessor :id, :name, :email, :role, :active, :metadata

  VALID_ROLES = %i[admin user guest].freeze
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  def initialize(id:, name:, email:, role: :user, active: true, metadata: {})
    @id = id
    @name = name
    @email = validate_email!(email)
    @role = validate_role!(role)
    @active = active
    @metadata = metadata
  end

  def admin?
    @role == :admin
  end

  def to_s
    "User ##{id}: #{name} (#{email}) - #{role}"
  end

  private

  def validate_email!(email)
    raise ArgumentError, "Invalid email: #{email}" unless email.match?(EMAIL_REGEX)
    email
  end

  def validate_role!(role)
    role = role.to_sym
    raise ArgumentError, "Invalid role: #{role}" unless VALID_ROLES.include?(role)
    role
  end
end

# Service for managing users
class UserService
  MAX_USERS = 1000

  def initialize
    @users = {}
    initialize_users
  end

  # Get user by ID
  # @param id [Integer] User's ID
  # @return [User, nil] User or nil if not found
  def get_user(id)
    @users[id]
  end

  # Find users matching criteria
  # @param filters [Hash] Filter criteria
  # @return [Array<User>] Matching users
  def find_users(**filters)
    @users.values.select do |user|
      filters.all? { |key, value| user.send(key) == value }
    end
  end

  # Create a new user
  # @return [User] The created user
  # @raise [StandardError] If max users reached
  def create_user(name:, email:, **options)
    raise StandardError, 'Maximum user limit reached' if @users.size >= MAX_USERS

    id = (@users.keys.max || 0) + 1
    metadata = { created_at: DateTime.now.iso8601 }
    
    user = User.new(
      id: id,
      name: name,
      email: email,
      metadata: metadata,
      **options
    )
    
    @users[id] = user
    user
  rescue ArgumentError => e
    puts "Error creating user: #{e.message}"
    nil
  end

  # Get all active users
  def active_users
    find_users(active: true)
  end

  private

  def initialize_users
    default_users = [
      { id: 1, name: 'Alice', email: 'alice@example.com', role: :admin },
      { id: 2, name: 'Bob', email: 'bob@example.com', role: :user },
      { id: 3, name: 'Charlie', email: 'charlie@example.com', active: false }
    ]

    default_users.each do |attrs|
      user = User.new(**attrs)
      @users[user.id] = user
    end
  end
end

# Example usage
if __FILE__ == $PROGRAM_NAME
  service = UserService.new

  # Find active users
  active = service.active_users
  puts "Found #{active.size} active users"

  # Get specific user
  user = service.get_user(1)
  puts user if user

  # Create new user
  new_user = service.create_user(
    name: 'Diana',
    email: 'diana@example.com',
    role: :user
  )
  puts "Created: #{new_user}" if new_user

  # Find all admins
  admins = service.find_users(role: :admin)
  puts "\nAdmins:"
  admins.each { |admin| puts "  - #{admin.name}" }
end
