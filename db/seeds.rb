# Idempotent: safe to run several times. In production SEED_PASSWORD is mandatory.
password = ENV.fetch("SEED_PASSWORD") { Rails.env.production? ? abort("Define SEED_PASSWORD para crear los usuarios iniciales") : "password" }

User.find_or_create_by!(email_address: "admin@terminal.test") do |user|
  user.password = password
  user.role = :admin
end

seller = User.find_or_create_by!(email_address: "vendedor@terminal.test") do |user|
  user.password = password
  user.role = :seller
end

return if Rails.env.production?

cities = %w[Bogotá Medellín Cali Barranquilla Bucaramanga Tunja Villavicencio].map do |name|
  City.find_or_create_by!(name:)
end

vehicles = [
  [ "TTA123", "Carlos Pérez", :bus, 40 ],
  [ "TTB456", "Luisa Gómez", :buseta, 24 ],
  [ "TTC789", "Jorge Ramírez", :microbus, 16 ],
  [ "TTD012", "Ana Torres", :van, 12 ]
].map do |plate, driver, kind, capacity|
  Vehicle.find_or_create_by!(plate:) { it.assign_attributes(driver:, kind:, capacity:) }
end

if Trip.none?
  bogota = cities.first
  7.times do |day|
    cities.drop(1).first(vehicles.size).each_with_index do |destination, index|
      Trip.create!(
        origin: bogota,
        destination:,
        vehicle: vehicles[index],
        departure_at: (day + 1).days.from_now.change(hour: 6 + index * 3),
        fare: 45_000 + index * 15_000
      )
    end
  end

  Trip.chronological.first.bookings.create!(user: seller, passenger_name: "María López", passenger_document: "1020304050", seat_number: 1, status: :paid)
end
