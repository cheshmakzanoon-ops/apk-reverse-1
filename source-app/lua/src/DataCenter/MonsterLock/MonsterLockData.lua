local MonsterLockData = BaseClass("MonsterLockData")

local function __init(self)
  self.id = 0
end

local function __delete(self)
  self.id = nil
end

local function ParseData(self, row)
  if row == nil then
    return
  end
  if row.pveMonsterId ~= nil then
    self.monsterId = row.pveMonsterId
  end
  local template = DataCenter.MonsterLockTemplateManager:GetTemplate(self.monsterId)
  if row.reward ~= nil and row.reward > 0 then
    self.rewardRemain = template.rewardInitCount
  end
  if row.state ~= nil then
    self.state = row.state
  end
  if row.offsetX ~= nil then
    self.offsetX = row.offsetX
  end
  if row.offsetY ~= nil then
    self.offsetY = row.offsetY
  end
  if row.expireTime then
    self.expireTime = row.expireTime
  end
  if row.rewardInfo then
    self.rewardInfo = DataCenter.RewardManager:ReturnRewardParamForView(row.rewardInfo)
  end
  self:ReCalculatePointIndex()
  local _, count = template:GetCost()
  self.needPay = 0 < count
  self.rewardType = template.rewardModel
end

local function IsOverTime(self)
  if self.expireTime == nil or self.expireTime == 0 then
    return false
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now >= self.expireTime
end

local function ReCalculatePointIndex(self)
  local mainPos = DataCenter.BuildManager.main_city_pos
  local vec2 = CS.UnityEngine.Vector2Int(mainPos.x + tonumber(self.offsetX), mainPos.y + tonumber(self.offsetY))
  self.pointId = SceneUtils.TilePosToIndex(vec2)
end

MonsterLockData.__init = __init
MonsterLockData.__delete = __delete
MonsterLockData.ParseData = ParseData
MonsterLockData.IsOverTime = IsOverTime
MonsterLockData.ReCalculatePointIndex = ReCalculatePointIndex
return MonsterLockData
