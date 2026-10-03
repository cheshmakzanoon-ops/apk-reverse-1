local ActBossRankData = BaseClass("ActBossRankData")

local function __init(self)
  self.uid = ""
  self.rank = -1
  self.score = 0
  self.unit = nil
end

local function __delete(self)
  self.uid = nil
  self.rank = nil
  self.score = nil
  self.unit = nil
end

local function ParseData(self, rank, score, unit, uid)
  if rank ~= nil then
    self.rank = rank
  end
  if score ~= nil then
    self.score = score
  end
  if unit ~= nil then
    self.unit = PBController.ParsePb1(unit, "protobuf.ArmyUnitInfo")
  end
  self.uid = uid
end

ActBossRankData.__init = __init
ActBossRankData.__delete = __delete
ActBossRankData.ParseData = ParseData
return ActBossRankData
