local LWSeasonWastedlandRankShowInfoMessage = BaseClass("LWSeasonWastedlandRankShowInfoMessage", SFSBaseMessage)
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
  DataCenter.LWSeasonTrendsManager:HandleWastedlandRankRewardInfo(t)
end

LWSeasonWastedlandRankShowInfoMessage.OnCreate = OnCreate
LWSeasonWastedlandRankShowInfoMessage.HandleMessage = HandleMessage
return LWSeasonWastedlandRankShowInfoMessage
