local S0AllianceBattleRecordInfo = BaseClass("S0AllianceBattleRecordInfo")
local S0AllianceRecordPlayerInfo = require("DataCenter.ActS0AllianceBoss.S0AllianceRecordPlayerInfo")

local function __init(self)
  self.difficultyLevel = 0
  self.difficultyStage = 0
  self.totalDamage = 0
  self.passCost = 0
  self.state = 0
  self.mvpInfo = nil
  self.topDamageInfo = nil
  self.maxAttackInfo = nil
end

local function __delete(self)
  self.difficultyLevel = nil
  self.difficultyStage = nil
  self.totalDamage = nil
  self.passCost = nil
  self.state = nil
  self.mvpInfo = nil
  self.topDamageInfo = nil
  self.maxAttackInfo = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  self.difficultyLevel = message.difficultyLevel or 0
  self.difficultyStage = message.difficultyStage or 0
  self.totalDamage = message.totalDamage or 0
  self.passCost = message.passCost or 0
  self.state = message.state or 0
  local mvpInfo = message.mvpInfo
  if table.IsNullOrEmpty(mvpInfo) then
    self.mvpInfo = nil
  else
    if self.mvpInfo == nil then
      self.mvpInfo = S0AllianceRecordPlayerInfo.New()
    end
    self.mvpInfo:ParseData(mvpInfo)
  end
  local topDamageInfo = message.topDamageInfo
  if table.IsNullOrEmpty(topDamageInfo) then
    self.topDamageInfo = nil
  else
    if self.topDamageInfo == nil then
      self.topDamageInfo = S0AllianceRecordPlayerInfo.New()
    end
    self.topDamageInfo:ParseData(topDamageInfo)
  end
  local maxAttackInfo = message.maxAttackInfo
  if table.IsNullOrEmpty(maxAttackInfo) then
    self.maxAttackInfo = nil
  else
    if self.maxAttackInfo == nil then
      self.maxAttackInfo = S0AllianceRecordPlayerInfo.New()
    end
    self.maxAttackInfo:ParseData(maxAttackInfo)
  end
end

S0AllianceBattleRecordInfo.__init = __init
S0AllianceBattleRecordInfo.__delete = __delete
S0AllianceBattleRecordInfo.ParseData = ParseData
return S0AllianceBattleRecordInfo
