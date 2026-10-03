local AnimationPlant = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniPlant")
local AnimationWater = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniWater")
local AnimationReap = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniReap")
local AnimationAttack = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniAttack")
local AnimationStopAttack = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniStopAttack")
local AnimationIdle = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniIdle")
local AnimationRun = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniRun")
local CitySpaceManAniAdjustRun = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniAdjustRun")
local AnimationHoldFlagCom = require("Scene.CityPioneer.SpaceMan.CitySpaceManAniHoldFlagCom")
local Com_SubmitRes_Trigger = require("Scene.CityPioneer.SpaceMan.CitySpaceManCarryCom")
local Com_PlantCom = require("Scene.CityPioneer.SpaceMan.CitySpaceManPlantCom")
local CitySpaceManAniJump = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniJump")
local PlayerWeapon = require("Scene.CityPioneer.SpaceMan.CitySpaceManWeapon")
local CitySpaceMan2 = BaseClass("CitySpaceMan2")
local Resource = CS.GameEntry.Resource
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local CutReward = 1
local CarryMaxCount = 20
local CarryObject = require("Scene.CityPioneer.CityCarryObject")
local Const = require("Scene.CityPioneer.Const")
local Physics = CS.UnityEngine.Physics
local InitWeaponRange = 0.5
local WeaponLength = 0.5
local ShowCarryTipsTimeDuring = 2000
local RotationAngleSpeed = 400
local _cp_weapon = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/weapon"
local _cp_weapon_trigger = "collider"
local _cp_weapon_sickle = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/A_soldie_ben_sickle"
local Animator = typeof(CS.UnityEngine.Animator)
local path_Animator_Body = "A_soldie_ben/A_soldie@ben_skin"
local MoveState = {
  Idle = 0,
  Run = 1,
  AdjustRun = 2,
  None = 10
}
local ActionState = {
  Wait = 0,
  Attack = 1,
  ToPlant = 2,
  ToWater = 3,
  ToReap = 4,
  ReapWait = 5,
  Jump = 6,
  None = 7
}
CitySpaceMan2.ActionState = ActionState
local GameState = {
  Normal = 0,
  HoldFlag = 1,
  SubmitFlag = 2,
  Jump = 3,
  None = 4
}
local AnimationType = {
  Idle = "idle",
  IdleWithFlag = "idleWithFlag",
  Run = "run",
  StandAttack = "attack",
  RunAttack = "runAttack",
  RunWithFlag = "runWithFlag",
  WaveFlag = "waveFlag",
  Plant = "plant",
  RunPlant = "runPlant",
  Water = "water",
  RunWater = "runWater",
  Reap = "reap",
  RunReap = "runReap",
  Jump = "jump"
}

function CitySpaceMan2:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:DataDefine()
  self:ComponentDefine()
  self:ChangeWeapon()
end

function CitySpaceMan2:OnDestroy()
  if self.m_curActionState ~= ActionState.None then
    self.m_actionStateAniList[self.m_curActionState]:OnExit()
    self.m_curActionState = ActionState.None
  end
  self.m_curGameState = GameState.Normal
  self:ClearAllOtherRes()
  self.gameObject = nil
  if self.m_holdFlagCom then
    self.m_holdFlagCom:Destroy()
    self.m_holdFlagCom = nil
  end
  self:ClearTriggerAction()
  self:ComponentDestroy()
  self:DataDestroy()
end

