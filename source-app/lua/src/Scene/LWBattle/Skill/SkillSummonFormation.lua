local SkillSummonFormation = BaseClass("SkillSummonFormation")

function SkillSummonFormation:Init(heroSkillTemplate)
  self.occupied = {}
  self.heroSkillTemplate = heroSkillTemplate
  self.summonFormationList = heroSkillTemplate:GetSummonFormationList()
  self.total = #self.summonFormationList
end

function SkillSummonFormation:TryGetFreeSlot()
  for i = 1, self.total do
    if not self.occupied[i] then
      self.occupied[i] = true
      return i
    end
  end
  return -1
end

function SkillSummonFormation:ReleaseSlot(slot)
  if slot < 1 or slot > self.total then
    Logger.LogError("SkillSummonFormation:ReleaseSlot invalid slot : " .. slot)
    return
  end
  if not self.occupied[slot] then
    Logger.LogError("SkillSummonFormation:ReleaseSlot duplicate slot : " .. slot)
    return
  end
  self.occupied[slot] = nil
end

function SkillSummonFormation:GetSlotPos(slot)
  if slot < 1 or slot > self.total then
    Logger.LogError("SkillSummonFormation:GetSlotPos invalid slot : " .. slot)
    return
  end
  if not self.occupied[slot] then
    Logger.LogError("SkillSummonFormation:GetSlotPos empty slot : " .. slot)
  end
  local pos = self.summonFormationList[slot]
  return pos[1], pos[2]
end

return SkillSummonFormation
