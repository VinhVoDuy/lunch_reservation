class Api::ReservationsController < ApiController
  def index
    @reservations = current_user.reservations.joins(:dish).where('dishes.date >= ?', Date.today)
  end

  def destroy
    reservation = Reservation.find(params[:id])
    if reservation.destroy
      render json: { status: :success }
    else
      render json: { error: reservation.errors.full_messages.join(', ') }, status: 400
    end
  end

  def create
    reservation = Reservation.new(user: current_user, dish_id: params[:dish_id])
    if reservation.save
      render json: { error: reservation.errors.full_messages.join(', ') }, status: 400
    else
      render json: { status: :success }
    end
  end
end