function CitySpaceMan2:ComponentDefine()
  local skinObj = self.gameObject.transform:Find(path_Animator_Body)
  if skinObj ~= nil then
    self.m_animator = skinObj:GetComponent(Animator)
  end
  self.weaponRoot = self:GetTransform():Find(_cp_weapon)
  self.weaponRoot.gameObject:SetActive(false)
  self.m_objSickle = self:GetTransform():Find(_cp_weapon_sickle)
  if self.m_objSickle ~= nil then
    self.m_sickleTrigger = self.m_objSickle:GetComponent(typeof(CS.CitySpaceManTrigger))
    if self.m_sickleTrigger ~= nil then
      function self.m_sickleTrigger.TriggerEnterAction(uuid, resType)
        self:OnTriggerEnter_Weapon(uuid, resType)
      end
    end
  end
  self.triggerHandler = self.gameObject:GetComponent(typeof(CS.ColliderEventHandler))
  if self.triggerHandler ~= nil then
    function self.triggerHandler.OnTriggerEnterAction(obj)
      self:OnTriggerEnter(obj)
    end
    
    function self.triggerHandler.OnTriggerExitAction(obj)
      self:OnTriggerExit(obj)
    end
  end
  local _objTransform = self.gameObject.transform
  self.vfxCollide = _objTransform:Find("VFX_Collide")
  self.carryRoot = _objTransform:Find("A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/Root_M/ResRootObj")
  if not table.IsNullOrEmpty(self.old_pos) then
    local new_pos = SceneUtils.TileToWorld(self.old_pos)
    self:SetPosition(new_pos)
  end
end

function CitySpaceMan2:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function CitySpaceMan2:DataDefine()
  self.param = nil
  self.m_deltaT = 0
  self.m_updateTimer = nil
  self.m_targetUidList = {}
  self.m_curMoveState = MoveState.None
  self.m_moveStateAniList = {}
  self.m_curActionState = ActionState.None
  self.m_actionStateAniList = {}
  self.m_curGameState = GameState.Normal
  self.m_weaponTrigger = nil
  self.carryObj = {}
  self.collider = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), 200)
  self.weaponSize = 1
  self.m_curActionName = ""
  self.m_position = Vector3.New(0, 0, 0)
  self.m_tilePos = Vector3.New(0, 0, 0)
  self.weaponName = nil
  self.weapon = {}
  self.showCarryTipsTime = 0
  self.isRotation = false
  self.startRotation = nil
  self.endRotation = nil
  self.rotationTime = 0
end

function CitySpaceMan2:DataDestroy()
  for k, v in pairs(self.weapon) do
    v:Destroy()
  end
  self.weaponName = nil
  self.weapon = {}
  self.param = nil
  self.isRotation = false
  self.startRotation = nil
  self.endRotation = nil
  self.rotationTime = 0
end

function CitySpaceMan2:ReInit(param)
  self.param = param
  if self.param.pos ~= nil then
    self:SetPosition(self.param.pos)
  end
  if self.param.rot ~= nil then
    self.gameObject.transform.rotation = self.param.rot
  end
  self:InitScript()
  self:SetMoveState(MoveState.Idle)
  self:SetActionState(ActionState.Wait)
end

function CitySpaceMan2:GetMoveState()
  return self.m_curMoveState
end

function CitySpaceMan2:InitScript()
  self.m_actionStateAniList[ActionState.Wait] = AnimationStopAttack.New(self)
  self.m_actionStateAniList[ActionState.Attack] = AnimationAttack.New(self)
  self.m_actionStateAniList[ActionState.ToPlant] = AnimationPlant.New(self)
  self.m_actionStateAniList[ActionState.ToWater] = AnimationWater.New(self)
  self.m_actionStateAniList[ActionState.ToReap] = AnimationAttack.New(self)
  self.m_actionStateAniList[ActionState.ReapWait] = AnimationStopAttack.New(self)
  self.m_actionStateAniList[ActionState.Jump] = CitySpaceManAniJump.New(self)
  self.m_moveStateAniList[MoveState.Idle] = AnimationIdle.New(self)
  self.m_moveStateAniList[MoveState.Run] = AnimationRun.New(self)
  self.m_moveStateAniList[MoveState.AdjustRun] = CitySpaceManAniAdjustRun.New(self)
  self.m_SubmitTrigger = Com_SubmitRes_Trigger.New(self)
  self.m_holdFlagCom = AnimationHoldFlagCom.New(self)
  self.m_plantCom = Com_PlantCom.New(self)
