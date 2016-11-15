ActiveAdmin.register Dish do

  permit_params :names, :name, :price, :date
  action_item :add_dishes, only: :index do
    link_to 'Add Dishes', new_admin_dish_path(bulk: true)
  end

  filter :price
  filter :date
  scope :previous_week
  scope :this_week
  scope :today
  scope :next_week

  index do |vl|
    selectable_column
    id_column
    column :name
    column :price
    column :date do |dish|
      dish.date.strftime('%a, %e %b %Y')
    end
    column :users do |dish|
      dish.reservations.each do |reservation|
        @total_user_payment = @total_user_payment.to_i + reservation.amount
        @total_reservations = @total_reservations.to_i + 1
      end

      dish.users.each_with_index do |user, index|
        @total_payment = @total_payment.to_i + dish.price
        if index > 0
          span ','
        else
          span { link_to user.name, admin_user_path(user) }
        end
      end
      nil
    end

    column :total do |dish|
      dish.reservations.count
    end

    panel 'Summary' do
      div "Company Pay", style: 'width: 300px; display: inline-block'
      div "#{@total_payment.to_i - @total_user_payment.to_i} VND", style: 'display: inline-block'
      br
      div "User Pay", style: 'width: 300px; display: inline-block'
      div "#{@total_user_payment.to_i} VND", style: 'display: inline-block'
      br
      div "Total Pay", style: 'width: 300px; display: inline-block'
      div "#{@total_payment.to_i} VND", style: 'display: inline-block'

      br
      div "Total Reservations", style: 'width: 300px; display: inline-block'
      div "#{@total_reservations.to_i}", style: 'display: inline-block'
    end
  end

  form do |f|
    if params[:bulk]
      inputs 'Dishes' do
        input :names, as: :text, hint: 'List should be seperated line by line'
        input :price
        input :date, as: :datepicker
      end
    else
      inputs 'New Dish' do
        input :name
        input :price
        input :date, as: :datepicker
      end
    end
    f.submit
  end

  controller do
    def create
      super do |format|
        dish_params = permitted_params[:dish]
        if dish_params[:names].present?
          name_list = dish_params[:names].split("\r\n").reject(&:blank?)
          name_list.each do |a_name|
            Dish.create(name: a_name, price: dish_params[:price], date: dish_params[:date])
          end
          return redirect_to collection_url('q[date_equals]' => dish_params[:date])
        end
      end
    end
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
