local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingObj")
local SurfingBuffObj = BaseClass("SurfingBuffObj", base)

function SurfingBuffObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self.soundId = 11007
  self.effectType = SurfingUnitEffectType.GotProps
end

function SurfingBuffObj:OnCollide(target)
  DataCenter.LWSoundManager:PlaySound(self.soundId, false)
  self:HandleExtra(target)
  self:HandleCollide(target)
end

function SurfingBuffObj:HandleCollide(target)
  self:AddSelfBuff(target, self:GetBuffId())
  self:Death()
end

function SurfingBuffObj:AddSelfBuff(target, buffId, param)
  if buffId and 0 < buffId then
    local buff = target:AddBuff(buffId, param)
    EventManager:GetInstance():Broadcast(EventId.SurfingOnBuffAdd, {buff = buff})
    target:ShowUnitEffect(self.effectType)
    self.logic:TryCheckObj(self.bornId, self.monsterId, self.oriId)
    Logger.LogInfo(string.format("Surfing -- [TryCheckObj] bornId:%s monsterId:%s oriId:%s z:%s transform pos:%s player distance:%s totalRunTime :%s", self.bornId, self.monsterId, self.oriId, self.z, self:GetPosition() and self:GetPosition().z or 0, self.logic:GetCurDistanceData(), self.logic.totalRunTime))
    return buff
  end
end

function SurfingBuffObj:GetBuffId()
  if self.logic and self.logic.isPlayback then
    if self.monsterId then
      local bMMeta = DataCenter.SurfingMonsterTemplateManager:GetTemplate(self.monsterId)
      if bMMeta then
        local buffType = bMMeta:GetBuffType()
        local level = self.logic:GetBuffLevel(buffType) or 0
        if 0 < level then
          local buff_id = DataCenter.LWSurfingDataManager:GetBuffIdByBuffType(buffType, level)
          return buff_id
        end
      end
    end
  elseif self.monsterMeta then
    local unlock, buff_id = self.monsterMeta:CheckBuffIsUnlock()
    if unlock then
      return buff_id
    end
  end
  return 0
end

function SurfingBuffObj:HandleExtra(target)
end

return SurfingBuffObj