end

function CitySpaceMan2:HandFlag()
  self.m_curGameState = GameState.HoldFlag
  self.m_holdFlagCom:KillAll()
  self:ClearAllCarryObj()
  self:SetActionState(ActionState.Wait)
end

function CitySpaceMan2:WaveFlag()
  self.m_curGameState = GameState.SubmitFlag
  self.gameObject.transform.rotation = Quaternion.Euler(0, 100, 0)
  self:PlayAnimation()
  self.m_holdFlagCom:Over()
end

function CitySpaceMan2:SetGameStateToNormal()
  self.m_curGameState = GameState.Normal
  self.m_holdFlagCom:HideFlag()
end

function CitySpaceMan2:RemoveAllFlag()
  self.m_holdFlagCom:Destroy()
end

function CitySpaceMan2:PlayAnimation()
  if self.m_animator == nil then
    return
  end
  self:ResetAllTrigger()
  local animation_name = ""
  if self.m_curGameState == GameState.SubmitFlag then
    self.m_animator:SetTrigger(AnimationType.WaveFlag)
    return
  end
  if self.m_curMoveState == MoveState.Idle and self.m_curGameState == GameState.HoldFlag then
    animation_name = AnimationType.IdleWithFlag
    self.m_holdFlagCom:killAllIdle()
  elseif self.m_curMoveState == MoveState.Run and self.m_curGameState == GameState.HoldFlag then
    animation_name = AnimationType.RunWithFlag
    self.m_holdFlagCom:KillAllRun()
  elseif self.m_curMoveState == MoveState.Idle and self.m_curActionState == ActionState.Wait then
    animation_name = AnimationType.Idle
  elseif self.m_curMoveState == MoveState.Run and self.m_curActionState == ActionState.Wait then
    animation_name = AnimationType.Run
  elseif self.m_curMoveState == MoveState.Idle and self.m_curActionState == ActionState.Attack then
    animation_name = AnimationType.StandAttack
  elseif self.m_curMoveState == MoveState.Run and self.m_curActionState == ActionState.Attack then
    animation_name = AnimationType.RunAttack
  elseif self.m_curMoveState == MoveState.Idle and self.m_curActionState == ActionState.ToPlant then
    animation_name = AnimationType.Plant
  elseif self.m_curMoveState == MoveState.Run and self.m_curActionState == ActionState.ToPlant then
    animation_name = AnimationType.RunPlant
  elseif self.m_curMoveState == MoveState.Idle and self.m_curActionState == ActionState.ToWater then
    animation_name = AnimationType.Water
  elseif self.m_curMoveState == MoveState.Run and self.m_curActionState == ActionState.ToWater then
    animation_name = AnimationType.RunWater
  elseif self.m_curMoveState == MoveState.Idle and self.m_curActionState == ActionState.ToReap then
    animation_name = AnimationType.Reap
  elseif self.m_curMoveState == MoveState.Run and self.m_curActionState == ActionState.ToReap then
    animation_name = AnimationType.RunReap
  elseif self.m_curMoveState == MoveState.Idle and self.m_curActionState == ActionState.ReapWait then
    animation_name = AnimationType.Idle
  elseif self.m_curMoveState == MoveState.Run and self.m_curActionState == ActionState.ReapWait then
    animation_name = AnimationType.Run
  elseif self.m_curMoveState == MoveState.Idle and self.m_curActionState == ActionState.Jump then
    animation_name = AnimationType.Jump
  end
  if animation_name == self.m_curActionName then
    return
  end
  self.m_curActionName = animation_name
  self.m_animator:SetTrigger(animation_name)
end

function CitySpaceMan2:ResetAllTrigger()
  for _, v in pairs(AnimationType) do
    self.m_animator:ResetTrigger(v)
  end
end

function CitySpaceMan2:GetFlyPos()
  local objTransform = self.gameObject.transform
  local hangPoint = objTransform:Find("A_soldie_ben/sold_point1")
  return hangPoint.position
