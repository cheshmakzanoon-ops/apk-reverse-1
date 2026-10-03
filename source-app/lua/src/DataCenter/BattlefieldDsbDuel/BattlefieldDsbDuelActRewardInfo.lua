local BattlefieldDsbDuelActRewardInfo = BaseClass("BattlefieldDsbDuelActRewardInfo")

local function __init(self)
  self.id = 0
  self.state0 = 0
  self.state1 = 0
  self.state1Num = 0
end

local function __delete(self)
  self.id = 0
  self.state0 = 0
  self.state1 = 0
  self.state1Num = 0
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.id ~= nil then
    self.id = message.id
  end
  if message.state0 ~= nil then
    self.state0 = message.state0
  end
  if message.state1 ~= nil then
    self.state1 = message.state1
  end
  if message.state1Num ~= nil then
    self.state1Num = message.state1Num
  end
end

local function GetReceiveState(self, isAllianceReward)
  return isAllianceReward and self.state0 or self.state1
end

local function HasRewardToReceive(self, isAllianceReward)
  local template = BattlefieldDsbDuelUtils.ActTemplateInfo:GetLWDsbLeagueRankRewardTemplate(self.id)
  local hasZoneReward
  if template then
    hasZoneReward = not table.IsNullOrEmpty(template:GetZoneRankRewardList())
  end
  if isAllianceReward == nil then
    return self.state0 == BattlefieldDsbConst.BF_DSB_REWARD_STATE.CanReceive or hasZoneReward and self.state1 == BattlefieldDsbConst.BF_DSB_REWARD_STATE.CanReceive
  elseif isAllianceReward then
    return self.state0 == BattlefieldDsbConst.BF_DSB_REWARD_STATE.CanReceive
  else
    return hasZoneReward and self.state1 == BattlefieldDsbConst.BF_DSB_REWARD_STATE.CanReceive
  end
end

local function GetZoneRewardCount(self)
  return self.state1Num
end

BattlefieldDsbDuelActRewardInfo.__init = __init
BattlefieldDsbDuelActRewardInfo.__delete = __delete
BattlefieldDsbDuelActRewardInfo.ParseData = ParseData
BattlefieldDsbDuelActRewardInfo.GetReceiveState = GetReceiveState
BattlefieldDsbDuelActRewardInfo.GetZoneRewardCount = GetZoneRewardCount
BattlefieldDsbDuelActRewardInfo.HasRewardToReceive = HasRewardToReceive
return BattlefieldDsbDuelActRewardInfo
