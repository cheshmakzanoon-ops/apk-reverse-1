local SeasonLootZoneTrainMessage = BaseClass("SeasonLootZoneTrainMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonLootZoneTrainMessage:OnCreate(playerUid, heroInfo, chipSetId, squadNo)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("lootUid", playerUid)
  self.sfsObj:PutSFSArray("heroInfo", heroInfo)
  if chipSetId and 0 < chipSetId and chipSetId <= 4 then
    self.sfsObj:PutInt("chipEquipGroup", chipSetId)
  end
  self.sfsObj:PutInt("squadNo", squadNo)
end

function SeasonLootZoneTrainMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.TrainSkirmishDataReceived, message)
    if message.reward then
      DataCenter.RewardManager:AddRewardsAndRes(message)
    end
    if message.lootTimes then
      DataCenter.HSRDataManager:SetRobCount(message.lootTimes)
    end
    DataCenter.HSRDataManager:SetDailyLootNum(message.dailyLootNum)
  end
  EventManager:GetInstance():Broadcast(EventId.TrainAttackReceived)
end

return SeasonLootZoneTrainMessage
