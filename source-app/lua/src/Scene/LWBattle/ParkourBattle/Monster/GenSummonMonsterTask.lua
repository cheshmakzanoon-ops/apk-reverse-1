local GenSummonMonsterTask = BaseClass("GenSummonMonsterTask")

function GenSummonMonsterTask:__init(mgr, pos, metaId, count, hp, ownerMeta)
  self.mgr = mgr
  self.lastTickTime = 0
  self.genMetaId = metaId
  self.genCount = count
  self.monsterHp = hp
  self.genX = pos.x
  self.genZ = pos.z
  self.interval = 0.1
  self.genCounter = 0
  self.ownerMeta = ownerMeta
end

function GenSummonMonsterTask:__delete()
end

function GenSummonMonsterTask:Update()
  local now = Time.time
  if now - self.lastTickTime > self.interval then
    self.lastTickTime = now
    self:DoLogic()
  end
end

function GenSummonMonsterTask:DoLogic()
  self.genCounter = self.genCounter + 1
  if self.genCounter > self.genCount then
    self.mgr:RemoveTask(self)
    return
  end
  self:Gen()
end

function GenSummonMonsterTask:Gen()
  local dir = Vector3.Normalize(Vector3.New(math.random(-10000, 10000), 0, math.random(-10000, 20000)))
  local len = math.random() * 2
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

return GenSummonMonsterTask
