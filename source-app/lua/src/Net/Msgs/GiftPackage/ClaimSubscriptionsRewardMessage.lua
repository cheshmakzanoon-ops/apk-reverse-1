local ClaimSubscriptionsRewardMessage = BaseClass("ClaimSubscriptionsRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, cardId)
  base.OnCreate(self)
  self.sfsObj:PutInt("card_id", tonumber(cardId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      if t.freeReward ~= nil then
        for i = 1, #t.freeReward do
          table.insert(t.reward, t.freeReward[i])
        end
      end
      DataCenter.RewardManager:ShowCommonReward(t, nil, nil, nil, nil, nil, function()
        local showTipsCountdown = t.tipsDay or 0
        if 0 < showTipsCountdown then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local remainTime = t.golloesMonthCard.endTime - curTime
          local days = math.ceil(remainTime / (OneDayTime * 1000))
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIExpiredMonthlyCardTips, {anim = true}, days)
        end
      end)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    local weekCards = t.cards
    if not table.IsNullOrEmpty(weekCards) then
      for i, v in pairs(weekCards) do
        DataCenter.WeekCardManager:UpdateOneWeekCard(v)
      end
    end
    DataCenter.MonthCardNewManager:UpdateMonthCardData(t)
    if t.freeDailyObj ~= nil then
      GiftPackageData.UpdateClaimFreeWeeklyPackageT(t.freeDailyObj, false)
    end
    if t.weekFreeObj ~= nil then
      DataCenter.WeekCardManager:UpdateWeekCardFreeReward(t.weekFreeObj)
    end
    if t.seasonWeekFreeObj ~= nil then
      DataCenter.SeasonPeriodicCardManager:UpdateFreeRewardDate(t.seasonWeekFreeObj, false)
    end
    if t.seasonWeekCardObj ~= nil then
      DataCenter.SeasonPeriodicCardManager:UpdateDailyRewardDate(t.seasonWeekCardObj)
    end
  end
end

ClaimSubscriptionsRewardMessage.OnCreate = OnCreate
ClaimSubscriptionsRewardMessage.HandleMessage = HandleMessage
return ClaimSubscriptionsRewardMessage
