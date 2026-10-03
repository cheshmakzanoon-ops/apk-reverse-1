local PushSkyBattleUserInfoMessage = BaseClass("PushSkyBattleUserInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSkyBattleUserInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSkyBattleUserInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSkyBattleGrowthChapterManager:RefreshUserInfoData(t)
  end
end

return PushSkyBattleUserInfoMessage