end

function CitySpaceMan2:ClearTriggerAction()
  if self.m_weaponTrigger then
    self.m_weaponTrigger.TriggerEnterAction = nil
    self.m_weaponTrigger = nil
  end
  if self.m_sickleTrigger then
    self.m_sickleTrigger.TriggerEnterAction = nil
    self.m_sickleTrigger = nil
  end
  if self.triggerHandler then
    self.triggerHandler.OnTriggerEnterAction = nil
    self.triggerHandler.OnTriggerExitAction = nil
    self.triggerHandler = nil
  end
end

function CitySpaceMan2:OnTriggerEnter(otherObj)
  local tag = otherObj.tag
  local npcTalkData = DataCenter.CityNpcManager:GetNpcTalkData(otherObj:GetInstanceID())
  if npcTalkData ~= nil then
    local talkParam = {}
    talkParam.talkType = NpcTalkType.Right
    talkParam.target = otherObj.transform
    talkParam.dialogId = npcTalkData.dialogId
    talkParam.offset = Vector3.New(0, npcTalkData.height, 0)
    EventManager:GetInstance():Broadcast(EventId.ShowTalkBubble, talkParam)
  else
  end
end

function CitySpaceMan2:OnTriggerExit(otherObj)
  EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
    target = otherObj.transform
  })
end

function CitySpaceMan2:OnTriggerEnter_Weapon(uuid, resType)
  if self.m_curActionState == ActionState.Attack then
    self:OnCutOnce(uuid, resType)
  elseif self.m_curActionState == ActionState.ToReap then
    local farmTile = WastelandFarmManager:GetInstance():GetTileByObjId(uuid)
    if farmTile ~= nil then
      local result, resType = farmTile:GetCollectResult()
      if result then
        self:CarryOneObject(resType)
        farmTile:RecvPick()
      end
    end
  end
end

function CitySpaceMan2:GetCarryRoot()
  return self.carryRoot
end

function CitySpaceMan2:OnCutOnce(uuid, resType)
  local build = CS.SceneManager.World:GetObjectByPointId(uuid)
  if build == nil then
    return
  end
  local garbageBase = build._luaTable
  if garbageBase == nil then
    return
  end
  CommonUtil.VibratorLightImpact()
  if self.param.isMain then
    self:CarryOneObject(resType)
  else
    CitySpaceMan:GetInstance():CarryOneObject(resType)
  end
  garbageBase:OnCutOnce()
  local remain = garbageBase:GetBloodLeftCnt(CutReward)
  if remain <= 0 then
    self:OnLeaveTarget(uuid)
  end
end

function CitySpaceMan2:CarryOneObject(t)
  if #self.carryObj >= CarryMaxCount then
    local pos = self:FindOneObjectByNotType(t)
    if pos == 0 then
      self:ShowCarryOutRangeTips()
    else
      local index = pos
      local carryObj = CarryObject.New()
      local param = {}
      param.resType = t
      param.localPos = self:__BagIndexToPos(index)
      param.spaceMan = self
      carryObj:Create(param)
      self:ReplaceOneObjectByPos(pos, carryObj)
    end
  else
    local count = #self.carryObj + 1
    local carryObj = CarryObject.New()
    local param = {}
    param.resType = t
    param.localPos = self:__BagIndexToPos(count)
    param.spaceMan = self
    carryObj:Create(param)
    self.carryObj[count] = carryObj
  end
  DataCenter.CityPioneerManager:CheckResReachGuide()
end

function CitySpaceMan2:__BagIndexToPos(index)
  index = index - 1
  local pos = Vector3.New(index * -0.19, -0.25, 0)
  if 10 <= index then
    pos = Vector3.New((index - 10) * -0.19, -0.42, 0)
  end
  return pos
end

