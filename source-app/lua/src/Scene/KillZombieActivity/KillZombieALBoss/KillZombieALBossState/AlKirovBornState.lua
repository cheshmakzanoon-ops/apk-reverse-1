local AlKirovBornState = BaseClass("AlKirovBornState")

function AlKirovBornState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function AlKirovBornState:__delete()
  self.stateMgr = nil
end

function AlKirovBornState:OnEnter()
  local stateMgr = self.stateMgr
  if stateMgr then
    stateMgr:ChangeModel("A_build_jiluofu_feiting_03_blue")
    stateMgr:PlayEffect(stateMgr.EffectFlag.Airflow)
    stateMgr:PlayEffect(stateMgr.EffectFlag.BornFire, 5)
    stateMgr:PlayAnimation(stateMgr.Anim.Born, function()
      stateMgr:ChangeState(stateMgr.FsmState.Idle)
    end)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_down, false)
  end
end

function AlKirovBornState:OnExit()
  if self.stateMgr then
    self.stateMgr:RemoveEffect(self.stateMgr.EffectFlag.BornFire)
  end
end

function AlKirovBornState:OnUpdate(deltaTime)
end

return AlKirovBornState
