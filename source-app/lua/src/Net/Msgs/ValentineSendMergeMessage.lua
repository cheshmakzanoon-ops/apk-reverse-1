local ValentineSendMergeMessage = BaseClass("ValentineSendMergeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
  end
  EventManager:GetInstance():Broadcast(EventId.ValentineSendGiftMakeGift, t)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

ValentineSendMergeMessage.OnCreate = OnCreate
ValentineSendMergeMessage.HandleMessage = HandleMessage
return ValentineSendMergeMessage
