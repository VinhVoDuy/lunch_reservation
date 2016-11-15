ActiveAdmin.register Reservation do
  permit_params :user_id, :dish_id
  actions :all, except: [:destroy, :update, :edit]
  config.sort_order = 'created_at_desc'

  index do
    column :id
    column :user
    column :dish
    column :amount
    column :created_at
    actions
  end

  form do |f|
    h1 f.object.errors.full_messages.join(',')
    f.inputs 'Reservation' do
      f.input :user
      f.input :dish, collection: Dish.all.map{|dish| ["#{ dish.name } - #{dish.price} VND", dish.id]}
    end
    f.submit
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
