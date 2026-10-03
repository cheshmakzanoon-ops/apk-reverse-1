local ActivityPayRewardPreviewMessage = BaseClass("ActivityPayRewardPreviewMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.rewardArr ~= nil then
    EventManager:GetInstance():Broadcast(EventId.OnGetActivityPayRewardPreview, t.rewardArr)
  end
end

ActivityPayRewardPreviewMessage.OnCreate = OnCreate
ActivityPayRewardPreviewMessage.HandleMessage = HandleMessage
return ActivityPayRewardPreviewMessage
