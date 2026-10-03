local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.MonsterObj")
local Const = require("Scene.LWBattle.Const")
local BornState = require("Scene.LWBattle.SkyBattle.MonsterState.MonsterStateBorn")
local SearchTargetState = require("Scene.LWBattle.SkyBattle.MonsterState.MonsterStateSearchTarget")
local AttackState = require("Scene.LWBattle.SkyBattle.MonsterState.MonsterStateAttack")
local DieState = require("Scene.LWBattle.SkyBattle.MonsterState.MonsterStateDie")
local HitLState = require("Scene.LWBattle.SkyBattle.MonsterState.MonsterStateHitL")
local HitRState = require("Scene.LWBattle.SkyBattle.MonsterState.MonsterStateHitR")
local FSM = require("Framework.Common.FSMWithPool")
local MultHpBarCell = require("DataCenter.ZombieBattle.HpBar.MultHpBarCell")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local SkyBattleAIMonster = BaseClassCache("SkyBattleAIMonster", base)
local MoveType = {
  Circle = 1,
  EllipseLike = 2,
  PingPong = 3,
  OffsetBezier3 = 4
}
local FULL_CIRCLE_RADIAN = 6.28318
local MAX_Z_EULER = 30
local MAX_PING_PONG_Z_EULER = 5
local MAX_PING_PONG_FLOAT_HEIGHT = 1
local HP_BAR_VISIBLE_TIME = 3
local Vector3Zero = Vector3.New(0, 0, 0)

function SkyBattleAIMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.monsterMeta = monsterMeta
  self.currState = nil
  self.stateList = {}
  self.attackTargetId = nil
  self.isVisible = true
  self.skillManager = SkillManager.New(self.logic, self)
  self.isBoss = monsterMeta.is_boss == 1 or monsterMeta.monster_type == Const.MonsterType.Boss
  self.eulerY = 180
  self.bloodDirty = false
  self.layer = LayerMask.NameToLayer("Zombie")
  self.invincibleWhenCmpGroupStatus = true
  self.compGroupStatus = 1
  self.allGroupStatusFinish = false
  self.colliderCenterPos = Vector3.New(0, 0, 0)
  self.useColliderPos = true
  self.curFramePosition = Vector3.New(x, 0, y)
  self.curFrameForward = Vector3.New(0, 0, 1)
  self.lastFrameForward = Vector3.New(self.curFrameForward.x, self.curFrameForward.y, self.curFrameForward.z)
end

function SkyBattleAIMonster:InitStatusCmpGroups(status)
  local statusGroupParamIndices = self.monsterMeta.status_group_params[status]
  if not statusGroupParamIndices then
    return false
  end
  self.curStatusCmpGroupsParams = {}
  self.curStatusCmpGroupAliveMonsterCount = {}
  self.curStatusCmpGroupMonsterObjs = {}
  for i, groupParamIndic in ipairs(statusGroupParamIndices) do
    local cmpGroupParams = self.monsterMeta.comp_group_params[groupParamIndic]
    local groupAliveMonsterCount = 0
    if cmpGroupParams then
      self.curStatusCmpGroupsParams[groupParamIndic] = cmpGroupParams
      self:ChangeViewWhenGroupAliveOrInAlive(cmpGroupParams, true)
      local groupMonsters = {}
      self.curStatusCmpGroupMonsterObjs[groupParamIndic] = groupMonsters
      local groupIndic = cmpGroupParams.groupIndic
      local groupCmpMonsterIndices = self.monsterMeta.comp_groups[groupIndic]
      if groupCmpMonsterIndices then
        groupAliveMonsterCount = #groupCmpMonsterIndices
        for j, cmpMonsterIndic in ipairs(groupCmpMonsterIndices) do
          local cmpMonsterParam = self.monsterMeta.comp_monsters[cmpMonsterIndic]
          local monsterId = cmpMonsterParam.monsterId
          local monsterAttachedCmpIndex = cmpMonsterParam.cmpPathIndic
          local cmpMonsterTemplate = DataCenter.PveMonsterTemplateManager:GetSkyBattleTemplate(monsterId)
          if cmpMonsterTemplate and (cmpMonsterTemplate.monster_type == Const.MonsterType.SkyBattleNormal or cmpMonsterTemplate.monster_type == Const.MonsterType.SkyBattleCollider) then
            local monster = self.mgr:CreateMonster(0, 0, monsterId, nil, nil)
            if monster then
              groupMonsters[monster.guid] = monster
              local cmpMonsterAttachedPoint = self:GetCmpPointByIndex(monsterAttachedCmpIndex)
              monster:SetCmpProperty(self, cmpMonsterAttachedPoint or self.transform, Vector3Zero, Vector3Zero, groupParamIndic)
            end
          end
        end
      end
    end
    self.curStatusCmpGroupAliveMonsterCount[groupParamIndic] = groupAliveMonsterCount
  end
  if self.curStatusCmpGroupMonsterObjs then
    for i, groupCmpMonsters in pairs(self.curStatusCmpGroupMonsterObjs) do
      for j, cmpMonster in pairs(groupCmpMonsters) do
        if cmpMonster then
          cmpMonster:Load()
        end
      end
    end
  end
  return true
end

