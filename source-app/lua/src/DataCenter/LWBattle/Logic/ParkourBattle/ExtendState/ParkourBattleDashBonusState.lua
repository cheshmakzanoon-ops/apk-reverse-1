local base = require("DataCenter.LWBattle.Logic.ParkourBattle.ExtendState.ParkourBattleExtendState")
local Const = require("Scene.LWBattle.Const")
local ParkourBattleDashBonusState = BaseClass("ParkourBattleDashBonusState", base)

function ParkourBattleDashBonusState:__init(logic)
  self.logic = logic
  self.bonusWinConditions = self.logic.data.bonusWinConditions
end

function ParkourBattleDashBonusState:__delete()
  self.logic = nil
  self.bonusWinConditions = nil
end

function ParkourBattleDashBonusState:OnEnter(state)
  self.state = state
  self.logic.team:ChangeStage(state)
  self.logic:OnFingerUp()
  self.duration = 2
  self:ClearDelay()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self:ChangeShowFinish()
  end, self.duration - 0.2)
  self.logic.monsterMgr:ClearMonsterByView()
  self.logic:RefreshWinConditions(self.bonusWinConditions)
  self.timeMgr = UITimeManager:GetInstance()
  self.startTime = self.timeMgr:GetServerTime()
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

function ParkourBattleDashBonusState:ChangeShowFinish()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWarningTip)
end

function ParkourBattleDashBonusState:OnUpdate()
  if self.changing then
    local team = self.logic.team
    local now = self.timeMgr:GetServerTime()
    local t = (now - self.startTime) * 0.001
    if t < self.duration then
      local timePercent = t / self.duration
      local tempA = (self.controlPoint2 - self.controlPoint1) * timePercent
      local a = self.controlPoint1 + tempA
      tempA:ReturnPool()
      local tempB = (self.controlPoint3 - self.controlPoint2) * timePercent
      local b = self.controlPoint2 + tempB
      tempB:ReturnPool()
      for _, v in pairs(team.teamUnits) do
        local member = v
        local offset = member.localPosition
        self.b.x = offset.x + b.x
        self.b.z = offset.z + b.z
        if member.transform then
          member.transform:LookAt(self.b)
        end
      end
      local diffPos = b - a
      local tempPos = diffPos * timePercent
      local newPos = a + tempPos
      tempPos:ReturnPool()
      team:SetPosition(newPos.x, newPos.z)
      newPos:ReturnPool()
      diffPos:ReturnPool()
      a:ReturnPool()
      b:ReturnPool()
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
    return
  end
end

function ParkourBattleDashBonusState:OnExit()
  self:ClearDelay()
end

function ParkourBattleDashBonusState:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function ParkourBattleDashBonusState:GetBonusType()
  return Const.ParkourBattleBonusType.Dash
end

return ParkourBattleDashBonusState
