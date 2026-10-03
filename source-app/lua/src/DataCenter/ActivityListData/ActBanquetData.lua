local ActBanquetData = BaseClass("ActBanquetData")
local ActivityFreeRewardData = require("DataCenter.ActivityFreeRewardData.ActivityFreeRewardData")

local function __init(self)
  self.activityId = 0
  self.actBanquetId = 0
  self.banquetLevel = 0
  self.score = 0
  self.contribution = 0
  self.levelReward = {}
  self.receiveReward = {}
  self.activityFreeRewardData = ActivityFreeRewardData.New()
  self.selfRank = {}
  self.selfAllyRank = {}
  self.personRankList = {}
  self.allyRankList = {}
  self.selfRankReward = -1
  self.selfAllyRankReward = -1
  self.personRankReward = {}
  self.allyRankReward = {}
  self.actBanquetTemplate = {}
end

local function __delete(self)
  self.activityId = nil
  self.actBanquetId = nil
  self.banquetLevel = nil
  self.score = nil
  self.contribution = nil
  self.levelReward = nil
  self.receiveReward = nil
  self.activityFreeRewardData = nil
  self.selfRank = nil
  self.selfAllyRank = nil
  self.personRankList = nil
  self.allyRankList = nil
  self.selfRankReward = nil
  self.selfAllyRankReward = nil
  self.personRankReward = nil
  self.allyRankReward = nil
  self.actBanquetTemplate = nil
end

local function ParseInfo(self, message)
  if message == nil then
    return
  end
  if message.id then
    self.actBanquetId = message.id
    self.actBanquetTemplate = DataCenter.ActivityPartyTemplateManager:GetActBanquetTemplate(self.actBanquetId)
  end
  if message.score then
    self.score = message.score
  end
  if message.level then
    self.banquetLevel = message.level
  end
  table.clear(self.levelReward)
  if message.level_reward then
    for i = 1, table.count(message.level_reward) do
      table.insert(self.levelReward, message.level_reward[i].rewards)
    end
  end
  table.clear(self.receiveReward)
  if message.levels then
    local strArray = string.split(message.levels, ",")
    if not string.IsNullOrEmpty(strArray) then
      for i = 1, table.count(strArray) do
        table.insert(self.receiveReward, tonumber(strArray[i]))
      end
    end
  end
  self.activityFreeRewardData:ParseData(message)
end

local function SetActivityId(self, id)
  self.activityId = tonumber(id)
end

local function GetActScore(self)
  return self.score
end

local function GetCurBanquetLevel(self)
  return self.banquetLevel
end

local function GetBanquetMaxLevel(self)
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.level_max
  end
end

local function GetBanquetAddScore(self)
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.add_score
  end
end

local function GetBanquetAddGoodId(self)
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.add_good_id
  end
end

local function GetBanquetAddGoodNum(self)
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.add_good_num
  end
end

local function GetBanquetDonateItemId(self)
  if self.actBanquetTemplate then
    return self.actBanquetTemplate.donate_item_id
  end
end

local function GetActNextTargetScore(self)
  if self.actBanquetTemplate and not table.IsNullOrEmpty(self.actBanquetTemplate) then
    return self.actBanquetTemplate.level_dic[self.banquetLevel + 1]
  end
end

local function GetActScoreList(self)
  local ret = {}
  if self.actBanquetTemplate then
    for i = 1, self.actBanquetTemplate.level_max do
      local oneData = {}
      oneData.selfLevel = self.banquetLevel
      oneData.targetScore = self.actBanquetTemplate.level_dic[i]
      oneData.targetLevel = i
      oneData.state = table.hasvalue(self.receiveReward, i) and 1 or 0
      oneData.reward = self.levelReward[i]
      table.insert(ret, oneData)
    end
  end
  return ret
end

local function CanGotoPackShop(self)
  return self.activityFreeRewardData:CanGotoPackShop()
end

