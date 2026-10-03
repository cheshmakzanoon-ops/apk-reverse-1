local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameIdleBattleSquad = BaseClass("T11IdleGameIdleBattleSquad")
local T11IdleGameIdleBattleSoldier = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/T11IdleGameIdleBattleSoldier")
local T11IdleGameIdleBattleBullet = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/T11IdleGameIdleBattleBullet")

function T11IdleGameIdleBattleSquad:__init(logic)
  self.logic = logic
  self.soldiers = {}
  self.soldierId = nil
  self.appearanceMeta = nil
  self.skillId = nil
  self.soldierMeta = nil
  self.fireSoundPlayListCache = {}
end

function T11IdleGameIdleBattleSquad:__delete()
  self:Destroy()
end

function T11IdleGameIdleBattleSquad:Destroy()
  if self.soldiers then
    for i, v in ipairs(self.soldiers) do
      v:Destroy()
    end
  end
  self.soldiers = nil
  ObjectPool:GetInstance():Clear(T11IdleGameIdleBattleSoldier)
  ObjectPool:GetInstance():Clear(T11IdleGameIdleBattleBullet)
  self.soldierId = nil
  self.appearanceMeta = nil
  self.skillId = nil
  self.soldierMeta = nil
  self.logic = nil
  self:StopRunSound()
  self.fireSoundPlayListCache = nil
end

function T11IdleGameIdleBattleSquad:OnUpdate(deltaTime)
  if self.soldiers then
    for _, soldier in ipairs(self.soldiers) do
      soldier:OnUpdate(deltaTime)
    end
  end
end

function T11IdleGameIdleBattleSquad:LoadSoldiers(parent, finishCallback)
  local infoData = self.logic:GetInfoData()
  if infoData == nil then
    return
  end
  self.soldierId = infoData.soldierId
  self.soldierMeta = DataCenter.SoldierDataManager:GetTemplate(self.soldierId)
  self.skillId = DataCenter.T11IdleGameTemplateManager:GetSoldierSkillId(self.soldierId)
  self.appearanceMeta = DataCenter.T11IdleGameTemplateManager:GetIdleBattleSoldierHeroAppearanceMeta(self.soldierId)
  local count = #Const.DefaultSoldierPosList
  for i = 1, count do
    local soldier = ObjectPool:GetInstance():Load(T11IdleGameIdleBattleSoldier)
    soldier:Init(i, infoData.soldierId, self.appearanceMeta, self.skillId, self)
    soldier:Load(Const.DefaultSoldierPosList[i], parent, function()
      if self.soldiers == nil then
        self.soldiers = {}
      end
      self.soldiers[i] = soldier
      if #self.soldiers == count and finishCallback ~= nil then
        finishCallback()
      end
    end)
  end
end

function T11IdleGameIdleBattleSquad:ResetSoldiersStateMachine()
  if self.soldiers then
    DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameIdleBattleSquad:ResetSoldiersState")
    for _, soldier in ipairs(self.soldiers) do
      soldier:ResetStateMachine()
    end
  end
end

function T11IdleGameIdleBattleSquad:ChangeSoldiersState(state, ...)
  if self.soldiers then
    DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameIdleBattleSquad:ChangeSoldiersState " .. state)
    for _, soldier in ipairs(self.soldiers) do
      soldier:ChangeState(state, ...)
    end
    if state == Const.SoldierState.Run then
      self:PlayRunSound()
    else
      self:StopRunSound()
    end
  end
end

function T11IdleGameIdleBattleSquad:ChangeSingleSoldierState(index, state, ...)
  if self.soldiers and self.soldiers[index] then
    DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameIdleBattleSquad:ChangeSingleSoldierState " .. index .. " " .. state)
    self.soldiers[index]:ChangeState(state, ...)
  end
end

function T11IdleGameIdleBattleSquad:GetSoldier(index)
  if self.soldiers and self.soldiers[index] then
    return self.soldiers[index]
  end
  return nil
end

function T11IdleGameIdleBattleSquad:SetAllSoldierBubbleImage(img)
  if self.soldiers then
    for i, v in ipairs(self.soldiers) do
      v:SetBubbleImage(img)
    end
  end
end

function T11IdleGameIdleBattleSquad:ShowAllSoldierBubble()
  if self.soldiers then
    for i, v in ipairs(self.soldiers) do
      v:ShowBubble()
    end
  end
end

function T11IdleGameIdleBattleSquad:HideAllSoldierBubble()
  if self.soldiers then
    for i, v in ipairs(self.soldiers) do
      v:HideBubble()
    end
  end
end

function T11IdleGameIdleBattleSquad:EnterBattle(monsters)
  self.fireSoundPlayListCache = {}
  if self.soldiers then
    for i, v in ipairs(self.soldiers) do
      local monsterType = v:GetTargetMonsterType()
      if monsterType and monsters[monsterType] then
        v:ChangeState(Const.SoldierState.Battle, monsters[monsterType])
      end
    end
  end
end

function T11IdleGameIdleBattleSquad:PlayRunSound()
  if self.runSoundHandle ~= nil then
    return
  end
  self.runSoundHandle = DataCenter.LWSoundManager:PlaySound(91004, true)
end

function T11IdleGameIdleBattleSquad:StopRunSound()
  if self.runSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.runSoundHandle)
    self.runSoundHandle = nil
  end
end

function T11IdleGameIdleBattleSquad:TryPlayFireSound(waveIndex)
  if self.fireSoundPlayListCache == nil then
    self.fireSoundPlayListCache = {}
  end
  if self.fireSoundPlayListCache[waveIndex] ~= nil then
    return
  end
  self.fireSoundPlayListCache[waveIndex] = true
  DataCenter.LWSoundManager:PlaySound(91001, false)
end

return T11IdleGameIdleBattleSquad
