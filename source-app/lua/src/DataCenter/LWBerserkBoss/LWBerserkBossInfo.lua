local LWBerserkBossInfo = BaseClass("LWBerserkBossInfo")

function LWBerserkBossInfo:__init()
  self.uuid = ""
  self.bossId = 0
  self.monsterId = 0
  self.status = -1
  self.startTime = 0
  self.endTime = 0
  self.curHp = 0
  self.maxHp = 0
  self.selfRank = 0
  self.selfDamage = 0
  self.targetRank = 0
  self.targetDamage = 0
  self.startPos = Vector3.zero
end

function LWBerserkBossInfo:__delete()
  self.uuid = nil
  self.bossId = nil
  self.monsterId = nil
  self.status = nil
  self.startTime = nil
  self.endTime = nil
  self.curHp = nil
  self.maxHp = nil
  self.selfRank = nil
  self.selfDamage = nil
  self.targetRank = nil
  self.targetDamage = nil
  self.startPos = nil
end

function LWBerserkBossInfo:InitData(message)
  local isChange = false
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.bossId then
    self.bossId = message.bossId
  end
  if message.monsterId then
    self.monsterId = message.monsterId
  end
  if message.startTime then
    self.startTime = message.startTime
  end
  if message.endTime then
    self.endTime = message.endTime
  end
  if message.status then
    if self.status ~= message.status then
      isChange = true
    end
    self.status = message.status
  end
  if message.curHp then
    if self.curHp ~= message.curHp then
      isChange = true
    end
    self.curHp = message.curHp
  end
  if message.maxHp then
    if self.maxHp ~= message.maxHp then
      isChange = true
    end
    self.maxHp = message.maxHp
  end
  if message.selfRank then
    if self.selfRank ~= message.selfRank then
      isChange = true
    end
    self.selfRank = message.selfRank
  end
  if message.selfDamage then
    if self.selfDamage ~= message.selfDamage then
      isChange = true
    end
    self.selfDamage = message.selfDamage
  end
  if message.targetRank then
    if self.targetRank ~= message.targetRank then
      isChange = true
    end
    self.targetRank = message.targetRank
  end
  if message.targetDamage then
    if self.targetDamage ~= message.targetDamage then
      isChange = true
    end
    self.targetDamage = message.targetDamage
  end
  if message.startPos then
    self.startPos = message.startPos
  end
  return isChange
end

function LWBerserkBossInfo:IsAttacking()
  return self.status == MarchStatus.ATTACKING and self.curHp > 0
end

function LWBerserkBossInfo:IsComingSoon()
  return self.status == MarchStatus.BERSERK_BOSS_WAITING
end

return LWBerserkBossInfo
