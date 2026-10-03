local BattleBaseState = BaseClass("BattleBaseState")
local Const = require("Scene.LWBattle.Const")

function BattleBaseState:__init(logic)
  self.logic = logic
end

function BattleBaseState:__delete()
  self.logic = nil
end

function BattleBaseState:OnEnter()
end

function BattleBaseState:OnExit()
  if self.countingToWinTimer then
    self.countingToWinTimer:Stop()
    self.countingToWinTimer = nil
    self.logic.battleMgr:SetGamePause(false)
    Time.timeScale = 1
    self:OnConditionMatch()
  end
end

function BattleBaseState:OnUpdate(deltaTime)
end

function BattleBaseState:OnFingerDown(pos)
end

function BattleBaseState:OnFingerUp()
end

function BattleBaseState:OnFingerHold(deltaTime)
end

function BattleBaseState:CanChangeTo(stateIndex)
  return true
end

function BattleBaseState:GetInterestingWinCondition()
  return nil
end

function BattleBaseState:OnConditionMatch()
end

function BattleBaseState:OnMemberAllDied()
  self.logic:OnBattleLose()
end

function BattleBaseState:TriggerCondition(conditionType, param)
  local interestWinCondition = self:GetInterestingWinCondition()
  if not interestWinCondition then
    return false
  end
  local index = table.indexof(interestWinCondition, conditionType)
  if not index or index < 1 then
    return false
  end
  local conditionMet = false
  if conditionType == Const.ParkourWinType.KillMonster or conditionType == Const.ParkourWinType.KillTargetMonster then
    local monster = param
    conditionMet = self.logic:CheckWinConditionsMet(conditionType, monster)
    if conditionMet then
      self:OnConditionMatch()
    end
  elseif conditionType == Const.ParkourWinType.FinishPoint or conditionType == Const.ParkourWinType.Time then
    conditionMet = self.logic:CheckWinConditionsMet(conditionType)
    if conditionMet then
      self:OnConditionMatch()
    end
  elseif conditionType == Const.ParkourWinType.KillBoss then
    local monster = param
    conditionMet = self.logic:CheckWinConditionsMet(conditionType, monster)
    if conditionMet then
      self.logic.unitMgr:ForceFinishFlash()
      self.logic.battleMgr:SetGamePause(true)
      if not self.countingToWinTimer then
        Time.timeScale = 0.5
        self.countingToWinTimer = TimerManager:GetInstance():GetTimer(4, function()
          self.countingToWinTimer:Stop()
          self.countingToWinTimer = nil
          self.logic.battleMgr:SetGamePause(false)
          Time.timeScale = 1
          self:OnConditionMatch()
        end, nil, true, false, true)
        self.countingToWinTimer:Start()
      end
    end
  end
  return conditionMet
end

return BattleBaseState
