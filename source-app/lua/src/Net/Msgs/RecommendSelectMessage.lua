local RecommendSelectMessage = BaseClass("RecommendSelectMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, select)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("select", select)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DigActivityManager:OnRecvDigRecommendSelect(t)
    EventManager:GetInstance():Broadcast(EventId.DigActivityRecommendSelectChange)
  end
end

RecommendSelectMessage.OnCreate = OnCreate
RecommendSelectMessage.HandleMessage = HandleMessage
return RecommendSelectMessage
