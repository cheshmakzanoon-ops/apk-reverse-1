local SlotsLotteyMessage = BaseClass("SlotsLotteyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, free, multiple)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutBool("free", free)
  self.sfsObj:PutBool("multiple", multiple)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
    end
    DataCenter.ActSlotMachineDataManager:UpdateLotteyMessage(t)
    EventManager:GetInstance():Broadcast(EventId.ActSlotRollResult, t)
  end
end

SlotsLotteyMessage.OnCreate = OnCreate
SlotsLotteyMessage.HandleMessage = HandleMessage
return SlotsLotteyMessage
