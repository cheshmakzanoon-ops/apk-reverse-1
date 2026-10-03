local Localization = CS.GameEntry.Localization
local AnimationAttack = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniAttack")
local PlayerAniInteract = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniInteract")
local AnimationStopAttack = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniStopAttack")
local AnimationIdle = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniIdle")
local AnimationRun = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniRun")
local AnimationHoldFlagCom = require("Scene.PVEBattleLevel.Player.PlayerAniHoldFlagCom")
local PlayerAniAdjustRun = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniAdjustRun")
local PlayerAniAdjustToAttack = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniAdjustToAttack")
local PlayerAniMoveTo = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniMoveTo")
local Com_SubmitRes_Trigger = require("Scene.PVEBattleLevel.Player.PlayerCarryCom")
local Resource = CS.GameEntry.Resource
local CarryObject = require("Scene.PVEBattleLevel.Player.CarryObject")
local PlayerWeapon = require("Scene.PVEBattleLevel.Player.PlayerWeapon")
local PlayerWeaponTrailManager = require("Scene.PVEBattleLevel.Player.PlayerWeaponTrailManager")
local Physics = CS.UnityEngine.Physics
local PveHeroHpBar = require("Scene.PVEBattleLevel.PveHeroHpBar")
local _cp_weapon = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/weapon"
local _cp_weapon_hero = "A_Hero_low/A_Hero_low_skin/To_unity/DeformationSystem/Root/guadian"
local _cp_weapon_sickle = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/A_soldie_ben_sickle"
local _cp_weapon_sickle_hero = "A_Hero_low/A_Hero_low_skin/To_unity/DeformationSystem/Root/guadian/A_soldie_shxr_sickle"
local Animator = typeof(CS.UnityEngine.Animator)
local path_Animator_Body = "A_soldie_ben/A_soldie@ben_skin"
local path_Animator_Body_hero = "A_Hero_low/A_Hero_low_skin"
local leftprintEffect = "Assets/_Art/Effect/prefab/Arms/Taikongbing/VFX_taikongbing_movesmoke_left.prefab"
local rightprintEffect = "Assets/_Art/Effect/prefab/Arms/Taikongbing/VFX_taikongbing_movesmoke_right.prefab"
local leftPointPath = "A_soldie_ben/LeftStepPoint"
local rightPointPath = "A_soldie_ben/RightStepPoint"
local leftPointPath_hero = "A_Hero_low/A_Hero_low_skin/LeftStepPoint"
local rightPointPath_hero = "A_Hero_low/A_Hero_low_skin/RightStepPoint"
local skin_material_path = "A_soldie_ben/A_soldie@ben_skin/To_unity/A_soldie_ben/A_soldie_ben 1"
local Const = require("Scene.PVEBattleLevel.Const")
local SubmitTime = 0.1
local ChangeSubmitTime = 2
local ChangeSubmitCount = 1
local LeftStepRot = Quaternion.Euler(-90, 0, -90)
local RightStepRot = Quaternion.Euler(-90, 0, 0)
local StepPoolMax = 50
local InitWeaponRange = 0.8
local WeaponLength = 0.8
local ShowCarryTipsTimeDuring = 2000
local TestOnGroundPoint1 = Vector3.New(0, 0, 0)
local TestOnGroundPoint2 = Vector3.New(0, 0, 0)
local CheckCollectRotationAngle = 120
local CheckCollectAttackSize = 1.4
local AttackAnimTime = 0.2
local BuffAttackAnimTime = 0.2
local CheckCollectRotationCircleAngle = 180
local CheckCollectRotationFollowAngle = 60
local CheckCollectRotationFollowRadius = 5
local ChangePosDistance = 0.2
local ChangeRotDistance = 5
local MoveState = {
  Idle = 0,
  Run = 1,
  AdjustRun = 2,
  AdjustToAttack = 3,
  MoveTo = 4,
  None = 10
}
local ActionState = {
  Wait = 0,
  Attack = 1,
  ToPlant = 2,
  ToWater = 3,
  ToReap = 4,
  ReapWait = 5,
  Interact = 6,
  None = 7
}
local GameState = {
  Normal = 0,
  HoldFlag = 1,
  SubmitFlag = 2,
  None = 3
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
  StandAttackBuff = "buffAttack",
  BuffRunAttack = "buffRunAttack",
  Jump = "jump",
  Weaken = "weaken",
  Stun = "stun"
}
local Player = BaseClass("Player")
Player.ActionState = ActionState
Player.MoveState = MoveState

function Player:__init(battleLevel, objId, req, param, isHero, doScale)
  self.subMitCount = 1
  self.m_req = req
  self.param = param
  self.battleLevel = battleLevel
  self.objId = objId
  self.doScale = doScale
  self.cur_pos = Vector3.New(0, 0, 0)
  self.cur_rotation = Quaternion.LookRotation(Vector3.back)
  if param.isMain then
    self.cur_rotation = battleLevel:GetPlayerInitRotation()
  end
  self.level = param.level
  self.skinName = param.skinName
  self.modelHeight = nil
  self.isHero = false
  if isHero ~= nil and isHero == true then
    self.isHero = true
  end
  self.m_deltaT = 0
  self.stepList = {}
  self.stepDic = {}
  self.targetObjId = nil
  self.m_targetUidList = {}
  self.m_curMoveState = MoveState.None
  self.m_moveStateAniList = {}
  self.m_curActionState = ActionState.None
  self.m_actionStateAniList = {}
  self.m_curGameState = GameState.Normal
  self.m_weaponTrigger = nil
  self.carryObj = {}
  self.carryResource = {}
  self.hitInfo = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.RaycastHit), 5)
  self.m_curActionName = ""
  self.m_visible = true
  self.m_startCameraFollow = false
  self.m_waveFlagEndTimer = nil
  self.subMitTime = SubmitTime
  self.continueSubTime = 0
  self.weaponSize = 1
  self.attack = 1
  self.attackSpeed = 1
  self.weaponName = nil
  self.weapon = {}
  self.stepPool = {
    [leftprintEffect] = {},
    [rightprintEffect] = {}
  }
  self.destroyStepTimer = TimerManager:GetInstance():GetTimer(1, function()
    self:CheckDestroyStep()
  end, nil, false, false, false)
  self.destroyStepTimer:Start()
  self.showCarryTipsTime = 0
  self.time = 0
  self.waitAttackList = {}
  self.weaponEnable = false
  self.scale = 1
  self.lastChangePosX = 0
  self.lastChangePosZ = 0
  self.lastChangeRot = 0
  self.moveToEndPosArr = {}
  self.weaponTrailMgr = PlayerWeaponTrailManager.New(self)
  self.waitTurnToPos = nil
end

function Player:OnCreate()
  if self.m_req ~= nil then
    self.m_gameObject = self.m_req.gameObject
    self.transform = self.m_gameObject.transform
  end
  self:InitRotation()
  self:DataDefine()
  self:ComponentDefine()
end

function Player:InitRotation()
  if self.isHero ~= nil and self.isHero == true then
    local _obj = self:GetTransform():Find("A_Hero_low")
    if _obj ~= nil then
      local heroSize = self.battleLevel:GetHeroSize()
      _obj.gameObject.transform:Set_localScale(heroSize, heroSize, heroSize)
    end
  end
end

