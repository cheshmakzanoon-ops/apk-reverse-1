local DetectEventPveFeatureEndMessage = BaseClass("DetectEventPveFeatureEndMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, isWin)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutBool("win", isWin)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reward then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    EventManager:GetInstance():Broadcast(EventId.ParkourBattleReward, t.reward)
  end
end

DetectEventPveFeatureEndMessage.OnCreate = OnCreate
DetectEventPveFeatureEndMessage.HandleMessage = HandleMessage
return DetectEventPveFeatureEndMessage
