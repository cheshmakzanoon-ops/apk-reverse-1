local UserSkyBattleEquipUninstallMessage = BaseClass("UserSkyBattleEquipUninstallMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserSkyBattleEquipUninstallMessage:OnCreate(takeoffSlots)
  base.OnCreate(self)
  local oneArr = SFSArray.New()
  for k, v in ipairs(takeoffSlots) do
    oneArr:AddInt(v)
  end
  self.sfsObj:PutSFSArray("slot", oneArr)
end

function UserSkyBattleEquipUninstallMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSkyBattleGrowthChapterManager:SlotEquipTakeOff(t)
  end
end

return UserSkyBattleEquipUninstallMessage