function Player:Destroy()
  self:DestroyStunEffect()
  self.weaponTrailMgr:Destroy()
  if self.param.isNoGain then
    EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
      target = self.transform
    })
  end
  if self.stepList then
    for i, t in pairs(self.stepList) do
      i:Destroy()
    end
    self.stepList = nil
  end
  for k, v in pairs(self.weapon) do
    v:Destroy()
  end
  self.weapon = {}
  self.weaponName = nil
  if self.stepPool then
    local leftPool = self.stepPool[leftprintEffect]
    local rightPool = self.stepPool[rightprintEffect]
    for i, v in ipairs(leftPool) do
      v:Destroy()
    end
    for i, v in ipairs(rightPool) do
      v:Destroy()
    end
    self.stepPool = nil
  end
  self:ClearTriggerEvent()
  if self.m_curActionState ~= ActionState.None then
    self.m_actionStateAniList[self.m_curActionState]:OnExit()
    self.m_curActionState = ActionState.None
  end
  self.m_curGameState = GameState.Normal
  if self.m_SubmitTrigger then
    self.m_SubmitTrigger:Delete()
    self.m_SubmitTrigger = nil
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.destroyStepTimer then
    self.destroyStepTimer:Stop()
    self.destroyStepTimer = nil
  end
  self:ClearAllOtherRes()
  self.m_gameObject = nil
  if self.m_holdFlagCom then
    self.m_holdFlagCom:Destroy()
    self.m_holdFlagCom = nil
  end
  self:ClearTriggerAction()
  for _, v in pairs(self.m_actionStateAniList) do
    v:Delete()
  end
  for _, v in pairs(self.m_moveStateAniList) do
    v:Delete()
  end
  if self.m_waveFlagEndTimer then
    self.m_waveFlagEndTimer:Stop()
  end
  self:ComponentDestroy()
  self:DataDestroy()
  if self.m_req ~= nil then
    self.m_req:Destroy()
    self.m_req = nil
  end
  if self.headTag then
    self.headTag:Destroy()
    self.headTag = nil
  end
  if self.skinAsset then
    self.skinAsset.completed = nil
    Resource:UnloadAsset(self.skinAsset)
    self.skinAsset = nil
  end
end

function Player:CheckDestroyStep()
  local stepList = self.stepList
  local stepPool = self.stepPool
  local now = Time.time
  for stepInst, v in pairs(stepList) do
    if stepInst.gameObject ~= nil and now > v.destroyTime then
      stepList[stepInst] = nil
      local pool = stepPool[v.path]
      if #pool < StepPoolMax then
        stepInst.gameObject:SetActive(false)
        pool[#pool + 1] = stepInst
      else
        stepInst:Destroy()
      end
    end
  end
end

function Player:ComponentDefine()
  local skinPath = path_Animator_Body
  if self.isHero == true then
    skinPath = path_Animator_Body_hero
  end
  local skinObj = self.m_gameObject.transform:Find(skinPath)
  if skinObj ~= nil then
    self.m_animator = skinObj:GetComponent(Animator)
  end
  local weaponPath = _cp_weapon
  if self.isHero == true then
    weaponPath = _cp_weapon_hero
  end
  self.weaponRoot = self:GetTransform():Find(weaponPath)
  self:ShowWeapon(false)
  local sicklePath = _cp_weapon_sickle
  if self.isHero == true then
    sicklePath = _cp_weapon_sickle_hero
  end
  self.m_objSickle = self:GetTransform():Find(sicklePath)
  if self.m_objSickle ~= nil then
    self.m_sickleTrigger = self.m_objSickle:GetComponent(typeof(CS.CitySpaceManTrigger))
    if self.m_sickleTrigger ~= nil then
    end
  end
  self.triggerHandler = self.m_gameObject:GetComponent(typeof(CS.ColliderEventHandler))
  if self.triggerHandler ~= nil then
    function self.triggerHandler.OnTriggerEnterAction(obj)
      self:OnTriggerEnter(obj)
    end
    
    function self.triggerHandler.OnTriggerExitAction(obj)
      self:OnTriggerExit(obj)
    end
  end
  local leftPath = leftPointPath
  local rightPath = rightPointPath
  if self.isHero == true then
    leftPath = leftPointPath_hero
    rightPath = rightPointPath_hero
  end
  self.leftPoint = self.transform:Find(leftPath)
  self.rightPoint = self.transform:Find(rightPath)
  local bodyPath = path_Animator_Body
  if self.isHero == true then
    bodyPath = path_Animator_Body_hero
  end
  self.triggerEvent = self.transform:Find(bodyPath):GetComponent(typeof(CS.CitySpaceManAnimationListener))
  if self.triggerEvent ~= nil then
    function self.triggerEvent.animation_walkLeft()
      self:OnWalkLeft()
    end
    
    function self.triggerEvent.animation_walkRight()
      self:OnWalkRight()
    end
  end
  local _objTransform = self.m_gameObject.transform
  self.vfxCollide = _objTransform:Find("VFX_Collide")
  self.transform.rotation = self.cur_rotation
  self.transform.position = self.cur_pos
  if self.isHero == true then
    self.carryRoot = _objTransform:Find("A_Hero_low/A_Hero_low_skin/To_unity/DeformationSystem/Root/Root_M/ResRootObj")
  else
    self.carryRoot = _objTransform:Find("A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/Root_M/ResRootObj")
  end
  local modelHeightCom = self.m_gameObject:GetComponent(typeof(CS.ModelHeight))
  if modelHeightCom then
    self.modelHeight = modelHeightCom:GetHeight()
  end
  local topTf = self.transform:Find("PveHero_Top")
  if not IsNull(topTf) then
    self.top_transform = topTf
    self.top_transform.gameObject:SetActive(true)
    local expTf = topTf:Find("PVEHero_AddExp")
    if not IsNull(expTf) then
      self.add_exp_text = expTf:GetComponent(typeof(CS.SuperTextMesh))
      self.add_exp_text.gameObject:SetActive(false)
    end
    local levelUpTf = topTf:Find("PVEHero_LevelUp")
    if not IsNull(levelUpTf) then
      self.level_up_go = levelUpTf.gameObject
      self.level_up_go:SetActive(false)
      self.level_up_text = levelUpTf:Find("LevelUpText"):GetComponent(typeof(CS.SuperTextMesh))
      self.level_up_text.text = Localization:GetString("100091")
    end
    local hpBarTf = topTf:Find("PVEHero_HpBar")
    if not IsNull(hpBarTf) then
      self.hp_bar = PveHeroHpBar.New(hpBarTf.gameObject)
      self.hp_bar:SetActive(false)
    end
  end
  local skinTf = self.transform:Find(skin_material_path)
  if skinTf ~= nil then
    self.skinRenderer = skinTf:GetComponent(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  end
end

function Player:ComponentDestroy()
  self.m_gameObject = nil
  self.transform = nil
end

function Player:DataDefine()
end

function Player:DataDestroy()
end

function Player:ReInit()
  if self.param.pos ~= nil then
    self:SetPosition(self.param.pos + self.param.extraPos)
  else
    self:SetPosition(self:GetPosWithExtra())
  end
  if self.param.rot ~= nil then
    self:SetRotation(self.param.rot)
  else
    self:SetRotation(Quaternion.LookRotation(Vector3.back))
  end
  self:InitScript()
  self:SetMoveState(MoveState.Idle)
  self:SetActionState(ActionState.Wait)
  self.m_gameObject:SetActive(self.m_visible)
  if self.initHandFlag then
    self:HandFlag()
  end
  self:RefreshMain()
  self:DoNoGainAnim()
  self:ChangeWeapon()
  self:InitCarry()
  self:InitSkin()
end

function Player:GetMoveState()
  return self.m_curMoveState
end

function Player:GetGameObject()
  return self.m_gameObject
end

function Player:GetTransform()
  return self.m_gameObject.transform
end

function Player:GetInstantiateObj()
  return self.m_gameObject
end

function Player:SetVisible(visible)
  self.m_visible = visible
  if self.m_gameObject then
    self.m_gameObject:SetActive(visible)
  end
end

function Player:InitScript()
  self.m_actionStateAniList[ActionState.Wait] = AnimationStopAttack.New(self)
  self.m_actionStateAniList[ActionState.Attack] = AnimationAttack.New(self)
  self.m_actionStateAniList[ActionState.Interact] = PlayerAniInteract.New(self)
  self.m_moveStateAniList[MoveState.Idle] = AnimationIdle.New(self)
  self.m_moveStateAniList[MoveState.Run] = AnimationRun.New(self)
  self.m_moveStateAniList[MoveState.AdjustRun] = PlayerAniAdjustRun.New(self)
  self.m_moveStateAniList[MoveState.AdjustToAttack] = PlayerAniAdjustToAttack.New(self)
  self.m_moveStateAniList[MoveState.MoveTo] = PlayerAniMoveTo.New(self)
  self.m_SubmitTrigger = Com_SubmitRes_Trigger.New(self)
  self.m_holdFlagCom = AnimationHoldFlagCom.New(self)
end

function Player:InitHandFlag(handFlag)
  self.initHandFlag = handFlag
end

function Player:SaveArchive()
end

function Player:LoadArchive(archive)
end

function Player:HandFlag()
  if self.m_holdFlagCom then
    self.m_curGameState = GameState.HoldFlag
    self.m_holdFlagCom:KillAll()
    self:ClearAllCarryObj()
    self:SetActionState(ActionState.Wait)
  else
    self.initHandFlag = true
  end
end

function Player:WaveFlag()
  self.m_curGameState = GameState.SubmitFlag
  self:SetRotation(Quaternion.Euler(0, 100, 0))
  self:PlayAnimation()
  self.m_holdFlagCom:Over()
  self.m_waveFlagEndTimer = TimerManager:GetInstance():GetTimer(4, function()
    self:SetGameStateToNormal()
    self:Idle()
  end, nil, true, false, false, false)
  self.m_waveFlagEndTimer:Start()
end

function Player:SetGameStateToNormal()
  self.m_curGameState = GameState.Normal
  self.m_holdFlagCom:HideFlag()
end

function Player:RemoveAllFlag()
  self.m_holdFlagCom:Destroy()
end

function Player:GetIdleAnimation()
  local animation_name = ""
  if self:IsLowEnergy() then
    animation_name = AnimationType.Weaken
  elseif self:IsStun() then
    animation_name = AnimationType.Weaken
  else
    animation_name = AnimationType.Idle
  end
  return animation_name
end

function Player:PlayAnimation()
  if self.m_animator == nil then
    return
  end
  local attackBuff = self.battleLevel:HasBuffByType(PveBuffType.AttackAnim)
  local animation_name = ""
  if self.m_curGameState == GameState.SubmitFlag then
    animation_name = AnimationType.WaveFlag
  elseif self.m_curMoveState == MoveState.Idle and self.m_curGameState == GameState.HoldFlag then
    animation_name = AnimationType.IdleWithFlag
    self.m_holdFlagCom:killAllIdle()
  elseif self.m_curMoveState == MoveState.Run and self.m_curGameState == GameState.HoldFlag then
    animation_name = AnimationType.RunWithFlag
    self.m_holdFlagCom:KillAllRun()
  elseif self.m_curMoveState == MoveState.Idle and self.m_curActionState == ActionState.Wait then
    animation_name = self:GetIdleAnimation()
  elseif self.m_curMoveState == MoveState.Run and self.m_curActionState == ActionState.Wait then
    animation_name = AnimationType.Run
  elseif self.m_curMoveState == MoveState.AdjustRun and self.m_curActionState == ActionState.Wait then
    animation_name = AnimationType.Run
  elseif self.m_curMoveState == MoveState.AdjustToAttack and self.m_curActionState == ActionState.Wait then
    animation_name = AnimationType.Run
  elseif self.m_curMoveState == MoveState.Idle and self.m_curActionState == ActionState.Attack then
    if attackBuff then
      animation_name = AnimationType.StandAttackBuff
    else
      animation_name = AnimationType.StandAttack
    end
  elseif self.m_curMoveState == MoveState.Run and self.m_curActionState == ActionState.Attack then
    if attackBuff then
      animation_name = AnimationType.BuffRunAttack
    else
      animation_name = AnimationType.RunAttack
    end
  elseif self.m_curMoveState == MoveState.AdjustRun and self.m_curActionState == ActionState.Attack then
    if attackBuff then
      animation_name = AnimationType.BuffRunAttack
    else
      animation_name = AnimationType.RunAttack
    end
  elseif self.m_curMoveState == MoveState.AdjustToAttack and self.m_curActionState == ActionState.Attack then
    if attackBuff then
      animation_name = AnimationType.BuffRunAttack
    else
      animation_name = AnimationType.RunAttack
    end
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
    animation_name = self:GetIdleAnimation()
  elseif self.m_curMoveState == MoveState.Run and self.m_curActionState == ActionState.ReapWait then
    animation_name = AnimationType.Run
  elseif self.m_curMoveState == MoveState.None then
    animation_name = ""
  end
  if animation_name == AnimationType.BuffRunAttack or animation_name == AnimationType.StandAttackBuff then
    local index = math.random(1, 2)
    if index == 1 then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_hero_vortex1, false)
    else
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_hero_vortex2, false)
    end
  end
  if animation_name == self.m_curActionName then
    return
  end
  self:ResetLastTrigger()
  self.m_curActionName = animation_name
  if animation_name ~= "" then
    self.m_animator:SetTrigger(animation_name)
  end
