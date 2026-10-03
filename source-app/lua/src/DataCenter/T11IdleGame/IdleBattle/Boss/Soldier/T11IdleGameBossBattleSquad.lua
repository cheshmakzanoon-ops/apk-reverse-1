local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameBossBattleSquad = BaseClass("T11IdleGameBossBattleSquad")
local T11IdleGameBossBattleSoldier = require("DataCenter/T11IdleGame/IdleBattle/Boss/Soldier/T11IdleGameBossBattleSoldier")
local T11IdleGameIdleBattleBullet = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/T11IdleGameIdleBattleBullet")

function T11IdleGameBossBattleSquad:__init(logic, root)
  self.logic = logic
  self.soldiers = {}
  self.root = root
  self.anim = root.transform:GetComponent(typeof(CS.SimpleAnimation))
  self.soldierId = nil
  self.appearanceMeta = nil
  self.soldierMeta = nil
  self.skillId = nil
  self.fireSoundPlayListCache = {}
end

function T11IdleGameBossBattleSquad:__delete()
  self:Destroy()
  self.logic = nil
end

function T11IdleGameBossBattleSquad:Destroy()
  self:ClearAnimFinishTimer()
  if self.soldiers then
    for i, v in ipairs(self.soldiers) do
      v:Destroy()
    end
  end
  self.soldiers = nil
  ObjectPool:GetInstance():Clear(T11IdleGameBossBattleSoldier)
  ObjectPool:GetInstance():Clear(T11IdleGameIdleBattleBullet)
  self.soldierId = nil
  self.appearanceMeta = nil
  self.soldierMeta = nil
  self.skillId = nil
  self.root = nil
  self.anim = nil
  self:StopRunSound()
  self.fireSoundPlayListCache = nil
end

function T11IdleGameBossBattleSquad:OnUpdate(deltaTime)
  if self.soldiers then
    for _, soldier in ipairs(self.soldiers) do
      soldier:OnUpdate(deltaTime)
    end
  end
end

function T11IdleGameBossBattleSquad:LoadSoldiers(finishCallback)
  local infoData = self.logic:GetInfoData()
  if infoData == nil then
    return
  end
  self.soldierId = infoData.soldierId
  self.soldierMeta = DataCenter.SoldierDataManager:GetTemplate(self.soldierId)
  self.skillId = DataCenter.T11IdleGameTemplateManager:GetSoldierSkillId(self.soldierId)
  self.appearanceMeta = DataCenter.T11IdleGameTemplateManager:GetIdleBattleSoldierHeroAppearanceMeta(self.soldierId)
  local count = #Const.BossBattleDefaultSoldierPosList
  for i = 1, count do
    local soldier = ObjectPool:GetInstance():Load(T11IdleGameBossBattleSoldier)
    soldier:Init(infoData.soldierId, self.appearanceMeta, self.skillId, i, self)
    soldier:Load(Const.BossBattleDefaultSoldierPosList[i], self.root, function()
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

function T11IdleGameBossBattleSquad:ChangeSoldiersState(state, ...)
  if self.soldiers then
    DataCenter.T11IdleGameManager:PrintEditorCustomLog("T11IdleGameBossBattleSquad:ChangeSoldiersState " .. state)
    for _, soldier in ipairs(self.soldiers) do
      soldier:ChangeState(state, ...)
    end
    if state == Const.BossBattleSoldierState.Run then
      self:PlayRunSound()
    else
      self:StopRunSound()
    end
  end
end

function T11IdleGameBossBattleSquad:GetSingleFireDamage()
  local damage = 0
  if self.soldierMeta and self.soldierMeta.attack then
    damage = checknumber(self.soldierMeta.attack.value)
  end
  if damage <= 0 then
    return Const.BossBattleDefaultSoldierSkillDamage
  end
  return damage
end

function T11IdleGameBossBattleSquad:PlayAnim(name, finishCallback)
  self:ClearAnimFinishTimer()
  if IsNotNull(self.anim) then
    if finishCallback then
      local length = self.anim:GetClipLength(name) or 1
      self.animFinishTimer = TimerManager:GetInstance():DelayInvoke(function()
        if finishCallback then
          finishCallback()
        end
      end, length)
    end
    self.anim:Play(name)
  end
end

function T11IdleGameBossBattleSquad:ClearAnimFinishTimer()
  if self.animFinishTimer then
    self.animFinishTimer:Stop()
    self.animFinishTimer = nil
  end
end

function T11IdleGameBossBattleSquad:EnterFire(boss)
  self.fireSoundPlayListCache = {}
  if self.soldiers then
    for i, v in ipairs(self.soldiers) do
      local hitIndex = v:GetBossHitTargetIndex()
      v:ChangeState(Const.BossBattleSoldierState.Fire, boss, hitIndex)
    end
  end
end

function T11IdleGameBossBattleSquad:PlayRunSound()
  if self.runSoundHandle ~= nil then
    return
  end
  self.runSoundHandle = DataCenter.LWSoundManager:PlaySound(91004, true)
end

function T11IdleGameBossBattleSquad:StopRunSound()
  if self.runSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.runSoundHandle)
    self.runSoundHandle = nil
  end
end

function T11IdleGameBossBattleSquad:TryPlayFireSound(waveIndex)
  if self.fireSoundPlayListCache == nil then
    self.fireSoundPlayListCache = {}
  end
  if self.fireSoundPlayListCache[waveIndex] ~= nil then
    return
  end
  self.fireSoundPlayListCache[waveIndex] = true
  DataCenter.LWSoundManager:PlaySound(91001, false)
end

return T11IdleGameBossBattleSquad
