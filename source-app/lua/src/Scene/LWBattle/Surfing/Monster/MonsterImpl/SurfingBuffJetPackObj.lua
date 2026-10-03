local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffObj")
local SurfingBuffJetPackObj = BaseClass("SurfingBuffJetPackObj", base)

function SurfingBuffJetPackObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self._showStaticEffect = true
end

function SurfingBuffJetPackObj:ShowStaticEffect()
  if self.logic.ignoreSpectacularEffect then
    return
  end
  local pos = self.logic.staticEffectCommonPos
  if self.effectParent == nil then
    pos.x = self.curWorldPos.x
    pos.y = self.curWorldPos.y
    pos.z = self.curWorldPos.z
  else
    pos.x = 0
    pos.y = 0
    pos.z = 0
  end
  self.staticEffectId = self.logic:ShowEffectObj("Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_shine.prefab", pos, nil, -1, self.effectParent)
end

function SurfingBuffJetPackObj:HandleCollide(target)
  local buffId = self:GetBuffId()
  local buff = self:AddSelfBuff(target, buffId)
  if buff and self.logic then
    local duration = buff.meta and buff.meta.buff_time or 0
    self.logic:ShowSkyScores(self:GetDataZ(), duration)
  end
  self:Death()
end

return SurfingBuffJetPackObj
