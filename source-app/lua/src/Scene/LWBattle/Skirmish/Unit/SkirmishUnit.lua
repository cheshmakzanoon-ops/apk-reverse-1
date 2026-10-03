local base = require("Scene.LWBattle.UnitBase")
local SkirmishUnit = BaseClassCache("SkirmishUnit", base)
local FSM = require("Framework.Common.FSM")
local MoveStatePath = require("Scene.LWBattle.Skirmish.UnitFSM.MoveStatePath")
local FireStateIdle = require("Scene.LWBattle.Skirmish.UnitFSM.FireStateIdle")
local FireStateDie = require("Scene.LWBattle.Skirmish.UnitFSM.FireStateDie")
local BattleTimeline = require("Scene.LWBattle.Skirmish.BattleTimeline.BattleTimeline")

function SkirmishUnit:Init(logic, platoon, heroData, localPos, index)
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
  self.timeline = BattleTimeline.New(self)
end

function SkirmishUnit:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(SkirmishFireState.TeamMove, MoveStatePath.New(self))
  self.fsm:AddState(SkirmishFireState.Idle, FireStateIdle.New(self))
  self.fsm:AddState(SkirmishFireState.Die, FireStateDie.New(self))
  self.fsm:ChangeState(SkirmishFireState.Idle)
  self:ChangeStage(self.logic.stage)
end

function SkirmishUnit:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate()
  end
  if self.timeline then
    self.timeline:Update()
  end
end

function SkirmishUnit:DestroyView()
  base.DestroyView(self)
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
  self.firePointNull = true
  self.anim = nil
  self.timeline:Delete()
end

function SkirmishUnit:DestroyData()
  self.sceneData = nil
  self.battleData = nil
  self.logic = nil
  self.platoon = nil
  self.heroData = nil
  self.localPosition = nil
  base.DestroyData(self)
end

function SkirmishUnit:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(self.anim) then
    self.anim.transform:Set_localPosition(0, 0, 0)
  end
end

function SkirmishUnit:SetLocalPosition(localPos)
  self.localPosition = localPos
  if self.transform then
    self.transform:Set_localPosition(localPos.x, localPos.y, localPos.z)
  end
end

function SkirmishUnit:GetPosition()
  if self.transform then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  else
    return self.platoon:GetPosition() + self.localPosition * self.dirMultiplier
  end
end

function SkirmishUnit:Rotate(degree)
  self.transform:Rotate(Vector3.up, degree)
end

function SkirmishUnit:IsMoving()
  return self.fsm and self.fsm:GetStateIndex() == SkirmishFireState.TeamMove
end

function SkirmishUnit:GetMoveVelocity()
  if self:IsMoving() then
    return self.platoon:GetMoveVelocity()
  else
    return Vector3.zero
  end
end

function SkirmishUnit:GetFirePoint()
  return self.firePoint, self.firePointNull
end

function SkirmishUnit:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id], false
  end
  return self:GetFirePoint()
end

function SkirmishUnit:ChangeStage(stage)
  if stage == SkirmishStage.Load then
  elseif stage == SkirmishStage.Opening then
    if self.fsm then
      self.fsm:ChangeState(SkirmishFireState.TeamMove)
    end
  elseif stage == SkirmishStage.Fight then
  elseif stage == SkirmishStage.End and self.fsm and self.fsm:GetStateIndex() ~= SkirmishFireState.Die then
    self.fsm:ChangeState(SkirmishFireState.Idle)
  end
end

function SkirmishUnit:GoDie()
  self.curBlood = 0
  self.fsm:ChangeState(SkirmishFireState.Die)
  if self.buffManager then
    self.buffManager:RemoveAllBuff()
  end
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

function SkirmishUnit:Revive()
  self:ShowOrHide(true)
  self.curBlood = self.bloodBeforeDie or self.maxBlood
  self.fsm:ChangeState(SkirmishFireState.Idle)
end

function SkirmishUnit:StopMoving()
  if self.fsm then
    self.fsm:ChangeState(SkirmishFireState.Idle)
  end
end

function SkirmishUnit:OnBuffAdded(buff)
  self:OnBuffPropertyDirty()
end

function SkirmishUnit:OnBuffRemoved(buff)
  self:OnBuffPropertyDirty()
end

function SkirmishUnit:GetSkillSlotIndex(skillId)
  if self.skillManager then
    local skillData = self.skillManager:GetSkillById(skillId)
    if not skillData or not skillData.skillInfo then
      return 0
    end
    local skillInfo = skillData.skillInfo
    return skillInfo and skillInfo.slotIndex or 0
  end
  return 0
end

function SkirmishUnit:GetSkillInfo(skillId)
  if self.skillManager then
    local skillData = self.skillManager:GetSkillById(skillId)
    if not skillData or not skillData.skillInfo then
      return nil
    end
    return skillData.skillInfo
  end
  return nil
end

function SkirmishUnit:GetSplashDamageBullet()
  local bulletId
  if self:HasBuffManager() then
    local function GetBuffBullet(buff)
      if buff then
        local rawPara = buff.meta.rawPara
        
        if rawPara then
          local para = string.match(rawPara, "([^;]*)")
          if para then
            bulletId = tonumber(para)
            return false
          end
        end
      end
      return true
    end
    
    self:DoActionForTypeBuff(BuffType.SplashDamage, GetBuffBullet)
  end
  return bulletId
end

