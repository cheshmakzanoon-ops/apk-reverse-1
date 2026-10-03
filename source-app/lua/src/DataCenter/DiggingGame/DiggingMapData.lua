local DiggingMapData = BaseClass("DiggingMapData")

function DiggingMapData:__init()
  self.type = 0
  self.uuid = 0
  self.uid = ""
  self.mapConfigId = 0
  self.blockInfo = {}
  self.personalOpenInfo = {}
  self.allianceOpenInfo = {}
  self.brickDic = {}
  self.rewardState = 0
  self.helpInfo = {}
  self.shardTime = 0
  self.helpNum = 0
  self.endTime = 0
end

function DiggingMapData:__delete()
  self.type = nil
  self.uuid = nil
  self.uid = nil
  self.mapConfigId = nil
  self.blockInfo = nil
  self.personalOpenInfo = nil
  self.allianceOpenInfo = nil
  self.rewardState = nil
  self.helpInfo = nil
  self.shardTime = nil
  self.helpNum = nil
  self.endTime = nil
end

function DiggingMapData:UpdateData(message)
  if message == nil then
    return
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.mapConfigId ~= nil then
    self.mapConfigId = message.mapConfigId
  end
  self.brickDic = {}
  self.brickDicCheck = {}
  if message.personalOpenInfo ~= nil then
    self.personalOpenInfo = message.personalOpenInfo
    if self.personalOpenInfo then
      for i, v in ipairs(self.personalOpenInfo) do
        self.brickDic[v] = {pos = v}
      end
    end
  elseif message.openInfo ~= nil then
    self.personalOpenInfo = message.openInfo
    if self.personalOpenInfo then
      for i, v in ipairs(self.personalOpenInfo) do
        self.brickDic[v] = {pos = v}
        self.brickDicCheck[v] = true
      end
    end
  end
  if message.allianceOpenInfo ~= nil then
    self.allianceOpenInfo = message.allianceOpenInfo
    if self.allianceOpenInfo then
      for i, v in ipairs(self.allianceOpenInfo) do
        self.brickDic[v.pos] = v
      end
    end
  end
  if message.blockInfo ~= nil then
    self.blockInfo = message.blockInfo
    local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(self.mapConfigId)
    if levelConfig then
      for i, v in ipairs(self.blockInfo) do
        if v.pos then
          local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(v.bid)
          v.get = config and DataCenter.DiggingDataManager:CheckBlockGet(v.pos, self.brickDic, levelConfig.num_width, config.size_width, config.size_height)
        end
      end
      for i, v in pairs(self.brickDic) do
        if v.playerInfo then
          local blockInfo = DataCenter.DiggingDataManager:GetBlockByPos(v.pos, self.blockInfo, levelConfig.num_width)
          if blockInfo then
            v.blockInfo = blockInfo
          end
        end
      end
    end
  end
  if message.rewardState ~= nil then
    self.rewardState = message.rewardState
  end
  if message.helpInfo ~= nil then
    self.helpInfo = message.helpInfo
  end
  if message.shardTime ~= nil then
    self.shardTime = message.shardTime
  end
  if message.helpNum ~= nil then
    self.helpNum = message.helpNum
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
end

return DiggingMapData
