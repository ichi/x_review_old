json.array! @themes do |theme|
  json.partial! 'theme', theme: theme
end