local function CanGetFreePack(self)
  return false
end

local function GetGiftPackId(self)
  return self.activityFreeRewardData:GetGiftPackId()
end

local function GetDonateHandle(self, message)
  if message == nil or message.id ~= self.actBanquetId or message.aid ~= self.activityId then
    return
  end
  if message.score then
    self.score = self.score + message.score
  end
  if message.contribution then
    self.contribution = message.contribution
  end
  if message.level then
    self.banquetLevel = message.level
  end
  local rewards = message.add_goods
  if rewards then
    DataCenter.RewardManager:AddRewards(rewards)
  end
  EventManager:GetInstance():Broadcast(EventId.OnBanquetDonate, message.add_goods)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetRankRewardHandle(self, message)
  if message == nil or message.id ~= self.actBanquetId then
    return
  end
  if message.type then
    local type = message.type
    if type == 0 then
      if message.self_rank then
        self.selfRankReward = message.self_rank
      end
      table.clear(self.personRankReward)
      if message.rewards then
        for i = 1, table.count(message.rewards) do
          local key = message.rewards[i].key
          local str = string.split(key, "-")
          if 1 < #str then
            local oneData = {}
            oneData.startN = tonumber(str[1])
            oneData.endN = tonumber(str[2])
            oneData.reward = message.rewards[i].rewards
            table.insert(self.personRankReward, oneData)
          end
        end
      end
    elseif type == 1 then
      if message.self_rank then
        self.selfAllyRankReward = message.self_rank
      end
      table.clear(self.allyRankReward)
      if message.rewards then
        for i = 1, table.count(message.rewards) do
          local key = message.rewards[i].key
          local str = string.split(key, "-")
          if 1 < #str then
            local oneData = {}
            oneData.startN = tonumber(str[1])
            oneData.endN = tonumber(str[2])
            oneData.reward = message.rewards[i].rewards
            table.insert(self.allyRankReward, oneData)
          end
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActBanquetRankRewardUpdate)
end

local function ParseRankingData(self, message)
  if not message or self.actBanquetId ~= message.id then
    return
  end
  local type = message.type
  local playerRankingInfoMsg = message.self
  if playerRankingInfoMsg then
    local selfPlayerData = BasePlayerInfo.New()
    selfPlayerData:ParseData(playerRankingInfoMsg)
    selfPlayerData.score = playerRankingInfoMsg.score
    selfPlayerData.ranking = playerRankingInfoMsg.rank
    if type == BanquetRankType.Personal then
      self.selfRank = selfPlayerData
    elseif type == BanquetRankType.Ally then
      self.selfAllyRank = selfPlayerData
    end
  end
  local rankingList = message.ranks
  if rankingList then
    for _, v in pairs(rankingList) do
      local playerData = BasePlayerInfo.New()
      playerData:ParseData(v)
      playerData.score = v.score
      playerData.ranking = v.rank
      if type == BanquetRankType.Personal then
        playerData.picVer = v.picver
        self.personRankList[playerData.ranking] = playerData
      elseif type == BanquetRankType.Ally then
        playerData.icon = v.icon
        playerData.aid = v.aid
        playerData.name = v.name
        self.allyRankList[playerData.ranking] = playerData
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActBanquetRankUpdate)
end

