local LWSeasonWeekCardDailyRewardMessage = BaseClass("LWSeasonWeekCardDailyRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, cardId)
  base.OnCreate(self)
  self.sfsObj:PutInt("card_id", tonumber(cardId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonPeriodicCardManager:UpdateDailyRewardDate(t)
end

LWSeasonWeekCardDailyRewardMessage.OnCreate = OnCreate
LWSeasonWeekCardDailyRewardMessage.HandleMessage = HandleMessage
return LWSeasonWeekCardDailyRewardMessage
