local UIGameObjectWrap = {}
UIGameObjectWrap.__index = UIGameObjectWrap

function UIGameObjectWrap.new(gameObject)
  local self = setmetatable({}, UIGameObjectWrap)
  self.activeSelf = gameObject.activeSelf
  self.gameObject = gameObject
  return self
end

function UIGameObjectWrap:SetActive(value)
  if self.activeSelf ~= value then
    self.gameObject:SetActive(value)
    self.activeSelf = value
  end
end

function UIGameObjectWrap:__index(key)
  if UIGameObjectWrap[key] then
    return UIGameObjectWrap[key]
  else
    return self.gameObject[key]
  end
end

return UIGameObjectWrap
