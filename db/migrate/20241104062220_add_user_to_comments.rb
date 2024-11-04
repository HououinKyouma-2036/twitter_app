class AddUserToComments < ActiveRecord::Migration[7.2]
  def up
    # Add user_id to comments as nullable first
    add_reference :comments, :user, null: true, foreign_key: true

    # Create or find system user
    default_user = User.find_or_create_by!(username: 'system_user')

    # Update existing comments to use default user
    Comment.where(user_id: nil).update_all(user_id: default_user.id)

    # Make user_id non-nullable
    change_column_null :comments, :user_id, false
  end

  def down
    remove_reference :comments, :user
  end
end