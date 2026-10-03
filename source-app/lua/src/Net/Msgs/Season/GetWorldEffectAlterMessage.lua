local GetWorldEffectAlterMessage = BaseClass("GetWorldEffectAlterMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetWorldEffectAlterMessage:OnCreate(worldId)
  base.OnCreate(self)
  self.sfsObj:PutInt("worldId", worldId or 0)
end

function GetWorldEffectAlterMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil and t and t.list then
    DataCenter.AllianceSkillManager:UpdateEffectAlter(t.list)
  end
end

return GetWorldEffectAlterMessage
