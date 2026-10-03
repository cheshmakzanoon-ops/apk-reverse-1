local ActivityGGGoRankMessage = BaseClass("ActivityGGGoRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, activityType)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  if activityType == nil then
    activityType = DataCenter.LWGGGoDataManager:GetActivityType()
  end
  self.sfsObj:PutInt("activityType", activityType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGGGoDataManager:UpdateRank(t)
  end
end

ActivityGGGoRankMessage.OnCreate = OnCreate
ActivityGGGoRankMessage.HandleMessage = HandleMessage
return ActivityGGGoRankMessage
