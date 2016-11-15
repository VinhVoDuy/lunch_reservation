class Api::DishesController < ApiController
  def index
    @date = Date.strptime(params[:date], "%d-%m-%Y")
    @dishes = Dish.where('created_at >= :start AND created_at <= :end', start: @date.beginning_of_day, end: @date.end_of_day)
  rescue TypeError, ArgumentError
    render json: { error: 'Invalid or missing date' }, status: 400
  end

end