end

function Player:ResetAllTrigger()
  for _, v in pairs(AnimationType) do
    self.m_animator:ResetTrigger(v)
  end
end

function Player:ResetLastTrigger()
  if self.m_curActionName ~= nil then
    self.m_animator:ResetTrigger(self.m_curActionName)
  end
end

function Player:GetFlyPos()
  local objTransform = self.m_gameObject.transform
  if self.isHero == true then
    local hangPoint = objTransform:Find("A_soldie_shxr_env/A_soldie@xiaoren_skin/To_unity/Geometry/A_soldie_shxr/A_soldie_shxr 1/sold_point1")
    return hangPoint.position
  else
    local hangPoint = objTransform:Find("A_soldie_ben/sold_point1")
    return hangPoint.position
  end
end

function Player:ClearTriggerAction()
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

function Player:OnTriggerEnter(otherObj)
end

function Player:OnTriggerExit(otherObj)
end

function Player:OnTriggerEnter_Weapon(uuid, resType)
  if self.m_curActionState == ActionState.Attack then
    self:OnCutOnce(uuid, resType)
  end
end

function Player:GetCarryRoot()
  return self.carryRoot
end

function Player:GetTargetObjId()
  return self.targetObjId
end

function Player:OnCutOnce(uuid, resType)
  if resType ~= nil and 0 < resType then
    local collectionData = self.battleLevel:GetObj(uuid)
    if collectionData ~= nil and self.battleLevel:IsPveStaminaEnough(collectionData:GetNeedPveStamina()) then
      CommonUtil.VibratorLightImpact()
      if self.param.isMain then
        self.battleLevel:ShakeCamera()
      end
      collectionData:OnCutOnce(self:GetAttack())
      local remain = collectionData:GetBloodLeftCnt()
      if remain <= 0 then
        self:OnLeaveTarget(uuid)
        if (resType == Const.CityCutResType.HeroExp or resType == Const.CityCutResType.AttackBox) and not collectionData:IsTriggerOK() then
          self.battleLevel:DoTrigger(collectionData)
        end
      end
    end
  end
end

function Player:CarryOneObject(t)
  local count = self:GetCarryCnt()
  local isShow = self.battleLevel:IsShowCarry()
  if false then
    local pos = self:FindOneObjectByNotType(t)
    if pos ~= 0 then
      local index = pos
      local carryObj = CarryObject.New(self)
      local param = {}
      param.resType = t
      param.localPos = self:BagIndexToPos(index)
      param.visible = true
      carryObj:ReInit(param)
      if param.visible then
        carryObj:Create()
      end
      self:ReplaceOneObjectByPos(pos, carryObj)
    else
      self:ShowCarryOutRangeTips()
    end
  else
    if isShow then
      local index = count + 1
      local carryObj = CarryObject.New(self)
      local param = {}
      param.resType = t
      param.localPos = self:BagIndexToPos(index)
      param.visible = index <= self.battleLevel:GetCarryMaxNum()
      carryObj:ReInit(param)
      if param.visible then
        carryObj:Create()
      end
      self.carryObj[index] = carryObj
    end
    self:ChangeOneResType(t, 1)
    self.battleLevel:RefreshCarryResourceText()
  end
end

function Player:ClearAllOtherRes(t)
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
    if self.carryResource ~= nil then
      self.carryResource[t] = cnt
    end
  end
  self.battleLevel:RefreshCarryResourceText()
end

