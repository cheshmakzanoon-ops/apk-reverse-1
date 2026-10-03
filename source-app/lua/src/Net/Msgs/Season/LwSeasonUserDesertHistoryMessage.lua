local LwSeasonUserDesertHistoryMessage = BaseClass("LwSeasonUserDesertHistoryMessage", SFSBaseMessage)
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
  DataCenter.SeasonUserDesertHistoryDataManager:HandleUserDesertHistoryMessage(t)
end

LwSeasonUserDesertHistoryMessage.OnCreate = OnCreate
LwSeasonUserDesertHistoryMessage.HandleMessage = HandleMessage
return LwSeasonUserDesertHistoryMessage
