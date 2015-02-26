json.array! @groups do |group|
  json.partial! 'api/groups/group', group: group, url: api_user_group_path(group)
end
