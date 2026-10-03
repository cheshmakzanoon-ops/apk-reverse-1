local base = require("Scene.LWBattle.Buff.BuffBase")
local BuffProperty = BaseClass("BuffProperty", base)

function BuffProperty:__init(logic, mgr, unit, meta, id, property)
  self.logic = logic
  local battleType = logic:GetPVEType()
  if PVPType[battleType] then
    self.property = {}
  else
    self.property = property
  end
end

function BuffProperty:__delete()
  self:Destroy()
end

function BuffProperty:Destroy()
  base.Destroy(self)
end

function BuffProperty:OnStart()
  for k, _ in pairs(self.property) do
    self.mgr:RegisterPropertyBuff(k, self)
  end
end

function BuffProperty:OnEnd()
  for k, _ in pairs(self.property) do
    self.mgr:UnregisterPropertyBuff(k, self)
  end
end

function BuffProperty:GetPropertyValue(propertyType)
  return self.property[propertyType] or 0
end

return BuffProperty