function SkyBattleAIMonster:ChangeViewWhenGroupAliveOrInAlive(groupParam, alive)
  if not groupParam then
    return
  end
  if alive then
    for i, aliveShowSkinIndic in ipairs(groupParam.aliveShowSkinIndices) do
      local aliveShowSkinPoint = self:GetSkinObjPointByIndex(aliveShowSkinIndic)
      if IsNotNull(aliveShowSkinPoint) then
        aliveShowSkinPoint.gameObject:SetActive(true)
      end
    end
    for i, aliveHideSkinIndic in ipairs(groupParam.aliveHideSkinIndices) do
      local aliveHideSkinPoint = self:GetSkinObjPointByIndex(aliveHideSkinIndic)
      if IsNotNull(aliveHideSkinPoint) then
        aliveHideSkinPoint.gameObject:SetActive(false)
      end
    end
  else
    for i, inAliveShowSkinIndic in ipairs(groupParam.inAliveShowSkinIndices) do
      local inAliveShowSkinPoint = self:GetSkinObjPointByIndex(inAliveShowSkinIndic)
      if IsNotNull(inAliveShowSkinPoint) then
        inAliveShowSkinPoint.gameObject:SetActive(true)
      end
    end
    for i, inAliveHideSkinIndic in ipairs(groupParam.inAliveHideSkinIndices) do
      local inAliveHideSkinPoint = self:GetSkinObjPointByIndex(inAliveHideSkinIndic)
      if IsNotNull(inAliveHideSkinPoint) then
        inAliveHideSkinPoint.gameObject:SetActive(false)
      end
    end
  end
  if groupParam.inAliveAnim and not alive then
    local inAliveChangeStatus = self:GetAnimTargetStatusType(groupParam.inAliveAnim)
    if inAliveChangeStatus then
      self.fsm:ChangeState(inAliveChangeStatus)
    end
  end
end

function SkyBattleAIMonster:GetAnimTargetStatusType(animName)
  if animName == SkyBattleAnimName.HitL then
    return SkyBattleMonsterStateType.HitL
  elseif animName == SkyBattleAnimName.HitR then
    return SkyBattleMonsterStateType.HitR
  elseif animName == SkyBattleAnimName.Idle then
    return SkyBattleMonsterStateType.SearchTarget
  elseif animName == SkyBattleAnimName.Attack then
    return SkyBattleMonsterStateType.Attack
  elseif animName == SkyBattleAnimName.Dead then
    return SkyBattleMonsterStateType.Die
  elseif animName == SkyBattleAnimName.Born then
    return SkyBattleMonsterStateType.Born
  elseif animName == SkyBattleAnimName.Hurt then
  end
end

function SkyBattleAIMonster:SetViewParam(viewParamStr)
  local viewParam = viewParamStr
  self.viewParamStr = viewParam
  if not string.IsNullOrEmpty(viewParam) then
    local split = string.split(viewParam, ",")
    self.view_type = not string.IsNullOrEmpty(split[1]) and tonumber(split[1]) or 0
    self.view_z_offset = not string.IsNullOrEmpty(split[2]) and tonumber(split[2]) or 0
  end
end

function SkyBattleAIMonster:SetMoveParam(moveParamStr)
  local moveParam = moveParamStr
  self.moveParamStr = moveParam
  if not string.IsNullOrEmpty(moveParam) then
    local split = string.split(moveParam, ";")
    self.move_type = not string.IsNullOrEmpty(split[1]) and tonumber(split[1]) or 1
    if not string.IsNullOrEmpty(split[2]) then
      local offsetStrs = string.split(split[2], ",")
      local offsetX = not string.IsNullOrEmpty(offsetStrs[1]) and tonumber(offsetStrs[1]) or 0
      local offsetY = not string.IsNullOrEmpty(offsetStrs[2]) and tonumber(offsetStrs[2]) or 0
      self.move_center_offset = Vector2.New(offsetX, offsetY)
      if offsetStrs[3] and offsetStrs[4] then
        local offsetXP2 = tonumber(offsetStrs[3])
        local offsetYP2 = tonumber(offsetStrs[4])
        self.move_center_offset_2 = Vector2.New(offsetXP2, offsetYP2)
      end
    end
    if not string.IsNullOrEmpty(split[3]) then
      local paramStrs = string.split(split[3], ",")
      local param1 = not string.IsNullOrEmpty(paramStrs[1]) and tonumber(paramStrs[1]) or 1
      local param2 = not string.IsNullOrEmpty(paramStrs[2]) and tonumber(paramStrs[2]) or 0
      self.move_params = {}
      table.insert(self.move_params, param1)
      table.insert(self.move_params, param2)
    end
    if not string.IsNullOrEmpty(split[4]) then
      self.move_direction = not string.IsNullOrEmpty(split[4]) and tonumber(split[4]) or 0
    end
    if not string.IsNullOrEmpty(split[5]) then
      self.startMoveOffsetZtoMaxVisibleZ = not string.IsNullOrEmpty(split[5]) and tonumber(split[5]) or 0
    end
  end
end

function SkyBattleAIMonster:SetCmpProperty(parentUnit, attachedPoint, localPosition, localEuler, groupParamIndic)
  self.isCmpMonster = true
  self.groupParamIndic = groupParamIndic
  self.parentUnit = parentUnit
  self.cmpAttachedPoint = attachedPoint
  self.childToParentLocalPosition = localPosition
  self.childToParentLocalEuler = localEuler
end

function SkyBattleAIMonster:DestroyView()
  base.DestroyView(self)
  if self.hpBar then
    self.hpBar:Destroy()
    self.hpBar = nil
  end
  if self.hpBarHandle then
    pveUnitViewUtil.DestroyHpBar(self.hpBarHandle)
    self.hpBarHandle = nil
  end
  if self.fsm then
    self.fsm:Delete()
    ObjectPool:GetInstance():Save(self.fsm)
    self.fsm = nil
  end
  if self.skillManager then
    self.skillManager:DestroyView()
  end
  self.anim = nil
end

