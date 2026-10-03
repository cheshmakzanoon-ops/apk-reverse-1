local TWSkillChipPutOffMessage = BaseClass("TWSkillChipPutOffMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TWSkillChipPutOffMessage:OnCreate(equipGroup, uuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("equipGroup", equipGroup)
  self.sfsObj:PutLong("uuid", uuid)
end

function TWSkillChipPutOffMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
    UIUtil.ShowTipsId(errCode)
  end
end

return TWSkillChipPutOffMessage