function Player:OnLeaveTarget(uuid)
  local attackBuff = self.battleLevel:HasBuffByType(PveBuffType.AttackAnim)
  self.m_targetUidList[uuid] = nil
  if next(self.m_targetUidList) == nil and not attackBuff then
    self:SetActionState(ActionState.Wait)
  end
end

function Player:GetCitySpaceManGameObject()
  return self.m_gameObject
end

function Player:SetPosition(pos)
  local cur_pos = self.cur_pos
  if cur_pos.x ~= pos.x or cur_pos.y ~= pos.y or cur_pos.z ~= pos.z then
    cur_pos.x, cur_pos.y, cur_pos.z = pos.x, pos.y, pos.z
    if self.transform ~= nil then
      self.transform.position = cur_pos
    end
    if self.param.isMain and (math.abs(pos.x - self.lastChangePosX) >= ChangePosDistance or math.abs(pos.z - self.lastChangePosZ) >= ChangePosDistance) then
      self.lastChangePosX = pos.x
      self.lastChangePosZ = pos.z
      self.battleLevel:OnPlayerMoveSignal(pos)
    end
  end
end

function Player:GetPosition()
  return self.cur_pos
end

function Player:SetTilePos(v)
  self:SetPosition(SceneUtils.TileToWorld(v))
end

function Player:GetTilePos()
  return SceneUtils.WorldToTile(self:GetPosition())
end

function Player:GetCurActionState()
  return self.m_curActionState
end

function Player:IsFarmMode()
  if self.m_curActionState == ActionState.ToPlant or self.m_curActionState == ActionState.ToWater or self.m_curActionState == ActionState.ReapWait or self.m_curActionState == ActionState.ToReap then
    return true
  end
  return false
end

function Player:IsSlowMode()
  if self.m_curActionState == ActionState.ToPlant or self.m_curActionState == ActionState.ToWater or self.m_curActionState == ActionState.ToReap then
    return true
  end
  return false
end

function Player:SetMoveState(moveState)
  if self.m_gameObject ~= nil and moveState ~= nil and self.m_curMoveState ~= moveState then
    if self.m_curMoveState ~= MoveState.None then
      self.m_moveStateAniList[self.m_curMoveState]:OnExit()
    end
    self.m_curMoveState = moveState
    if self.m_curMoveState ~= MoveState.None then
      self.m_moveStateAniList[self.m_curMoveState]:OnEnter()
    end
  end
end

function Player:SetActionState(attackState)
  if self.m_curActionState == attackState then
    return
  end
  if self.m_curActionState < ActionState.None then
    self.m_actionStateAniList[self.m_curActionState]:OnExit()
  end
  self.m_curActionState = attackState
  if self.m_curActionState < ActionState.None then
    self.m_actionStateAniList[self.m_curActionState]:OnEnter()
  end
end

local velocity = Vector3.unity_vector3(0, 0, 0)
local smoothTime = 0.3
local tmpV1 = Vector3.New(0, 0, 0)
local tmpV2 = Vector3.New(0, 0, 0)
local tmpV3 = Vector3.New(0, 0, 0)

function Player:OnUpdate()
  if self.m_gameObject == nil or self.m_curGameState == GameState.None or not self.m_visible then
    return
  end
  if self.battleLevel:IsUseMoveY() then
    self:SetPosOnGround()
  end
  if self.m_startCameraFollow and not self.battleLevel:IsPlayingShakeCamera() then
    self:UpdateCameraFollow()
  end
  self.time = self.time + Time.deltaTime
  self:CheckAttackTime()
  local hasDoUpdate = false
  if self.m_curMoveState == MoveState.AdjustRun or self.m_curMoveState == MoveState.AdjustToAttack or self.m_curMoveState == MoveState.MoveTo then
    self.m_moveStateAniList[self.m_curMoveState]:OnUpdate()
    hasDoUpdate = true
  end
  if self.m_deltaT < self.subMitTime then
    self.m_deltaT = self.m_deltaT + Time.deltaTime
    return
  end
  self.m_deltaT = 0
  if not hasDoUpdate then
    self.m_moveStateAniList[self.m_curMoveState]:OnUpdate()
  end
  if self.m_curGameState == GameState.Normal and not self:IsFarmMode() then
    self.m_actionStateAniList[self.m_curActionState]:OnUpdate()
    if self.m_curActionState ~= ActionState.Interact and not DataCenter.GuideManager:InGuide() then
      self:CheckCollectState()
    end
  end
  if self.m_curActionState ~= ActionState.Interact and not DataCenter.GuideManager:InGuide() then
    if self.param.isMain then
      if self.m_SubmitTrigger:CheckSubmitRes() then
        self.continueSubTime = self.continueSubTime + 1
        if self.continueSubTime >= ChangeSubmitTime then
          self.continueSubTime = 0
          if self.subMitCount < ChangeSubmitCount then
            self.subMitCount = self.subMitCount + 1
          end
        end
      else
        self.continueSubTime = 0
        self.subMitCount = 1
      end
      self:CheckCollideTriggerPoint()
    end
    self:OnPlayEffect()
  end
  if self.hp_bar ~= nil then
    self.hp_bar:OnUpdate()
  end
end

function Player:StartCameraFollow(spawnPos)
  if self.param.isMain then
    self.m_startCameraFollow = true
    self:InitLevelCameraLookat(spawnPos)
  end
end

function Player:PauseCameraFollow()
  self.m_startCameraFollow = false
end

function Player:ResumeCameraFollow()
  self.m_startCameraFollow = true
end

function Player:SetPosOnGround()
  local p1 = TestOnGroundPoint1
  local p2 = TestOnGroundPoint2
  local cur_pos = self.cur_pos
  p1.x, p1.y, p1.z = cur_pos.x, 1000, cur_pos.z
  p2.x, p2.y, p2.z = cur_pos.x, 1000 - (self:GetModelHeight() or 1), cur_pos.z
  local hitCount = Physics.CapsuleCastNonAlloc(p1, p2, 0.5, Vector3.down, self.hitInfo, 10000, LayerMask.GetMask("Terrain"))
  if 0 < hitCount then
    local maxY = 0
    for i = 0, hitCount - 1 do
      if maxY < self.hitInfo[i].point.y then
        maxY = self.hitInfo[i].point.y
      end
    end
    p1.y = maxY
    self:SetPosition(p1)
  end
end

function Player:IsCuttingObject()
  return self.targetObjId ~= nil or next(self.m_targetUidList) ~= nil
end

function Player:GetLeader()
  return self.battleLevel:GetPlayer()
end

function Player:InitLevelCameraLookat(playerPos)
  local v2 = playerPos
  local v3 = Vector3.back
  if self.m_gameObject ~= nil then
    v2 = self.m_gameObject.transform.position
    v3 = self.m_gameObject.transform.forward
  end
  tmpV2:Set(v2.x, v2.y, v2.z)
  tmpV3:Set(v3.x, v3.y, v3.z)
  tmpV2.x = tmpV2.x + tmpV3.x * 0.3
  tmpV2.y = tmpV2.y + tmpV3.y * 0.3
  tmpV2.z = tmpV2.z + tmpV3.z * 0.3
  self.battleLevel:Lookat(tmpV2)
end

function Player:UpdateCameraFollow()
  if self.m_gameObject == nil then
    return
  end
  if not DataCenter.GuideManager:InGuide() then
    local v1 = self.battleLevel:GetFollowCameraTarget()
    local v2 = self.m_gameObject.transform.position
    local v3 = self.m_gameObject.transform.forward
    tmpV1:Set(v1.x, v1.y, v1.z)
    tmpV2:Set(v2.x, v2.y, v2.z)
    tmpV3:Set(v3.x, v3.y, v3.z)
    tmpV2.x = tmpV2.x + tmpV3.x * 0.3
    tmpV2.y = tmpV2.y + tmpV3.y * 0.3
    tmpV2.z = tmpV2.z + tmpV3.z * 0.3
    local distance = true
    if math.abs(tmpV1.x - tmpV2.x) < 0.01 and math.abs(tmpV1.y - tmpV2.y) < 0.01 and math.abs(tmpV1.z - tmpV2.z) < 0.01 then
      distance = false
      velocity.x, velocity.y, velocity.z = 0, 0, 0
    end
    if distance then
      local targetPos, v = Vector3.SmoothDamp(v1, tmpV2, velocity, smoothTime)
      velocity = v
      self.battleLevel:CameraFollowLookat(targetPos)
    end
  end
