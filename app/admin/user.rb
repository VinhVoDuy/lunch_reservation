ActiveAdmin.register User do

  permit_params [:email, :password, :password_confirmation, :user_type_id, :name]

  filter :email
  filter :name
  filter :user_type

  controller do
    def scoped_collection
      super.includes(:reservations, :deposits)
    end
  end
  index do
    column :id
    column :name
    column :email
    column :user_type
    column :balance do |user|
      "#{ user.deposits.sum(:amount) - user.reservations.sum(:amount) } VND"
    end


    actions
  end

  form do |f|
    f.inputs 'User Info' do
      f.input :email
      f.input :name
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation, required: true
      end
      f.input :user_type, include_blank: false
    end
    f.submit
  end

  show do
    attributes_table do
      row :id
      row :email
      row :name
      row :user_type
      row :balance do
        "#{ number_with_delimiter(resource.deposits.sum(:amount) - resource.reservations.sum(:amount), :delimiter => ',') } VND"
      end
      row :reservations do |user|
        span { link_to 'This Week', admin_reservations_path('q[user_id_eq]' => user.id, 'q[created_at_gteq_date]' => Time.now.beginning_of_week, 'q[created_at_lteq_date]' => Time.now.end_of_week) }
        span { ', '}
        span { link_to 'Last Week', admin_reservations_path('q[user_id_eq]' => user.id, 'q[created_at_gteq_date]' => Time.now.beginning_of_week - 1.week, 'q[created_at_lteq_date]' => Time.now.end_of_week - 1.week) }

        span { ', '}
        span { link_to 'This Month', admin_reservations_path('q[user_id_eq]' => user.id, 'q[created_at_gteq_date]' => Time.now.beginning_of_month, 'q[created_at_lteq_date]' => Time.now.end_of_month) }

        span { ', '}
        span { link_to 'Last Month', admin_reservations_path('q[user_id_eq]' => user.id, 'q[created_at_gteq_date]' => Time.now.beginning_of_month - 1.month, 'q[created_at_lteq_date]' => Time.now.end_of_month - 1.month) }
      end
      row :last_deposit do |user|
        last_deposit = user.deposits.order(created_at: :desc).first
        if last_deposit
          span do
            link_to last_deposit.amount, admin_deposit_path(last_deposit)
          end

          span { "(at #{last_deposit.created_at.strftime("%d-%b")} )" }
        end
      end

      row :deposits do |user|
        link_to 'All Deposits', admin_deposits_path('q[user_id_eq]' => user.id)
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
