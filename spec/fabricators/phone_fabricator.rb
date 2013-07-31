Fabricator(:phone) do
  name  'John F. Kennedy'
  number '+1 234 56 78'
end

Fabricator(:lincolns_phone, class_name: :phone) do
  name  'Abraham Lincoln'
  number '+1 876 54 32'
end
