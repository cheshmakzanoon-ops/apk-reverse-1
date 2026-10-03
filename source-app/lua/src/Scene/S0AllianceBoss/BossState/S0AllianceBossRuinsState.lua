local S0AllianceBossRuinsState = BaseClass("S0AllianceBossRuinsState")

function S0AllianceBossRuinsState:__init(stateMgr)
  self.stateMgr = stateMgr
end

function S0AllianceBossRuinsState:__delete()
  self.stateMgr = nil
end

function S0AllianceBossRuinsState:OnEnter(param)
  local stateMgr = self.stateMgr
  if stateMgr then
    local offset = param
    if offset and 0 <= offset and offset <= 4500 then
      stateMgr:PlayBossAnimation(stateMgr.BossAnim.Leave, false, true, nil, function()
        stateMgr:HideBossModel()
      end)
      stateMgr:PlayBuildAnimation(stateMgr.BuildingAnim.Ruins, false, true, nil, function()
        stateMgr:PlayBuildAnimation(stateMgr.BuildingAnim.Hold, false, true, 1)
      end)
    else
      stateMgr:PlayBuildAnimation(stateMgr.BuildingAnim.Hold, false, true, 1)
      stateMgr:HideBossModel()
    end
  end
end

function S0AllianceBossRuinsState:OnExit()
end

function S0AllianceBossRuinsState:OnUpdate(deltaTime)
end

return S0AllianceBossRuinsState
