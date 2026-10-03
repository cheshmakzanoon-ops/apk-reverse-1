local PushUserSkyBattleSlotMessage = BaseClass("PushUserSkyBattleSlotMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserSkyBattleSlotMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushUserSkyBattleSlotMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSkyBattleGrowthChapterManager:RefreshBattleSlotInfoData(t)
  end
end

return PushUserSkyBattleSlotMessage
