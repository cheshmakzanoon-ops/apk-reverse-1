local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local T11IdleGameIdleBattleMonster = BaseClass("T11IdleGameIdleBattleMonster")
local ResourceManager = CS.GameEntry.Resource
local FSMachine = require("Common.FSMachine")
local BattleState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Monster/State/T11IdleGameIdleBattleMonsterStateBattle")
local IdleState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Monster/State/T11IdleGameIdleBattleMonsterStateIdle")
local RunState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Monster/State/T11IdleGameIdleBattleMonsterStateRun")
local DeadState = require("DataCenter/T11IdleGame/IdleBattle/Battle/Monster/State/T11IdleGameIdleBattleMonsterStateDead")

function T11IdleGameIdleBattleMonster:__init(node)
  self.node = node
  self.monsterMeta = nil
  self.obj = nil
  self.anim = nil
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(Const.NodeBattleMonsterState.Idle, IdleState.New(self))
  self.fsm:Add(Const.NodeBattleMonsterState.Run, RunState.New(self))
  self.fsm:Add(Const.NodeBattleMonsterState.Battle, BattleState.New(self))
  self.fsm:Add(Const.NodeBattleMonsterState.Dead, DeadState.New(self))
end

function T11IdleGameIdleBattleMonster:__delete()
  self:Destroy()
end

function T11IdleGameIdleBattleMonster:Init(monsterMeta, position, rotation, scale, parent, finishCallback)
  self.monsterMeta = monsterMeta
  local req = ResourceManager:InstantiateAsync(self.monsterMeta.asset)
  req:completed("+", function(request)
    if request.isError then
      return
    end
    request.gameObject.transform:SetParent(parent.transform)
    request.gameObject.transform:Set_localPosition(position:Split())
    request.gameObject.transform:Set_localEulerAngles(rotation:Split())
    request.gameObject.transform:Set_localScale(scale, scale, scale)
    self.obj = request.gameObject
    self.anim = request.gameObject.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self:PlayAnim(AnimName.Idle)
    if finishCallback then
      finishCallback()
    end
  end)
  self.req = req
end

function T11IdleGameIdleBattleMonster:Destroy()
  if self.req then
    self.req:Destroy()
  end
  self.req = nil
  self.monsterMeta = nil
  self.obj = nil
  self.anim = nil
  if self.fsm then
    self.fsm:Dispose()
    self.fsm = nil
  end
end

function T11IdleGameIdleBattleMonster:GetAnimLength(name)
  if IsNotNull(self.anim) then
    return self.anim:GetClipLength(name)
  end
  return 1
end

function T11IdleGameIdleBattleMonster:CrossFadeAnim(name)
  if IsNotNull(self.anim) then
    self.anim:CrossFade(name, 0.2)
  end
end

function T11IdleGameIdleBattleMonster:PlayAnim(name)
  if IsNotNull(self.anim) then
    if self.anim:IsPlaying(name) then
      self.anim:Rewind(name)
    else
      self.anim:CrossFade(name, 0.2)
    end
  end
end

function T11IdleGameIdleBattleMonster:GetHitPosition()
  if IsNotNull(self.obj) then
    return self.obj.transform.position
  end
  return Vector3.zero
end

function T11IdleGameIdleBattleMonster:IsLoaded()
  return IsNotNull(self.obj)
end

function T11IdleGameIdleBattleMonster:ChangeState(state, ...)
  self.fsm:Switch(state, ...)
end

function T11IdleGameIdleBattleMonster:BeHit()
  local curState = self.fsm:GetCurState()
  if curState and curState.BeHit then
    curState:BeHit()
  end
end

function T11IdleGameIdleBattleMonster:SetActive(value)
  if IsNotNull(self.obj) then
    self.obj:SetActive(value)
  end
end

function T11IdleGameIdleBattleMonster:GetMonsterId()
  if self.monsterMeta then
    return self.monsterMeta.id
  end
  return 0
end

return T11IdleGameIdleBattleMonster
