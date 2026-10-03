local base = require("DataCenter/T11IdleGame/IdleBattle/Battle/Node/T11IdleGameIdleBattleNode_Base")
local T11IdleGameIdleBattleNode_Battle = BaseClass("T11IdleGameIdleBattleNode_Battle", base)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameIdleBattleMonster = require("DataCenter/T11IdleGame/IdleBattle/Battle/Monster/T11IdleGameIdleBattleMonster")

function T11IdleGameIdleBattleNode_Battle:__init(logic, owner)
  base.__init(self, logic, owner)
  self.monsters = nil
end

function T11IdleGameIdleBattleNode_Battle:__delete()
  base.__delete(self)
end

function T11IdleGameIdleBattleNode_Battle:Destroy()
  base.Destroy(self)
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
  if self.monsters then
    for i, v in pairs(self.monsters) do
      v:Destroy()
    end
    self.monsters = nil
  end
end

function T11IdleGameIdleBattleNode_Battle:Start()
  base.Start(self)
  local monsterData = self.data:GetMonsterData()
  if monsterData == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleBattleNode_Battle:Start call with nil monsterData")
    return
  end
  self.sequence = nil
  self.monsters = {}
  local propRoot = self.owner:GetNodePropRootByNodeType(self.data:GetType())
  local propRootInitPos = propRoot.transform.localPosition
  propRoot.transform:Set_localPosition(propRootInitPos.x, propRootInitPos.y, Const.NodeBattleMonsterOutPosition.z)
  local bossMonsterId = monsterData.bossId
  local zombieMonster1Id = monsterData.zombieId1
  local zombieMonster2Id = monsterData.zombieId2
  local bossMeta = DataCenter.PveMonsterTemplateManager:GetTemplate(bossMonsterId)
  local zombie1Meta = DataCenter.PveMonsterTemplateManager:GetTemplate(zombieMonster1Id)
  local zombie2Meta = DataCenter.PveMonsterTemplateManager:GetTemplate(zombieMonster2Id)
  self.monsters[Const.NodeBattleMonster.Boss] = self:CreateMonster(bossMeta, Const.NodeBattleBossPosition, Const.NodeBattleRotation, tonumber(bossMeta.model_size), propRoot, function()
    self:TryStartPlay()
  end)
  self.monsters[Const.NodeBattleMonster.Zombie1] = self:CreateMonster(zombie1Meta, Const.NodeBattleZombie1Position, Const.NodeBattleRotation, tonumber(zombie1Meta.model_size), propRoot, function()
    self:TryStartPlay()
  end)
  self.monsters[Const.NodeBattleMonster.Zombie2] = self:CreateMonster(zombie2Meta, Const.NodeBattleZombie2Position, Const.NodeBattleRotation, tonumber(zombie2Meta.model_size), propRoot, function()
    self:TryStartPlay()
  end)
end

function T11IdleGameIdleBattleNode_Battle:CreateMonster(monsterMeta, position, rotation, scale, parent, finishCallback)
  local monster = T11IdleGameIdleBattleMonster.New(self)
  monster:Init(monsterMeta, position, rotation, scale, parent, finishCallback)
  return monster
end

function T11IdleGameIdleBattleNode_Battle:TryStartPlay()
  if not self.monsters or #self.monsters ~= 3 then
    return
  end
  for i, v in pairs(self.monsters) do
    if not v:IsLoaded() then
      return
    end
  end
  local squad = self.logic:GetSquad()
  if not squad then
    return
  end
  local firstSoldier = self.logic:GetSoldier(1)
  if not firstSoldier then
    return
  end
  if self.sequence then
    return
  end
  local propRoot = self.owner:GetNodePropRootByNodeType(self.data:GetType())
  if not propRoot then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameIdleBattleNode_Battle:TryStartPlay call with nil propRoot, nodeType:" .. self.data:GetType() .. ", nodeIndex:" .. self.data:GetIndex() .. ", nodeId: " .. self.data.nodeId)
    return
  end
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.logic:PauseSceneManager()
  self.logic:ChangeSquadState(Const.SoldierState.Idle, "idle_game_idle01")
  squad:SetAllSoldierBubbleImage(Const.NodeBattleSoldierBubbleIconImagePath1)
  squad:ShowAllSoldierBubble()
  DataCenter.LWSoundManager:PlaySound(90117, false)
  local duration = math.abs(Const.NodeBattleMonsterInPosition.z - Const.NodeBattleMonsterOutPosition.z) / Const.PropMoveSpeed
  local moveTween = propRoot.transform:DOLocalMoveZ(Const.NodeBattleMonsterInPosition.z, duration):SetEase(CS.DG.Tweening.Ease.Linear)
  moveTween:OnStart(function()
    self:ChangeAllMonstersState(Const.NodeBattleMonsterState.Run)
  end)
  moveTween:OnComplete(function()
    self:ChangeAllMonstersState(Const.NodeBattleMonsterState.Idle)
    base.ShowTips(self, Localization:GetString("t11_idle_game_desc_13"))
  end)
  self.sequence:Append(moveTween)
  self.sequence:AppendCallback(function()
    squad:ResetSoldiersStateMachine()
    self.logic:ChangeSquadState(Const.SoldierState.Idle, "idle_game_idle02")
    squad:SetAllSoldierBubbleImage(Const.NodeBattleSoldierBubbleIconImagePath2)
  end)
  self.sequence:AppendInterval(0.7)
  self.sequence:AppendCallback(function()
    squad:HideAllSoldierBubble()
    squad:EnterBattle(self.monsters)
    self:ChangeAllMonstersState(Const.NodeBattleMonsterState.Battle)
  end)
  self.sequence:AppendInterval(4)
  self.sequence:AppendCallback(function()
    self:ChangeAllMonstersState(Const.NodeBattleMonsterState.Dead)
  end)
  self.sequence:AppendInterval(0.5)
  self.sequence:AppendCallback(function()
    if self.logic then
      self.logic:ChangeSquadState(Const.SoldierState.Idle, "idle_game_idle02")
      if firstSoldier then
        firstSoldier:SetBubbleImage(Const.NodeBattleSoldierBubbleIconImagePath3)
        firstSoldier:ShowBubble()
      end
    end
  end)
  self.sequence:AppendInterval(3)
  self.sequence:OnComplete(function()
    self.sequence = nil
    self:RefreshUINodeInfoComponent()
    self:Finish()
    if firstSoldier then
      firstSoldier:HideBubble()
    end
    local uiComp = self.logic:GetBattleUIComponent()
    if uiComp then
      uiComp:RefreshRewardContent()
    end
  end)
end

function T11IdleGameIdleBattleNode_Battle:ChangeAllMonstersState(state, ...)
  if not self.monsters then
    return
  end
  for i, v in ipairs(self.monsters) do
    v:ChangeState(state, ...)
  end
end

return T11IdleGameIdleBattleNode_Battle
