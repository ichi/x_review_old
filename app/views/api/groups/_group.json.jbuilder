json.extract! group, *group.attributes.keys
json.editable group.editable?(current_user)
json.url api_group_path(group)
