local base = require("Scene.LWBattle.UnitBase")
local Minion = BaseClassCache("Minion", base)
local FSM = require("Framework.Common.FSM")
local FireStateAuto = require("Scene.LWBattle.Skirmish.UnitFSM.MinionFSM.FireStateAuto")
local FireStateIdle = require("Scene.LWBattle.Skirmish.UnitFSM.MinionFSM.FireStateIdle")
local FireStateDie = require("Scene.LWBattle.Skirmish.UnitFSM.MinionFSM.FireStateDie")
local MoveStatePath = require("Scene.LWBattle.Skirmish.UnitFSM.MinionFSM.MoveStatePath")
local MoveStateStay = require("Scene.LWBattle.Skirmish.UnitFSM.MoveStateStay")
local Resource = CS.GameEntry.Resource

function Minion:DestroyData()
  self.skillMeta = nil
  self.maxCD = nil
  self.curCD = nil
  self.hero = nil
  self.meta = nil
  self.isHuman = nil
  self.cannon = nil
  self.angular_speed_deg = nil
  self.sceneData = nil
  self.battleData = nil
  self.logic = nil
  self.platoon = nil
  self.heroData = nil
  self.localPosition = nil
  base.DestroyData(self)
end

function Minion:Init(logic, platoon, heroData, localPos, index)
  base.Init(self, logic)
  self.logic = logic
  self.sceneData = self.logic.sceneData
  self.battleData = self.logic.battleData
  self.platoon = platoon
  self.heroData = heroData
  self.guid = self.logic:AllotUnitGuid()
  self.curPos = Vector3.zero
  self.dirMultiplier = self.platoon.dirMultiplier
  self:SetLocalPosition(localPos)
  self.index = index
  self.hero = heroData
  self.meta = self.hero.meta
  self.isHuman = true
  self.unitType = UnitType.Plot
  local path = self.hero.appearanceMeta.model_path
  self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
  self.maxBlood = self.hero:GetMaxHp()
  self.curBlood = self.maxBlood
  self.req = Resource:InstantiateAsync(path, ObjectPoolTag.Battle)
  self.req:completed("+", function(request)
    self.gameObject = request.gameObject
    self.transform = request.gameObject.transform
    self.transform:SetParent(self.platoon.transform)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
    self:ComponentDefine()
    self:InitFSM()
    local appearanceMeta = self.hero.appearanceMeta
    self.transform:Set_localScale(appearanceMeta.model_size, appearanceMeta.model_size, appearanceMeta.model_size)
    local fire_paths = appearanceMeta.fire_paths
    self.firePoints = {}
    for i, v in ipairs(fire_paths) do
      local firePoint = self.transform:Find(v)
      if not firePoint then
        Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. v)
      end
      table.insert(self.firePoints, firePoint)
    end
    self.firePoint = self.firePoints[1]
    self.cannon = self.transform
    self.angular_speed_deg = self.meta.angular_speed * 60
    self:InitSkill()
    self:EnableCollider(false)
  end)
end

function Minion:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(SkirmishFireState.Idle, FireStateIdle.New(self))
  self.fsm:AddState(SkirmishFireState.Die, FireStateDie.New(self))
  self.fsm:AddState(SkirmishFireState.Auto, FireStateAuto.New(self))
  self.fsm:ChangeState(SkirmishFireState.Idle)
  self.moveFsm = FSM.New()
  self.moveFsm:AddState(SkirmishMoveState.Path, MoveStatePath.New(self))
  self.moveFsm:AddState(SkirmishMoveState.Stay, MoveStateStay.New(self))
  self.moveFsm:ChangeState(SkirmishMoveState.Stay)
end

function Minion:InitSkill()
  local skillInfo = self.hero:GetHeroSkillBySlotIndex(1)
  if skillInfo then
    self.skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillInfo.skillId)
    self.maxCD = self.sceneData.MINION_ATTACK_CD
    self.curCD = math.random() * self.sceneData.MINION_ATTACK_PRECD
  else
    Logger.LogError("\232\139\177\233\155\132\230\151\1601\230\138\128\232\131\189,\232\139\177\233\155\132Id\239\188\154" .. self.hero.heroId)
  end
