local SurfingPlayerDieState = BaseClass("SurfingPlayerDieState")

function SurfingPlayerDieState:__init(unit)
  self.unit = unit
end

function SurfingPlayerDieState:__delete()
  self.unit = nil
end

function SurfingPlayerDieState:OnEnter(attackerObjId)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Death, false)
  self.unit:TryCrossFadeSimpleAnim("death2", nil, nil, true)
  if attackerObjId and 0 < attackerObjId then
    local modifyZ = PvePhysicsUtil.TryGetSurfingPlayerCollideZ(attackerObjId)
    local unitY = self.unit:GetPosition().y
    if 0 < modifyZ or 0 < unitY then
      self.unit:DeathModifyZ(modifyZ)
    end
  end
  self.unit.logic:OnPlayerDeath()
end

function SurfingPlayerDieState:OnExit()
end

function SurfingPlayerDieState:OnUpdate(deltaTime)
end

return SurfingPlayerDieState