function SkyBattleAIMonster:DestroyData()
  base.DestroyData(self)
  if self.skillManager then
    self.skillManager:DestroyData()
    ObjectPool:GetInstance():Save(self.skillManager)
    self.skillManager = nil
  end
  self.curStatusCmpGroupMonsterObjs = nil
  self.curStatusCmpGroupAliveMonsterCount = nil
  self.curStatusCmpGroupsParams = nil
  self.cachedCircleCenterPositionX = nil
  self.cachedCircleRadius = nil
  self.cachedCircleRadianSpeed = nil
  self.circleTime = nil
  self.startMoveDiffScrCenterPos = nil
  self.startMove = false
  self.curFramePosition = nil
  self.degreeIncreaseFactor = nil
  self.curRadian = nil
  self.alreadyShowed = nil
  self.moveDirectionFactor = nil
  self.ellipseParams = nil
  self.angularSpeed = nil
  self.isCmpMonster = nil
  self.parentUnit = nil
  self.childToParentLocalPosition = nil
  self.childToParentLocalEuler = nil
  self.viewParamStr = nil
  self.view_type = nil
  self.view_z_offset = nil
  self.moveParamStr = nil
  self.move_type = nil
  self.move_center_offset = nil
  self.move_center_offset_2 = nil
  self.move_params = nil
  self.move_direction = nil
  self.lastDeltaX = nil
  self.lastDeltaZ = nil
  self.monsterMeta = nil
  self.OffsetBezierStartPos = nil
  self.OffsetBezierEndPos = nil
  self.OffsetBezierMiddlePos = nil
  self.offsetBezierTotalTime = 1
  self.OffsetBezierLerpValue = 0
  self.OffsetBezierResetPosDelayTime = 0
  self.remainTimeToResetBezierPos = 0
end

function SkyBattleAIMonster:EnableCollider(enable)
  self.colliderEnabled = enable
  base.EnableCollider(self, self.colliderEnabled)
end

function SkyBattleAIMonster:OnLoadComplete()
  if IsNotNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  self:EnableCollider(false)
  self:InitFsm()
  if not string.IsNullOrEmpty(self.monsterMeta.ui_path) then
    UnitViewFacade.InitUIPoint(self.viewHandle, self.monsterMeta.ui_path)
  end
  self.hasExtFirePath = false
  local fire_paths = self.monsterMeta.fire_paths
  if fire_paths then
    local firePathCount = #fire_paths
    if 0 < firePathCount then
      local append = UnitViewFacade.InitFirePoints(self.viewHandle, self.monsterMeta.id, firePathCount)
      if append then
        for i = 1, firePathCount do
          UnitViewFacade.AppendFirePoint(self.viewHandle, fire_paths[i])
        end
      end
      self.hasExtFirePath = true
    end
  end
  self.cmpPathsCount = #self.monsterMeta.comps_path
  self.skinObjPathsCount = #self.monsterMeta.skin_obj_paths
  local totalCachedCount = self.cmpPathsCount + self.skinObjPathsCount
  if 0 < totalCachedCount then
    local append = UnitViewFacade.InitCompPoints(self.viewHandle, self.monsterMeta.id, totalCachedCount)
    if append then
      for i = 1, self.cmpPathsCount do
        UnitViewFacade.AddCompPoint(self.viewHandle, i - 1, self.monsterMeta.comps_path[i])
      end
      for i = 1, self.skinObjPathsCount do
        UnitViewFacade.AddCompPoint(self.viewHandle, i + self.cmpPathsCount - 1, self.monsterMeta.skin_obj_paths[i])
      end
    end
  end
end

function SkyBattleAIMonster:OnVisible()
  if IsNotNull(self.gameObject) then
    self.gameObject:SetActive(true)
  end
  if not self.isCmpMonster or self.parentUnit.fsm ~= nil and self.parentUnit.fsm:GetStateIndex() ~= nil and self.parentUnit.fsm:GetStateIndex() ~= SkyBattleMonsterStateType.Die and self.parentUnit.fsm:GetStateIndex() ~= SkyBattleMonsterStateType.Born then
    if self.isFromSummon or self.isBoss or self.isCmpMonster then
      self.fsm:ChangeState(SkyBattleMonsterStateType.Born)
    else
      if self:HpBarKeepShow() then
        self:InitHpBar()
      end
      self.fsm:ChangeState(SkyBattleMonsterStateType.SearchTarget)
    end
  end
  local initStatusSuccess = self:InitStatusCmpGroups(self.compGroupStatus)
  self.allGroupStatusFinish = not initStatusSuccess
  self:InitSkills()
  if self.isCmpMonster and self.cmpAttachedPoint and IsNotNull(self.cmpAttachedPoint) then
    self.transform:SetParent(self.cmpAttachedPoint)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_eulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.transform:Set_localPosition(self.childToParentLocalPosition.x, self.childToParentLocalPosition.y, self.childToParentLocalPosition.z)
    self.transform:Set_localEulerAngles(self.childToParentLocalEuler.x, self.childToParentLocalEuler.y, self.childToParentLocalEuler.z)
  end
end

function SkyBattleAIMonster:GetCmpPointByIndex(index)
  return UnitViewFacade.GetCmpPointByIndex(self.viewHandle, index - 1)
end

function SkyBattleAIMonster:GetSkinObjPointByIndex(index)
  return UnitViewFacade.GetCmpPointByIndex(self.viewHandle, index + self.cmpPathsCount - 1)
end

local ViewType = {None = 0, OffsetZ = 1}

function SkyBattleAIMonster:CheckShowCondition(cameraMinVisibleZ, cameraMaxVisibleZ)
  if self.alreadyShowed then
    return true
  end
  if not self.isCmpMonster and self.view_type == ViewType.OffsetZ then
    local viewOffsetZ = self.view_z_offset
    local curPosZ = self:GetPosition().z
    if viewOffsetZ < curPosZ - cameraMaxVisibleZ then
      return false
    end
  end
  self:OnVisible()
  self.alreadyShowed = true
  return true
end

function SkyBattleAIMonster:HpBarKeepShow()
  return (self.monsterMeta.monster_type == Const.MonsterType.Boss or self.isCmpMonster) and self.allGroupStatusFinish
end

