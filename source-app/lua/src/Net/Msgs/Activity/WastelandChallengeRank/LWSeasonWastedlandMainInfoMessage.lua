local LWSeasonWastedlandMainInfoMessage = BaseClass("LWSeasonWastedlandMainInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutInt("type", tonumber(type))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.LWSeasonTrendsManager:HandleWastedlandMainRank(t)
end

LWSeasonWastedlandMainInfoMessage.OnCreate = OnCreate
LWSeasonWastedlandMainInfoMessage.HandleMessage = HandleMessage
return LWSeasonWastedlandMainInfoMessage