local BattletimelineClipInfo = require("Scene.LWBattle.Skirmish.BattleTimeline.TimelineClipInfo.BattleTimelineClipInfo")
local BattleTimelineEnum = require("Scene.LWBattle.Skirmish.BattleTimeline.BattleTimelineEnum")
local BattleTimelineClipType = BattleTimelineEnum.BattleTimelineClipType
local BattleTimelineTrackType = BattleTimelineEnum.BattleTimelineTrackType
local ClipInfoUtils = require("Scene.LWBattle.Skirmish.BattleTimeline.ClipInfoUtils")

function SkirmishUnit:Tl_PlaySimpleAnim(name, time, speed, fallbackToIdle)
  local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.PlayAnimation, time, 0, false, 0, name, speed, fallbackToIdle)
  self.timeline:AddClip(clipInfo)
end

function SkirmishUnit:Tl_CrossFadeSimpleAnim(name, time, speed, fadeTime, fallbackToIdle)
  local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.CrossFadeAnimation, time, 0, false, 0, name, speed, fadeTime, fallbackToIdle)
  self.timeline:AddClip(clipInfo)
end

function SkirmishUnit:Tl_RewindAndPlaySimpleAnim(name, time, speed, fallbackToIdle)
  local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.RewindAndPlayAnimation, time, 0, false, 0, name, speed, fallbackToIdle)
  self.timeline:AddClip(clipInfo)
end

function SkirmishUnit:Tl_SetRotation(rotation)
  if self.timeline:IsTrackRunning(BattleTimelineTrackType.Rotate) then
    return
  end
  self.transform.localRotation = rotation
end

function SkirmishUnit:PlayPositionTimeline(timeline)
  if not timeline then
    return
  end
  for i = 1, #timeline do
    local node = timeline[i]
    if node.type == SkillMovingLogicType.TeamZeroPos then
      local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.Move, node.duration, node.time, false, 1, true, self:GetTeamZeroWorldPos())
      self.timeline:AddClip(clipInfo)
    elseif node.type == SkillMovingLogicType.UnitNormalFormationPos then
      local position = self:GetUnitPositionInTeam()
      local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.Move, node.duration, node.time, false, 1, false, position)
      self.timeline:AddClip(clipInfo)
    elseif node.type == SkillMovingLogicType.PlayAnimation then
      if node.para then
        local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.RewindAndPlayAnimation, node.duration, node.time, false, 1, node.para, 1)
        self.timeline:AddClip(clipInfo)
      end
    elseif node.type == SkillMovingLogicType.MoveToIndex then
      if node.para then
        local index = tonumber(node.para)
        if not self.battleData.IsAtkHero(self.index) then
          index = self.sceneData.GetOpponentHero(index)
        end
        local position = self.sceneData:GetHeroPos(index)
        local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.Move, node.duration, node.time, false, 1, true, position)
        self.timeline:AddClip(clipInfo)
      end
    elseif node.type == SkillMovingLogicType.RotateToIndex then
      if node.para then
        local index = tonumber(node.para)
        if not self.battleData.IsAtkHero(self.index) then
          index = self.sceneData.GetOpponentHero(index)
        end
        local position = self.sceneData:GetHeroPos(index)
        local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.RotateToTargetPos, node.duration, node.time, false, 1, position)
        self.timeline:AddClip(clipInfo)
      end
    elseif node.type == SkillMovingLogicType.LockPos then
      if node.para then
        local clipInfo = ObjectPool:GetInstance():Load(BattletimelineClipInfo)
        clipInfo:Init(BattleTimelineClipType.Base, node.duration, node.time, false, 1)
        self.timeline:AddClip(clipInfo, BattleTimelineTrackType.Move)
      end
    elseif node.type == SkillMovingLogicType.LockRotate then
      if node.para then
        local clipInfo = ObjectPool:GetInstance():Load(BattletimelineClipInfo)
        clipInfo:Init(BattleTimelineClipType.Base, node.duration, node.time, false, 1)
        self.timeline:AddClip(clipInfo, BattleTimelineTrackType.Rotate)
      end
    elseif node.type == SkillMovingLogicType.RotateToFormationPos then
      if node.para then
        local position = self:GetUnitPositionInTeam()
        position = self.transform:TransformPoint(position)
        local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.RotateToTargetPos, node.duration, node.time, false, 1, position)
        self.timeline:AddClip(clipInfo)
      end
    elseif node.type == SkillMovingLogicType.RotateToAngle then
      if node.para then
        local angle = tonumber(node.para)
        local vector = Vector3.New(angle, angle, angle)
        local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.RotateToAngle, node.duration, node.time, false, 1, vector)
        self.timeline:AddClip(clipInfo)
      end
    elseif node.type == SkillMovingLogicType.CrossFade then
      if node.para then
        local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.CrossFadeAnimation, node.duration, node.time, false, 1, node.para, 1, 0.1)
        self.timeline:AddClip(clipInfo)
      end
    elseif node.type == SkillMovingLogicType.TeamCustomPos and node.para then
      local x, y, z = string.match(node.para, "([%-]?%d+%.?%d*);([%-]?%d+%.?%d*);([%-]?%d+%.?%d*)")
      if not self.battleData.IsAtkHero(self.index) then
        x = -1 * x
      end
      local position = Vector3.New(checknumber(x), checknumber(y), checknumber(z))
      local teamRootTransform = self:GetTeamRootTransform()
      position = teamRootTransform:TransformPoint(position)
      local clipInfo = ClipInfoUtils.GetClipInfo(BattleTimelineClipType.Move, node.duration, node.time, false, 1, true, position)
      self.timeline:AddClip(clipInfo)
    end
  end
end

function SkirmishUnit:CastSkill(skill, target)
  if self.skillManager then
    self.skillManager:ActiveCast(skill, target)
  end
end

SkirmishUnit.UpdatePosTimeLine = SkirmishUnit.UpdatePosTimeLine
return SkirmishUnit
