local UserSkyBattleEquipInstallMessage = BaseClass("UserSkyBattleEquipInstallMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserSkyBattleEquipInstallMessage:OnCreate(equips)
  base.OnCreate(self)
  if equips == nil then
    return
  end
  local equipArr = SFSArray.New()
  for slotId, equipUuId in pairs(equips) do
    local obj1 = SFSObject.New()
    obj1:PutInt("slot", slotId)
    obj1:PutLong("uuid", equipUuId)
    equipArr:AddSFSObject(obj1)
  end
  self.sfsObj:PutSFSArray("slot2Uuid", equipArr)
end

function UserSkyBattleEquipInstallMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSkyBattleGrowthChapterManager:SlotEquipTakeOn(t)
  end
end

return UserSkyBattleEquipInstallMessage
