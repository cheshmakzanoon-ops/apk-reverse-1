local T11IdleGameBossTemplate = BaseClass("T11IdleGameBossTemplate")

function T11IdleGameBossTemplate:__init()
  self.id = 0
  self.boss_order = 0
  self.next_boss_id = 0
  self.boss_power = 0
  self.boss_reward = 0
  self.boss_cd = 0
  self.boss_monster = {}
  self.maxCount = -1
end

function T11IdleGameBossTemplate:__delete()
  self.id = nil
  self.boss_order = nil
  self.next_boss_id = nil
  self.boss_power = nil
  self.boss_reward = nil
  self.boss_cd = nil
  self.boss_monster = nil
  self.maxCount = nil
end

function T11IdleGameBossTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.boss_order = rowData:getValue("boss_order") or 0
  self.next_boss_id = rowData:getValue("next_boss_id") or 0
  self.boss_power = rowData:getValue("boss_power") or 0
  self.boss_reward = rowData:getValue("boss_reward") or 0
  self.boss_cd = rowData:getValue("boss_cd") or 0
  self.boss_monster = rowData:getValue("boss_monster") or {}
end

function T11IdleGameBossTemplate:GetRandomMonsterId()
  if not table.IsNullOrEmpty(self.boss_monster) then
    return self.boss_monster[math.random(1, #self.boss_monster)]
  end
end

function T11IdleGameBossTemplate:IsFinalBoss()
  return self.next_boss_id <= 0
end

function T11IdleGameBossTemplate:GetNextBossTemplate()
  if self.next_boss_id > 0 then
    return DataCenter.T11IdleGameTemplateManager:GetBossTemplateById(self.next_boss_id)
  end
end

function T11IdleGameBossTemplate:GetMaxBossCount()
  if self.maxCount == -1 then
    self.maxCount = 1
    local round = 0
    local nextBoss = self:GetNextBossTemplate()
    while nextBoss ~= nil and round < 9999 do
      round = round + 1
      self.maxCount = self.maxCount + 1
      nextBoss = nextBoss:GetNextBossTemplate()
    end
  end
  return self.maxCount
end

return T11IdleGameBossTemplate
