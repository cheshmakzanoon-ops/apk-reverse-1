local base = require("DataCenter.LWBattle.Logic.ParkourBattle.ExtendState.ParkourBattleExtendState")
local Const = require("Scene.LWBattle.Const")
local ParkourBattleGoldMonsterBonusState = BaseClass("ParkourBattleGoldMonsterBonusState", base)

function ParkourBattleGoldMonsterBonusState:__init(logic)
  self.logic = logic
  self.bonusWinConditions = self.logic.data.bonusWinConditions
end

function ParkourBattleGoldMonsterBonusState:__delete()
  self.logic = nil
  self.bonusWinConditions = nil
  self:StopTimer()
end

function ParkourBattleGoldMonsterBonusState:OnEnter(state)
  self.state = state
  self.logic.team:ChangeStage(state)
  self.logic:OnFingerUp()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWarningTip, {anim = true}, WarningTipType.ParkourGoldBonus)
  self.logic:RefreshWinConditions({})
  local delayTime = 2.4
  self.tipTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnWarningTipEnd()
  end, delayTime)
end

function ParkourBattleGoldMonsterBonusState:OnWarningTipEnd()
  if self.logic and self.logic.monsterMgr then
    self.logic.monsterMgr:ChangeBonus()
    self.logic:RefreshWinConditions(self.bonusWinConditions)
    local param = {}
    param.bonusType = self:GetBonusType()
    param.conditions = self:GetCheckWinConditions()
    param.useTime = self.logic.useTime
    param.extendData = self.logic.data.bonusExtendData
    self.logic.mainUI:OnBonusEnter(param)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWarningTip)
end

function ParkourBattleGoldMonsterBonusState:OnExit()
  self:StopTimer()
end

function ParkourBattleGoldMonsterBonusState:StopTimer()
  if self.tipTimer then
    self.tipTimer:Stop()
    self.tipTimer = nil
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWarningTip)
end

function ParkourBattleGoldMonsterBonusState:OnUpdate()
  local winConditions = self:GetCheckWinConditions()
  if self.logic.team:GetPositionZ() < self.logic.endLine then
  elseif winConditions[Const.ParkourWinType.FinishPoint] then
    self:OnBattleWin()
  end
end

function ParkourBattleGoldMonsterBonusState:GetCheckWinConditions()
  return self.bonusWinConditions
end

function ParkourBattleGoldMonsterBonusState:OnFingerDown(pos)
  self.logic:OnFingerDownLeftRight(pos)
end

function ParkourBattleGoldMonsterBonusState:OnFingerHold(deltaTime)
  self.logic:OnFingerHoldLeftRight(deltaTime)
end

function ParkourBattleGoldMonsterBonusState:GetBonusType()
  return Const.ParkourBattleBonusType.GoldMonster
end

return ParkourBattleGoldMonsterBonusState
