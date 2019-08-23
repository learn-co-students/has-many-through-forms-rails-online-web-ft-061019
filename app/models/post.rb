class Post < ActiveRecord::Base
  has_many :post_categories
  has_many :categories, through: :post_categories
  # Could have used `accepts_nested_attributes_for :categories` if one didn't want unique categories (i.e. dupes ok).
  # The `accepts_nested_attributes_for :categories` would have auto created a #categories_attributes (which when fed by our params hash containing `categories_attribues` would have used mass assignment - linked together through the post_categories table - to auto create the associate and new category) method BUT it doesn't check for dupes so thus the custom writer method was used instead

  # This is custom writer for `category_attributes` so that we don't get dupe categories. (which keeps us from having dupe / bad data)
  # So when the PostsController recieves information in its params hash when creating a new post FOR a new category (contained in the `categories_attributes` key in the params hash, it is going to try to hit a writer method called `categores_attributes=` -- just like it tries to hit a writer method called `title=` when making up the new Post instance.  This is where active record (using accepts_nested_attributes_for) can automatically create the categories_attributes writer method and do the creation and linking of the category back to the post (though doesn't prevent dupes) OR we can write a custom writer method that can find_or_create_by and then link the new category to the post category like shown below. 
  def categories_attributes=(category_attributes)
    category_attributes.values.each do |category_attribute|
      category = Category.find_or_create_by(category_attribute)
      #self.post_categories.build(category: category)
      self.categories << category
    end
  end

end
