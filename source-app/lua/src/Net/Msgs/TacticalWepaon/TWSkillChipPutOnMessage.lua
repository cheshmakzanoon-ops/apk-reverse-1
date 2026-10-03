local TWSkillChipPutOnMessage = BaseClass("TWSkillChipPutOnMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TWSkillChipPutOnMessage:OnCreate(equipGroup, equips)
  base.OnCreate(self)
  self.sfsObj:PutInt("equipGroup", equipGroup)
  local chipArray = SFSArray.New()
  table.walk(equips, function(k, v)
    local obj = SFSObject.New()
    obj:PutInt("slot", k)
    obj:PutLong("uuid", v)
    chipArray:AddSFSObject(obj)
  end)
  self.sfsObj:PutSFSArray("chipArr", chipArray)
end

function TWSkillChipPutOnMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
    UIUtil.ShowTipsId(errCode)
  end
end

return TWSkillChipPutOnMessage
