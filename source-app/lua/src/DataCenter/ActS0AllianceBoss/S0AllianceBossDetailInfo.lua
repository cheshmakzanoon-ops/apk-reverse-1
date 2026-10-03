local S0AllianceBossDetailInfo = BaseClass("S0AllianceBossDetailInfo")

local function __init(self)
  self.allianceId = ""
  self.startTime = 0
  self.battleStartTime = 0
  self.battleEndTime = 0
  self.difficulty = 0
  self.damage = 0
  self.bonus = 0
  self.lv = 0
  self.maxDamage = 0
  self.reward = nil
  self.mvp = nil
end

local function __delete(self)
  self.allianceId = nil
  self.name = nil
  self.battleStartTime = nil
  self.battleEndTime = nil
  self.difficulty = nil
  self.damage = nil
  self.bonus = nil
  self.lv = nil
  self.maxDamage = nil
  self.reward = nil
  self.mvp = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId or ""
  end
  if message.name ~= nil then
    self.name = message.name or ""
  end
  if message.battleStartTime ~= nil then
    self.battleStartTime = message.battleStartTime or 0
  end
  if message.battleEndTime ~= nil then
    self.battleEndTime = message.battleEndTime or 0
  end
  if message.difficulty ~= nil then
    self.difficulty = message.difficulty or 0
  end
  if message.damage ~= nil then
    self.damage = message.damage or 0
  end
  if message.bonus ~= nil then
    self.bonus = message.bonus or 0
  end
  if message.lv ~= nil then
    self.lv = message.lv or 0
  end
  if message.maxDamage ~= nil then
    self.maxDamage = message.maxDamage or 0
  end
  if message.reward ~= nil then
    self.reward = message.reward or {}
  end
  if message.mvp ~= nil then
    self.mvp = message.mvp or {}
  end
end

S0AllianceBossDetailInfo.__init = __init
S0AllianceBossDetailInfo.__delete = __delete
S0AllianceBossDetailInfo.ParseData = ParseData
return S0AllianceBossDetailInfo
