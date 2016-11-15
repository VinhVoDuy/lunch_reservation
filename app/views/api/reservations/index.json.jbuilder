json.reservations @reservations do |reservation|
  json.id reservation.id
  json.(reservation.dish, :name)
  json.date reservation.dish.date
end
