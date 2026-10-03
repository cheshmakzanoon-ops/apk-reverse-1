local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameIdleBattleSoldier = BaseClass("T11IdleGameIdleBattleSoldier")
local ResourceManager = CS.GameEntry.Resource
local FSMachine = require("Common.FSMachine")
local IdleState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/State/T11IdleGameBattleSoldierStateIdle")
local RunState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/State/T11IdleGameBattleSoldierStateRun")
local OpeningState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/State/T11IdleGameBattleSoldierStateOpening")
local OpenChestState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/State/T11IdleGameBattleSoldierStateOpenChest")
local EventState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/State/T11IdleGameBattleSoldierStateEvent")
local BattleState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/State/T11IdleGameBattleSoldierStateBattle")
local EndState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/State/T11IdleGameBattleSoldierStateEnd")
local T11IdleGameIdleBattleBullet = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/T11IdleGameIdleBattleBullet")

function T11IdleGameIdleBattleSoldier:__init()
  self.req = nil
  self.index = nil
  self.obj = nil
  self.controller = nil
  self.simpleAnimation = nil
  self.animEffectController = nil
  self.soldierId = nil
  self.appearanceMeta = nil
  self.firePoint = nil
  self.skillId = nil
  self.skillMeta = nil
  self.owner = nil
  self.curState = nil
  self.fireTargetPos = nil
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(Const.SoldierState.Idle, IdleState.Create())
  self.fsm:Add(Const.SoldierState.Run, RunState.Create())
  self.fsm:Add(Const.SoldierState.Opening, OpeningState.Create())
  self.fsm:Add(Const.SoldierState.OpenChest, OpenChestState.Create())
  self.fsm:Add(Const.SoldierState.Event, EventState.Create())
  self.fsm:Add(Const.SoldierState.Battle, BattleState.Create())
  self.fsm:Add(Const.SoldierState.End, EndState.Create())
  self.bullets = {}
  self.bulletId = 0
end

function T11IdleGameIdleBattleSoldier:__delete()
  self:Destroy()
end

function T11IdleGameIdleBattleSoldier:OnUpdate(deltaTime)
  if self.fsm then
    self.fsm:Update(deltaTime)
  end
  if self.bullets then
    for i, v in pairs(self.bullets) do
      if v then
        v:OnUpdate(deltaTime)
      end
    end
  end
end

function T11IdleGameIdleBattleSoldier:Init(index, soldierId, appearanceMeta, skillId, squad)
  self.index = index
  self.soldierId = soldierId
  self.appearanceMeta = appearanceMeta
  self.skillId = skillId
  self.firePoint = nil
  self.skillMeta = nil
  self.owner = squad
  self.assetPath = DataCenter.T11IdleGameTemplateManager:GetIdleBattleSoldierAssetPath(self.soldierId)
  if string.IsNullOrEmpty(self.assetPath) then
    self.assetPath = Const.DefaultSoldierAssetPath
  end
end

function T11IdleGameIdleBattleSoldier:Load(pos, parent, finishCallback)
  if string.IsNullOrEmpty(self.assetPath) then
    return
  end
  local req = ResourceManager:InstantiateAsync(self.assetPath)
  req:completed("+", function(request)
    if request.isError then
      return
    end
    request.gameObject.transform:SetParent(parent.transform)
    request.gameObject.transform:Set_localPosition(pos.x, pos.y, pos.z)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.obj = request.gameObject
    self.controller = request.gameObject.transform:GetComponentInChildren(typeof(CS.T11IdleGameIdleBattleSoldierController))
    self.animEffectController = request.gameObject.transform:GetComponent(typeof(CS.T11IdleGameBossBattleAnimationController))
    self.simpleAnimation = self.controller:GetMainAnim()
    self.controller:HideBubble(true)
    self.controller:SetSoldierForward(180)
    self.animEffectController:HideAllEffects()
    local appearanceMeta = self.appearanceMeta
    local rootNodeName = PathUtil.GetFileNameWithoutExtension(appearanceMeta.model_path)
    local firePoints = {}
    for i, v in ipairs(appearanceMeta.fire_paths) do
      local firePointPath = rootNodeName .. "/" .. v
      local firePoint = request.gameObject.transform:Find(firePointPath)
      if not firePoint then
        Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. appearanceMeta.id .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. firePointPath)
      else
        table.insert(firePoints, firePoint)
      end
    end
    self.firePoint = firePoints[1]
    self:InitSkill()
    if finishCallback then
      finishCallback()
    end
  end)
  self.req = req
end

