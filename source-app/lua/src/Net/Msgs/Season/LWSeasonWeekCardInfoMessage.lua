local LWSeasonWeekCardInfoMessage = BaseClass("LWSeasonWeekCardInfoMessage", SFSBaseMessage)
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
  DataCenter.SeasonPeriodicCardManager:InitInfo(t)
end

LWSeasonWeekCardInfoMessage.OnCreate = OnCreate
LWSeasonWeekCardInfoMessage.HandleMessage = HandleMessage
return LWSeasonWeekCardInfoMessage