end

function Player:GetTriggerIds(radius, collectType, isAttack)
  local result = {}
  local attackAngle, attackTime = self:GetAttackAngleAndTime()
  local absAttackAngle = math.abs(attackAngle)
  local angleMin = 90 - absAttackAngle
  local angleMax = 90 + absAttackAngle
  local angleSpeed = attackTime / (2 * absAttackAngle)
  local pos = self:GetPosition()
  local tilesPos = SceneUtils.WorldToTileFloat(pos)
  local savePointId = {}
  local minX, minY = SceneUtils.WorldToTileXZ(pos.x - radius, pos.z - radius)
  local maxX, maxY = SceneUtils.WorldToTileXZ(pos.x + radius, pos.z + radius)
  local cur = Vector2.New(0, 0)
  local deltaVec = Vector2.New(0, 0)
  for x = minX, maxX do
    for y = minY, maxY do
      cur.x = x
      cur.y = y
      local angle = Vector2.Angle(Vector2.up, cur - tilesPos)
      if angleMin <= angle and angleMax >= angle then
        local pointId = SceneUtils.TilePosToIndex(cur)
        if savePointId[pointId] == nil then
          savePointId[pointId] = true
          if collectType == Const.CheckCollectType.Collect then
            local canAttack = false
            local list = self.battleLevel.collectionMgr:GetCollectList(pointId)
            if list ~= nil then
              for k, v in ipairs(list) do
                local newPos = SceneUtils.WorldToTileFloat(v:GetPosition())
                local dis = Vector2.Distance(newPos, tilesPos) * 2
                deltaVec.x = newPos.x - tilesPos.x
                deltaVec.y = newPos.y - tilesPos.y
                local newAngle = Vector2.Angle(Vector2.up, deltaVec)
                if angleMax >= newAngle and angleMin <= newAngle and radius >= dis then
                  if not canAttack and self.battleLevel:IsPveStaminaEnough(v:GetNeedPveStamina()) then
                    canAttack = true
                  end
                  if canAttack then
                    local id = v:GetObjId()
                    local param = {}
                    param.obj = v
                    param.id = id
                    param.time = angleSpeed * math.abs(newAngle + attackAngle)
                    param.collectType = collectType
                    param.resType = v:GetResType()
                    param.angle = newAngle
                    param.dis = dis
                    table.insert(result, param)
                    if isAttack and self.waitAttackList[id] == nil then
                      self.waitAttackList[id] = param
                    end
                  end
                end
              end
            end
            if self.param.isMain then
              local triggerList = self.battleLevel:GetTriggersByPointId(pointId)
              for k, v in ipairs(triggerList) do
                local triggerPoint = v
                if triggerPoint ~= nil and triggerPoint:IsTypeCanAttack() then
                  local newPos = SceneUtils.WorldToTileFloat(triggerPoint:GetPosition())
                  local dis = Vector2.Distance(newPos, tilesPos) * 2
                  deltaVec.x = newPos.x - tilesPos.x
                  deltaVec.y = newPos.y - tilesPos.y
                  local newAngle = Vector2.Angle(Vector2.up, deltaVec)
                  if angleMax >= newAngle and angleMin <= newAngle and radius >= dis then
                    local id = triggerPoint:GetObjId()
                    local param = {}
                    param.obj = triggerPoint
                    param.id = id
                    param.time = angleSpeed * math.abs(newAngle + attackAngle)
                    param.resType = triggerPoint.config.resType
                    param.collectType = Const.CheckCollectType.Trigger
                    param.angle = newAngle
                    param.dis = dis
                    table.insert(result, param)
                    if isAttack and self.waitAttackList[id] == nil then
                      self.waitAttackList[id] = param
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  return result
end

function Player:GetNearestTriggerId()
  local list = self:GetTriggerIds(CheckCollectRotationFollowRadius, Const.CheckCollectType.Collect)
  if 0 < #list then
    local nearestId
    local minDist = 1000000
    for k, v in ipairs(list) do
      local dist = v.dis
      if minDist > dist then
        minDist = dist
        nearestId = v.id
      end
    end
    return nearestId
  end
end

function Player:CheckCollectState()
  if not self.param.isNoGain then
    local toAttack = false
    local attackBuff = self.battleLevel:HasBuffByType(PveBuffType.AttackAnim)
    self.m_targetUidList = {}
    self.targetObjId = nil
    if self.battleLevel.started and (not self.battleLevel:IsUseRandomAttackModelLevel() or self.battleLevel.isWalk == false) and not attackBuff and not self:IsStun() then
      local list = self:GetTriggerIds(self:GetAttackCollectRadius(), Const.CheckCollectType.Collect)
      for k, v in ipairs(list) do
        self.m_targetUidList[v.id] = true
        toAttack = true
      end
      if toAttack then
        local selfPos = self:GetPosition()
        local selfVec = Vector2.New(self.transform.forward.x, self.transform.forward.z)
        local maxCos = -2
        self.targetObjId = nil
        for k, _ in pairs(self.m_targetUidList) do
          local targetPos = self.battleLevel:GetObj(k):GetPosition()
          local targetVec = Vector2.New(targetPos.x - selfPos.x, targetPos.z - selfPos.z)
          local cos = Vector2.Dot(selfVec, targetVec) / (Vector2.Magnitude(selfVec) * Vector2.Magnitude(targetVec))
          if (self.battleLevel:IsSkillLevel() or 0 < cos) and maxCos < cos then
            maxCos = cos
            self.targetObjId = k
          end
        end
      else
        self.targetObjId = nil
      end
    end
    if toAttack and self.targetObjId ~= nil or attackBuff then
      self:SetActionState(ActionState.Attack)
      self:ChangeWeapon()
      if self.battleLevel:IsSkillLevel() then
        self:TurnToTarget()
      end
    elseif self.m_curActionState == ActionState.Attack then
      self.m_targetUidList = {}
      self:SetActionState(ActionState.Wait)
    end
  end
end

function Player:TurnToTargetId(targetId)
  if targetId ~= nil then
    targetId = toInt(targetId)
    local obj = self.battleLevel:GetTriggerByTriggerId(targetId)
    if obj then
      local selfPos = self:GetPosition()
      local objPos = obj:GetPosition()
      local lookRot = Quaternion.LookRotation(Vector3.Normalize(objPos - selfPos), Vector3.up)
      self:TurnToRotation(lookRot)
    end
  end
end

function Player:TurnToTarget()
  local objId = self:GetTargetObjId()
  if objId ~= nil then
    local obj = self.battleLevel:GetObj(objId)
    if obj then
      local selfPos = self:GetPosition()
      local objPos = obj:GetPosition()
      local lookRot = Quaternion.LookRotation(Vector3.Normalize(objPos - selfPos), Vector3.up)
      self:TurnToRotation(lookRot)
    end
  end
end

function Player:TurnToRotation(rotation)
  self:SetRotation(rotation)
end

function Player:TurnToPos(endPos)
  if self:IsMoveTo() then
    self.waitTurnToPos = endPos
  else
    self.waitTurnToPos = nil
    local selfPos = self:GetPosition()
    local lookRot = Quaternion.LookRotation(Vector3.Normalize(endPos - selfPos), Vector3.up)
    self:TurnToRotation(lookRot)
  end
end

function Player:CheckCollideTriggerPoint()
end

function Player:Walk(vx, vz)
  if self.param.isNoGain then
    return
  end
  if DataCenter.GuideManager:InGuide() or self.m_gameObject == nil or vx == nil or vz == nil or vx == 0 and vz == 0 then
    return
  end
  if self.m_curGameState == GameState.SubmitFlag or self.m_curGameState == GameState.None or self.m_curActionState == ActionState.Interact then
    return
  end
  if self:IsStun() then
    return
  end
  local t = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UITutorialAnimation)
  if t and not self.timer then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UITutorialAnimation)
      self.timer = nil
    end, 2)
  end
  self:SetMoveState(MoveState.Run)
  self.m_moveStateAniList[MoveState.Run]:SetVelocity(vx, vz)
