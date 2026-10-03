function IsNull(unity_object)
  if unity_object == nil then
    return true
  end
  if type(unity_object) == "userdata" and unity_object.IsNull ~= nil then
    return unity_object:IsNull()
  end
  return false
end

function IsNotNull(unity_object)
  if unity_object == nil then
    return false
  end
  if type(unity_object) == "userdata" and unity_object.IsNull ~= nil then
    return not unity_object:IsNull()
  end
  return true
end

function GameObjectIsValid(unity_game_object)
  if unity_game_object == nil then
    return false
  end
  if type(unity_game_object) == "userdata" and unity_game_object.IsNull ~= nil then
    return not unity_game_object:IsNull()
  end
  return false
end

function ComponentIsValid(lua_component)
  if lua_component == nil then
    return false
  end
  local unity_game_object = lua_component.gameObject
  if unity_game_object ~= nil and type(unity_game_object) == "userdata" and unity_game_object.IsNull ~= nil then
    return not unity_game_object:IsNull()
  end
  return false
end