end

function Minion:GetRawProperty(type)
  if self.hero == nil then
    return 0
  end
  return self.hero:GetHeroProperty(type)
end

function Minion:ChangeStage(stage)
  if stage == SkirmishStage.Load then
  elseif stage == SkirmishStage.Opening then
    if self.moveFsm then
      self.moveFsm:ChangeState(SkirmishMoveState.Path)
    end
  elseif stage == SkirmishStage.Fight then
    self.fsm:ChangeState(SkirmishFireState.Auto, self.curCD, self.maxCD, self.skillMeta)
  elseif stage == SkirmishStage.End and self.fsm and self.fsm:GetStateIndex() ~= SkirmishFireState.Die then
    self.fsm:ChangeState(SkirmishFireState.Idle)
  end
end

function Minion:SetMinionFightPause(isPause)
  if not isPause then
    self.fsm:ChangeState(SkirmishFireState.Auto, self.curCD, self.maxCD, self.skillMeta)
  else
    self.fsm:ChangeState(SkirmishFireState.Idle)
  end
end

function Minion:StopMoving()
  if self.moveFsm then
    self.moveFsm:ChangeState(SkirmishMoveState.Stay)
  end
  self:CrossFadeSimpleAnim(AnimName.Idle, 1, 0.2)
end

function Minion:GoDie()
  self.curBlood = 0
  self.fsm:ChangeState(SkirmishFireState.Die)
  self.moveFsm:ChangeState(SkirmishMoveState.Stay)
  if self.heroEffectMeta then
    local effectMeta = self.heroEffectMeta
    self.logic:ShowEffectObj(effectMeta.death_effect_nomal, self:GetPosition(), nil, nil)
    local bloodEffect = effectMeta:GetRandomBlood()
    if bloodEffect then
      self.logic:ShowEffectObj(bloodEffect, self:GetPosition(), nil, -1, nil, EffectObjType.Sprite)
    end
    if effectMeta.deathShakeParam then
      self.logic:ShakeCameraWithParam(effectMeta.deathShakeParam)
    end
  end
end

function Minion:Revive()
  self:ShowOrHide(true)
  self.curBlood = self.bloodBeforeDie or self.maxBlood
  self.fsm:ChangeState(SkirmishFireState.Idle)
  self.moveFsm:ChangeState(SkirmishMoveState.Stay)
end

function Minion:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id]
  end
  return self:GetFirePoint()
end

function Minion:GetFirePoint()
  return self.firePoint
end

function Minion:GetMoveVelocity()
  if self:IsMoving() then
    return self.platoon:GetMoveVelocity()
  else
    return Vector3.zero
  end
end

function Minion:IsMoving()
  return self.moveFsm and self.moveFsm:GetStateIndex() == SkirmishMoveState.Path
end

function Minion:Rotate(degree)
  self.transform:Rotate(Vector3.up, degree)
end

function Minion:GetPosition()
  if self.transform then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  else
    return self.platoon:GetPosition() + self.localPosition * self.dirMultiplier
  end
end

function Minion:SetLocalPosition(localPos)
  self.localPosition = localPos
  if self.transform then
    self.transform:Set_localPosition(localPos.x, localPos.y, localPos.z)
  end
end

function Minion:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(self.anim) then
    self.anim.transform:Set_localPosition(0, 0, 0)
  end
end

function Minion:DestroyView()
  base.DestroyView(self)
  if self.moveFsm then
    self.moveFsm:Delete()
    self.moveFsm = nil
  end
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  if self.req then
    self.req:Destroy()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
  end
  self.firePoint = nil
  self.anim = nil
end

function Minion:OnUpdate(deltaTime)
  if self.moveFsm then
    self.moveFsm:OnUpdate(deltaTime)
  end
  if self.fsm then
    self.fsm:OnUpdate(deltaTime)
  end
end

return Minion
