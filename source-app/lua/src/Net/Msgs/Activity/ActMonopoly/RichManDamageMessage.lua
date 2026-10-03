local RichManDamageMessage = BaseClass("RichManDamageMessage", SFSBaseMessage)
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
  if t.boosStageReward ~= nil then
    DataCenter.RewardManager:AddRewards(t.boosStageReward)
  end
  DataCenter.ActMonopolyDataManager:OnGetDamageDataMsg(t)
  EventManager:GetInstance():Broadcast(EventId.ActMonopolyBossBattle, t)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

RichManDamageMessage.OnCreate = OnCreate
RichManDamageMessage.HandleMessage = HandleMessage
return RichManDamageMessage
