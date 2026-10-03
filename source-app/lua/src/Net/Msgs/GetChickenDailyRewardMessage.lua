local GetChickenDailyRewardMessage = BaseClass("GetChickenDailyRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetChickenDailyRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetChickenDailyRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonEasterEggManager:OnClaimRewardCallback(t)
  end
end

return GetChickenDailyRewardMessage
