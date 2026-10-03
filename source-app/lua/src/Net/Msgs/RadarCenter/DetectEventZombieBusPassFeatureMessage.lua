local DetectEventZombieBusPassFeatureMessage = BaseClass("DetectEventZombieBusPassFeatureMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, index)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    UIUtil.ShowTips(Localization:GetString(errorCode))
  else
    if message.reward then
      DataCenter.RewardManager:AddRewardsAndRes(message)
    end
    EventManager:GetInstance():Broadcast(EventId.DetectZombieBusTrainBattleDataGet, message)
    DataCenter.RadarCenterDataManager:SaveZombieBusReward(message.reward)
    EventManager:GetInstance():Broadcast(EventId.ParkourBattleReward, message.reward)
  end
end

DetectEventZombieBusPassFeatureMessage.OnCreate = OnCreate
DetectEventZombieBusPassFeatureMessage.HandleMessage = HandleMessage
return DetectEventZombieBusPassFeatureMessage
