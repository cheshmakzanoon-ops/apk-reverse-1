local RichManReceiveEventMessage = BaseClass("RichManReceiveEventMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, eventId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("eventId", tostring(eventId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = t.reward
    if reward and 0 < #reward then
      DataCenter.RewardManager:AddRewards(reward)
    end
    DataCenter.ActMonopolyDataManager:RefreshActDetailData(t)
    EventManager:GetInstance():Broadcast(EventId.ActMonopolyAutoEventDataReceive, t)
  end
end

RichManReceiveEventMessage.OnCreate = OnCreate
RichManReceiveEventMessage.HandleMessage = HandleMessage
return RichManReceiveEventMessage
