local MonsterInvasionData = BaseClass("MonsterInvasionData")

local function __init(self)
  self.id = 0
  self.startTime = 0
  self.endTime = 0
  self.fightTime = 0
  self.activityType = 0
  self.stage = 0
  self.reward = nil
  self.aliMonsters = nil
  self.selfMonsters = nil
  self.selfMonsters = nil
  self.oldMonsters = nil
  self.killedMonsters = nil
  self.attackNum = nil
end

local function __delete(self)
  self.id = nil
  self.startTime = nil
  self.endTime = nil
  self.fightTime = nil
  self.activityType = nil
  self.stage = nil
  self.reward = nil
  self.aliMonsters = nil
  self.selfMonsters = nil
  self.refreshTime = nil
  self.oldMonsters = nil
  self.killedMonsters = nil
  self.attackNum = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  self.id = message.id
  self.startTime = message.startTime
  self.endTime = message.endTime
  self.fightTime = message.fightTime
  self.activityType = message.activityType
  self.stage = message.stage
  self.reward = message.reward
  self.aliMonsters = message.aliMonsters
  self.selfMonsters = message.selfMonsters
  self.refreshTime = message.refreshTime and message.refreshTime or 0
  self.attackNum = message.attackNum and message.attackNum or 0
end

local function SetCachedMonsters(self)
  self.oldMonsters = self.aliMonsters
end

local function ResetCachedMonsters(self)
  self.oldMonsters = nil
end

local function GetKilledMonsters(self)
  if table.IsNullOrEmpty(self.oldMonsters) then
    return
  end
  if table.IsNullOrEmpty(self.aliMonsters) then
    for _, v in ipairs(self.oldMonsters) do
      if v then
        v.killed = true
      end
    end
    return self.oldMonsters
  end
  local list = {}
  local actData = DataCenter.ActivityMonsterInvasionDataManager:GetActivityData()
  local effectMaxNum = actData and actData.lightNum
  for _, v in pairs(self.oldMonsters) do
    if v and not self:ContainsValue(self.aliMonsters, v.uuid) then
      if effectMaxNum <= #list then
        break
      end
      local template = DataCenter.MonsterTemplateManager:GetMonsterTemplate(v.monsterId)
      if template then
        local special = template.special
        if special ~= WorldMonsterSpecialType.InvasionBigBoss then
          v.killed = true
          table.insert(list, v)
        end
      end
    end
  end
  return list
end

local function ContainsValue(self, list, uuid)
  if not table.IsNullOrEmpty(list) and uuid then
    for i, v in pairs(list) do
      if v.uuid == uuid then
        return true
      end
    end
  end
  return false
end

MonsterInvasionData.__init = __init
MonsterInvasionData.__delete = __delete
MonsterInvasionData.ParseData = ParseData
MonsterInvasionData.SetCachedMonsters = SetCachedMonsters
MonsterInvasionData.ResetCachedMonsters = ResetCachedMonsters
MonsterInvasionData.GetKilledMonsters = GetKilledMonsters
MonsterInvasionData.ContainsValue = ContainsValue
return MonsterInvasionData
