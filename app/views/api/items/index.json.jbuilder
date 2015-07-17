json.array! @items do |item|
  json.partial! 'item', theme: @theme, item: item
end
