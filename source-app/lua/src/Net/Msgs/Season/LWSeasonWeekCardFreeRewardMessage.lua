local LWSeasonWeekCardFreeRewardMessage = BaseClass("LWSeasonWeekCardFreeRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local _isAutoClaim = false

local function OnCreate(self, cardId, isAutoClaim)
  base.OnCreate(self)
  self.sfsObj:PutInt("card_id", tonumber(cardId))
  _isAutoClaim = isAutoClaim
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonPeriodicCardManager:UpdateFreeRewardDate(t, _isAutoClaim)
end

LWSeasonWeekCardFreeRewardMessage.OnCreate = OnCreate
LWSeasonWeekCardFreeRewardMessage.HandleMessage = HandleMessage
return LWSeasonWeekCardFreeRewardMessage
