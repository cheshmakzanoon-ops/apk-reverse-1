local base = AllianceMemberInfo
local AllianceSeasonRewardMember = BaseClass("AllianceSeasonRewardMember", base)

local function __init(self)
  base.__init(self)
  self.rewardIndex = 0
  self.rewardNum = 0
  self.settlementRewardState = 0
  self.rankInfo = {}
  self.seasonRole = 0
end

local function __delete(self)
  self.rewardIndex = nil
  self.rewardNum = nil
  self.rankInfo = {}
  self.settlementRewardState = nil
  base.__delete(self)
end

local function ParseData(self, message)
  base.ParseData(self, message)
  if message.settlement then
    local settlement = message.settlement
    if settlement.settlement_reward_type and settlement.settlement_reward_num then
      self.rewardIndex = settlement.settlement_reward_type
      self.rewardNum = settlement.settlement_reward_num
    else
      self.rewardIndex = 0
      self.rewardNum = 0
    end
    if settlement.settlement_reward_state then
      self.settlementRewardState = settlement.settlement_reward_state
    else
      self.settlementRewardState = 0
    end
  else
    self.rewardIndex = 0
    self.rewardNum = 0
    self.settlementRewardState = 0
  end
  if message.seasonRole then
    self.seasonRole = message.seasonRole
  else
    self.seasonRole = 0
  end
end

local function ParseRankData(self, message)
  if message.rank_info then
    for key, value in pairs(message.rank_info) do
      local eventI = value.event_id
      local rank = value.rank
      if eventI and rank then
        self.rankInfo[eventI] = rank
      end
    end
  end
end

local function SetRewardType(self, type)
  if type then
    self.rewardIndex = type
    self.rewardNum = 1
  else
    self.rewardIndex = 0
    self.rewardNum = 0
  end
end

local function GetRankData(self, eventId)
  if self.rankInfo[eventId] then
    return self.rankInfo[eventId]
  end
  return 0
end

local function IsAlreadyGetReward(self)
  return self.settlementRewardState == 1
end

AllianceSeasonRewardMember.__init = __init
AllianceSeasonRewardMember.__delete = __delete
AllianceSeasonRewardMember.ParseData = ParseData
AllianceSeasonRewardMember.ParseRankData = ParseRankData
AllianceSeasonRewardMember.GetRankData = GetRankData
AllianceSeasonRewardMember.SetRewardType = SetRewardType
AllianceSeasonRewardMember.IsAlreadyGetReward = IsAlreadyGetReward
return AllianceSeasonRewardMember
