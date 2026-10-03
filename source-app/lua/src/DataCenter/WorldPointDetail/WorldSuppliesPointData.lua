local WorldSuppliesPointData = BaseClass("WorldSuppliesPointData")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local WorldChargeData = require("DataCenter.WorldPointDetail.WorldChargeData")
local __BtnState = {
  CanGet = 0,
  AlreadyGet = 1,
  Limit = 2,
  Over = 3
}

function WorldSuppliesPointData:__init()
  self.uuid = 0
  self.configId = 0
  self.type = 0
  self.limit = 0
  self.totalLimit = 0
  self.state = 2
  self.iceDurability = 0
  self.meltingEndTime = 0
  self.expireTime = 0
  self.commonReward = {}
  self.luckyReward = {}
  self.redReward = {}
  self.obtainRewardPlayer = {}
  self.luckyRewardIndex = {}
  self.btnState = 0
  self.rewardCount = 0
  self.rewardMax = 0
  self.discovererInfo = nil
  self.chargeData = nil
  self.redRewardList = nil
  self.playerSuppliesRewardTimes = nil
end

function WorldSuppliesPointData:__delete()
  self.redRewardList = nil
  self.playerSuppliesRewardTimes = nil
end

function WorldSuppliesPointData:ParseData(message)
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.configId then
    self.configId = message.configId
    local config = LocalController:instance():getLine(TableName.LWIceSupplies, self.configId)
    if config.reward_lucky_num then
      for index, value in ipairs(config.reward_lucky_num) do
        self.luckyRewardIndex[value] = true
      end
    end
    self.type = config.type
    self.limit = config.limit
    self.totalLimit = config.total_limit
  end
  if message.state then
    self.state = message.state
  end
  if message.iceDurability then
    self.iceDurability = message.iceDurability
  end
  if message.meltingEndTime then
    self.meltingEndTime = message.meltingEndTime
  else
    self.meltingEndTime = 0
  end
  if message.commonReward then
    self.commonReward = DataCenter.RewardManager:ReturnRewardParamForView(message.commonReward)
  end
  if message.luckyReward then
    self.luckyReward = DataCenter.RewardManager:ReturnRewardParamForView(message.luckyReward)
  end
  if message.redReward then
    self.redReward = DataCenter.RewardManager:ReturnRewardParamForView(message.redReward)
  end
  if message.expire_time and 0 < message.expire_time then
    self.expireTime = message.expire_time
  else
    self.expireTime = 0
  end
  if message.newRewardMax and message.newRewardCount and 0 < message.newRewardMax then
    self.rewardMax = message.newRewardMax
    self.rewardLeftCount = message.newRewardCount
    self.rewardCount = message.newRewardMax - message.newRewardCount
  elseif message.user_reward_count then
    self.rewardCount = message.user_reward_count
    self.rewardLeftCount = nil
    self.rewardMax = DataCenter.SeasonSuppliesShareDataManager:GetCountLimit()
  end
  self.btnState = 0
  local count, playerTotal = 0, 0
  if (self.type == WorldSuppliesType.DarknessSeasonType or self.type == WorldSuppliesType.DarknessSeasonSmallType) and self:ParseDataCharge(message) then
    local indexDic = self.chargeData.indexDic
    if indexDic then
      local playerUid = LuaEntry.Player.uid
      for key, value in pairs(indexDic) do
        if value.getReward == 1 then
          playerTotal = playerTotal + 1
          if value.uid == playerUid then
            count = count + 1
          end
        end
      end
    end
  else
    if self.expireTime and 0 < self.expireTime then
      self.btnState = __BtnState.Over
    end
    if message.obtainRewardPlayer then
      self.obtainRewardPlayer = message.obtainRewardPlayer
      if 0 >= self.btnState then
        local playerUid = LuaEntry.Player.uid
        count = 0
        playerTotal = #self.obtainRewardPlayer
        for key, value in pairs(self.obtainRewardPlayer) do
          if value.uid == playerUid then
            count = count + 1
          end
        end
      end
    end
  end
  if count >= self.limit then
    self.btnState = __BtnState.AlreadyGet
  elseif playerTotal >= self.totalLimit then
    self.btnState = __BtnState.Over
  elseif self.type == WorldSuppliesType.ZoneMobilizationType or self.type == WorldSuppliesType.ZoneMobilizationSmallType then
    self.btnState = __BtnState.CanGet
  elseif self.rewardCount >= self.rewardMax then
    self.btnState = __BtnState.Limit
  end
  if message.discovererInfo then
    message.discovererInfo.pic = message.discovererInfo.headPic
    message.discovererInfo.picVer = message.discovererInfo.headPicVer
    self.discovererInfo = BasePlayerInfo.New()
    self.discovererInfo:ParseData(message.discovererInfo)
  end
  if message.suppliesRewardTimes then
    self.suppliesRewardTimes = message.suppliesRewardTimes
  end
  if message.playerSuppliesRewardTimes then
    self.playerSuppliesRewardTimes = message.playerSuppliesRewardTimes
  end
  if message.triggerName then
    self.triggerName = message.triggerName
  end
  if message.redRewardList then
    self.redRewardList = message.redRewardList
  end
end

function WorldSuppliesPointData:CheckBtnState()
  if self.btnState == __BtnState.CanGet then
    return true, ""
  end
  if self.btnState == __BtnState.AlreadyGet then
    return false, Localization:GetString("season_s2_ice_supplies_1")
  end
  if self.btnState == __BtnState.Limit then
    return false, Localization:GetString("season_s2_ice_supplies_9")
  end
  if self.btnState == __BtnState.Over then
    return false, Localization:GetString("season_s2_ice_supplies_9")
  end
end

function WorldSuppliesPointData:HasDiscoverer()
  if self.discovererInfo and self.discovererInfo.uid == LuaEntry.Player.uid then
    return true
  end
  return false
end

function WorldSuppliesPointData:HasPlayer(uid)
  uid = uid or LuaEntry.Player.uid
  if self.chargeData then
    return self.chargeData:HasPlayer(uid)
  end
  for key, value in pairs(self.obtainRewardPlayer) do
    if value.uid == uid then
      return true
    end
  end
  return false
end

function WorldSuppliesPointData:GetPlayerCount()
  if self.chargeData then
    return self.chargeData:GetPlayerCount()
  end
  return #self.obtainRewardPlayer
end

function WorldSuppliesPointData:GetPlayerByIndex(index)
  local playerInfo = self.chargeData and self.chargeData:GetPlayerByIndex(index)
  playerInfo = playerInfo or self.obtainRewardPlayer[index]
  return playerInfo
end

function WorldSuppliesPointData:ParseDataCharge(message)
  if message.indexArray or message.chargeStartTime or message.battery then
    self.chargeData = WorldChargeData.New()
    self.chargeData:ParseData(message)
    return true
  end
end

return WorldSuppliesPointData
