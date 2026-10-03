local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingColliderMonster")
local SurfingMovableMonster = BaseClassCache("SurfingMovableMonster", base)

function SurfingMovableMonster:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self.isVisible = false
  self.curState = SurfingMonsterState.None
end

function SurfingMovableMonster:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not self.anim then
    Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
  end
end

function SurfingMovableMonster:DestroyData()
  base.DestroyData(self)
  self.isVisible = nil
  self.curState = nil
end

function SurfingMovableMonster:SetVisible(visible)
  self.isVisible = visible
  if self.gameObject then
    self.gameObject:SetActive(visible)
  end
end

function SurfingMovableMonster:DestroyView()
  base.DestroyView(self)
  self.anim = nil
end

function SurfingMovableMonster:OnObjStartMoved()
  if self.monsterMeta then
    if self.lightEffect ~= nil then
      return
    end
    local effectData = self.monsterMeta:GetEffectData()
    if effectData == nil then
      return
    end
    if IsNull(self.transform) or self.logic == nil then
      return
    end
    local path = effectData.path
    local nodePath = effectData.root
    local parent = self.transform:Find(nodePath)
    if IsNotNull(parent) then
      self.lightEffect = self.logic:ShowEffectObj(path, nil, nil, -1, parent)
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Truck, false)
  end
end

function SurfingMovableMonster:RemoveEffect()
  base.RemoveEffect(self)
  if self.lightEffect then
    self.logic:RemoveEffectObj(self.lightEffect)
    self.lightEffect = nil
  end
end

return SurfingMovableMonster
