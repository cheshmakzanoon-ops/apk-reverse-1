local LWFireworkGiftRecordInfo = BaseClass("LWFireworkGiftRecordInfo")
local LWFireworkGiftRecordPlayerInfo = require("DataCenter.LWFirework.LWFireworkGiftRecordPlayerInfo")

function LWFireworkGiftRecordInfo:__init()
  self:ResetData()
end

function LWFireworkGiftRecordInfo:__delete()
  self.remainNum = nil
  self.senderInfo = nil
  self.recordPlayerInfoList = nil
  self.rewardId = nil
  self.configId = nil
  self.uuid = nil
  self.ownerUid = nil
  self.wave = nil
end

function LWFireworkGiftRecordInfo:ResetData()
  self.remainNum = 0
  self.senderInfo = {}
  self.recordPlayerInfoList = {}
  self.rewardId = {}
  self.configId = nil
  self.uuid = nil
  self.ownerUid = nil
  self.wave = nil
end

function LWFireworkGiftRecordInfo:InitData(message)
  self:ResetData()
  if message.senderInfo then
    self.senderInfo = {}
    local senderInfoData = message.senderInfo
    if senderInfoData.uid then
      self.senderInfo.uid = senderInfoData.uid
    end
    if senderInfoData.name then
      self.senderInfo.name = senderInfoData.name
    end
    if senderInfoData.pic then
      self.senderInfo.pic = senderInfoData.pic
    end
    if senderInfoData.picVer then
      self.senderInfo.picVer = senderInfoData.picVer
    end
    if senderInfoData.headSkinId then
      self.senderInfo.headSkinId = senderInfoData.headSkinId
    end
    if senderInfoData.headSkinET then
      self.senderInfo.headSkinET = senderInfoData.headSkinET
    end
  end
  if message.recordList then
    self.recordPlayerInfoList = {}
    local list = message.recordList
    for i, v in pairs(list) do
      local infoData = LWFireworkGiftRecordPlayerInfo.New()
      infoData:InitData(v)
      table.insert(self.recordPlayerInfoList, infoData)
    end
  end
  if message.rewardId then
    self.rewardId = message.rewardId
  end
  if message.configId then
    self.configId = message.configId
  end
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.ownerUid then
    self.ownerUid = message.ownerUid
  end
  if message.wave then
    self.wave = message.wave
  end
end

function LWFireworkGiftRecordInfo:GetSelfClaimState()
  local count = table.count(self.recordPlayerInfoList)
  for i = 1, count do
    local detectEventTreasureClaimPlayerInfo = self.recordPlayerInfoList[i]
    if detectEventTreasureClaimPlayerInfo.uid == LuaEntry.Player:GetUid() then
      if detectEventTreasureClaimPlayerInfo.isDouble then
        return DetectEventTreasureClaimState.DoubleClaim
      else
        return DetectEventTreasureClaimState.NormalClaim
      end
    end
  end
  return DetectEventTreasureClaimState.NoClaim
end

function LWFireworkGiftRecordInfo:GetRemainNum()
  local rewardStr = GetTableData(TableName.Firework, self.configId, "reward", "")
  local rewardArray = string.split(rewardStr, "|")
  if self.wave and rewardArray and #rewardArray > self.wave then
    local reward = rewardArray[self.wave + 1]
    local rewardDetail = string.split(reward, ";")
    if rewardDetail and 3 <= #rewardDetail then
      local maxNum = tonumber(rewardDetail[3])
      if maxNum and 0 < maxNum then
        return maxNum - #self.recordPlayerInfoList
      end
    end
  end
  return 0
end

return LWFireworkGiftRecordInfo
