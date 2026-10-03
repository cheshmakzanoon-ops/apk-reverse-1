local LWSeasonActivitySynthesisRewardRateMessage = BaseClass("LWSeasonActivitySynthesisRewardRateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.ActivityListDataManager:UpdateExtraData(SEASON_ACTIVITY_SYNTHESIS_REWARD_RATE, t.show)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonSynthesisRateTip)
  end
end

LWSeasonActivitySynthesisRewardRateMessage.OnCreate = OnCreate
LWSeasonActivitySynthesisRewardRateMessage.HandleMessage = HandleMessage
return LWSeasonActivitySynthesisRewardRateMessage
