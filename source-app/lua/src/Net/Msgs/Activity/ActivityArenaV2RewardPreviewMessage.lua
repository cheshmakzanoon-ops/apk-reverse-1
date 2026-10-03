local ActivityArenaV2RewardPreviewMessage = BaseClass("ActivityArenaV2RewardPreviewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaV2BattlePreview)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaRewardPreivewBack, t)
  end
end

ActivityArenaV2RewardPreviewMessage.OnCreate = OnCreate
ActivityArenaV2RewardPreviewMessage.HandleMessage = HandleMessage
return ActivityArenaV2RewardPreviewMessage
