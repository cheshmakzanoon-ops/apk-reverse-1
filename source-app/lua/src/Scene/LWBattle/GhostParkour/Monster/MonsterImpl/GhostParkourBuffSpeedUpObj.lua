local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffObj")
local GhostParkourBuffSpeedUpObj = BaseClass("GhostParkourBuffSpeedUpObj", base)

function GhostParkourBuffSpeedUpObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self._showStaticEffect = false
  self.soundId = 0
end

function GhostParkourBuffSpeedUpObj:ShowStaticEffect()
end

function GhostParkourBuffSpeedUpObj:ResetEffectPosition()
  if self.effectParent == nil and self.staticEffectId then
    local p = self.curWorldPos
    self.logic:ResetEffectPosition(self.staticEffectId, p.x, p.y + 1, p.z)
  end
end

function GhostParkourBuffSpeedUpObj:OnCollide(target)
  self:HandleExtra(target)
  self:HandleCollide(target)
end

function GhostParkourBuffSpeedUpObj:AddSelfBuff(target, buffId, param)
  if buffId and 0 < buffId and self.logic then
    local buff = target:AddBuff(buffId, param)
    self.logic:OnBuffAdd(buff)
    target:ShowUnitEffect(self.effectType)
    self.logic:RecordBuffList(ParkourBuffType.SPEED_BOARD, buffId, self.bornId, self.monsterId)
    Logger.LogInfo(string.format("Surfing -- [TryCheckObj] bornId:%s monsterId:%s oriId:%s z:%s transform pos:%s player distance:%s totalRunTime :%s", self.bornId, self.monsterId, self.oriId, self.z, self:GetPosition() and self:GetPosition().z or 0, self.logic:GetCurDistanceData(), self.logic.totalRunTime))
    return buff
  end
end

function GhostParkourBuffSpeedUpObj:GetBuffId()
  if self.monsterMeta then
    local buff_id = self.monsterMeta:GetBuffType()
    return buff_id
  end
  if self.monsterId then
    local bMMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(self.monsterId)
    if bMMeta then
      local buff_id = bMMeta:GetBuffType()
      return buff_id
    end
  end
  return 0
end

function GhostParkourBuffSpeedUpObj:HandleExtra(target)
end

function GhostParkourBuffSpeedUpObj:HandleCollide(target)
  self:AddSelfBuff(target, self:GetBuffId())
end

return GhostParkourBuffSpeedUpObj
