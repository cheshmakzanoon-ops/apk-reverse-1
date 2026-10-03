local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "objectPath"},
  {"bool", "active"}
}
behaviour.optionalParams = {
  {
    "bool",
    "revertWhenClear",
    true
  }
}

function behaviour:Begin()
  local go = CS.UnityEngine.GameObject.Find(self.objectPath)
  if IsNull(go) then
    self:LogError("Can't find object: " .. self.objectPath)
    self.done = true
    return
  end
  self.go = go
  self.origActived = go.activeSelf
  go:SetActive(self.active)
  self.done = true
end

function behaviour:Clear()
  if self.revertWhenClear and self.origActived ~= nil and not IsNull(self.go) then
    self.go:SetActive(self.origActived)
  end
end

return behaviour