function CitySpaceMan2:FindOneObjectByNotType(notType)
  for i = table.count(self.carryObj), 1, -1 do
    local carryType = self.carryObj[i]:GetType()
    if self:CanReplaceResType(carryType) and carryType ~= notType then
      return i
    end
  end
  return 0
end

function CitySpaceMan2:ReplaceOneObjectByPos(index, newCarryObj)
  if 1 <= index and index <= #self.carryObj then
    local obj = self.carryObj[index]
    if obj ~= nil then
      obj:Destroy()
    end
    self.carryObj[index] = newCarryObj
  end
end

function CitySpaceMan2:ClearAllOtherRes(t)
  local cnt = 0
  t = tonumber(t)
  for _, v in pairs(self.carryObj) do
    if v:GetType() == t then
      cnt = cnt + 1
    end
  end
  self:ClearAllCarryObj()
  if 0 < cnt then
    for i = 1, cnt do
      self:CarryOneObject(t)
    end
  end
end

function CitySpaceMan2:OnLeaveTarget(uuid)
  self.m_targetUidList[uuid] = nil
  if next(self.m_targetUidList) == nil then
    self:SetActionState(ActionState.Wait)
  end
end

function CitySpaceMan2:GetCitySpaceManGameObject()
  return self.gameObject
end

function CitySpaceMan2:SetPosition(pos)
  if self.gameObject == nil then
    self.old_pos = SceneUtils.WorldToTile(pos)
    self.idle_pos = self.old_pos
    return
  end
  self.m_position = pos
  self.gameObject.transform.position = self.m_position
end

function CitySpaceMan2:GetPosition()
  if self.gameObject == nil then
    return self.m_position
  end
  local x, y, z = self.gameObject.transform:Get_position()
  self.m_position.x = x
  self.m_position.y = y
  self.m_position.z = z
  return self.m_position
end

function CitySpaceMan2:SetTilePos(v)
  self:SetPosition(SceneUtils.TileToWorld(v))
  self.idle_pos = v
end

function CitySpaceMan2:GetTilePos()
  local worldPos = self:GetPosition()
  local x, y = SceneUtils.WorldToTileXZ(worldPos.x, worldPos.z)
  self.m_tilePos.x = x
  self.m_tilePos.y = y
  return self.m_tilePos
end

function CitySpaceMan2:GetWeaponSize()
  return self.weaponSize or 1
end

function CitySpaceMan2:SetWeaponSize(size)
  self.weaponSize = math.max(1, size)
end

function CitySpaceMan2:GetCurActionState()
  return self.m_curActionState
end

function CitySpaceMan2:IsFarmMode()
  if self.m_curActionState == ActionState.ToPlant or self.m_curActionState == ActionState.ToWater or self.m_curActionState == ActionState.ReapWait or self.m_curActionState == ActionState.ToReap then
    return true
  end
  return false
end

function CitySpaceMan2:IsSlowMode()
  if self.m_curActionState == ActionState.ToPlant or self.m_curActionState == ActionState.ToWater or self.m_curActionState == ActionState.ToReap then
    return true
  end
  return false
end

function CitySpaceMan2:SetMoveState(moveState)
  if self.gameObject ~= nil and moveState ~= nil and self.m_curMoveState ~= moveState then
    if moveState == MoveState.Idle then
      self.idle_pos = self:GetTilePos()
    end
    if self.m_curMoveState ~= MoveState.None then
      self.m_moveStateAniList[self.m_curMoveState]:OnExit()
    end
    self.m_curMoveState = moveState
    if self.m_curMoveState ~= MoveState.None then
      self.m_moveStateAniList[self.m_curMoveState]:OnEnter()
    end
  end
end

function CitySpaceMan2:SetActionState(attackState)
  if self.m_curActionState == attackState then
    return
  end
  if attackState == ActionState.ToPlant or attackState == ActionState.ToWater or attackState == ActionState.ReapWait or attackState == ActionState.ToReap then
    self.m_plantCom:SetCameraIn()
  end
  if self.m_curActionState < ActionState.None then
    self.m_actionStateAniList[self.m_curActionState]:OnExit()
  end
  self.m_curActionState = attackState
  if self.m_curActionState < ActionState.None then
    self.m_actionStateAniList[self.m_curActionState]:OnEnter()
  end