function SkyBattleAIMonster:CanBeAttack()
  return (not self.isCmpMonster and self.fsm ~= nil and self.fsm:GetStateIndex() ~= nil and self.fsm:GetStateIndex() ~= SkyBattleMonsterStateType.Die and self.fsm:GetStateIndex() ~= SkyBattleMonsterStateType.Born or self.isCmpMonster and self.parentUnit and self.parentUnit.fsm and self.parentUnit.fsm:GetStateIndex() ~= nil and self.parentUnit.fsm:GetStateIndex() ~= SkyBattleMonsterStateType.Die and self.parentUnit.fsm:GetStateIndex() ~= SkyBattleMonsterStateType.Born and self.fsm ~= nil and self.fsm:GetStateIndex() ~= SkyBattleMonsterStateType.Die and self.fsm:GetStateIndex() ~= SkyBattleMonsterStateType.Born) and (not self.invincibleWhenCmpGroupStatus or self.allGroupStatusFinish)
end

function SkyBattleAIMonster:InitHpBar()
  if self.monsterMeta.hp_bar_num > 1 then
    if not self.hpBar then
      local uiPoint = UnitViewFacade.GetUIPoint(self.viewHandle)
      local parentTrans = uiPoint or self.transform
      self.hpBar = MultHpBarCell.New(Const.HPBarStyle.Enemy, parentTrans, self.monsterMeta.hp_bar_height, self.monsterMeta.hp_bar_num)
      self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
    end
  elseif not self.hpBarHandle then
    self.hpBarHandle = pveUnitViewUtil.CreateEnemyHpBarWithHandle(self.viewHandle, self.monsterMeta.hp_bar_height * 1.0, nil, self.curBlood, self.maxBlood, self:GetShieldValue(), true)
    self.hpBarVisibleTime = HP_BAR_VISIBLE_TIME
  end
end

function SkyBattleAIMonster:InitSkills()
  if self.monsterMeta.skill then
    for _, skillId in pairs(self.monsterMeta.skill) do
      local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
      if skillMeta == nil then
        Logger.LogError("\230\138\128\232\131\189\232\161\168\228\184\173\230\178\161\230\156\137id\228\184\186" .. skillId .. "\231\154\132\230\138\128\232\131\189")
      end
      self.skillManager:AddSkill(skillMeta)
    end
  end
end

function SkyBattleAIMonster:TriggerSkill(triggerType, param)
  if self.skillManager then
    self.skillManager:PassiveCast(triggerType, param)
  end
end

function SkyBattleAIMonster:InitFsm()
  self.fsm = ObjectPool:GetInstance():Load(FSM)
  self.fsm:Init(self)
  if self.isFromSummon or self.isCmpMonster or self.isBoss then
    local bornState = ObjectPool:GetInstance():Load(BornState)
    bornState:Init(self)
    self.fsm:AddState(SkyBattleMonsterStateType.Born, bornState)
  end
  local searchTargetStateObj = ObjectPool:GetInstance():Load(SearchTargetState)
  searchTargetStateObj:Init(self)
  self.fsm:AddState(SkyBattleMonsterStateType.SearchTarget, searchTargetStateObj)
  local attackStateObj = ObjectPool:GetInstance():Load(AttackState)
  attackStateObj:Init(self)
  self.fsm:AddState(SkyBattleMonsterStateType.Attack, attackStateObj)
  local dieStateObj = ObjectPool:GetInstance():Load(DieState)
  dieStateObj:Init(self)
  self.fsm:AddState(SkyBattleMonsterStateType.Die, dieStateObj)
  local hitLStateObj = ObjectPool:GetInstance():Load(HitLState)
  hitLStateObj:Init(self)
  self.fsm:AddState(SkyBattleMonsterStateType.HitL, hitLStateObj)
  local hitRStateObj = ObjectPool:GetInstance():Load(HitRState)
  hitRStateObj:Init(self)
  self.fsm:AddState(SkyBattleMonsterStateType.HitR, hitRStateObj)
end

function SkyBattleAIMonster:SetVisible(visible)
  self.isVisible = visible
  if self.gameObject then
    self.gameObject:SetActive(visible)
  end
end

function SkyBattleAIMonster:OnUpdate(deltaTime)
  if not self.viewLoaded then
    return
  end
  local cameraMinVisibleZ, cameraMaxVisibleZ = self.logic:GetCameraVisiblePlaneMinZAndMaxZ()
  ProfilerUtil.BeginSample("Monster UpdateMove")
  self:UpdateMove(deltaTime, cameraMinVisibleZ, cameraMaxVisibleZ)
  ProfilerUtil.EndSample()
  if not self:CheckShowCondition(cameraMinVisibleZ, cameraMaxVisibleZ) then
    return
  end
  if self.bloodDirty then
    self.bloodDirty = false
    self.hpBarVisibleTime = HP_BAR_VISIBLE_TIME
    if self.curBlood > 0 then
      if self.hpBar then
        self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
      elseif self.hpBarHandle then
        pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
        pveUnitViewUtil.EnableHpBar(self.hpBarHandle, true)
      else
        self:InitHpBar()
      end
    end
  end
  if not self:HpBarKeepShow() and self.hpBarHandle and self.hpBarVisibleTime and self.hpBarVisibleTime > 0 then
    self.hpBarVisibleTime = self.hpBarVisibleTime - deltaTime
    if self.hpBarVisibleTime <= 0 then
      pveUnitViewUtil.EnableHpBar(self.hpBarHandle, false)
    end
  end
  self:UpdateBuffManager()
  self:UpdateFlashCountdown(deltaTime)
  if self.fsm then
    self.fsm:OnUpdate(deltaTime)
  end
  if self.skillManager then
    self.skillManager:OnUpdate(deltaTime)
  end
  if self.hpBar then
    self.hpBar:Update()
  end
  self:UpdateColliderEnable(cameraMinVisibleZ, cameraMaxVisibleZ)
