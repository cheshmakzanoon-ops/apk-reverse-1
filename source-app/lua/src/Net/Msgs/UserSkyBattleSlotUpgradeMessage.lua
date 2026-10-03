local UserSkyBattleSlotUpgradeMessage = BaseClass("UserSkyBattleSlotUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserSkyBattleSlotUpgradeMessage:OnCreate(slot)
  base.OnCreate(self)
  self.sfsObj:PutInt("slot", slot)
end

function UserSkyBattleSlotUpgradeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSkyBattleGrowthChapterManager:SlotUpdate(t)
  end
end

return UserSkyBattleSlotUpgradeMessage
