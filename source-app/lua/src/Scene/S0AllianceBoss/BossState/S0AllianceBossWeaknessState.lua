local S0AllianceBossWeaknessState = BaseClass("S0AllianceBossWeaknessState")

function S0AllianceBossWeaknessState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function S0AllianceBossWeaknessState:__delete()
  self.stateMgr = nil
end

function S0AllianceBossWeaknessState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:PlayBuildAnimation(stateMgr.BuildingAnim.Idle, true, true)
    stateMgr:PlayBossAnimation(stateMgr.BossAnim.Weakness, true, true)
    stateMgr:ResetMaterial()
  end
end

function S0AllianceBossWeaknessState:OnExit()
end

function S0AllianceBossWeaknessState:OnUpdate(deltaTime)
end

return S0AllianceBossWeaknessState
