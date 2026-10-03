local SlotsOpenBoxMessage = BaseClass("SlotsOpenBoxMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, uuid, rewardAll, index, openTime)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutBool("rewardAll", rewardAll)
  self.sfsObj:PutInt("index", index)
  self.sfsObj:PutInt("openTime", openTime)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    DataCenter.ActSlotMachineDataManager:UpdateBoxMessage(t)
    EventManager:GetInstance():Broadcast(EventId.ActSlotBoxUpdate, t)
  end
end

SlotsOpenBoxMessage.OnCreate = OnCreate
SlotsOpenBoxMessage.HandleMessage = HandleMessage
return SlotsOpenBoxMessage
