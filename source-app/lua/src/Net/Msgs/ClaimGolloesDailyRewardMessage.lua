local ClaimGolloesDailyRewardMessage = BaseClass("ClaimGolloesDailyRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, monthCardId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("itemId", monthCardId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if not t.reward then
      t.reward = {}
    end
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t, Localization:GetString(320337), nil, nil, nil, nil, function()
      local showTipsCountdown = t.tipsDay or 0
      if 0 < showTipsCountdown then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local remainTime = t.golloesMonthCard.endTime - curTime
        local days = math.ceil(remainTime / (OneDayTime * 1000))
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIExpiredMonthlyCardTips, {anim = true}, days)
      end
    end)
    DataCenter.MonthCardNewManager:UpdateMonthCardData(t)
  end
end

ClaimGolloesDailyRewardMessage.OnCreate = OnCreate
ClaimGolloesDailyRewardMessage.HandleMessage = HandleMessage
return ClaimGolloesDailyRewardMessage
