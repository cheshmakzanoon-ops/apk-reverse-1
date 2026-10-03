local PveActData = BaseClass("PveActData")

local function __init(self, actId)
  self.actId = actId
  self.tasks = {}
  self.stages = {}
  self.pveInfo = {}
  self.score = 0
  self.exp = 0
  self.hasRank = false
end

local function __delete(self)
  self.actId = nil
  self.tasks = nil
  self.stages = nil
  self.pveInfo = nil
  self.score = nil
  self.exp = nil
  self.hasRank = nil
end

PveActData.__init = __init
PveActData.__delete = __delete
return PveActData
