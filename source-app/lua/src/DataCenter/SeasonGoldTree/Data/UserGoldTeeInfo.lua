local UserGoldTeeInfo = BaseClass("UserGoldTeeInfo")

function UserGoldTeeInfo:__init(msg)
  self:RefreshData(msg)
end

function UserGoldTeeInfo:__delete()
  self.uuid = nil
  self.uid = nil
  self.weekTime = nil
  self.goldTreeConfigId = nil
  self.seasonFirstFinishPowerTime = nil
  self.combinationId = nil
  self.settle = nil
  self.startTime = nil
  self.endTime = nil
  self.lotteryHideName = nil
  self.lotteryAllianceId = nil
  self.lotteryStageArr = nil
  self.lotteryCardArr = nil
  self.lotteryCombinationId = nil
end

function UserGoldTeeInfo:RefreshData(msg)
  self.uuid = msg.uuid
  self.uid = msg.uid
  self.weekTime = msg.weekTime
  self.goldTreeConfigId = msg.goldTreeConfigId
  self.seasonFirstFinishPowerTime = msg.seasonFirstFinishPowerTime
  self.combinationId = msg.combinationId
  self.settle = msg.settle
  self.startTime = msg.startTime
  self.endTime = msg.endTime
  self.lotteryHideName = msg.lotteryHideName
  self.lotteryAllianceId = msg.lotteryAllianceId
  self.lotteryStageArr = msg.lotteryStageArr
  self.lotteryCardArr = msg.lotteryCardArr
  self.lotteryCombinationId = msg.lotteryCombinationId
end

return UserGoldTeeInfo
