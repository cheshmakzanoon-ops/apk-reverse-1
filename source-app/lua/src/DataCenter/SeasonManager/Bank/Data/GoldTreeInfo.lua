local GoldTreeInfo = BaseClass("GoldTreeInfo")

function GoldTreeInfo:__init(msg)
  self:RefreshData(msg)
end

function GoldTreeInfo:__delete()
  self.uuid = nil
  self.serverId = nil
  self.pointId = nil
  self.worldId = nil
  self.treeId = nil
  self.refreshTime = nil
  self.startTime = nil
  self.endTime = nil
  self.power = nil
  self.finishTime = nil
end

function GoldTreeInfo:RefreshData(msg)
  self.uuid = msg.uuid
  self.serverId = msg.serverId
  self.pointId = msg.pointId
  self.worldId = msg.worldId
  self.treeId = msg.treeId
  self.refreshTime = msg.refreshTime
  self.startTime = msg.startTime
  self.endTime = msg.endTime
  self.power = msg.power
  self.finishTime = msg.finishTime
end

function GoldTreeInfo:OnPowerFinish(msg)
  if self.uuid ~= msg.uuid or msg.treeId ~= self.treeId or msg.serverId ~= self.serverId then
    return
  end
  self.finishTime = msg.finishTime
end

function GoldTreeInfo:IsCharge()
  if not self.finishTime or self.finishTime <= 0 then
    return true
  end
  return UITimeManager:GetInstance():GetServerTime() < self.finishTime
end

return GoldTreeInfo