function T11IdleGameIdleBattleSoldier:Destroy()
  if self.req then
    self.req:Destroy()
  end
  self.req = nil
  self.index = nil
  if self.bullets then
    for i, v in pairs(self.bullets) do
      if v then
        v:Destroy()
      end
    end
    self.bullets = nil
  end
  self.bulletId = nil
  if self.fsm then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.curState = nil
  self.soldierId = nil
  self.appearanceMeta = nil
  self.firePoint = nil
  self.skillId = nil
  self.skillMeta = nil
  self.owner = nil
  self.fireTargetPos = nil
  self.obj = nil
  self.controller = nil
  self.simpleAnimation = nil
  self.animEffectController = nil
end

function T11IdleGameIdleBattleSoldier:ChangeState(state, ...)
  if self.curState == state then
    return
  end
  self.curState = state
  self.fsm:Switch(state, ...)
end

function T11IdleGameIdleBattleSoldier:ResetStateMachine()
  if self.fsm then
    self.fsm:Reset()
  end
  self.curState = nil
end

function T11IdleGameIdleBattleSoldier:PlayAnim(animName, queueAnimName)
  if IsNotNull(self.simpleAnimation) then
    local animState = self.simpleAnimation:GetState(animName)
    if animState == nil then
      local allNames = ""
      local statesIEnum = self.simpleAnimation:GetStates()
      for state in statesIEnum, nil, nil do
        allNames = allNames .. state.name .. ","
      end
      DataCenter.T11IdleGameManager:PrintRealInfoLog("T11IdleGameIdleBattleSoldier:PlayAnim animName not found: " .. animName .. ", objName: " .. self.simpleAnimation.gameObject.name .. ", allNames: " .. allNames)
      return
    end
    if self.simpleAnimation:IsPlaying(animName) then
      self.simpleAnimation:Rewind(animName)
    else
      self.simpleAnimation:CrossFade(animName, 0.2)
    end
    if queueAnimName ~= nil then
      self.simpleAnimation:CrossFadeQueued(queueAnimName, 0.2, CS.UnityEngine.QueueMode.CompleteOthers)
    end
  end
end

function T11IdleGameIdleBattleSoldier:SetAnimSpeed(animName, speed)
  if IsNotNull(self.simpleAnimation) then
    self.simpleAnimation:SetStateSpeed(animName, speed)
  end
end

function T11IdleGameIdleBattleSoldier:GetFirePoint()
  return self.firePoint
end

function T11IdleGameIdleBattleSoldier:InitSkill()
  if self.skillId then
    self.skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(self.skillId)
  end
end

function T11IdleGameIdleBattleSoldier:GetSkillMeta()
  return self.skillMeta
end

function T11IdleGameIdleBattleSoldier:SetBubbleImage(imgPath)
  if IsNotNull(self.controller) then
    self.controller:SetBubbleImage(imgPath)
  end
end

function T11IdleGameIdleBattleSoldier:ShowBubble()
  if IsNotNull(self.controller) then
    self.controller:ShowBubble()
  end
end

function T11IdleGameIdleBattleSoldier:HideBubble()
  if IsNotNull(self.controller) then
    self.controller:HideBubble(false)
  end
end

function T11IdleGameIdleBattleSoldier:SetSoldierForward(yAngle, duration)
  if IsNotNull(self.controller) then
    self.controller:SetSoldierForward(yAngle, checknumber(duration))
  end
end

function T11IdleGameIdleBattleSoldier:SetSoldierLookAt(position)
  if IsNotNull(self.controller) then
    self.controller:SetSoldierLookAt(position)
  end
end

function T11IdleGameIdleBattleSoldier:GetPosition()
  if IsNotNull(self.obj) then
    return self.obj.transform.position
  end
  return Vector3.New(0, 0, 0)
end

function T11IdleGameIdleBattleSoldier:FireBullet(asset, startPos, endPos, speed, onBulletHit)
  local bullet = ObjectPool:GetInstance():Load(T11IdleGameIdleBattleBullet)
  self.bullets[self.bulletId] = bullet
  self.bullets[self.bulletId]:Init(asset, startPos, endPos, speed, self.bulletId, function(bulletInstance)
    local id = bulletInstance:GetId()
    if self.bullets[id] then
      self.bullets[id] = nil
    end
    bulletInstance:Clear()
    ObjectPool:GetInstance():Save(bulletInstance)
    if onBulletHit then
      onBulletHit()
    end
  end)
  self.bulletId = self.bulletId + 1
end

function T11IdleGameIdleBattleSoldier:GetTargetMonsterType()
  for i, v in pairs(Const.NodeBattleSoldierTargetMonster) do
    for _, index in pairs(v) do
      if index == self.index then
        return i
      end
    end
  end
end

function T11IdleGameIdleBattleSoldier:TryPlayFireSound(waveIndex)
  if self.owner then
    self.owner:TryPlayFireSound(waveIndex)
  end
end

return T11IdleGameIdleBattleSoldier
