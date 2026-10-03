local DetectEventGetTreasureClaimInfo = BaseClass("DetectEventGetTreasureClaimInfo")
local DetectEventTreasureClaimPlayerInfo = require("DataCenter.RadarCenterDataManager.DetectEventTreasureClaimPlayerInfo")

function DetectEventGetTreasureClaimInfo:__init()
  self:ResetData()
end

function DetectEventGetTreasureClaimInfo:__delete()
  self.eventId = nil
  self.remainNum = nil
  self.pointId = nil
  self.ownerInfo = nil
  self.treasureClaimPlayerInfoList = nil
  self.rewardList = nil
  self.createTime = nil
  self.targetServer = nil
end

function DetectEventGetTreasureClaimInfo:ResetData()
  self.eventId = 0
  self.remainNum = 0
  self.pointId = 0
  self.ownerInfo = {}
  self.treasureClaimPlayerInfoList = {}
  self.rewardList = {}
  self.createTime = 0
  self.targetServer = 0
end

function DetectEventGetTreasureClaimInfo:InitData(message)
  self:ResetData()
  if message.cfgId then
    self.eventId = message.cfgId
  end
  if message.num then
    self.remainNum = message.num
  end
  if message.pointId then
    self.pointId = message.pointId
  end
  if message.ownerInfo then
    self.ownerInfo = {}
    local ownerInfoData = message.ownerInfo
    if ownerInfoData.uid then
      self.ownerInfo.uid = ownerInfoData.uid
    end
    if ownerInfoData.name then
      self.ownerInfo.name = ownerInfoData.name
    end
    if ownerInfoData.headPic then
      self.ownerInfo.headPic = ownerInfoData.headPic
    end
    if ownerInfoData.headPicVer then
      self.ownerInfo.headPicVer = ownerInfoData.headPicVer
    end
    if ownerInfoData.headSkinId then
      self.ownerInfo.headSkinId = ownerInfoData.headSkinId
    end
    if ownerInfoData.headSkinET then
      self.ownerInfo.headSkinET = ownerInfoData.headSkinET
    end
  end
  if message.array then
    self.treasureClaimPlayerInfoList = {}
    local list = message.array
    for i, v in pairs(list) do
      local infoData = DetectEventTreasureClaimPlayerInfo.New()
      infoData:InitData(v)
      table.insert(self.treasureClaimPlayerInfoList, infoData)
    end
  end
  if message.reward then
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward)
  end
  if message.createTime then
    self.createTime = message.createTime
  end
  if message.targetServer then
    self.targetServer = message.targetServer
  end
end

function DetectEventGetTreasureClaimInfo:GetSelfClaimState()
  local count = table.count(self.treasureClaimPlayerInfoList)
  for i = 1, count do
    local detectEventTreasureClaimPlayerInfo = self.treasureClaimPlayerInfoList[i]
    if detectEventTreasureClaimPlayerInfo.uid == LuaEntry.Player:GetUid() then
      if detectEventTreasureClaimPlayerInfo.isBigReward then
        return DetectEventTreasureClaimState.DoubleClaim
      else
        return DetectEventTreasureClaimState.NormalClaim
      end
    end
  end
  return DetectEventTreasureClaimState.NoClaim
end

function DetectEventGetTreasureClaimInfo:GetSelfBigRewardMultiple()
  local count = table.count(self.treasureClaimPlayerInfoList)
  for i = 1, count do
    local detectEventTreasureClaimPlayerInfo = self.treasureClaimPlayerInfoList[i]
    if detectEventTreasureClaimPlayerInfo.uid == LuaEntry.Player:GetUid() and detectEventTreasureClaimPlayerInfo.isBigReward then
      return detectEventTreasureClaimPlayerInfo.bigRewardMultiple or 2
    end
  end
end

function DetectEventGetTreasureClaimInfo:GetSelfIsTriggerLuckyBuff()
  local count = table.count(self.treasureClaimPlayerInfoList)
  for i = 1, count do
    local detectEventTreasureClaimPlayerInfo = self.treasureClaimPlayerInfoList[i]
    if detectEventTreasureClaimPlayerInfo.uid == LuaEntry.Player:GetUid() and detectEventTreasureClaimPlayerInfo.hasLuckSiphonbuff == true then
      return true
    end
  end
  return false
end

function DetectEventGetTreasureClaimInfo:GetSelfLuckyBuffMultiple()
  local count = table.count(self.treasureClaimPlayerInfoList)
  for i = 1, count do
    local detectEventTreasureClaimPlayerInfo = self.treasureClaimPlayerInfoList[i]
    if detectEventTreasureClaimPlayerInfo.uid == LuaEntry.Player:GetUid() and detectEventTreasureClaimPlayerInfo.hasLuckSiphonbuff == true then
      return detectEventTreasureClaimPlayerInfo.bigRewardMultiple or 2
    end
  end
  return 0
end

return DetectEventGetTreasureClaimInfo
