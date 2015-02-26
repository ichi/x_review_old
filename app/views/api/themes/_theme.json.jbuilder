json.extract! theme, *theme.attributes.keys
json.editable theme.editable?(current_user)
json.url api_theme_path(theme)
json.group do
  json.partial! 'api/groups/group', group: theme.group if theme.group_id
end
