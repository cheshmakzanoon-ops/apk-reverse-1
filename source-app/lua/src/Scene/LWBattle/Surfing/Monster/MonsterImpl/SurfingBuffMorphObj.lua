local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBuffObj")
local SurfingBuffMorphObj = BaseClass("SurfingBuffMorphObj", base)

function SurfingBuffMorphObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self._showStaticEffect = true
  self.effectType = SurfingUnitEffectType.Morph
  self.soundId = 11025
end

function SurfingBuffMorphObj:ShowStaticEffect()
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

function SurfingBuffMorphObj:HandleCollide(target)
  local param1 = self.monsterMeta.para1
  if param1 and 3 <= #param1 then
    local morphPath = param1[3]
    local buffId = self:GetBuffId()
    self:AddSelfBuff(target, buffId, morphPath)
    local p = param1[2]
    local buffIds = string.split(p, ";")
    if buffIds then
      local id
      for _, v in ipairs(buffIds) do
        id = tonumber(v) or 0
        if 0 < id then
          local buff = target:AddBuff(id)
          EventManager:GetInstance():Broadcast(EventId.SurfingOnBuffAdd, {buff = buff})
        end
      end
    end
  end
  self:Death()
end

return SurfingBuffMorphObj
