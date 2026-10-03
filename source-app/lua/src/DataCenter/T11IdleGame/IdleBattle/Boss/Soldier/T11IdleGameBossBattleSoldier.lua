local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameBossBattleSoldier = BaseClass("T11IdleGameBossBattleSoldier")
local ResourceManager = CS.GameEntry.Resource
local FSMachine = require("Common.FSMachine")
local IdleState = require("DataCenter/T11IdleGame/IdleBattle/Boss/Soldier/State/T11IdleGameBossBattleSoldierStateIdle")
local FireState = require("DataCenter/T11IdleGame/IdleBattle/Boss/Soldier/State/T11IdleGameBossBattleSoldierStateFire")
local StrikeState = require("DataCenter/T11IdleGame/IdleBattle/Boss/Soldier/State/T11IdleGameBossBattleSoldierStateStrike")
local EndState = require("DataCenter/T11IdleGame/IdleBattle/Boss/Soldier/State/T11IdleGameBossBattleSoldierStateEnd")
local RunState = require("DataCenter/T11IdleGame/IdleBattle/Boss/Soldier/State/T11IdleGameBossBattleSoldierStateRun")
local T11IdleGameIdleBattleBullet = require("DataCenter/T11IdleGame/IdleBattle/Battle/Soldier/T11IdleGameIdleBattleBullet")

function T11IdleGameBossBattleSoldier:__init()
  self.req = nil
  self.anim = nil
  self.controller = nil
  self.animEffectController = nil
  self.soldierId = nil
  self.appearanceMeta = nil
  self.firePoint = nil
  self.skillId = nil
  self.index = nil
  self.skillMeta = nil
  self.owner = nil
  self.curState = Const.BossBattleSoldierState.None
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(Const.BossBattleSoldierState.Idle, IdleState.New(self))
  self.fsm:Add(Const.BossBattleSoldierState.Fire, FireState.New(self))
  self.fsm:Add(Const.BossBattleSoldierState.Run, RunState.New(self))
  self.fsm:Add(Const.BossBattleSoldierState.Strike, StrikeState.New(self))
  self.fsm:Add(Const.BossBattleSoldierState.End, EndState.New(self))
  self.bullets = {}
  self.bulletId = 0
end

function T11IdleGameBossBattleSoldier:__delete()
  self:Destroy()
end

function T11IdleGameBossBattleSoldier:OnUpdate(deltaTime)
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

function T11IdleGameBossBattleSoldier:Init(soldierId, appearanceMeta, skillId, index, squad)
  self.soldierId = soldierId
  self.appearanceMeta = appearanceMeta
  self.firePoint = nil
  self.skillId = skillId
  self.index = index
  self.skillMeta = nil
  self.owner = squad
  self.assetPath = DataCenter.T11IdleGameTemplateManager:GetIdleBattleSoldierAssetPath(self.soldierId)
  if string.IsNullOrEmpty(self.assetPath) then
    self.assetPath = Const.DefaultSoldierAssetPath
  end
end

function T11IdleGameBossBattleSoldier:Load(pos, parent, finishCallback)
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
    request.gameObject.transform:Set_localScale(0.7, 0.7, 0.7)
    self.controller = request.gameObject.transform:GetComponent(typeof(CS.T11IdleGameIdleBattleSoldierController))
    self.animEffectController = request.gameObject.transform:GetComponent(typeof(CS.T11IdleGameBossBattleAnimationController))
    self.anim = self.controller:GetMainAnim()
    self.controller:HideBubble(true)
    self.controller:SetSoldierForward(0)
    self.animEffectController:HideAllEffects()
    local appearanceMeta = self.appearanceMeta
    local rootNodeName = PathUtil.GetFileNameWithoutExtension(appearanceMeta.model_path)
    local firePoints = {}
    for i, v in ipairs(appearanceMeta.fire_paths) do
      local firePointPath = rootNodeName .. "/" .. v
      local firePoint = request.gameObject.transform:Find(firePointPath)
      if not firePoint then
        Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.appearanceMeta.id .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. firePointPath)
      end
      table.insert(firePoints, firePoint)
    end
    self.firePoint = firePoints[1]
    self:InitSkill()
    if finishCallback then
      finishCallback()
    end
  end)
  self.req = req
end

function T11IdleGameBossBattleSoldier:Destroy()
  if self.req then
    self.req:Destroy()
  end
  self.req = nil
  if self.fsm then
    self.fsm:Dispose()
    self.fsm = nil
  end
  if self.bullets then
    for i, v in pairs(self.bullets) do
      if v then
        v:Destroy()
      end
    end
    self.bullets = nil
  end
  self.bulletId = nil
  self.curState = nil
  self.soldierId = nil
  self.appearanceMeta = nil
  self.skillId = nil
  self.index = nil
  self.skillMeta = nil
  self.owner = nil
  self.firePoint = nil
  self.anim = nil
  self.controller = nil
  self.animEffectController = nil
end

function T11IdleGameBossBattleSoldier:ChangeState(state, ...)
  if self.curState == state then
    return
  end
  self.curState = state
  self.fsm:Switch(state, ...)
end

function T11IdleGameBossBattleSoldier:PlayAnim(animName, queueAnimName)
  if IsNotNull(self.anim) then
    if self.anim:IsPlaying(animName) then
      self.anim:Rewind(animName)
    else
      self.anim:CrossFade(animName, 0.2)
    end
    if queueAnimName ~= nil then
      self.anim:CrossFadeQueued(queueAnimName, 0.2, CS.UnityEngine.QueueMode.CompleteOthers)
    end
  end
end

function T11IdleGameBossBattleSoldier:SetAnimSpeed(animName, speed)
  if IsNotNull(self.anim) then
    self.anim:SetStateSpeed(animName, speed)
  end
end

function T11IdleGameBossBattleSoldier:GetFirePoint()
  return self.firePoint
end

function T11IdleGameBossBattleSoldier:InitSkill()
  if self.skillId then
    self.skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(self.skillId)
  else
    Logger.LogError("\232\139\177\233\155\132\230\151\1601\230\138\128\232\131\189,\232\139\177\233\155\132appId\239\188\154" .. self.appearanceMeta.id)
  end
end

function T11IdleGameBossBattleSoldier:GetSkillMeta()
  return self.skillMeta
end

function T11IdleGameBossBattleSoldier:GetPosition()
  if IsNotNull(self.controller) then
    return self.controller.transform.position
  end
  return Vector3.New(0, 0, 0)
end

function T11IdleGameBossBattleSoldier:FireBullet(asset, startPos, endPos, speed, onBulletHit)
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

function T11IdleGameBossBattleSoldier:GetBossHitTargetIndex()
  for i, v in pairs(Const.BossBattleSoldierTargetMonster) do
    for _, index in pairs(v) do
      if index == self.index then
        return i
      end
    end
  end
end

function T11IdleGameBossBattleSoldier:SetSoldierLookAt(position)
  if IsNotNull(self.controller) then
    self.controller:SetSoldierLookAt(position)
  end
end

function T11IdleGameBossBattleSoldier:SetSoldierForward(yAngle, duration)
  if IsNotNull(self.controller) then
    self.controller:SetSoldierForward(yAngle, checknumber(duration))
  end
end

function T11IdleGameBossBattleSoldier:TryPlayFireSound(waveIndex)
  if self.owner then
    self.owner:TryPlayFireSound(waveIndex)
  end
end

return T11IdleGameBossBattleSoldier