end

function SkyBattleAIMonster:GetCurBlood()
  return self.curBlood
end

function SkyBattleAIMonster:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  local hpPercentBefore = self.curBlood / self.maxBlood
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, dir, hitEff)
  local hpPercentAfter = self.curBlood / self.maxBlood
  if 0 < hurt and self.curBlood > 0 then
    self.bloodDirty = true
  end
  local param = {
    hpPercentBefore = hpPercentBefore,
    hpPercentAfter = hpPercentAfter,
    hurt = hurt
  }
  self:TriggerSkill(SkillTriggerType.BeHitNew, param)
  if self.curBlood <= 0 then
    self:TriggerSkill(SkillTriggerType.Death)
  end
end

function SkyBattleAIMonster:TryHitWhite(whiteTime)
  base.TryHitWhite(self, whiteTime)
  if self.isCmpMonster and self.parentUnit ~= nil then
    self.parentUnit:TryHitWhite(whiteTime)
  end
end

function SkyBattleAIMonster:ChangeFsmState(state)
  if not self.fsm then
    return
  end
  self.fsm:ChangeState(state)
end

function SkyBattleAIMonster:OnCmpGroupMonsterDeath(groupParamIndic, guid)
  if not self.curStatusCmpGroupMonsterObjs then
    return
  end
  local groupMonsters = self.curStatusCmpGroupMonsterObjs[groupParamIndic]
  if not groupMonsters then
    return
  end
  if not groupMonsters[guid] then
    return
  end
  groupMonsters[guid] = nil
  self.curStatusCmpGroupAliveMonsterCount[groupParamIndic] = self.curStatusCmpGroupAliveMonsterCount[groupParamIndic] - 1
  if self.curStatusCmpGroupAliveMonsterCount[groupParamIndic] <= 0 then
    local groupParams = self.curStatusCmpGroupsParams[groupParamIndic]
    self:ChangeViewWhenGroupAliveOrInAlive(groupParams, false)
    local allGroupMonsterDied = true
    for i, aliveMonsterCount in pairs(self.curStatusCmpGroupAliveMonsterCount) do
      if 0 < aliveMonsterCount then
        allGroupMonsterDied = false
        break
      end
    end
    if allGroupMonsterDied then
      local nextGroupStatus = self.compGroupStatus + 1
      local initNextStatus = self:InitStatusCmpGroups(nextGroupStatus)
      if initNextStatus then
        self.compGroupStatus = nextGroupStatus
      else
        self.allGroupStatusFinish = true
        if self:HpBarKeepShow() then
          self:InitHpBar()
        end
      end
    end
  end
end

function SkyBattleAIMonster:Death()
  if self.isCmpMonster and self.parentUnit and self.parentUnit.OnCmpGroupMonsterDeath then
    self.parentUnit:OnCmpGroupMonsterDeath(self.groupParamIndic, self.guid)
  end
  self:ForceDeathCompGroupMonsters()
  if self.fsm then
    self.fsm:ChangeState(SkyBattleMonsterStateType.Die)
  end
  if self.hpBar then
    self.hpBar:Destroy()
    self.hpBar = nil
  end
  if self.hpBarHandle then
    pveUnitViewUtil.DestroyHpBar(self.hpBarHandle)
    self.hpBarHandle = nil
  end
end

function SkyBattleAIMonster:ForceCurStatusGroupCmpChangeToBorn()
  if not self.curStatusCmpGroupMonsterObjs then
    return
  end
  if self.curStatusCmpGroupMonsterObjs then
    for i, groupCmpMonsters in pairs(self.curStatusCmpGroupMonsterObjs) do
      for j, cmpMonster in pairs(groupCmpMonsters) do
        if cmpMonster then
          cmpMonster:ChangeFsmState(SkyBattleMonsterStateType.Born)
        end
      end
    end
  end
end

function SkyBattleAIMonster:ForceDeathCompGroupMonsters()
  if not self.curStatusCmpGroupMonsterObjs then
    return
  end
  for i, groupMonsters in pairs(self.curStatusCmpGroupMonsterObjs) do
    if groupMonsters then
      for guid, cmpMonster in pairs(groupMonsters) do
        if cmpMonster then
          cmpMonster:Death()
        end
      end
    end
  end
  self.curStatusCmpGroupMonsterObjs = {}
end

function SkyBattleAIMonster:CreateBeHitEffect()
end

function SkyBattleAIMonster:SetDestination(x, z)
end

function SkyBattleAIMonster:RemoveDestination()
end

function SkyBattleAIMonster:CheckEnemyInAlertRange()
  local posZ = self.mgr.logic.team:GetPositionZ()
  return math.abs(self.transform.position.z - posZ) <= self.meta.alert_range
end

function SkyBattleAIMonster:GetFirePointById(id)
  if self.hasExtFirePath then
    local point = UnitViewFacade.GetFirePointById(self.viewHandle, id)
    if point ~= nil then
      return point, false
    end
  end
  return self:GetFirePoint()
end

function SkyBattleAIMonster:GetFirePoint()
  return self.transform, false
end

function SkyBattleAIMonster:OnBuffAdded(buff)
  base.OnBuffAdded(self, buff)
end

function SkyBattleAIMonster:OnBuffRemoved(buff)
  base.OnBuffRemoved(self, buff)
end

function SkyBattleAIMonster:GetFreezeXAxisMoveMinDistance()
  return nil
end

