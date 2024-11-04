class AddUserToPosts < ActiveRecord::Migration[7.2]
  def up
    # Create users table if it doesn't exist
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :username
        t.timestamps
      end
    end

    # Add user_id to posts as nullable first
    add_reference :posts, :user, null: true, foreign_key: true

    # Create default user
    default_user = User.find_or_create_by!(username: 'system_user')

    # Associate existing posts with default user
    Post.update_all(user_id: default_user.id)

    # Make user_id non-nullable
    change_column_null :posts, :user_id, false
  end

  def down
    remove_reference :posts, :user
  end
end