local AttackTrainMessage = BaseClass("AttackTrainMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, trainUuid, heroArray, trainServerId, chipSetId, squadNo)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", trainUuid)
  self.sfsObj:PutInt("serverId", trainServerId)
  self.sfsObj:PutInt("squadNo", squadNo)
  self.sfsObj:PutSFSArray("heroInfo", heroArray)
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    if message.errorCode == "E400207" then
      DataCenter.LWBattleManager:Exit()
    end
  else
    EventManager:GetInstance():Broadcast(EventId.TrainSkirmishDataReceived, message)
    if message.reward then
      DataCenter.RewardManager:AddRewardsAndRes(message)
    end
    if message.dailyRobCount then
      DataCenter.LWMyStationDataManager:OnRob(message)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.TrainAttackReceived)
end

AttackTrainMessage.OnCreate = OnCreate
AttackTrainMessage.HandleMessage = HandleMessage
return AttackTrainMessage
