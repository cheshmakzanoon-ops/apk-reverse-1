local LwSeasonTrendInfoMessage = BaseClass("LwSeasonTrendInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, trendsId, rankId)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.LWSeasonTrendsManager:InitTrendData(t)
end

LwSeasonTrendInfoMessage.OnCreate = OnCreate
LwSeasonTrendInfoMessage.HandleMessage = HandleMessage
return LwSeasonTrendInfoMessage