end

function Player:StopWalk()
  if self.param == nil then
    self:SetMoveState(MoveState.Idle)
  else
    if self.param.isNoGain then
      return
    end
    self:SetMoveState(MoveState.Idle)
  end
end

function Player:Idle()
  self:SetMoveState(MoveState.None)
  self:PlayAnimation()
  self:SetMoveState(MoveState.Idle)
end

function Player:GetTopObjectType()
  if #self.carryObj <= 0 then
    return nil
  end
  local obj = self.carryObj[#self.carryObj]
  return obj:GetType()
end

function Player:GetCarryCnt()
  local result = 0
  for k, v in pairs(self.carryResource) do
    result = result + v
  end
  return result
end

function Player:ClearAllCarryObj()
  if table.count(self.carryObj) == 0 then
    return
  end
  for _, v in pairs(self.carryObj) do
    v:Destroy()
  end
  self.carryObj = {}
  self.carryResource = {}
end

function Player:IsFinalState()
  if self.m_curGameState == GameState.HoldFlag then
    return true
  end
  return false
end

function Player:IsNeedCreate()
  return self.m_req == nil
end

function Player:SetRotation(rotation)
  if self.cur_rotation ~= rotation then
    self.cur_rotation = rotation
    self.transform.rotation = self.cur_rotation
    if self.param.isMain then
      local rot = rotation.eulerAngles.y
      if math.abs(rot - self.lastChangeRot) >= ChangeRotDistance then
        self.lastChangeRot = rot
        self.battleLevel:OnPlayerMoveSignal(self:GetPosition())
      end
    end
  end
end

function Player:GetRotation()
  return self.cur_rotation
end

function Player:GetWeaponSize()
  return self.weaponSize or 1
end

function Player:SetWeaponSize(size)
  self.weaponSize = math.max(1, size)
end

function Player:GetPosWithExtra()
  return self.battleLevel:GetPosition() + self.param.extraPos
end

function Player:LeaveAdjustRun()
  self:SetMoveState(MoveState.Idle)
end

function Player:LeaveAdjustToAttack()
  self:SetMoveState(MoveState.Idle)
end

function Player:LeaveMoveTo()
  self:ResetState()
  if self.waitTurnToPos ~= nil then
    self:TurnToPos(self.waitTurnToPos)
  end
end

function Player:MoveTo(endPosArr)
  self.moveToEndPosArr = endPosArr
  self:SetMoveState(MoveState.MoveTo)
  self:ResetLastTrigger()
  self.m_curActionName = AnimationType.Run
  self.m_animator:SetTrigger(self.m_curActionName)
end

function Player:ChangeSubPlayerToFollow()
  if not self.param.isNoGain then
    self:SetMoveState(MoveState.AdjustRun)
  end
end

function Player:ChangeSubPlayerToAdjustToAttack(objId)
  if not self.param.isNoGain then
    self.adjustAttackObjId = objId
    self:SetMoveState(MoveState.AdjustToAttack)
  end
end

function Player:GetAdjustAttackObjId()
  return self.adjustAttackObjId
end

function Player:SetAdjustAttackObjId(objId)
  self.adjustAttackObjId = objId
end

function Player:OnWalkLeft()
  table.insert(self.stepDic, leftprintEffect)
end

function Player:OnWalkRight()
  table.insert(self.stepDic, rightprintEffect)
end

function Player:OnPlayEffect()
  if self.leftPoint == nil or self.rightPoint == nil then
    return
  end
  for k, v in pairs(self.stepDic) do
    if v ~= nil then
      if v == leftprintEffect then
        self:CloneEffect(v, self.leftPoint, LeftStepRot)
      else
        self:CloneEffect(v, self.rightPoint, RightStepRot)
      end
    end
    self.stepDic[k] = nil
  end
end

function Player:CloneEffect(path, root, euler)
  local stepList = self.stepList
  local stepPool = self.stepPool[path]
  local stepInst
  local tremove = table.remove
  for i = #stepPool, 1, -1 do
    if stepPool[i].isDone then
      stepInst = tremove(stepPool, i)
      break
    end
  end
  if stepInst == nil then
    stepInst = Resource:InstantiateAsync(path)
    stepInst:completed("+", function(req)
      local transform = req.gameObject.transform
      transform:SetParent(root)
      transform:Set_localPosition(0, 0, 0)
      transform.localRotation = euler
      transform:SetParent(nil)
      transform:Set_localScale(1, 1, 1)
    end)
  else
    stepInst.gameObject:SetActive(true)
    local transform = stepInst.gameObject.transform
    transform:SetParent(root)
    transform:Set_localPosition(0, 0, 0)
    transform.localRotation = euler
    transform:SetParent(nil)
    transform:Set_localScale(1, 1, 1)
  end
  stepList[stepInst] = {
    path = path,
    destroyTime = Time.time + 2
  }
end

function Player:ClearTriggerEvent()
  if self.triggerEvent then
    self.triggerEvent.animation_walkLeft = nil
    self.triggerEvent.animation_walkRight = nil
    self.triggerEvent = nil
  end
end

function Player:ChangeParam(param)
  self.param = param
end

function Player:RefreshMain()
  if self.param.isMain then
    self.scale = 1
    if self.param.pos ~= nil then
      self:SetPosition(self.param.pos)
    end
    self:StartCameraFollow(self.param.pos)
    self.battleLevel:RefreshCarryUIParent()
  else
    self.m_startCameraFollow = false
    if self.doScale ~= nil and self.doScale == true then
      self.scale = 1
    else
      self.scale = 0.8
    end
    self:ChangeSubPlayerToFollow()
  end
  self.transform:Set_localScale(self.scale, self.scale, self.scale)
end

function Player:GetAllCarryResList(result)
  if result == nil then
    result = {}
  end
  for k, v in ipairs(Const.CarryResourceOrder) do
    if self.carryResource[v] ~= nil then
      table.insert(result, {
        resourceType = v,
        num = self.carryResource[v]
      })
    end
  end
  return result
end

function Player:ReplaceOneObjectByPos(index, newCarryObj)
  if 1 <= index and index <= #self.carryObj then
    local obj = self.carryObj[index]
    if obj ~= nil then
      local resType = obj:GetType()
      obj:Destroy()
      self:ChangeOneResType(resType, -1)
    end
    self.carryObj[index] = newCarryObj
    self:ChangeOneResType(newCarryObj:GetType(), 1)
    self.battleLevel:RefreshCarryResourceText()
  end
end

function Player:BagIndexToPos(index)
  index = index - 1
  local pos
  local max = self.battleLevel:GetCarryMaxNum()
  local perRowCount = self.battleLevel:GetCarryPerRowCount()
  local row = math.floor(index / perRowCount)
  local col = index % perRowCount
  local maxRow = self.battleLevel:GetCarryRow()
  if index >= max then
    pos = Vector3.New(perRowCount * -0.19, -0.25 - 0.17 * maxRow, 0)
  else
    pos = Vector3.New(col * -0.19, -0.25 - 0.17 * row, 0)
  end
  return pos
end

function Player:FindOneObjectByNotType(notType)
  for i = table.count(self.carryObj), 1, -1 do
    if self.carryObj[i]:GetType() ~= notType then
      return i
    end
  end
  return 0
end

function Player:PlayInterActAnim(animName, triggerId, animTime)
  if self.m_curActionState == ActionState.Interact then
    return Const.PlayerInteractCode.InteractCode_Already_Interact
  end
  if not string.IsNullOrEmpty(animName) then
    self:SetActionState(ActionState.Interact)
    self.m_actionStateAniList[ActionState.Interact]:SetTriggerId(triggerId)
    self.m_actionStateAniList[ActionState.Interact]:SetAnimTime(animTime)
    self:ResetAllTrigger()
    if string.contains(animName, "attack") then
      self:ShowWeapon(true)
    end
    self.m_curActionName = animName
    self.m_animator:SetTrigger(animName)
    return Const.PlayerInteractCode.InteractCode_OK
  end
  return Const.PlayerInteractCode.InteractCode_Fail
end

function Player:LeaveInteractState()
  self:ResetState()
end

function Player:ResetState()
  if self.m_gameObject ~= nil then
    self:SetMoveState(MoveState.Idle)
    self:SetActionState(ActionState.Wait)
  end
end

function Player:PlaySaveAnim()
  EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {
    target = self.transform
  })
  self:ResetAllTrigger()
  self.m_animator:SetTrigger(AnimationType.Jump)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Guide_Get_New_Hero, false)