local function GetFreeRewardHandle(self, message)
  if message == nil then
    return
  end
  local rewards = message.rewards
  if rewards then
    DataCenter.RewardManager:AddRewards(rewards)
    DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  end
  self.activityFreeRewardData:OnReceiveFreeReward()
  EventManager:GetInstance():Broadcast(EventId.ActFreeRewardReceive)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetLevelRewardHandle(self, message)
  if message == nil then
    return
  end
  local rewards = message.rewards
  if rewards then
    DataCenter.RewardManager:AddRewards(rewards)
    DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  end
  table.clear(self.receiveReward)
  if message.levels then
    local strArray = string.split(message.levels, ",")
    if not string.IsNullOrEmpty(strArray) then
      for i = 1, table.count(strArray) do
        table.insert(self.receiveReward, tonumber(strArray[i]))
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActBanquetScoreRewardReceive)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetActRed(self, id)
  local ret = 0
  local tipNum = 0
  local donateItemId = self:GetBanquetDonateItemId()
  if donateItemId then
    local haveCount = DataCenter.ItemData:GetItemCount(donateItemId)
    local onceDonateNum = DataCenter.ActBanquetData.actBanquetTemplate.unit_num or 1
    if haveCount >= onceDonateNum then
      local donateNum = math.floor(haveCount / onceDonateNum)
      tipNum = tipNum + donateNum
    end
  end
  if self:CanGetFreePack() then
    ret = ret + 1
  end
  ret = ret + self:GetCanGetScoreBoxCount()
  if 0 < ret then
    return 1, 1, 0
  end
  if 0 < tipNum then
    return 1, 0, 1
  end
  return 0, 0, 0
end

local function GetRewardArr(self, type)
  if type == BanquetRankType.Personal then
    return self.personRankReward
  elseif type == BanquetRankType.Ally then
    return self.allyRankReward
  end
end

local function GetRankArr(self, type)
  if type == BanquetRankType.Personal then
    return self.personRankList
  elseif type == BanquetRankType.Ally then
    return self.allyRankList
  end
end

local function IsRankRewardDataReach(self)
  return self.selfRankReward ~= -1
end

local function IsAllianceRankRewardDataReach(self)
  return self.selfAllyRankReward ~= -1
end

local function IsRankDataReach(self)
  return not table.IsNullOrEmpty(self.selfRank)
end

local function GetCanGetScoreBoxCount(self)
  local ret = 0
  for k, v in ipairs(self.levelReward) do
    if k <= self.banquetLevel and not table.hasvalue(self.receiveReward, k) then
      ret = ret + 1
    end
  end
  return ret
end

ActBanquetData.__init = __init
ActBanquetData.__delete = __delete
ActBanquetData.ParseInfo = ParseInfo
ActBanquetData.GetActScore = GetActScore
ActBanquetData.GetActNextTargetScore = GetActNextTargetScore
ActBanquetData.GetActScoreList = GetActScoreList
ActBanquetData.CanGotoPackShop = CanGotoPackShop
ActBanquetData.CanGetFreePack = CanGetFreePack
ActBanquetData.GetGiftPackId = GetGiftPackId
ActBanquetData.GetFreeRewardHandle = GetFreeRewardHandle
ActBanquetData.ParseRankingData = ParseRankingData
ActBanquetData.SetActivityId = SetActivityId
ActBanquetData.GetActRed = GetActRed
ActBanquetData.GetBanquetMaxLevel = GetBanquetMaxLevel
ActBanquetData.GetCurBanquetLevel = GetCurBanquetLevel
ActBanquetData.GetDonateHandle = GetDonateHandle
ActBanquetData.GetRankRewardHandle = GetRankRewardHandle
ActBanquetData.GetLevelRewardHandle = GetLevelRewardHandle
ActBanquetData.GetRewardArr = GetRewardArr
ActBanquetData.GetRankArr = GetRankArr
ActBanquetData.IsRankRewardDataReach = IsRankRewardDataReach
ActBanquetData.IsAllianceRankRewardDataReach = IsAllianceRankRewardDataReach
ActBanquetData.IsRankDataReach = IsRankDataReach
ActBanquetData.GetBanquetAddScore = GetBanquetAddScore
ActBanquetData.GetBanquetAddGoodId = GetBanquetAddGoodId
ActBanquetData.GetBanquetAddGoodNum = GetBanquetAddGoodNum
ActBanquetData.GetBanquetDonateItemId = GetBanquetDonateItemId
ActBanquetData.GetCanGetScoreBoxCount = GetCanGetScoreBoxCount
return ActBanquetData