function SkyBattleAIMonster:UpdateMove(deltaTime, cameraMinVisibleZ, cameraMaxVisibleZ)
  if self.isCmpMonster then
    return
  end
  if not self.fsm or self.fsm:GetStateIndex() == SkyBattleMonsterStateType.Die then
    return
  end
  local screenX, screenY, screenZ = self.logic:GetCurScreenWorldPositionWithInitX()
  local selfPos = self:GetPosition()
  local startMoveOffset2MaxVisibleZ = self.startMoveOffsetZtoMaxVisibleZ and self.startMoveOffsetZtoMaxVisibleZ or 0
  if not self.startMove and (self.move_type == MoveType.PingPong or self.move_type == MoveType.Circle or self.move_type == MoveType.EllipseLike or self.move_type == MoveType.OffsetBezier3) then
    self.startMove = startMoveOffset2MaxVisibleZ >= selfPos.z - cameraMaxVisibleZ
  end
  if not self.startMove then
    if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
      local add = self.logic:GetMoveSpeedZ() * deltaTime
      local z = selfPos.z - add
      self.curFramePosition.x = selfPos.x
      self.curFramePosition.z = z
      self.curFramePosition.y = selfPos.y
      self:SetPosition(self.curFramePosition)
    end
  else
    if self.fsm:GetStateIndex() == SkyBattleMonsterStateType.Born then
      return
    end
    if not self.startMoveDiffScrCenterPos then
      self.startMoveDiffScrCenterPos = Vector3.New(0, 0, 0)
      self.startMoveDiffScrCenterPos.x = selfPos.x - screenX
      self.startMoveDiffScrCenterPos.z = selfPos.z - screenZ
    end
    if self.move_type == MoveType.PingPong then
      local basePosX = self.startMoveDiffScrCenterPos.x + screenX
      local basePosZ = self.startMoveDiffScrCenterPos.z + screenZ
      if not self.moveDirectionFactor then
        self.moveDirectionFactor = self.move_direction == 0 and -1 or 1
        self.moveHDelta = 0
      end
      local moveHRotation = 0
      local moveHeight = 0
      if self.move_center_offset and self.monsterMeta.move_speed then
        local moveLerpFactor = 0
        local moveLerpDirection = self.moveDirectionFactor
        if 0 < self.moveHDelta and self.move_center_offset.y ~= 0 then
          moveLerpFactor = self.moveHDelta / self.move_center_offset.y
          moveHRotation = moveLerpFactor * MAX_PING_PONG_Z_EULER
          moveLerpDirection = 0 < self.moveDirectionFactor and 1 or -1
        end
        if 0 > self.moveHDelta and self.move_center_offset.x ~= 0 then
          moveLerpFactor = self.moveHDelta / self.move_center_offset.x
          moveHRotation = moveLerpFactor * -1 * MAX_PING_PONG_Z_EULER
          moveLerpDirection = 0 > self.moveDirectionFactor and 1 or -1
        end
        local hFactor = moveLerpDirection * moveLerpFactor * math.pi
        local moveSin = math.sin(hFactor)
        moveHeight = MAX_PING_PONG_FLOAT_HEIGHT * moveSin
        local moveSpeedFactor = moveSin
        local moveSinAbs = math.abs(moveSin)
        local minMoveSpeedFactor = 0.1
        moveSpeedFactor = moveSinAbs < minMoveSpeedFactor and minMoveSpeedFactor or moveSinAbs
        local moveDelta = moveSpeedFactor * (self.moveDirectionFactor * self.monsterMeta.move_speed * deltaTime)
        self.moveHDelta = self.moveHDelta + moveDelta
        if 0 < self.moveHDelta and self.moveHDelta > self.move_center_offset.y or 0 > self.moveHDelta and self.moveHDelta < self.move_center_offset.x then
          if 0 < self.moveHDelta then
            self.moveHDelta = self.move_center_offset.y
          else
            self.moveHDelta = self.move_center_offset.x
          end
          self.moveDirectionFactor = self.moveDirectionFactor * -1
        end
      end
      basePosX = basePosX + self.moveHDelta
      self.curFramePosition.x = basePosX
      self.curFramePosition.y = moveHeight
      self.curFramePosition.z = basePosZ
      self:SetPosition(self.curFramePosition)
      self.transform:Set_eulerAngles(0, -180, moveHRotation)
    elseif self.move_type == MoveType.Circle then
      if not self.moveDirectionFactor then
        self.moveDirectionFactor = self.move_direction == 0 and 1 or -1
      end
      local moveOffSetX = self.move_center_offset and self.move_center_offset.x or 0
      local moveOffSetZ = self.move_center_offset and self.move_center_offset.y or 0
      if not self.cachedCircleRadius then
        local centerDeltaX = selfPos.x - screenX - moveOffSetX
        local centerDeltaZ = selfPos.z - screenZ - moveOffSetZ
        self.cachedCircleRadius = math.max(0.1, math.sqrt(centerDeltaX * centerDeltaX + centerDeltaZ * centerDeltaZ))
        self.curRadian = math.atan(centerDeltaZ, centerDeltaX)
        self.cachedCircleRadianSpeed = self.monsterMeta.move_speed / self.cachedCircleRadius * self.moveDirectionFactor
      end
      self.curRadian = (self.curRadian + self.cachedCircleRadianSpeed * deltaTime) % FULL_CIRCLE_RADIAN
      local deltaX = math.cos(self.curRadian) * self.cachedCircleRadius
      local deltaZ = math.sin(self.curRadian) * self.cachedCircleRadius
      self.curFramePosition.x = screenX + deltaX + moveOffSetX
      self.curFramePosition.z = screenZ + deltaZ + moveOffSetZ
      self:SetPosition(self.curFramePosition)
      local diffYEuler = 0 < self.moveDirectionFactor and 0 or 180
      local eulerY = math.deg(self.curRadian * -1) + diffYEuler
      local eulerZ = self.cachedCircleRadianSpeed * MAX_Z_EULER
      if eulerZ < -MAX_Z_EULER then
        eulerZ = -MAX_Z_EULER
      elseif eulerZ > MAX_Z_EULER then
        eulerZ = MAX_Z_EULER
      end
      self.transform:Set_eulerAngles(0, eulerY, eulerZ)
    elseif self.move_type == MoveType.EllipseLike then
      if not self.moveDirectionFactor then
        self.moveDirectionFactor = self.move_direction == 0 and 1 or -1
      end
      local moveOffSetX = self.move_center_offset and self.move_center_offset.x or 0
      local moveOffSetZ = self.move_center_offset and self.move_center_offset.y or 0
      if not self.ellipseParams then
        local centerDeltaX = selfPos.x - screenX - moveOffSetX
        local centerDeltaZ = selfPos.z - screenZ - moveOffSetZ
        local maxSizeRatio = 1
        if self.move_params and self.move_params[1] then
          maxSizeRatio = self.move_params[1]
        end
        self.curRadian = math.atan(centerDeltaZ, centerDeltaX * maxSizeRatio)
        local distance2CenterPoW2 = centerDeltaX * centerDeltaX + centerDeltaZ * centerDeltaZ
        local sinValue = math.sin(self.curRadian)
        local cosValue = math.cos(self.curRadian)
        local k = math.max(maxSizeRatio * maxSizeRatio * sinValue * sinValue + cosValue * cosValue, 0.001)
        local tmpB = math.sqrt(distance2CenterPoW2 / k)
        local tmpA = maxSizeRatio * tmpB
        self.ellipseParams = {a = tmpA, b = tmpB}
        local circumference = math.pi * (3 * (self.ellipseParams.a + self.ellipseParams.b) - math.sqrt((3 * self.ellipseParams.a + self.ellipseParams.b) * (self.ellipseParams.a + 3 * self.ellipseParams.b)))
        self.angularSpeed = self.monsterMeta.move_speed / circumference * FULL_CIRCLE_RADIAN * self.moveDirectionFactor
      end
      local radianSin = math.sin(self.curRadian)
      local radianCos = math.cos(self.curRadian)
      local deltaX = self.ellipseParams.b * radianCos
      local deltaZ = self.ellipseParams.a * radianSin
      self.curFramePosition.x = screenX + deltaX + moveOffSetX
      self.curFramePosition.z = screenZ + deltaZ + moveOffSetZ
      self:SetPosition(self.curFramePosition)
      local diffYEuler = 0 < self.moveDirectionFactor and 0 or 180
      local eulerY = math.deg(self.curRadian * -1) + diffYEuler
      local eulerZ = 0
      if self.monsterMeta.move_speed ~= 0 then
        local rotateZScale = math.sin(self.curRadian)
        rotateZScale = rotateZScale < 0 and rotateZScale * -1 or rotateZScale
        eulerZ = rotateZScale * MAX_Z_EULER * self.moveDirectionFactor
      end
      if eulerZ < -MAX_Z_EULER then
        eulerZ = -MAX_Z_EULER
      elseif eulerZ > MAX_Z_EULER then
        eulerZ = MAX_Z_EULER
      end
      self.transform:Set_eulerAngles(0, eulerY, eulerZ)
      self.curRadian = (self.curRadian + self.angularSpeed * deltaTime) % FULL_CIRCLE_RADIAN
      self.lastDeltaX = deltaX
      self.lastDeltaZ = deltaZ
    elseif self.move_type == MoveType.OffsetBezier3 then
      if not self.OffsetBezierStartPos then
        self.OffsetBezierStartPos = Vector2.New(selfPos.x, selfPos.z)
      end
      if not self.OffsetBezierEndPos then
        local offsetEndPos = self.move_center_offset or Vector2.New(0, 0)
        self.OffsetBezierEndPos = Vector2.New(self.OffsetBezierStartPos.x + offsetEndPos.x, self.OffsetBezierStartPos.y + offsetEndPos.y)
      end
      if not self.OffsetBezierMiddlePos then
        local s2eSegment = Vector2.New(self.OffsetBezierEndPos.x - self.OffsetBezierStartPos.x, self.OffsetBezierEndPos.y - self.OffsetBezierStartPos.y)
        local s2eSegMag = math.sqrt(s2eSegment.x * s2eSegment.x + s2eSegment.y * s2eSegment.y)
        local s2eSegHalfMag = 0.5 * s2eSegMag
        local s2eSegmentNormalize = Vector2.New(1, 0)
        if 1.0E-5 < s2eSegMag then
          s2eSegmentNormalize.x = s2eSegment.x / s2eSegMag
          s2eSegmentNormalize.y = s2eSegment.y / s2eSegMag
        else
          s2eSegmentNormalize.x = 0
          s2eSegmentNormalize.y = 0
        end
        local s2eSegmentMiddlePoint = Vector2.New(self.OffsetBezierStartPos.x + s2eSegHalfMag * s2eSegmentNormalize.x, self.OffsetBezierStartPos.y + s2eSegHalfMag * s2eSegmentNormalize.y)
        if self.move_center_offset_2 then
          self.OffsetBezierMiddlePos = self.OffsetBezierStartPos + self.move_center_offset_2
        else
          local s2scSegment = Vector2.New(screenX - self.OffsetBezierStartPos.x, screenZ - self.OffsetBezierStartPos.y)
          local projectMag = s2scSegment.x * s2eSegmentNormalize.x + s2scSegment.y * s2eSegmentNormalize.y
          local projectSegment = Vector2.New(s2eSegmentNormalize.x * projectMag, s2eSegmentNormalize.y * projectMag)
          local vertical2s2eSegment = s2scSegment - projectSegment
          local vertical2s2eSegmentNormalize = Vector2.Normalize(vertical2s2eSegment)
          local middlePointScale = 1
          if self.move_params and self.move_params[1] then
            middlePointScale = self.move_params[1]
          end
          local middlePointMag = middlePointScale * s2eSegHalfMag
          self.OffsetBezierMiddlePos = Vector2.New(s2eSegmentMiddlePoint.x + vertical2s2eSegmentNormalize.x * middlePointMag, s2eSegmentMiddlePoint.y + vertical2s2eSegmentNormalize.y * middlePointMag)
        end
        self.OffsetBezierResetPosDelayTime = 0
        if self.move_params and self.move_params[2] then
          self.OffsetBezierResetPosDelayTime = self.move_params[2]
        end
        self.OffsetBezierLerpValue = 0
      end
      if self.remainTimeToResetBezierPos and 0 < self.remainTimeToResetBezierPos then
        self.remainTimeToResetBezierPos = self.remainTimeToResetBezierPos - deltaTime
        if 0 < self.remainTimeToResetBezierPos then
          return
        end
      end
      self.lastFrameForward.x = self.curFrameForward.x
      self.lastFrameForward.z = self.curFrameForward.z
      local lerpFactor = self.OffsetBezierLerpValue
      local curPosX, curPosY, lookPosX, lookPosY = self:OffsetBezierCal(lerpFactor)
      local directionDeltaX = lookPosX - curPosX
      local directionDeltaY = lookPosY - curPosY
      local directionMag = math.sqrt(directionDeltaX * directionDeltaX + directionDeltaY * directionDeltaY)
      local eulerZ = 0
      if 1.0E-5 < directionMag then
        self.curFrameForward.x = directionDeltaX / directionMag
        self.curFrameForward.z = directionDeltaY / directionMag
        local forwardEulerY = math.deg(math.atan(directionDeltaX, directionDeltaY))
        local crossY = self.lastFrameForward.x * self.curFrameForward.z - self.lastFrameForward.z * self.curFrameForward.x
        eulerZ = crossY * MAX_Z_EULER
        if eulerZ < -MAX_Z_EULER then
          eulerZ = -MAX_Z_EULER
        elseif eulerZ > MAX_Z_EULER then
          eulerZ = MAX_Z_EULER
        end
        self.transform:Set_eulerAngles(0, forwardEulerY, eulerZ)
      end
      self.curFramePosition.x = curPosX
      self.curFramePosition.z = curPosY
      self:SetPosition(self.curFramePosition)
      local targetDist = self.monsterMeta.move_speed * deltaTime
      local tNext = lerpFactor + 0.01
      local tmpPosX, tmpPosY, tmpLookPosX, tmpLookPosY = self:OffsetBezierCal(tNext)
      local pDeltaX = tmpPosX - curPosX
      local pDeltaY = tmpPosY - curPosY
      local pDeltaMag = math.sqrt(pDeltaX * pDeltaX + pDeltaY * pDeltaY)
      if 1.0E-5 < pDeltaMag then
        tNext = tNext + (targetDist - pDeltaMag) * (tNext - lerpFactor) / pDeltaMag
      end
      self.OffsetBezierLerpValue = tNext
      if 1 < self.OffsetBezierLerpValue then
        self.OffsetBezierLerpValue = 0
        self.remainTimeToResetBezierPos = self.OffsetBezierResetPosDelayTime
      end
    end
  end