end

function Player:RefreshBuff()
  self:PlayAnimation()
  local weaponSize = 1
  local buffValue = self.battleLevel:GetBuffEffectValueByType(PveBuffType.WeaponBigger)
  if 0 < buffValue then
    weaponSize = weaponSize * buffValue
  end
  self:SetWeaponSize(weaponSize)
  local weapon = self:GetCurWeapon()
  if weapon ~= nil then
    weapon:RefreshWeaponSize()
  end
  weaponSize = 1
  buffValue = self.battleLevel:GetBuffEffectValueByType(PveBuffType.AddAttack)
  if 0 < buffValue then
    weaponSize = weaponSize * buffValue
  end
  self:SetAttack(weaponSize)
  weaponSize = 1
  buffValue = self.battleLevel:GetBuffEffectValueByType(PveBuffType.AttackQuick)
  if 0 < buffValue then
    weaponSize = weaponSize * buffValue
  end
  self:SetAttackSpeed(weaponSize)
  if self.m_moveStateAniList ~= nil and self.m_moveStateAniList[self.m_curMoveState] ~= nil then
    self.m_moveStateAniList[self.m_curMoveState]:RefreshBuff()
  end
  if self.m_actionStateAniList ~= nil and self.m_actionStateAniList[self.m_curActionState] ~= nil then
    self.m_actionStateAniList[self.m_curActionState]:RefreshBuff()
  end
  if self:IsStun() then
    self:CreateStunEffect()
    self:CheckCollectState()
  else
    self:DestroyStunEffect()
  end
end

function Player:GetCarryCountByResType(resType)
  if self.carryResource[resType] ~= nil then
    return self.carryResource[resType]
  end
  return 0
end

function Player:ChangeOneResType(resType, num)
  if self.carryResource[resType] == nil then
    self.carryResource[resType] = num
  else
    self.carryResource[resType] = self.carryResource[resType] + num
  end
  if self.carryResource[resType] <= 0 then
    self.carryResource[resType] = nil
  end
end

function Player:GetAttack()
  return self.attack or 1
end

function Player:SetAttack(attack)
  self.attack = attack
  self:ChangeWeapon()
end

function Player:GetAttackSpeed()
  return self.attackSpeed or 1
end

function Player:SetAttackSpeed(attack)
  self.attackSpeed = attack
end

function Player:SetAnimSpeed(speed)
  if self.m_animator ~= nil then
    self.m_animator.speed = speed
  end
end

function Player:UpdateExpInfo(info)
  if info.expAdd <= 0 then
    return
  end
  self:ShowAddExp(info.expAdd)
  if self.level ~= nil and info.level > self.level then
    self.level = info.level
    self:ShowLevelUp()
  end
  self:FlyExpBall(info)
end

function Player:TopFaceToCamera()
  if not IsNull(self.top_transform) then
    self.top_transform.rotation = self.battleLevel:GetCameraRotation()
  end
end

function Player:ShowAddExp(addExp)
  if self.add_exp_text == nil then
    return
  end
  if self.level_up_timer ~= nil then
    return
  end
  if self.addExp == nil then
    self.addExp = 0
  end
  self.addExp = self.addExp + addExp
  self.add_exp_text.text = Localization:GetString("100332") .. " +" .. self.addExp
  self.add_exp_text.gameObject:SetActive(true)
  if self.add_exp_timer ~= nil then
    self.add_exp_timer:Stop()
  end
  self.add_exp_timer = TimerManager:GetInstance():DelayInvoke(function()
    self.add_exp_timer = nil
    self.add_exp_text.gameObject:SetActive(false)
    self.addExp = 0
  end, 2)
end

function Player:ShowLevelUp()
  if self.level_up_go == nil then
    return
  end
  self.level_up_go:SetActive(true)
  if self.level_up_timer ~= nil then
    self.level_up_timer:Stop()
  end
  self.level_up_timer = TimerManager:GetInstance():DelayInvoke(function()
    self.level_up_timer = nil
    self.level_up_go:SetActive(false)
  end, 2)
  if self.add_exp_timer ~= nil then
    self.add_exp_timer:Stop()
    self.add_exp_timer = nil
    self.add_exp_text.gameObject:SetActive(false)
    self.addExp = 0
  end
end

function Player:ShowLevelUpEffect()
  local effReq = Resource:InstantiateAsync("Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_upgrade.prefab")
  effReq:completed("+", function(req)
    local tf = req.gameObject.transform
    tf:SetParent(self.transform)
    tf.localPosition = Vector3.New(0, 0.62, 0)
    TimerManager:GetInstance():DelayInvoke(function()
      if req ~= nil then
        req:Destroy()
      end
    end, 3)
  end)
end

function Player:ShowExpPopEffect()
  local effReq = Resource:InstantiateAsync("Assets/Main/Prefabs/PVE/PveHero_ExpPop.prefab")
  effReq:completed("+", function(req)
    local tf = req.gameObject.transform
    tf.position = self.transform.position + Vector3.New(2, 2, 0)
    tf.rotation = self.battleLevel:GetCameraRotation()
    local txt = tf:Find("PVEHero_AddExp"):GetComponent(typeof(CS.SuperTextMesh))
    txt.text = Localization:GetString("100332")
    DOTween.Sequence():Append(tf:DOLocalMove(self.transform.position + Vector3.New(2, 3, 0), 0.5):SetEase(CS.DG.Tweening.Ease.OutCirc)):OnComplete(function()
      if req ~= nil then
        req:Destroy()
      end
    end)
  end)
end

function Player:CreateStunEffect()
  if self.stunReq ~= nil then
    return
  end
  self.stunReq = Resource:InstantiateAsync("Assets/_Art/Effect/prefab/scene/VFX_xuanyun.prefab")
  self.stunReq:completed("+", function(req)
    if self.transform == nil then
      self.stunReq:Destroy()
      self.stunReq = nil
      return
    end
    local tf = req.gameObject.transform
    tf:SetParent(self.transform)
    tf.localPosition = Vector3.zero
    tf.localRotation = Quaternion.identity
  end)
end

function Player:DestroyStunEffect()
  if self.stunReq ~= nil then
    self.stunReq:Destroy()
    self.stunReq = nil
  end
end

function Player:ShowHpBar(show)
  if self.hp_bar ~= nil then
    self.hp_bar:SetActive(show)
  end
end

function Player:SetHpBarVal(cur, max, showChange)
  if self.hp_bar ~= nil then
    self.hp_bar:SetVal(cur, max, showChange)
  end
end

function Player:CreateHeadTag()
  self.headTag = Resource:InstantiateAsync(Const.MainPlayerTag)
  self.headTag:completed("+", function()
    local transform = self.headTag.gameObject.transform
    transform:SetParent(self.transform, false)
    local y = self.modelHeight and self.modelHeight + 0.1 or 1.8
    transform:Set_localPosition(0, y, 0)
  end)
end

function Player:DestroyHeadTag()
  if self.headTag then
    self.headTag:Destroy()
    self.headTag = nil
  end
end

function Player:GetModelHeight()
  return self.modelHeight
end

function Player:HasHeadTag()
  return self.headTag ~= nil
end

function Player:FlyExpBall(info)
  if self.add_exp_text == nil then
    return
  end
  local camera = self.battleLevel.touchCamera
  local param = {}
  param.pos = camera:WorldToScreenPoint(self.add_exp_text.transform.position)
  param.info = info
  EventManager:GetInstance():Broadcast(EventId.PVEHeroExpFly, param)
end

function Player:DoNoGainAnim()
  if self.param.isNoGain then
  end
end

function Player:GetForward()
  return self.cur_rotation:Forward()
end

