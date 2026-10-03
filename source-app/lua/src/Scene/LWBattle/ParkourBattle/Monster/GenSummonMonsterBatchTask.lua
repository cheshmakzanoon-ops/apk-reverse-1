local GenSummonMonsterBatchTask = BaseClass("GenSummonMonsterBatchTask")

function GenSummonMonsterBatchTask:__init(mgr, startPos, metaId, count, posOffset, hp, ownerMeta)
  self.mgr = mgr
  self.lastTickTime = 0
  self.genMetaId = metaId
  self.startX = startPos.x
  self.startZ = startPos.z
  self.zOffset = posOffset
  self.genCount = count
  self.monsterHp = hp
  self.ownerMeta = ownerMeta
  self.interval = 0.05
  self.genCounter = 0
  if mgr.logic and mgr.logic.defenseOffsetZ then
    self.initDefenseOffsetZ = mgr.logic.defenseOffsetZ
  end
end

function GenSummonMonsterBatchTask:__delete()
end

function GenSummonMonsterBatchTask:Update()
  local now = Time.time
  if now - self.lastTickTime > self.interval then
    self.lastTickTime = now
    self:DoLogic()
  end
end

function GenSummonMonsterBatchTask:DoLogic()
  self.genCounter = self.genCounter + 1
  if self.genCounter > self.genCount then
    self.mgr:RemoveTask(self)
    return
  end
  self:Gen()
end

function GenSummonMonsterBatchTask:Gen()
  local offsetZ = 0
  if self.mgr.logic and self.mgr.logic.defenseOffsetZ then
    local curDefenseOffsetZ = self.mgr.logic.defenseOffsetZ
    offsetZ = curDefenseOffsetZ - self.initDefenseOffsetZ
  end
  local genPos = Vector3.New(self.startX, 0, self.startZ + (self.genCounter - 1) * self.zOffset + offsetZ)
  local m = self.mgr:CreateMonster(genPos.x, genPos.z, self.genMetaId)
  genPos:ReturnPool()
  if m then
    m:ResetHp(self.monsterHp, self.ownerMeta)
    m:SetIsFromSummon(true)
    m:Load()
  end
end

return GenSummonMonsterBatchTask
