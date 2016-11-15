json.date @date.strftime("%a, %d-%m-%Y")
json.discount = "#{ current_user.user_type.discount }%"
json.dishes @dishes do |dish|
  json.(dish, :id, :name)
  json.price dish.price * (1 - current_user.user_type.discount.to_f / 100)
end
