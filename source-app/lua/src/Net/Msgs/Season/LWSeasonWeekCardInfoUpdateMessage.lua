local LWSeasonWeekCardInfoUpdateMessage = BaseClass("LWSeasonWeekCardInfoUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonPeriodicCardManager:UpdateInfo(t)
end

LWSeasonWeekCardInfoUpdateMessage.OnCreate = OnCreate
LWSeasonWeekCardInfoUpdateMessage.HandleMessage = HandleMessage
return LWSeasonWeekCardInfoUpdateMessage
