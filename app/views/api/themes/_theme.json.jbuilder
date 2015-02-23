json.extract! theme, *theme.attributes.keys
json.editable theme.editable?(current_user)
json.url api_theme_path(theme)
