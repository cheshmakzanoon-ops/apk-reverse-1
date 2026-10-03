local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "objectPath"},
  {
    "string",
    "compTypeName"
  },
  {"bool", "enable"}
}
behaviour.optionalParams = {
  {
    "bool",
    "revertWhenClear",
    true
  }
}
local CompTypeMap = {
  ScrollView = typeof(CS.ScrollView)
}

function behaviour:Begin()
  local go = CS.UnityEngine.GameObject.Find(self.objectPath)
  if IsNull(go) then
    self:LogError("Can't find object: " .. self.objectPath)
    self.done = true
    return
  end
  local compType = CompTypeMap[self.compTypeName]
  if compType == nil then
    self:LogError("Unsupport component type: " .. self.compTypeName)
    self.done = true
    return
  end
  local comp = go:GetComponent(compType)
  if IsNull(comp) then
    self:LogError("Can't find component: " .. self.compTypeName .. " on object: " .. self.objectPath)
    self.done = true
    return
  end
  self.comp = comp
  self.origEnabled = comp.enabled
  comp.enabled = self.enable
  self.done = true
end

function behaviour:Clear()
  if self.revertWhenClear and self.origEnabled ~= nil and not IsNull(self.comp) then
    self.comp.enabled = self.origEnabled
  end
end

return behaviour
