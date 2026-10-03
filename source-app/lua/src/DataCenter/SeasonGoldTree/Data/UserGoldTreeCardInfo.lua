local UserGoldTreeCardInfo = BaseClass("UserGoldTreeCardInfo")

function UserGoldTreeCardInfo:__init(msg)
  self:RefreshData(msg)
end

function UserGoldTreeCardInfo:__delete()
  self.uuid = nil
  self.uid = nil
  self.day = nil
  self.cardId = nil
  self.multiplierId = nil
  self.targetUuid = nil
  self.rewardRecord = nil
end

function UserGoldTreeCardInfo:RefreshData(msg)
  self.uuid = msg.uuid
  self.uid = msg.uid
  self.day = msg.day
  self.cardId = msg.cardId
  self.multiplierId = msg.multiplierId
  self.targetUuid = msg.targetUuid
  self.rewardRecord = msg.rewardRecord
end

function UserGoldTreeCardInfo:GetFirstReward()
  if self.rewardRecord and #self.rewardRecord > 0 then
    if not self.rewardRecordList then
      self.rewardRecordList = DataCenter.RewardManager:ReturnRewardParamForMessage(self.rewardRecord)
    end
    return self.rewardRecordList and self.rewardRecordList[1]
  end
  return nil
end

return UserGoldTreeCardInfo
