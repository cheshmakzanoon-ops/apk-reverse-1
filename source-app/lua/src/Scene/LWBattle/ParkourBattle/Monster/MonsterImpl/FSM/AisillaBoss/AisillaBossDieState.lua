local AisillaBossDieState = BaseClass("AisillaBossDieState")
local effPath1 = "Assets/_Art_LastWar/Effect/Prefab/RiChang/aisila/Eff_s_aisila_dead_root.prefab"
local effPath1Root = "A_Mongster@Boss_aisila01_skin/To_unity/DeformationSystem/Root"

function AisillaBossDieState:Init(unit)
  self.unit = unit
end

function AisillaBossDieState:__delete()
  if self.eff1 then
    self.unit.logic:RemoveEffectObj(self.eff1)
    self.eff1 = nil
  end
  self.unit = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function AisillaBossDieState:OnEnter()
  self.unit.mgr:OnMonsterDeath(self.unit.guid)
  self.timer = TimerManager:DelayInvoke(function()
    self.unit.mgr:RemoveMonster(self.unit.guid)
  end, 4)
  self.unit:PlaySimpleAnim(ZombieAnim.Dead, 1)
  if IsNotNull(self.unit.transform) then
    local root1 = self.unit.transform:Find(effPath1Root)
    if IsNotNull(root1) then
      self.eff1 = self.unit.logic:ShowEffectObj(effPath1, nil, nil, 1, root1, 10)
    end
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Enemy_Boss_Aisila_Death, false)
end

function AisillaBossDieState:OnExit()
  if self.eff1 then
    self.unit.logic:RemoveEffectObj(self.eff1)
    self.eff1 = nil
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function AisillaBossDieState:OnUpdate(deltaTime)
end

return AisillaBossDieState