end

function CitySpaceMan2:OnUpdate()
  if self.gameObject == nil or self.m_curGameState == GameState.None then
    return
  end
  self.m_moveStateAniList[self.m_curMoveState]:OnUpdate()
  if self.m_curGameState == GameState.Normal and not self:IsFarmMode() then
    self.m_actionStateAniList[self.m_curActionState]:OnUpdate()
    self:CheckCollectState()
  end
  if not DataCenter.GuideManager:InGuide() then
    self:CheckCollideTriggerPoint()
    self.m_SubmitTrigger:CheckSubmitRes()
    self.m_plantCom:CheckPlant()
  end
  self:CheckRotation()
end

function CitySpaceMan2:GetTriggerIds(topVec, downVec, radius, layerName)
  local layerMask = LayerMask.GetMask(layerName)
  local cnt = CS.UnityEngine.Physics.OverlapCapsuleNonAlloc(topVec, downVec, radius, self.collider, layerMask)
  if cnt <= 0 then
    return {}
  end
  local tabResult = {}
  local tmpCnt = 200 < cnt and 200 or cnt
  local cityManPosition = self:GetPosition()
  for i = 1, tmpCnt do
    local _collider = self.collider[i - 1]
    local trigger = _collider.transform:GetComponentInParent(typeof(CS.CitySpaceManTrigger))
    if trigger ~= nil and trigger.resType ~= Const.CityCutResType.Weapon then
      local collider_pos = _collider.transform.position
      local vec1 = Vector2.New(collider_pos.x - cityManPosition.x, collider_pos.z - cityManPosition.z)
      local vec2 = Vector2.New(self.gameObject.transform.forward.x, self.gameObject.transform.forward.z)
      if 0 < Vector2.Dot(vec1, vec2) then
        tabResult[#tabResult + 1] = trigger.ObjectId
      end
    end
  end
  return tabResult
end

function CitySpaceMan2:Hit(transform, radius, v)
  local oritation
  local layerMask = LayerMask.GetMask("Default")
  local downPos = transform.position
  local topPos = transform.position
  topPos.y = topPos.y + 1
  local ret = Physics.CapsuleCastNonAlloc(downPos, topPos, radius, v, self.hitInfo, 0.5, layerMask)
  if ret then
    local qiexian = Vector3.Cross(self.hitInfo[0].normal, Vector3.up)
    if 0 < Vector3.Dot(transform.forward, qiexian) then
      oritation = qiexian
    else
      oritation = -qiexian
    end
    local r1, hitInfo = Physics.CapsuleCast(downPos, topPos, radius, oritation, 0.5)
    if r1 then
      oritation = Vector3.zero
      return true, oritation
    end
    return true, oritation
  end
  oritation = Vector3.zero
  return false, oritation
end

function CitySpaceMan2:CheckCollectState()
  if DataCenter.GuideManager:IsPrologueCanAttack() then
    local pos1 = self:GetPosition()
    local pos2 = pos1
    pos2.y = pos2.y + 1
    local toAttack = false
    local ret = self:GetTriggerIds(pos1, pos2, InitWeaponRange + WeaponLength * self.weaponSize, "Default")
    if table.count(ret) > 0 then
      for _, uuid in pairs(ret) do
        if uuid ~= 0 then
          self.m_targetUidList[uuid] = true
          toAttack = true
        end
      end
    end
    if toAttack then
      self:SetActionState(ActionState.Attack)
    elseif self.m_curActionState == ActionState.Attack then
      self.m_targetUidList = {}
      self:SetActionState(ActionState.Wait)
    end
  end
end

function CitySpaceMan2:CheckCollideTriggerPoint()
  local layerMask = LayerMask.GetMask("Terrain")
  local pos = self:GetPosition()
  local cnt = CS.UnityEngine.Physics.OverlapCapsuleNonAlloc(pos, pos, 0.5, self.collider, layerMask)
  if cnt <= 0 then
    return
  end
  local tmpCnt = 200 < cnt and 200 or cnt
  for i = 1, tmpCnt do
    local _collider = self.collider[i - 1]
    local trigger = _collider.transform:GetComponent(typeof(CS.CitySpaceManTrigger))
    if trigger ~= nil and trigger.resType == Const.CityCutResType.Weapon then
      local data = DataCenter.CityTriggerPointDataManager:GetTriggerPointDataFromId(trigger.ObjectId)
      if data:IsFull() or DataCenter.GuideManager:IsPrologueCanAttack() then
        CityTriggerPointManager:GetInstance():DoTriggerAndSave(trigger.ObjectId)
      end
    end
  end
end

function CitySpaceMan2:Walk(vx, vz)
  if DataCenter.GuideManager:InGuide() or self.gameObject == nil then
    return
  end
  if self.m_curGameState == GameState.WaveFlag or self.m_curGameState == GameState.None then
    return
  end
  self:SetMoveState(MoveState.Run)
  self.m_moveStateAniList[MoveState.Run]:SetVelocity(vx, vz)
end

function CitySpaceMan2:StopWalk()
  if self.param.isMain then
    self:SetMoveState(MoveState.Idle)
  else
    self:SetMoveState(MoveState.AdjustRun)
  end
end

function CitySpaceMan2:ToPlant()
  self:SetActionState(ActionState.ToPlant)
end

function CitySpaceMan2:ToWater()
  self:SetActionState(ActionState.ToWater)
end

function CitySpaceMan2:ToReap()
  if self.m_curActionState == ActionState.ToReap then
    return
  end
  local resType = self.m_plantCom:GetCurFarmAreaType()
  self:ClearAllOtherRes(resType)
  self:SetActionState(ActionState.ToReap)
end

function CitySpaceMan2:ToReapWait()
  if self.m_curActionState == ActionState.ReapWait then
    return
  end
  self:SetActionState(ActionState.ReapWait)
end

function CitySpaceMan2:LeaveFarmMode()
  if self.m_curActionState == ActionState.ToPlant or self.m_curActionState == ActionState.ToWater or self.m_curActionState == ActionState.ReapWait or self.m_curActionState == ActionState.ToReap then
    self:SetActionState(ActionState.Wait)
  end
end

function CitySpaceMan2:GetTopObjectType()
  if #self.carryObj <= 0 then
    return nil
  end
  local obj = self.carryObj[#self.carryObj]
  return obj:GetType()
end

function CitySpaceMan2:GetCarryCnt()
  return table.count(self.carryObj)
end

function CitySpaceMan2:ClearAllCarryObj()
  if table.count(self.carryObj) == 0 then
    return
  end
  for _, v in pairs(self.carryObj) do
    v:Destroy()
  end
  self.carryObj = {}
end

function CitySpaceMan2:IsFinalState()
  if self.m_curGameState == GameState.HoldFlag or self.m_curGameState == GameState.Jump then
    return true
  end
  return false
end

function CitySpaceMan2:IsNeedCreate()
  return self.m_req == nil
end

function CitySpaceMan2:Jump()
  self.gameObject.transform.rotation = Quaternion.Euler(0, 180, 0)
  self.m_curGameState = GameState.Jump
  self:SetActionState(ActionState.Jump)
  self:PlayAnimation()
end

function CitySpaceMan2:LeaveJump()
  self:SetActionState(ActionState.Wait)
end

function CitySpaceMan2:LookAtPos(pos)
  self.transform:LookAt(pos)
end

function CitySpaceMan2:SetRotation(angle)
  local curAngle = self.transform.rotation.eulerAngles.y
  if curAngle ~= angle then
    self.curTime = 0
    self.isRotation = true
    self.startRotation = self.transform.rotation
    self.endRotation = Quaternion.Euler(0, angle, 0)
    self.rotationTime = math.abs((angle - curAngle) / RotationAngleSpeed)
  else
    self.isRotation = false
    self:CheckNext()
  end
end

function CitySpaceMan2:GetTransform()
  return self.transform
end

function CitySpaceMan2:GetInstantiateObj()
  return self.gameObject
end

function CitySpaceMan2:GetRotation()
  return self.transform.rotation
end

function CitySpaceMan2:GetPosWithExtra()
  return CitySpaceMan:GetInstance():GetPosition() + self.param.extraPos
end

function CitySpaceMan2:LeaveAdjustRun()
  self:SetMoveState(MoveState.Idle)
end

function CitySpaceMan2:GetWeaponName()
  return "Assets/_Art/Models/Soldier/Ben_weapons/prefab/A_soldie_ben_weapons_prologue.prefab"
end

function CitySpaceMan2:ChangeWeapon()
  local weaponName = self:GetWeaponName()
  if weaponName ~= self.weaponName then
    if self.weapon[weaponName] == nil then
      local playerWeapon = PlayerWeapon.New()
      
      local function triggerEnterAction(uuid, resType)
        self:OnTriggerEnter_Weapon(uuid, resType)
      end
      
      playerWeapon:Create(self, weaponName, false, self.weaponRoot, triggerEnterAction)
      self.weapon[weaponName] = playerWeapon
    else
      self.weapon[weaponName]:SetVisible(true)
    end
    if self.weaponName ~= nil and self.weapon[self.weaponName] ~= nil then
      self.weapon[self.weaponName]:SetVisible(false)
    end
    self.weaponName = weaponName
  end
end

function CitySpaceMan2:SetWeaponColliderEnable(enable)
  local weapon = self:GetCurWeapon()
  if weapon then
    weapon:SetWeaponColliderEnable(enable)
  end
end

function CitySpaceMan2:GetCurWeapon()
  if self.weaponName ~= nil then
    return self.weapon[self.weaponName]
  end
end

function CitySpaceMan2:GetTrailEffectRoot()
  local weapon = self:GetCurWeapon()
  if weapon then
    return weapon:GetTrailEffectRoot()
  end
end

function CitySpaceMan2:ShowCarryOutRangeTips()
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.showCarryTipsTime + ShowCarryTipsTimeDuring then
    self.showCarryTipsTime = now
    UIUtil.ShowTipsId(tonumber(GameDialogDefine.PVE_CARRY_OUT_RANGE_TIP))
  end
end

function CitySpaceMan2:SetVisible(isVisible)
  if self.gameObject ~= nil then
    self.gameObject:SetActive(isVisible)
  end
end

function CitySpaceMan2:CheckRotation()
  if self.isRotation then
    self.curTime = self.curTime + Time.deltaTime
    local percent = self.curTime / self.rotationTime
    if 1 <= percent then
      self.curTime = 0
      self.transform.rotation = self.endRotation
      self.isRotation = false
      self:CheckNext()
    else
      self.transform.rotation = Quaternion.Lerp(self.startRotation, self.endRotation, percent)
    end
  end
end

function CitySpaceMan2:CheckNext()
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and template.type == GuideType.PrologueManRotation then
    DataCenter.GuideManager:DoNext()
  end
end

function CitySpaceMan2:GetResTypeCount(resType)
  local num = 0
  for k, v in ipairs(self.carryObj) do
    if v:GetType() == resType then
      num = num + 1
    end
  end
  return num
end

function CitySpaceMan2:CanReplaceResType(resType)
  local triggerData = DataCenter.CityTriggerPointDataManager:GetTriggerPointDataFromId(Const.ReplaceFinishTriggerId)
  if triggerData ~= nil and resType == Const.CityCutResType.Cactus then
    return false
  end
  return true
end

return CitySpaceMan2
