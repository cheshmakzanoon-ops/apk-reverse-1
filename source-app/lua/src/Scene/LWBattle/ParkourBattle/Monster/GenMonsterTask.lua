local GenMonsterTask = BaseClass("GenMonsterTask")
local Const = require("Scene.LWBattle.Const")
GenMonsterTask.GenType = {FixPoint = 1, Range = 2}

function GenMonsterTask:__init(mgr, bornMeta)
  self.mgr = mgr
  self.lastTickTime = 0
  self.bornMeta = bornMeta
  self.genNum = 0
  self.delayGenTime = 0
  self.initTime = Time.time
  local spl = string.split(bornMeta.para, "|")
  if bornMeta.type == 2 then
    self.type = GenMonsterTask.GenType.Range
    self.limit = tonumber(spl[2])
    self.interval = tonumber(spl[3]) / 1000
    self.r1 = tonumber(spl[4])
    self.r2 = tonumber(spl[5])
    local splMon = string.split(bornMeta.monster, ",")
    self.monsterArr = {}
    for k, v in pairs(splMon) do
      local innerSpl = string.split(v, "|")
      local randomParam = {
        id = tonumber(innerSpl[1]),
        p = tonumber(innerSpl[2])
      }
      table.insert(self.monsterArr, randomParam)
    end
  elseif bornMeta.type == 3 then
    self.type = GenMonsterTask.GenType.FixPoint
    self.limit = tonumber(spl[2])
    self.interval = tonumber(spl[3]) / 1000
    local splMon = string.split(bornMeta.monster, ",")
    self.monsterArr = {}
    for k, v in pairs(splMon) do
      local innerSpl = string.split(v, "|")
      local randomParam = {
        id = tonumber(innerSpl[1]),
        p = tonumber(innerSpl[2])
      }
      table.insert(self.monsterArr, randomParam)
    end
  elseif bornMeta.type == 6 or bornMeta.type == 7 then
    self.type = GenMonsterTask.GenType.FixPoint
    self.limit = 1
    self.interval = 0.1
    local splMon = string.split(bornMeta.monster, ",")
    self.monsterArr = {}
    for k, v in pairs(splMon) do
      local innerSpl = string.split(v, "|")
      local randomParam = {
        id = tonumber(innerSpl[1]),
        p = tonumber(innerSpl[2])
      }
      table.insert(self.monsterArr, randomParam)
    end
  elseif bornMeta.type == 9 then
    self.type = GenMonsterTask.GenType.FixPoint
    self.limit = 1
    self.interval = 0.1
    self.delayGenTime = bornMeta.delayGenTime or 0
    local splMon = string.split(bornMeta.monster, ",")
    self.monsterArr = {}
    for k, v in pairs(splMon) do
      local innerSpl = string.split(v, "|")
      local randomParam = {
        id = tonumber(innerSpl[1]),
        p = tonumber(innerSpl[2])
      }
      table.insert(self.monsterArr, randomParam)
    end
  end
end

function GenMonsterTask:__delete()
end

function GenMonsterTask:Update()
  local now = Time.time
  if now > self.initTime + self.delayGenTime and now - self.lastTickTime > self.interval then
    self.lastTickTime = now
    self:DoLogic()
  end
end

function GenMonsterTask:DoLogic()
  self.genNum = self.genNum + 1
  if self.genNum > self.limit then
    self.mgr:RemoveTask(self)
    return
  end
  if self.type == GenMonsterTask.GenType.FixPoint then
    self:FixPointsGen()
  elseif self.type == GenMonsterTask.GenType.Range then
    self:RangeGen()
  end
end

function GenMonsterTask:RangeGen()
  local y = self.mgr.logic.team:GetPositionZ()
  local x = Const.ParkourSceneCenter
  local dir = Vector3.Normalize(Vector3.New(math.random(-10000, 10000), 0, math.random(-10000, 20000)))
  local len = math.random(self.r2, self.r1)
  local tempPos = Vector3.New(x, 0, y + 10)
  local dirOffset = dir * len
  local genPos = tempPos + dirOffset
  tempPos:ReturnPool()
  dir:ReturnPool()
  dirOffset:ReturnPool()
  local r = math.random(0, 10000)
  local mId = 0
  for _, v in ipairs(self.monsterArr) do
    mId = v.id
    if r > v.p then
      break
    end
  end
  if 0 < mId then
    local m = self.mgr:CreateMonster(genPos.x, genPos.z, mId, self.bornMeta.view_Param, self.bornMeta.move_Param)
    if m then
      m:Load()
    end
  end
  genPos:ReturnPool()
end

function GenMonsterTask:FixPointsGen()
  local spl = string.split(self.bornMeta.coord, ",")
  local x = tonumber(spl[1])
  local y = tonumber(spl[2])
  local r = math.random(0, 10000)
  local mId = 0
  for _, v in ipairs(self.monsterArr) do
    mId = v.id
    if r > v.p then
      break
    end
  end
  if 0 < mId then
    local m = self.mgr:CreateMonster(x, y, mId, self.bornMeta.view_Param, self.bornMeta.move_Param)
    if m then
      m:Load()
    end
    if self.bornMeta.type == 6 or self.bornMeta.type == 7 then
      self.mgr.showList[m.guid] = m
    end
  end
end

return GenMonsterTask