function Player:GetWeaponName()
  local useAXE = self.battleLevel:HasBuffByType(PveBuffType.AttackAnim)
  if not useAXE and self.targetObjId ~= nil then
    local collectionData = self.battleLevel:GetObj(self.targetObjId)
    if collectionData ~= nil and collectionData.GetType ~= nil then
      local id = collectionData:GetType()
      local template = DataCenter.PveAtomTemplateManager:GetTemplate(id)
      if template ~= nil and template.type == PveAtomType.Tree then
        useAXE = true
      end
    end
  end
  if useAXE then
    return "Assets/_Art/Models/Soldier/Ben_weapons/prefab/A_soldie_ben_axe.prefab"
  end
  local attack = self:GetAttack()
  if attack == 2 then
    return "Assets/_Art/Models/Soldier/Ben_weapons/prefab/A_soldie_ben_weapons01.prefab"
  elseif 2 < attack then
    return "Assets/_Art/Models/Soldier/Ben_weapons/prefab/A_soldie_ben_weapons02.prefab"
  else
    return "Assets/_Art/Models/Soldier/Ben_weapons/prefab/A_soldie_ben_weapons.prefab"
  end
  return "Assets/_Art/Models/Soldier/Ben_weapons/prefab/A_soldie_ben_weapons.prefab"
end

function Player:ChangeWeapon()
  if self.weaponRoot ~= nil then
    local weaponName = self:GetWeaponName()
    if weaponName ~= self.weaponName then
      if self.weapon[weaponName] == nil then
        local playerWeapon = PlayerWeapon.New()
        playerWeapon:Create(self, weaponName, self.isHero, self.weaponRoot)
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
end

function Player:SetWeaponColliderEnable(enable)
  local weapon = self:GetCurWeapon()
  if weapon then
    self.weaponEnable = enable
    weapon:SetWeaponColliderEnable(enable)
    if enable then
      self.time = 0
      self:GetTriggerIds(self:GetAttackCollectRadius(), Const.CheckCollectType.Collect, true)
    end
  end
end

function Player:GetCurWeapon()
  if self.weaponName ~= nil then
    return self.weapon[self.weaponName]
  end
end

function Player:GetTrailEffectRoot()
  local weapon = self:GetCurWeapon()
  if weapon then
    return weapon:GetTrailEffectRoot()
  end
end

function Player:ShowCarryOutRangeTips()
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.showCarryTipsTime + ShowCarryTipsTimeDuring then
    self.showCarryTipsTime = now
    UIUtil.ShowTipsId(tonumber(GameDialogDefine.PVE_CARRY_OUT_RANGE_TIP))
  end
end

function Player:SubmitObjectAndGetSubmitCount(resType, pos, subCount, remain)
  local result = 0
  local carryCount = table.count(self.carryObj)
  if 0 < carryCount then
    for i = carryCount, 1, -1 do
      local obj = self.carryObj[i]
      if obj ~= nil then
        if obj:GetType() == resType then
          result = result + 1
        end
        if carryCount == i then
          obj:SetVisible(true)
          obj:FlyOut(pos, function()
            if obj ~= nil then
              obj:Destroy()
            end
          end)
        else
          obj:Destroy()
        end
      end
      self.carryObj[i] = nil
      subCount = subCount - 1
      if subCount <= 0 or remain <= result then
        break
      end
    end
  end
  return result
end

function Player:CheckAttackTime()
  local removeId = {}
  for k, v in pairs(self.waitAttackList) do
    if self.time >= v.time then
      table.insert(removeId, k)
      self:OnTriggerEnter_Weapon(v.id, v.resType)
    end
  end
  local count = table.count(removeId)
  if 0 < count then
    for i = count, 1, -1 do
      self.waitAttackList[removeId[i]] = nil
    end
  end
end

function Player:GetAttackAngleAndTime()
  local angle = -CheckCollectRotationAngle
  local time = AttackAnimTime
  if self.m_curActionState == ActionState.Attack then
    local attackAnimDirection = self.m_actionStateAniList[self.m_curActionState]:GetAttackDirection()
    if attackAnimDirection == AttackAnimDirection.LeftToRight then
      angle = CheckCollectRotationAngle
      time = AttackAnimTime
    elseif attackAnimDirection == AttackAnimDirection.RightToLeft then
      angle = -CheckCollectRotationAngle
      time = AttackAnimTime
    elseif attackAnimDirection == AttackAnimDirection.Circle then
      angle = -CheckCollectRotationCircleAngle
      time = BuffAttackAnimTime
    end
  elseif not self.param.isMain then
    angle = -CheckCollectRotationFollowAngle
    time = 0
  end
  time = time / self:GetAttackSpeed()
  return angle, time
end

function Player:GetAttackCollectRadius()
  local heroSize = self.battleLevel:GetHeroSize()
  local weaponDefaultSize = self.battleLevel:GetWeaponDefaultSize()
  return CheckCollectAttackSize * heroSize * (InitWeaponRange + WeaponLength * self.weaponSize * weaponDefaultSize)
end

function Player:IsLowEnergy()
  return LuaEntry.Player:GetCurPveStamina() < 1
end

function Player:IsStun()
  local effectValue = self.battleLevel:GetBuffEffectValueByType(PveBuffType.Stun)
  return 0 < effectValue
end

function Player:ShowWeapon(isShow)
  if self.weaponRoot ~= nil then
    self.weaponRoot.gameObject:SetActive(isShow)
  end
end

function Player:GetMoveToEndPosArr()
  return self.moveToEndPosArr
end

function Player:IsMoveTo()
  return self.m_curMoveState == MoveState.MoveTo
end

function Player:IsInInteract()
  return self.m_curActionState == ActionState.Interact
end

function Player:PlayTrail(attackDirection)
  local param = {}
  param.attackDirection = attackDirection
  param.pos = self:GetPosition()
  param.rot = self:GetRotation()
  local scale = self:GetWeaponSize() * self.battleLevel:GetWeaponDefaultSize()
  param.localScale = Vector3.New(scale, scale, scale)
  self.weaponTrailMgr:PlayTrail(param)
end

function Player:CanShowResetBtn()
  return self.m_curActionState == ActionState.Wait
end

function Player:ChangeCarryObjectNum(resType, num, pos)
  if 0 < num then
    for i = 1, num do
      self:CarryOneObject(resType)
    end
  elseif num < 0 then
    local result = 0
    local carryCount = table.count(self.carryObj)
    if 0 < carryCount then
      for i = carryCount, 1, -1 do
        local obj = self.carryObj[i]
        if obj ~= nil and obj:GetType() == resType then
          result = result + 1
          if result == 1 and pos ~= nil then
            obj:SetVisible(true)
            obj:FlyOut(pos, function()
              if obj ~= nil then
                obj:Destroy()
              end
            end)
          else
            obj:Destroy()
          end
          table.remove(self.carryObj, i)
          if result >= -num then
            break
          end
        end
      end
      self:AdjustCarryPos()
    end
    self:ChangeOneResType(resType, num)
  end
end

function Player:InitCarry()
  if self.param.isMain and self.battleLevel:IsShowCarry() then
    local list = self.battleLevel:GetAllCarryResourceItemList()
    for k, v in ipairs(list) do
      self:ChangeCarryObjectNum(v.resourceType, v.num)
    end
  end
end

function Player:InitSkin()
  if not string.IsNullOrEmpty(self.skinName) and self.skinRenderer ~= nil then
    self.skinAsset = Resource:LoadAssetAsync(self.skinName, typeof(CS.UnityEngine.Material))
    
    function self.skinAsset.completed(_)
      if self.skinAsset == nil then
        return
      end
      if IsNull(self.transform) or IsNull(self.skinRenderer) then
        Resource:UnloadAsset(self.skinAsset)
        self.skinAsset = nil
        return
      end
      local mat = self.skinAsset.asset
      cast(mat, typeof(CS.UnityEngine.Material))
      self.skinRenderer.material = mat
    end
  end
end

function Player:AdjustCarryPos()
  for k, v in ipairs(self.carryObj) do
    v:SetLocalPos(self:BagIndexToPos(k))
  end
end

return Player
