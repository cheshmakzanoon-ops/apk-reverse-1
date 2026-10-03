local ActivityTreasureHuntNewRecommendSelectMessage = BaseClass("ActivityTreasureHuntNewRecommendSelectMessage", SFSBaseMessage)
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
    DataCenter.ActivityTreasureHuntNewManager:OnRecvDigRecommendSelect(t)
    EventManager:GetInstance():Broadcast(EventId.ActivityTreasureHuntNewRecommendSelectChange)
  end
end

ActivityTreasureHuntNewRecommendSelectMessage.OnCreate = OnCreate
ActivityTreasureHuntNewRecommendSelectMessage.HandleMessage = HandleMessage
return ActivityTreasureHuntNewRecommendSelectMessage