end

function SkyBattleAIMonster:UpdateColliderEnable(cameraMinVisibleZ, cameraMaxVisibleZ)
  local curFramePos = self:GetPosition()
  local canView = cameraMinVisibleZ <= curFramePos.z and cameraMaxVisibleZ >= curFramePos.z
  if canView and self:CanBeAttack() then
    if not self.colliderEnabled then
      self:EnableCollider(true)
    end
  elseif self.colliderEnabled then
    self:EnableCollider(false)
  end
end

function SkyBattleAIMonster:OffsetBezierCal(t)
  if not self.offsetBezierVec1 then
    self.offsetBezierVec1 = Vector2.New(1, 0)
  end
  if not self.offsetBezierVec2 then
    self.offsetBezierVec2 = Vector2.New(1, 0)
  end
  local t1 = 1 - t
  local p0 = self.OffsetBezierStartPos
  local p1 = self.OffsetBezierMiddlePos
  local p2 = self.OffsetBezierEndPos
  local tmpV1 = self.offsetBezierVec1
  local tmpV2 = self.offsetBezierVec2
  tmpV1.x = t1 * p0.x + t * p1.x
  tmpV1.y = t1 * p0.y + t * p1.y
  tmpV2.x = t1 * p1.x + t * p2.x
  tmpV2.y = t1 * p1.y + t * p2.y
  tmpV1.x = t1 * tmpV1.x + t * tmpV2.x
  tmpV1.y = t1 * tmpV1.y + t * tmpV2.y
  return tmpV1.x, tmpV1.y, tmpV2.x, tmpV2.y
