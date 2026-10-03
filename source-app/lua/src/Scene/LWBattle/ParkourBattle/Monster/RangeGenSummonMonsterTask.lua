local RangeGenSummonMonsterTask = BaseClass("RangeGenSummonMonsterTask")

function RangeGenSummonMonsterTask:__init(mgr, pos, r1, r2, metaId, count, hp, ownerMeta)
  self.mgr = mgr
  self.lastTickTime = 0
  self.genMetaId = metaId
  self.genCount = count
  self.monsterHp = hp
  self.genX = pos.x
  self.genZ = pos.z
  self.r1 = r1
  self.r2 = r2
  self.interval = 0.1
  self.genCounter = 0
  self.ownerMeta = ownerMeta
end

function RangeGenSummonMonsterTask:__delete()
end

function RangeGenSummonMonsterTask:Update()
  local now = Time.time
  if now - self.lastTickTime > self.interval then
    self.lastTickTime = now
    self:DoLogic()
  end
end

function RangeGenSummonMonsterTask:DoLogic()
  self.genCounter = self.genCounter + 1
  if self.genCounter > self.genCount then
    self.mgr:RemoveTask(self)
    return
  end
  self:RangeGen()
end

function RangeGenSummonMonsterTask:RangeGen()
  local dir = Vector3.Normalize(Vector3.New(math.random(-10000, 10000), 0, math.random(-10000, 20000)))
  local len = math.random(self.r1, self.r2)
  local tempPos = Vector3.New(self.genX, 0, self.genZ)
  local dirOffset = dir * len
  local genPos = tempPos + dirOffset
  tempPos:ReturnPool()
  dir:ReturnPool()
  dirOffset:ReturnPool()
  local m = self.mgr:CreateMonster(genPos.x, genPos.z, self.genMetaId)
  genPos:ReturnPool()
  if m then
    m:ResetHp(self.monsterHp, self.ownerMeta)
    m:SetIsFromSummon(true)
    m:Load()
  end
end

return RangeGenSummonMonsterTask
