local ClaimWeekCardFreeRewardMessage = BaseClass("ClaimWeekCardFreeRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local _isAutoClaim = false

local function OnCreate(self, isAutoClaim)
  base.OnCreate(self)
  _isAutoClaim = isAutoClaim
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      local tips = _isAutoClaim and CS.GameEntry.Localization:GetString("auto_receive_desc") or ""
      DataCenter.RewardManager:ShowCommonReward(t, nil, nil, nil, nil, nil, nil, tips)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    DataCenter.WeekCardManager:UpdateWeekCardFreeReward(t)
  end
end

ClaimWeekCardFreeRewardMessage.OnCreate = OnCreate
ClaimWeekCardFreeRewardMessage.HandleMessage = HandleMessage
return ClaimWeekCardFreeRewardMessage