end

local function RealSetCacheColliderCenterWorldPos(self, x, y, z)
  if not self.curColliderCenterPos then
    self.curColliderCenterPos = Vector3.zero
  end
  self.curColliderCenterPos.x = x
  self.curColliderCenterPos.y = y
  self.curColliderCenterPos.z = z
end

function SkyBattleAIMonster:GetColliderPos()
  local curFrame = Time.frameCount
  if self.getColliderPosFrame == curFrame then
    return self.curColliderCenterPos
  end
  self.getColliderPosFrame = curFrame
  local collider = self:GetCollider()
  local pos = self:GetPosition()
  if collider and not self.colliderCenterOffset then
    local colliderCenter = collider.center
    local x, y, z = UnitViewFacade.GetTransformPoint(self.viewHandle, colliderCenter.x, colliderCenter.y, colliderCenter.z)
    self.colliderCenterOffset = Vector3.New(x - pos.x, y - pos.y, z - pos.z)
  end
  if self.colliderCenterOffset then
    RealSetCacheColliderCenterWorldPos(self, pos.x + self.colliderCenterOffset.x, pos.y + self.colliderCenterOffset.y, pos.z + self.colliderCenterOffset.z)
    return self.curColliderCenterPos
  end
  return pos
end

return SkyBattleAIMonster
