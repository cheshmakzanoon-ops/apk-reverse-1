local CollectRewardData = BaseClass("CollectRewardData")

local function __init(self)
  self.uuid = 0
  self.expireTime = 0
  self.contentId = ""
  self.pointId = 0
  self.rewardList = {}
end

local function __delete(self)
  self.uuid = nil
  self.expireTime = nil
  self.contentId = nil
  self.pointId = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.expireTime ~= nil then
    self.expireTime = message.expireTime
  end
  if message.contentId ~= nil then
    self.contentId = message.contentId
  end
  if message.pointId ~= nil then
    self.pointId = message.pointId
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.reward ~= nil then
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
  end
  if message.showBaseResRate ~= nil then
    self.showBaseResRate = message.showBaseResRate
  end
  if message.plunderValue ~= nil then
    self.plunderValue = message.plunderValue
  end
  if message.serverId ~= nil then
    self.serverId = message.serverId
  end
  if message.worldId ~= nil then
    self.worldId = message.worldId
  end
  if message.targetUuid ~= nil then
    self.targetUuid = message.targetUuid
  end
end

CollectRewardData.__init = __init
CollectRewardData.__delete = __delete
CollectRewardData.ParseData = ParseData
return CollectRewardData
