local SlotsOpenBoxNewMessage = BaseClass("SlotsOpenBoxNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, uuid, index, openTime)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("index", index)
  self.sfsObj:PutInt("openTime", openTime)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = t.reward
    if reward then
      DataCenter.RewardManager:AddRewards(reward)
    end
    DataCenter.ActSlotMachineDataManager:UpdateBoxMessage(t)
    EventManager:GetInstance():Broadcast(EventId.ActSlotBoxUpdate, t)
  end
end

SlotsOpenBoxNewMessage.OnCreate = OnCreate
SlotsOpenBoxNewMessage.HandleMessage = HandleMessage
return SlotsOpenBoxNewMessage
