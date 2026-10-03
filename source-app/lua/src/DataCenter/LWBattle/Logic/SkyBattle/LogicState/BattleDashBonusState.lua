local base = require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleBaseState")
local Const = require("Scene.LWBattle.Const")
local BattleDashBonusState = BaseClass("BattleDashBonusState", base)

function BattleDashBonusState:__init(logic)
  self.bonusWinConditions = self.logic.data.bonusWinConditions
end

function BattleDashBonusState:__delete()
  self.bonusWinConditions = nil
end

function BattleDashBonusState:OnEnter(state)
  base.OnEnter(self)
  Logger.Log("skyBattle\239\188\154BattleDashBonusState")
  self.logic.team:ChangeStage(state)
  self.logic:OnFingerUp()
  self.duration = 2
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self:ChangeShowFinish()
  end, self.duration - 0.2)
  self.logic.monsterMgr:ClearMonsterByView()
  self.logic:RefreshWinConditions(self.bonusWinConditions)
  self.timeSinceEnter = 0
  local team = self.logic.team
  local curPos = team:GetPosition()
  local rushXvalue = self.logic:GetParkourRushX()
  local startZ = curPos.z + 5
  if self.logic.data and self.logic.data.bonusExtendData then
    startZ = self.logic.data.bonusExtendData.rushStartZ
  end
  self.controlPoint1 = curPos
  self.controlPoint2 = Vector3.New(rushXvalue, 0, (curPos.z + startZ) * 0.5)
  self.controlPoint3 = Vector3.New(rushXvalue, 0, startZ)
  self.changing = true
  self.b = Vector3.zero
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWarningTip, {anim = true}, WarningTipType.ParkourGoldBonus)
  if self.logic.LoadBonusDashLevelText then
    self.logic:LoadBonusDashLevelText()
  end
end

function BattleDashBonusState:OnExit()
  base.OnExit(self)
  self:ClearDelay()
  self.state = nil
end

function BattleDashBonusState:ChangeShowFinish()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWarningTip)
end

function BattleDashBonusState:OnUpdate(deltaTime)
  if self.countingToWinTimer then
    return
  end
  self.timeSinceEnter = self.timeSinceEnter + deltaTime
  if self.changing then
    local team = self.logic.team
    if self.timeSinceEnter < self.duration then
      local timePercent = self.timeSinceEnter / self.duration
      local a = self.controlPoint1 + (self.controlPoint2 - self.controlPoint1) * timePercent
      local b = self.controlPoint2 + (self.controlPoint3 - self.controlPoint2) * timePercent
      for _, v in pairs(team.teamUnits) do
        local member = v
        local offset = member.localPosition
        self.b.x = offset.x + b.x
        self.b.z = offset.z + b.z
        if member.transform then
          member.transform:LookAt(self.b)
        end
      end
      local newPos = a + (b - a) * timePercent
      team:SetPosition(newPos.x, newPos.z)
    else
      self.changing = false
      team:SetPosition(self.controlPoint3.x, self.controlPoint3.z)
      for _, v in pairs(team.teamUnits) do
        local member = v
        self.b.x = 0
        self.b.z = self.controlPoint3.z + 1024
        if member.transform then
          member.transform:LookAt(self.b)
        end
      end
      local param = {}
      param.bonusType = self:GetBonusType()
      param.conditions = self.bonusWinConditions
      param.useTime = self.logic.useTime
      param.extendData = self.logic.data.bonusExtendData
      self.logic.mainUI:OnBonusEnter(param)
    end
  end
  local teamDefaultMoveZ = self.logic.team:GetBonusDashSpeedZ()
  local teamMoveZDelta = teamDefaultMoveZ * deltaTime
  local position = self.logic.team:GetPosition()
  local curZ = position.z + teamMoveZDelta
  self.logic.team:SetPosition(position.x, curZ)
  self.logic.cameraFollowPosition.z = self.logic.cameraFollowPosition.z + teamMoveZDelta
  self:TriggerCondition(Const.ParkourWinType.FinishPoint)
end

local interestingWinCondition = {
  Const.ParkourWinType.KillMonster,
  Const.ParkourWinType.FinishPoint,
  Const.ParkourWinType.Time
}

function BattleDashBonusState:GetInterestingWinCondition()
  return interestingWinCondition
end

function BattleDashBonusState:OnFingerHold(deltaTime)
  if self.changing then
    return
  end
  self.logic:OnFingerHoldHorizonAndVertical(deltaTime)
end

function BattleDashBonusState:OnConditionMatch()
  self.logic:OnBattleWin()
end

function BattleDashBonusState:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function BattleDashBonusState:GetBonusType()
  return Const.ParkourBattleBonusType.Dash
end

function BattleDashBonusState:CanChangeTo(stateIndex)
  return stateIndex == Const.ParkourBattleState.PreExit
end

function BattleDashBonusState:OnMemberAllDied()
  self.logic:OnBattleWin()
end

return BattleDashBonusState
