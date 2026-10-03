local BountyHunterSceneView = BaseClass("BountyHunterSceneView", UIBaseContainer)
local Resource = CS.GameEntry.Resource
local HunterItem = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterHunterItem")
local MonsterItem = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterMonsterItem")
local BountyHunterFreeChestItem = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterFreeChestItem")
local BountyHunterSceneObjInfo = require("DataCenter.BountyHunterActDataManager.BountyHunterSceneObjInfo")
local BountyHunterMonsterHpComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterMonsterHpComponent")
local BountyHunterMonsterChestItem = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterMonsterChestItem")
local BountyHunterUAV = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterUAV")
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")
local BOUNTY_HUNTER_SCENE_ROOT_PREFAB_PATH = "Assets/Main/Prefabs/BountyHunter/BountyHunterSceneRoot.prefab"
local SCENE_ROOT_PATH = "SceneRoot"
local SCENE_EFFECT_ROOT_PATH = "SceneEffectRoot"
local HUNTER_ROOT_POINT_PATH = "LastWar_Scene_BountyHunter_new/LastWar_Scene_BountyHunter_skin/LastWar_Scene_BountyHunter/HunterPoint"
local MONSTER_ROOT_POINT_PATH = "MonsterRoot"
local CHEST_ROOT_POINT_PATH = "ChestRoot"
local MONSTER_CHEST_ROOT_POINT_PATH = "MonsterChestRoot"
local UAW_ROOT_POINT_PATH = "UAVRoot"
local click_item_root_path = "SceneRT"
local scene_r_t_path = "SceneRT"
local camera_point_path = "LastWar_Scene_BountyHunter_new/LastWar_Scene_BountyHunter_skin/LastWar_Scene_BountyHunter/CameraPoint"
local camera_path = "LastWar_Scene_BountyHunter_new/LastWar_Scene_BountyHunter_skin/LastWar_Scene_BountyHunter/CameraPoint/Camera"
local click_item_path = "BountyHunterClickCheckItem"
local aim_obj_path = "SceneRT/AimObj"
local aim_animator_path = "SceneRT/AimObj/Eff_ui_BountyHunter_aim"
local ani_root_path = "LastWar_Scene_BountyHunter_new/LastWar_Scene_BountyHunter_skin"
local normal_monster_hp_path = "NormalMonsterHp"
local virtual_camera_controller_path = "LastWar_Scene_BountyHunter_new"
local FULL_SCREEN_ATK_EFF_PATH = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_s_BountyHunter_zhiyuan.prefab"
local AIM_EFF = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_s_BountyHunter_miaozhun.prefab"
local CONFUSE_BULLET_EFF_PATH = "Assets/Main/Prefabs/BountyHunter/Item/BountyHunterConfuse.prefab"
local CONFUSE_BULLET_GROUND_EFF_PATH = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_s_BountyHunter_zhaoyin.prefab"
local FULL_SCREEN_ATK_SCREEN_EFF_PATH = "Assets/Main/Prefabs/BountyHunter/Effect/Eff_s_BountyHunter_zhiyuan_cam.prefab"
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local QualitySettingUtil = require("Util.QualitySettingUtil")
local HUNTER_ATTACK_DURATION = 0.5
local RANDOM_BOMB_UAV_SHOW_DELAY = 2
local RANDOM_BOMB__DURATION = 2
local DEFAULT_CLICK_WIDTH = 100
local DEFAULT_CLICK_HEIGHT = 100
local AIM_MOVE_TIME = 0.3
local FULL_SCREEN_ATK_TIME = 3
local FULL_SCREEN_ATK_ANI_DELAY_TIME = 0.1
local FULL_SCREEN_ATK_DAMAGE_DELAY_TIME = 1.3
local FULL_ATK_AIM_DURATION = 3
local FULL_ATK_AIM_SHOW_INTERVAL_DURATION = 0.1
local CHANGE_SCENE_DELAY = 2
local IMMEDIATE_CHANGE_SCENE_DELAY = 3
local MONSTER_ENTER_FLEE_DELAY = 0.3
local ACTION_TYPE_TO_QUEUE_TYPE = {
  [BountyHunterAniActionType.RefreshScene] = BountyHunterAniActionQueueType.Scene,
  [BountyHunterAniActionType.ReceiveFreeChest] = BountyHunterAniActionQueueType.Scene,
  [BountyHunterAniActionType.RandomBomb] = BountyHunterAniActionQueueType.Scene,
  [BountyHunterAniActionType.SuperShoot] = BountyHunterAniActionQueueType.Scene,
  [BountyHunterAniActionType.GetFreeChest] = BountyHunterAniActionQueueType.Scene,
  [BountyHunterAniActionType.ShopEvent] = BountyHunterAniActionQueueType.Scene,
  [BountyHunterAniActionType.FullScreenAttack] = BountyHunterAniActionQueueType.Scene,
  [BountyHunterAniActionType.ConfuseMonster] = BountyHunterAniActionQueueType.Scene,
  [BountyHunterAniActionType.BossBirth] = BountyHunterAniActionQueueType.Scene,
  [BountyHunterAniActionType.MonsterHurt] = BountyHunterAniActionQueueType.Monster,
  [BountyHunterAniActionType.MonsterRemove] = BountyHunterAniActionQueueType.Monster,
  [BountyHunterAniActionType.AllSmallMonsterRemove] = BountyHunterAniActionQueueType.Monster,
  [BountyHunterAniActionType.HunterAttack] = BountyHunterAniActionQueueType.Hunter
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.CityLightManager:AddDeactiveRef()
end

local function OnDestroy(self)
  DataCenter.CityLightManager:DecreaseDeactiveRef()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rtImg = self:AddComponent(UIRawImage, scene_r_t_path)
  self.rtImg:SetActive(true)
  self.rtContent = self:AddComponent(UIBaseContainer, scene_r_t_path)
  self.hunterItem = nil
  self.allMonsterItemDic = {}
  self.allChestItemDic = {}
  self.uavItem = nil
  self.checkClickItem = self:AddComponent(UIBaseContainer, click_item_path)
  self.checkClickItem.gameObject:GameObjectCreatePool()
  self.aimObj = self:AddComponent(UIBaseContainer, aim_obj_path)
  self.aimAnimator = self:AddComponent(UISimpleAnimation, aim_animator_path)
  self.monsterHp = self:AddComponent(UIBaseContainer, normal_monster_hp_path)
  self.monsterHp.gameObject:GameObjectCreatePool()
  self.rtImgWidth = self.rtImg.rectTransform.rect.width or DefaultScreenWidth
  self.rtImgHeight = self.rtImg.rectTransform.rect.height or DefaultScreenHeight
  self.rtImgRowWidth = self.rtImgWidth
  self.rtImgRowHeight = self.rtImgHeight
  self.rtScale = self.rtImgHeight / DefaultScreenHeight
end

local function ComponentDestroy(self)
  self.renderTexture = nil
  self.rtImg = nil
  self.shadowDistance = nil
  if self.sceneShellReq then
    self.sceneShellReq:Destroy()
    self.sceneShellReq = nil
  end
  self.checkClickItem.gameObject:GameObjectRecycleAll()
  self.rtContent:RemoveAllComponentes(UIButton)
  self.monsterHp.gameObject:GameObjectRecycleAll()
  self.rtContent:RemoveAllComponentes(BountyHunterMonsterHpComponent)
  self.aimAnimator = nil
  self:ClearAllEff()
  self:ClearAllTimer()
  self:ClearAllTween()
  self.allMonsterItemDic = nil
  self:ClearSceneAndAllItem()
end

local function DataDefine(self)
  self.defaultScenePos = Vector3.New(0, 100, 0)
  self.monsterBirthPosList = {}
  self.itemPosSlotDic = {}
  self.curBatState = BattleSceneState.LoadFirstSceneState
  self.isPlayingRandomBomb = false
  self.allBeHitTimerList = {}
  self.allClickCptDic = {}
  self.isAutoSelectOrange = true
  self.monsterHpPool = {}
  self.curMonsterChestDic = {}
  self.monsterChestPool = {}
  self.curSceneObjInfo = BountyHunterSceneObjInfo.New()
  self.nextSceneObjInfo = BountyHunterSceneObjInfo.New()
  self.isInBossBattle = false
  self.effLoadReqList = {}
  self.allEffDestroyTimerList = {}
  self.allAimTimerList = {}
  self.allQueueDic = {}
  self.allQueueDic[BountyHunterAniActionQueueType.Scene] = {}
  self.allQueueDic[BountyHunterAniActionQueueType.Hunter] = {}
  self.allQueueDic[BountyHunterAniActionQueueType.Monster] = {}
  self.curBossItem = nil
  self.actionFuncDic = {}
  self.actionFuncDic[BountyHunterAniActionType.HunterAttack] = function(params)
    return self:OnHunterAttack(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.MonsterHurt] = function(params)
    return self:OnMonsterBeHurt(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.MonsterRemove] = function(params)
    return self:OnMonsterBeRemove(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.AllSmallMonsterRemove] = function(params)
    return self:OnAllSmallMonsterBeRemove(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.RefreshScene] = function(params)
    return self:StartChangeScene(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.BossBirth] = function(params)
    return self:OnTriggerBossEvent(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.RandomBomb] = function(params)
    return self:OnTriggerRandomBombEvent(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.SuperShoot] = function(params)
    return self:OnTriggerSuperShootEvent(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.ReceiveFreeChest] = function(params)
    return self:OnReceiveFreeChest(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.ShopEvent] = function(params)
    return self:OnTriggerShopEvent(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.GetFreeChest] = function(params)
    return self:GenerateFreeChest(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.FullScreenAttack] = function(params)
    return self:OnFullScreenAttack(params)
  end
  self.actionFuncDic[BountyHunterAniActionType.ConfuseMonster] = function(params)
    return self:StartConfuseMonster(params)
  end
  self.shootFlag = false
end

local function DataDestroy(self)
  self:ClearAllTimer()
  self.defaultScenePos = nil
  self.itemPosSlotDic = nil
  self.allClickCptDic = nil
  self.isAutoSelectOrange = nil
  self.actionFuncDic = nil
  if self.curSceneObjInfo then
    self.curSceneObjInfo:Destroy()
    self.curSceneObjInfo = nil
  end
  if self.nextSceneObjInfo then
    self.nextSceneObjInfo:Destroy()
    self.nextSceneObjInfo = nil
  end
  self.allQueueDic = nil
  self.isPlayingRandomBomb = nil
  self.monsterHpPool = nil
  if self.curMonsterChestDic then
    for _, v in pairs(self.curMonsterChestDic) do
      v:Destroy()
    end
    self.curMonsterChestDic = nil
  end
  if self.monsterChestPool then
    for _, v in ipairs(self.monsterChestPool) do
      v:Destroy()
    end
    self.monsterChestPool = nil
  end
  self.shootFlag = nil
end

function BountyHunterSceneView:M_OnAddListener()
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("BountyHunterSceneView M_OnAddListener")
  end
  self:AddUIListener(EventId.BountyHunterAddAniActionToQueue, self.OnAddOneAniAction)
  self:AddUIListener(EventId.BountyHunterHunterAttackAniFinish, self.OnHunterExitAttackState)
  self:AddUIListener(EventId.BountyHunterOnMonsterEnterDead, self.OnMonsterEnterDeadState)
  self:AddUIListener(EventId.BountyHunterOnMonsterBeHitEnd, self.OnMonsterBeHitEndState)
  self:AddUIListener(EventId.BountyHunterOnSuperShootFinish, self.OnSuperShootEventFinish)
end

function BountyHunterSceneView:M_OnRemoveListener()
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("BountyHunterSceneView M_OnRemoveListener")
  end
  self:RemoveUIListener(EventId.BountyHunterAddAniActionToQueue, self.OnAddOneAniAction)
  self:RemoveUIListener(EventId.BountyHunterHunterAttackAniFinish, self.OnHunterExitAttackState)
  self:RemoveUIListener(EventId.BountyHunterOnMonsterEnterDead, self.OnMonsterEnterDeadState)
  self:RemoveUIListener(EventId.BountyHunterOnMonsterBeHitEnd, self.OnMonsterBeHitEndState)
  self:RemoveUIListener(EventId.BountyHunterOnSuperShootFinish, self.OnSuperShootEventFinish)
end

function BountyHunterSceneView:ResetScene()
  self:ClearAllEff()
  self:ClearAllTimer()
  self:ClearAllTween()
  self:ResetData()
end

function BountyHunterSceneView:ClearAll()
  self:ClearAllEff()
  self:ClearAllTimer()
  self:ClearAllTween()
  self:DestroySceneShell()
  self:ClearSceneAndAllItem()
end

function BountyHunterSceneView:ResetData()
  self.allQueueDic = {}
  self.allQueueDic[BountyHunterAniActionQueueType.Scene] = {}
  self.allQueueDic[BountyHunterAniActionQueueType.Hunter] = {}
  self.allQueueDic[BountyHunterAniActionQueueType.Monster] = {}
  self.isInBossBattle = false
  self.curBossItem = nil
  self.effLoadReqList = {}
  self.allEffDestroyTimerList = {}
end

function BountyHunterSceneView:CreateScene(onCreateFinish)
  self:ResetScene()
  self:DestroySceneShell()
  self:ClearSceneAndAllItem()
  self:LoadSceneShell()
  self:SetAimShowHideState(false)
  self.curSelectMonsterUuid = nil
  self.onCreateFinish = onCreateFinish
end

function BountyHunterSceneView:EnterScene()
  self:ChangeBattleState(BattleSceneState.Enter)
end

function BountyHunterSceneView:LoadSceneShell()
  self.sceneShellReq = ResourceManager:InstantiateAsync(BOUNTY_HUNTER_SCENE_ROOT_PREFAB_PATH)
  self.sceneShellReq:completed("+", function()
    if self.sceneShellReq.isError then
      self.sceneShellReq = nil
      if CS.UnityEngine.Application.isEditor then
        self:ShowHunterLog("scene shell prefab load error")
      end
      return
    end
    self.sceneShellObj = self.sceneShellReq.gameObject
    self.sceneShellObj:SetActive(true)
    self.sceneShellObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.sceneShellObj.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    self:OnShellObjLoadFinish()
  end)
end

function BountyHunterSceneView:DestroySceneShell()
  if self.sceneShellReq then
    self.sceneShellReq:Destroy()
    self.sceneShellReq = nil
  end
  self.sceneShellObj = nil
  self.sceneHangUpPointObj = nil
  self.sceneEffHangUpPointObj = nil
  self.hunterHangUpPointObj = nil
  self.monsterHangUpPointObj = nil
  self.freeChestHangUpPointObj = nil
  self.monsterChestHangUpPointObj = nil
  self.uavHangUpPointObj = nil
  self.sceneCamera = nil
  self.sceneAni = nil
  self.virtualCameraController = nil
end

function BountyHunterSceneView:OnShellObjLoadFinish()
  if not self.sceneShellObj then
    return
  end
  self.cameraPoint = self.sceneShellObj.transform:Find(camera_point_path)
  self.sceneCamera = self.sceneShellObj.transform:Find(camera_path):GetComponentInChildren(typeof(Camera))
  self.sceneAni = self.sceneShellObj.transform:Find(ani_root_path):GetComponentInChildren(typeof(CS.SimpleAnimation))
  self.sceneAni:Play("Idle")
  self.virtualCameraController = self.sceneShellObj.transform:Find(virtual_camera_controller_path):GetComponentInChildren(typeof(CS.BountyHunterCinemachineController))
  self.sceneHangUpPointObj = self.sceneShellObj.transform:Find(SCENE_ROOT_PATH)
  self.sceneEffHangUpPointObj = self.sceneShellObj.transform:Find(SCENE_EFFECT_ROOT_PATH)
  self.hunterHangUpPointObj = self.sceneShellObj.transform:Find(HUNTER_ROOT_POINT_PATH)
  self.monsterHangUpPointObj = self.sceneShellObj.transform:Find(MONSTER_ROOT_POINT_PATH)
  self.freeChestHangUpPointObj = self.sceneShellObj.transform:Find(CHEST_ROOT_POINT_PATH)
  self.monsterChestHangUpPointObj = self.sceneShellObj.transform:Find(MONSTER_CHEST_ROOT_POINT_PATH)
  self.uavHangUpPointObj = self.sceneShellObj.transform:Find(UAW_ROOT_POINT_PATH)
  self:ToggleSceneCamera(false)
  self:ChangeBattleState(BattleSceneState.LoadFirstSceneState)
end

function BountyHunterSceneView:UpdateData(activityId)
  if not activityId then
    return
  end
  self.activityId = activityId
  local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
  if not actData then
    return
  end
  self.actData = actData
  local sceneData = actData.sceneData
  self.sceneData = sceneData
  if not sceneData then
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("bounty hunter sceneData is null!")
    end
    return
  end
  self.allMonsterDataDic = sceneData.allMonsterDataDic
  self.allChestDataDic = sceneData.allChestDataDic
  local stageTmpData = sceneData.stageTmpData
  if not stageTmpData then
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("bounty hunter stageTmpData is null!")
    end
    return
  end
  self:ParseTemplateData(stageTmpData)
end

function BountyHunterSceneView:ParseTemplateData(stageTmpData)
  if not stageTmpData then
    return
  end
  self.curScenePath = stageTmpData.scene
  self.prevHunterPrefabPath = self.hunterPrefabPath
  self.hunterPrefabPath = stageTmpData.mine_prefab
  self.itemPosSlotDic = {}
  local index = 1
  if not string.IsNullOrEmpty(stageTmpData.monster_birth_points) then
    local splitRet = string.split(stageTmpData.monster_birth_points, "|")
    for _, v in ipairs(splitRet) do
      local posInfoArr = string.split_ff_array(v, ";")
      if 3 <= #posInfoArr then
        local mPos = Vector3.New(posInfoArr[1], posInfoArr[2], posInfoArr[3])
        local slotInfo = {}
        slotInfo.ownerUuid = nil
        slotInfo.localPos = mPos
        slotInfo.slotType = BountyHunterItemType.GroundMonster
        self.itemPosSlotDic[index] = slotInfo
        index = index + 1
      end
    end
  end
  if not string.IsNullOrEmpty(stageTmpData.fly_monster_birth_points) then
    local splitRet = string.split(stageTmpData.fly_monster_birth_points, "|")
    for _, v in ipairs(splitRet) do
      local posInfoArr = string.split_ff_array(v, ";")
      if 3 <= #posInfoArr then
        local mPos = Vector3.New(posInfoArr[1], posInfoArr[2], posInfoArr[3])
        local slotInfo = {}
        slotInfo.ownerUuid = nil
        slotInfo.localPos = mPos
        slotInfo.slotType = BountyHunterItemType.FlyMonster
        self.itemPosSlotDic[index] = slotInfo
        index = index + 1
      end
    end
  end
  local bossBirthLocalPos = Vector3.New(0, 0, 0)
  if not string.IsNullOrEmpty(stageTmpData.boss_birth_point) then
    local splitRet = string.split_ff_array(stageTmpData.boss_birth_point, ";")
    if 3 <= #splitRet then
      bossBirthLocalPos = Vector3.New(splitRet[1], splitRet[2], splitRet[3])
      local slotInfo = {}
      slotInfo.ownerUuid = nil
      slotInfo.localPos = bossBirthLocalPos
      slotInfo.slotType = BountyHunterItemType.Boss
      self.itemPosSlotDic[index] = slotInfo
      index = index + 1
    end
  end
  if not string.IsNullOrEmpty(stageTmpData.freebox_point) then
    local splitRet = string.split(stageTmpData.freebox_point, "|")
    for _, v in ipairs(splitRet) do
      local posInfoArr = string.split_ff_array(v, ";")
      if 3 <= #posInfoArr then
        local mPos = Vector3.New(posInfoArr[1], posInfoArr[2], posInfoArr[3])
        local slotInfo = {}
        slotInfo.ownerUuid = nil
        slotInfo.localPos = mPos
        slotInfo.slotType = BountyHunterItemType.FreeChest
        self.itemPosSlotDic[index] = slotInfo
        index = index + 1
      end
    end
  end
end

function BountyHunterSceneView:LoadAllItemWhenFirstEnter()
  if not self.sceneShellObj then
    return
  end
  self:LoadFirstScene()
  self:GenerateHunter()
end

function BountyHunterSceneView:LoadFirstScene()
  if string.IsNullOrEmpty(self.curScenePath) then
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("bounty hunter scene path is null!")
    end
    return
  end
  self.gameObject:SetActive(true)
  self.rtImg:SetEnable(false)
  if self.curSceneObjInfo:IsLoading() then
    return
  end
  if self.curSceneObjInfo:IsLoadedFinish() and self.sceneCamera then
    self:OnRenderTexture(self.sceneCamera)
    self:DoWhenCurSceneLoaded()
    return
  end
  self.curSceneObjInfo:LoadScene(self.curScenePath, self.sceneHangUpPointObj, function()
    self:ToggleSceneCamera(true)
    self:DoWhenCurSceneLoaded(self)
  end)
end

function BountyHunterSceneView:DoWhenCurSceneLoaded()
  self:CheckSceneIsCanEnter()
end

function BountyHunterSceneView:GenerateHunter()
  self.hunterItem = HunterItem.New(self)
  self.hunterItem:LoadItem(self.hunterPrefabPath, self.hunterHangUpPointObj, Vector3(0, 0, 0), Vector3(0, 0, 0), function()
    self.hunterItem:SetActive(false)
    self:CheckSceneIsCanEnter()
  end)
end

function BountyHunterSceneView:GenerateUAV()
  self.uavItem = BountyHunterUAV.New(self)
  self.uavItem:LoadItem(self.uavHangUpPointObj, function()
  end)
end

function BountyHunterSceneView:GenerateAllMonster()
  self:ClearAllMonsterItem()
  if not self.allMonsterDataDic then
    return
  end
  for _, v in pairs(self.allMonsterDataDic) do
    self:GenerateOneMonster(v)
  end
  self.curBattleWave = (self.curBattleWave or 0) + 1
end

function BountyHunterSceneView:GenerateOneMonster(monsterData)
  if monsterData and monsterData.curHp <= 0 then
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog(string.format("monster uuid: %s hp is 0!", monsterData.uuid))
    end
    return
  end
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog(string.format("gen one monster uuid: %s", monsterData.uuid))
  end
  local monsterItem = MonsterItem.New(self)
  self.allMonsterItemDic[monsterData.uuid] = monsterItem
  local birthLocalPos, slotIndex = self:AllocateFreeSlotToItem(monsterData.uuid, monsterData.itemType)
  monsterItem:LoadItem(monsterData, self.monsterHangUpPointObj, birthLocalPos, slotIndex, function()
    local extraParams = {}
    extraParams.hunterWorldPos = self.hunterHangUpPointObj.transform.position
    extraParams.cameraDir = self.cameraPoint.transform.forward
    monsterItem:SetExtraData(extraParams)
    self:OnMonsterModelLoadFinish(monsterItem)
    if monsterData.monsterQuality == BountyMonsterQualityType.Boss then
      self:OnEnterBossBattle(monsterItem)
      EventManager:GetInstance():Broadcast(EventId.BountyHunterEnterBossBattle, monsterData)
    end
  end)
  
  local function clickFunc()
    self:OnMonsterItemBeClick(monsterData.uuid)
  end
  
  self:BlindClickEventToItem(monsterItem, clickFunc)
end

function BountyHunterSceneView:OnMonsterModelLoadFinish(monsterItem)
  self:CheckMonsterHpBar(monsterItem)
  local isAllMonsterLoadFinish = true
  for _, v in pairs(self.allMonsterItemDic) do
    if not v.isLoadFinish then
      isAllMonsterLoadFinish = false
      break
    end
  end
  if isAllMonsterLoadFinish then
    self:OnAllMonsterLoadFinish()
  end
end

function BountyHunterSceneView:IsAllMonsterClear()
  return not self.allMonsterItemDic or table.count(self.allMonsterItemDic) == 0
end

function BountyHunterSceneView:OnAllMonsterLoadFinish()
  self:AllMonsterEnterFleeWhenBossAppear()
end

function BountyHunterSceneView:AllMonsterEnterFleeWhenBossAppear()
  if not self.isInBossBattle then
    return
  end
  if self.monsterEnterFleeTimer then
    self.monsterEnterFleeTimer:Stop()
    self.monsterEnterFleeTimer = nil
  end
  local params = {}
  if self.curBossItem and self.curBossItem.transform then
    params.bossWorldPos = self.curBossItem.transform.position
  end
  if self.hunterItem and self.hunterItem.transform then
    params.hunterWorldPos = self.hunterItem.transform.position
  end
  self.monsterEnterFleeTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:AllNormalMonsterEnterTargetState(BountyMonsterStateType.FleeBoss, params)
  end, MONSTER_ENTER_FLEE_DELAY)
end

function BountyHunterSceneView:OnEnterBossBattle(bossItem)
  self:AutoSelectOneMonster()
  self.isInBossBattle = true
  self.curBossItem = bossItem
  self:AllMonsterEnterFleeWhenBossAppear()
end

function BountyHunterSceneView:OnExitBossBattle()
  self.isInBossBattle = false
  self.curBossItem = nil
  self:AllNormalMonsterEnterTargetState(BountyMonsterStateType.Patrol)
  if self.monsterEnterFleeTimer then
    self.monsterEnterFleeTimer:Stop()
    self.monsterEnterFleeTimer = nil
  end
  EventManager:GetInstance():Broadcast(EventId.BountyHunterExitBossBattle)
end

function BountyHunterSceneView:AllNormalMonsterEnterTargetState(targetState, params)
  if not self.allMonsterItemDic then
    return
  end
  for _, v in pairs(self.allMonsterItemDic) do
    if not v:IsBoss() and not v:IsDied() then
      v:ChangeBehaviourState(targetState, params)
    end
  end
end

function BountyHunterSceneView:GenerateFreeChest()
  if self:IsInChangeSceneAni() then
    return true
  end
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("execute GenerateFreeChest")
  end
  self:ClearAllChestItem()
  self.allChestItemDic = {}
  if not self.allChestDataDic then
    return
  end
  for _, v in pairs(self.allChestDataDic) do
    self:GenerateOneFreeChest(v)
  end
end

function BountyHunterSceneView:GenerateOneFreeChest(chestData)
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog(string.format("gen one chest uuid: %s", chestData.uuid))
  end
  local chestItem = BountyHunterFreeChestItem.New(self)
  self.allChestItemDic[chestData.uuid] = chestItem
  local birthLocalPos, slotIndex = self:AllocateFreeSlotToItem(chestData.uuid, chestData.itemType)
  chestItem:LoadItem(chestData, self.freeChestHangUpPointObj, birthLocalPos, slotIndex, function()
  end)
  
  local function clickFunc()
    self:OnFreeChestItemBeClick(chestData.uuid)
  end
  
  self:BlindClickEventToItem(chestItem, clickFunc)
end

function BountyHunterSceneView:CheckSceneIsCanEnter()
  if self.curBatState ~= BattleSceneState.LoadFirstSceneState then
    return
  end
  if self.curSceneObjInfo:IsLoading() then
    return
  end
  if not self.hunterItem or not self.hunterItem.isLoadFinish then
    return
  end
  if not self.allMonsterItemDic then
    return
  end
  for _, v in pairs(self.allMonsterItemDic) do
    if not v.isLoadFinish then
      return
    end
  end
  self:ChangeBattleState(BattleSceneState.ReadyToEnter)
end

function BountyHunterSceneView:GetCurBattleState()
  return self.curBatState
end

function BountyHunterSceneView:ChangeBattleState(state, params)
  self.curBatState = state
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("ChangeBattleState: " .. self:GetBattleStateByEnumId(state))
  end
  if state == BattleSceneState.LoadFirstSceneState then
    self:LoadAllItemWhenFirstEnter()
  elseif state == BattleSceneState.ReadyToEnter then
    if self.onCreateFinish then
      self.onCreateFinish()
      self.onCreateFinish = nil
    end
  elseif state == BattleSceneState.Enter then
    self:ResetScenePosition()
    self:GenerateAllMonster()
    self:HunterAndMonsterPlayEnterDisplay()
  elseif state == BattleSceneState.EnterBattle then
    self:ResetScenePosition()
    self:GenerateAllMonster()
    self:SetVirtualCameraMachine(false)
    self:ChangeBattleState(BattleSceneState.InBattle)
  elseif state == BattleSceneState.InBattle then
    local excludeUuid
    local noAimAni = true
    self:AutoSelectOneMonster(excludeUuid, noAimAni)
    self:GenerateFreeChest()
  elseif state == BattleSceneState.ChangeScene then
    self:ExecuteChangeScene(params)
  end
end

function BountyHunterSceneView:ExecuteChangeScene(params)
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("StartChangeScene")
  end
  self.isInBossBattle = false
  self:ClearAllMonsterClickEvent()
  self:ClearAllMonsterHpBar()
  self:SetAimShowHideState(false)
  EventManager:GetInstance():Broadcast(EventId.BountyHunterStartChangeScene)
  if not self.nextTurnDir then
    self.nextTurnDir = math.random(0, 1) == 1 and BountyHunterSceneDoorType.Right or BountyHunterSceneDoorType.Left
  end
  self:LoadNextScene(params, self.nextTurnDir)
  self.waitRewardFlyTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:PlayChangeSceneAni(params, self.nextTurnDir)
    self.waitRewardFlyTimer = nil
  end, CHANGE_SCENE_DELAY)
end

function BountyHunterSceneView:StartChangeScene(params)
  if self:IsAnyEventPlayAni() then
    return true
  end
  self:ExecuteChangeScene(params)
end

function BountyHunterSceneView:CheckIsNeedPlayConfuseMonsterAni(refreshData)
  local isRefreshByPlayer = refreshData.isRefreshByPlayer
  if not isRefreshByPlayer then
    return false
  end
  local isExistMonsterItem = not self.allMonsterItemDic or table.count(self.allMonsterItemDic) > 0
  if not isExistMonsterItem then
    return false
  end
  return true
end

function BountyHunterSceneView:LoadNextScene(params, turnDir)
  local nextStageTemp = params.nextStageTemp
  local nextScenePrefab = nextStageTemp.scene
  if string.IsNullOrEmpty(nextScenePrefab) then
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("bounty hunter next scene path is null!")
    end
    return
  end
  self.nextSceneObjInfo:LoadScene(nextScenePrefab, self.sceneHangUpPointObj, function()
    self:OnLoadChangeSceneFinish(turnDir)
  end)
end

function BountyHunterSceneView:OnLoadChangeSceneFinish(turnDir)
  self.nextSceneObjInfo:CalWorldPos(self.curSceneObjInfo, turnDir)
end

function BountyHunterSceneView:PlayChangeSceneAni(refreshData, turnDir)
  local randomDir = turnDir == BountyHunterSceneDoorType.Right and "Right" or "Left"
  if self.sceneAni:IsPlaying(randomDir) then
    self.sceneAni:Rewind(randomDir)
  else
    self.sceneAni:Play(randomDir)
  end
  self.hunterItem:ChangeBehaviourState(BountyHunterStateType.ChangeScene, Const.SCENE_CHANGE_ANIM_LENGTH, turnDir)
  self.changeSceneTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnChangeSceneAniFinish()
    self.changeSceneTimer = nil
  end, Const.SCENE_CHANGE_ANIM_LENGTH)
end

function BountyHunterSceneView:OnChangeSceneAniFinish()
  self:ClearAllChestItem()
  self.curSceneObjInfo:Destroy()
  local temp = self.curSceneObjInfo
  self.curSceneObjInfo = self.nextSceneObjInfo
  self.nextSceneObjInfo = temp
  if self.sceneAni:IsPlaying("Idle") then
    self.sceneAni:Rewind("Idle")
  else
    self.sceneAni:Play("Idle")
  end
  self:UpdateData(self.activityId)
  self:ChangeBattleState(BattleSceneState.EnterBattle)
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Scene)
  EventManager:GetInstance():Broadcast(EventId.BountyHunterStartChangeSceneFinish)
  TimerManager:GetInstance():DelayInvoke(function()
    if self.uavItem then
      self.uavItem:EnterPatrolState()
    end
  end, 2)
end

function BountyHunterSceneView:ResetScenePosition()
  if not self.curSceneObjInfo or IsNull(self.curSceneObjInfo.sceneObj) then
    return
  end
  self.sceneAni.transform.position = self.curSceneObjInfo.sceneObj.transform.position
  self.sceneAni.transform.rotation = self.curSceneObjInfo.sceneObj.transform.rotation
  self.monsterHangUpPointObj.transform.position = self.curSceneObjInfo.sceneObj.transform.position
  self.monsterHangUpPointObj.transform.rotation = self.curSceneObjInfo.sceneObj.transform.rotation
  self.freeChestHangUpPointObj.transform.position = self.curSceneObjInfo.sceneObj.transform.position
  self.freeChestHangUpPointObj.transform.rotation = self.curSceneObjInfo.sceneObj.transform.rotation
  self.monsterChestHangUpPointObj.transform.position = self.curSceneObjInfo.sceneObj.transform.position
  self.monsterChestHangUpPointObj.transform.rotation = self.curSceneObjInfo.sceneObj.transform.rotation
  self.sceneEffHangUpPointObj.transform.position = self.curSceneObjInfo.sceneObj.transform.position
  self.sceneEffHangUpPointObj.transform.rotation = self.curSceneObjInfo.sceneObj.transform.rotation
end

function BountyHunterSceneView:HunterAndMonsterPlayEnterDisplay()
  self.sceneAni:Play("Enter")
  self.hunterItem:SetActive(true)
  self.hunterItem:ChangeBehaviourState(BountyHunterStateType.Birth)
  self.enterSceneTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ChangeBattleState(BattleSceneState.InBattle)
    self.enterSceneTimer = nil
  end, Const.ENTER_SCENE_TIME)
end

function BountyHunterSceneView:AllocateFreeSlotToItem(monsterUuid, itemType)
  for index, v in ipairs(self.itemPosSlotDic) do
    if v.ownerUuid == nil and (v.slotType == itemType or not itemType) then
      v.ownerUuid = monsterUuid
      return v.localPos, index
    end
  end
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("not any free monster slot plz check it!")
  end
  local sceneCenterWorldPos = ResetPosition
  if self.curSceneObjInfo and self.curSceneObjInfo.sceneObj then
    sceneCenterWorldPos = self.curSceneObjInfo.sceneObj.transform.position
  end
  return sceneCenterWorldPos
end

function BountyHunterSceneView:ReleaseSlot(slotIndex)
  if not self.itemPosSlotDic then
    return
  end
  local slotInfo = self.itemPosSlotDic[slotIndex]
  if not slotInfo then
    return
  end
  slotInfo.ownerUuid = nil
end

function BountyHunterSceneView:BlindClickEventToItem(itemEntity, clickFunc)
  if not itemEntity or not itemEntity.uuid then
    return
  end
  local clickItemObj = self.checkClickItem.gameObject:GameObjectSpawn(self.rtContent.transform)
  clickItemObj.transform:Set_anchorMin(0, 0)
  clickItemObj.transform:Set_anchorMax(0, 0)
  clickItemObj.transform:Set_pivot(0.5, 0.5)
  local clickWidth = DEFAULT_CLICK_WIDTH
  local clickHeight = DEFAULT_CLICK_HEIGHT
  if itemEntity then
    clickWidth = (itemEntity.clickWidth or DEFAULT_CLICK_WIDTH) * (self.rtScale or 1)
    clickHeight = (itemEntity.clickHeight or DEFAULT_CLICK_HEIGHT) * (self.rtScale or 1)
  end
  clickItemObj.transform:Set_sizeDelta(clickWidth, clickHeight)
  local uuid = itemEntity.uuid
  local name = tostring(uuid)
  clickItemObj.name = name
  local clickCpt = self.rtContent:AddComponent(UIButton, name)
  itemEntity:BlindClickItem(clickCpt)
  clickCpt:SetOnClick(function()
    if clickFunc then
      clickFunc()
    end
  end)
  self.allClickCptDic[itemEntity.uuid] = clickCpt
end

function BountyHunterSceneView:RemoveItemClickEvent(uuid)
  if self.allClickCptDic and table.containsKey(self.allClickCptDic, uuid) then
    local btnObj = self.allClickCptDic[uuid]
    if btnObj.gameObject then
      btnObj.gameObject:GameObjectRecycle()
    elseif CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("RemoveItemClickEvent not find click Obj. uuid: " .. uuid)
    end
    self.allClickCptDic[uuid] = nil
  end
  self.rtContent:RemoveComponent(tostring(uuid), UIButton)
  local monsterItem = self:GetMonsterItemByUuid(uuid)
  if monsterItem then
    monsterItem:RemoveClickItem()
  end
  local chestItem = self:GetChestItemByUuid(uuid)
  if chestItem then
    chestItem:RemoveClickItem()
  end
end

function BountyHunterSceneView:OnMonsterItemBeClick(uuid)
  local monsterItem = self:GetMonsterItemByUuid(uuid)
  if not monsterItem or monsterItem:IsDied() then
    return
  end
  local curSelectMonsterUuid = self:GetCurSelectMonsterUuid()
  if curSelectMonsterUuid == uuid then
    local function AttackDirectly()
      if self.holder and self.holder.ExecuteAttackAction then
        self.holder:ExecuteAttackAction()
      end
    end
    
    if self.actData then
      if not self.actData:HasShownAttackMonsterDirectlyConfirm() then
        local costItemNum = self.actData.hunterActTmpData.cost_num
        local costItemName = DataCenter.ItemTemplateManager:GetName(self.actData.hunterActTmpData.cost_id)
        local message = Localization:GetString("activity_hunter_alert1", tostring(costItemNum), costItemName)
        UIUtil.ShowMessage(message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          AttackDirectly()
        end)
        self.actData:SetHasShownAttackMonsterDirectlyConfirm()
      else
        AttackDirectly()
      end
    end
    return
  end
  local autoSelectUuid = self:GetAutoSelectMonsterUuid()
  if autoSelectUuid then
    local autoSelectMonsterItem = self:GetMonsterItemByUuid(autoSelectUuid)
    if autoSelectMonsterItem and autoSelectMonsterItem.monsterQuality == BountyMonsterQualityType.Boss and monsterItem.monsterQuality ~= BountyMonsterQualityType.Boss then
      UIUtil.ShowTipsId("activity_hunter_alert3")
      return
    end
  end
  self:ChangeSelectMonster(uuid)
  EventManager:GetInstance():Broadcast(EventId.BountyHunterSelectMonsterByHand, uuid)
end

function BountyHunterSceneView:OnFreeChestItemBeClick(uuid)
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("OnFreeChestItemBeClick uuid:" .. uuid)
  end
  SFSNetwork.SendMessage(MsgDefines.BountyHunterClickChestReward, self.activityId, uuid)
end

function BountyHunterSceneView:GetMonsterItemByUuid(uuid)
  if not self.allMonsterItemDic then
    return
  end
  return self.allMonsterItemDic[uuid]
end

function BountyHunterSceneView:GetChestItemByUuid(uuid)
  if not self.allChestItemDic then
    return
  end
  return self.allChestItemDic[uuid]
end

function BountyHunterSceneView:UpdateAutoSelectOrangeToggle(isOnlyOrange)
  if self.isOnlySelectOrange and self.isOnlySelectOrange == isOnlyOrange then
    return
  end
  self.isOnlySelectOrange = isOnlyOrange
  self:AutoSelectOneMonsterWithAlert()
end

function BountyHunterSceneView:AutoSelectOneMonsterWithAlert()
  self:AutoSelectOneMonster()
  if self.hunterItem then
    local targetUuid = self.curSelectMonsterUuid
    if self.allMonsterItemDic[targetUuid] and self.allMonsterItemDic[targetUuid].transform then
      local aimParam = {}
      aimParam.targetItem = self.allMonsterItemDic[targetUuid]
      self.hunterItem:ChangeBehaviourState(BountyHunterStateType.Alert, aimParam)
    end
  end
end

function BountyHunterSceneView:GetAutoSelectMonsterUuid(excludeUuid)
  if not self.allMonsterItemDic or table.count(self.allMonsterItemDic) <= 0 then
    return nil
  end
  local normalMonsterUuid, eliteMonsterUuid, bossMonsterUuid
  for _, v in pairs(self.allMonsterItemDic) do
    local uuid = v.uuid
    if not v:IsDied() then
      if v.monsterQuality == BountyMonsterQualityType.Boss then
        bossMonsterUuid = uuid
        break
      elseif v.monsterQuality == BountyMonsterQualityType.EliteMonster then
        eliteMonsterUuid = uuid
      elseif v.monsterQuality == BountyMonsterQualityType.NormalMonster and not self.isOnlySelectOrange and excludeUuid ~= uuid then
        normalMonsterUuid = uuid
      end
    end
  end
  return bossMonsterUuid or eliteMonsterUuid or normalMonsterUuid
end

function BountyHunterSceneView:AutoSelectOneMonster(excludeUuid, noAimAni)
  local targetMonsterUuid = self:GetAutoSelectMonsterUuid(excludeUuid)
  self:ChangeSelectMonster(targetMonsterUuid, noAimAni)
end

function BountyHunterSceneView:ChangeSelectMonster(monsterUuid, noAimAni)
  local isChanging = self.curSelectMonsterUuid ~= monsterUuid
  self.curSelectMonsterUuid = monsterUuid
  if not self.curSelectMonsterUuid then
    self:SetAimShowHideState(false)
    return
  end
  self:SetAimShowHideState(true, isChanging)
  self:UpdateAimPos(not noAimAni)
  self.hunterItem:SetCurrentAimItem(self.allMonsterItemDic[monsterUuid])
  EventManager:GetInstance():Broadcast(EventId.BountyHunterSelectMonster, self.curSelectMonsterUuid)
end

function BountyHunterSceneView:SetAimShowHideState(value, playAnim)
  self.aimObj:SetActive(false)
  if value then
    self.aimObj:SetActive(true)
    if playAnim then
      self.aimAnimator:Play("aim")
    end
  end
  if value then
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("SetAimState show")
    end
  elseif CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("SetAimState hide")
  end
end

function BountyHunterSceneView:Update100MS()
  if self.curBatState == BattleSceneState.InBattle then
    self:UpdateItemPos()
  end
  if not self.aimMoveTween then
    self:UpdateAimPos(false)
  end
end

function BountyHunterSceneView:Update()
  if self.curBatState == BattleSceneState.LoadFirstSceneState then
    return
  end
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Scene)
end

function BountyHunterSceneView:UpdateItemPos()
  if not self.sceneCamera then
    return
  end
  if self.allMonsterItemDic then
    for _, v in pairs(self.allMonsterItemDic) do
      v:UpdateClickBtnPos(self.sceneCamera, self.rtImgRowWidth, self.rtImgRowHeight)
      v:UpdateHpBarPos(self.sceneCamera, self.rtImgRowWidth, self.rtImgRowHeight)
    end
  end
  if self.allChestItemDic then
    for _, v in pairs(self.allChestItemDic) do
      v:UpdateClickBtnPos(self.sceneCamera, self.rtImgRowWidth, self.rtImgRowHeight)
    end
  end
end

function BountyHunterSceneView:UpdateAimPos(isTweenAni)
  if not self.aimObj or not self.allClickCptDic then
    return
  end
  local targetItemClickBtn = self.allClickCptDic[self.curSelectMonsterUuid]
  if not targetItemClickBtn or not targetItemClickBtn.transform then
    return
  end
  local targetWorldPos = targetItemClickBtn.transform.localPosition
  local yOffset = 0
  local targetLocalPos = Vector3(targetWorldPos.x, targetWorldPos.y + yOffset, 0)
  if isTweenAni then
    self:AimObjMoveTargetPos(targetLocalPos)
    return
  else
    self.aimObj.transform:Set_localPosition(targetLocalPos.x, targetLocalPos.y, targetLocalPos.z)
  end
end

function BountyHunterSceneView:AimObjMoveTargetPos(targetLocalPos)
  if self.aimMoveTween then
    self.aimMoveTween:Kill()
  end
  self.aimMoveTween = self.aimObj.transform:DOLocalMove(targetLocalPos, AIM_MOVE_TIME):OnComplete(function()
    self.aimMoveTween = nil
  end)
end

function BountyHunterSceneView:ToggleSceneCamera(b)
  local sceneCamera = self.sceneCamera
  if not IsNull(sceneCamera) then
    sceneCamera.gameObject:SetActive(b)
    if b then
      self:OnRenderTexture(sceneCamera)
    else
      sceneCamera.targetTexture = nil
    end
  end
end

function BountyHunterSceneView:OnRenderTexture(camera)
  if camera == nil then
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("OnRenderTexture camera is nil!")
    end
    return
  end
  if self.renderTexture == nil then
    local maxHeight = DefaultScreenHeight
    local newHeight = math.min(self.rtImgHeight, maxHeight)
    local newWidth = newHeight / (self.rtImgHeight / self.rtImgWidth)
    local rtFormat = RenderTextureFormat.ARGBHalf
    self.renderTexture = RenderTexture.GetTemporary(math.floor(newWidth), math.floor(newHeight), 24, rtFormat)
    self.renderTexture.name = "HunterSceneRT"
    self.rtImg:SetTexture(self.renderTexture)
    self.rtImg:SetColor(Color.white)
  end
  self.rtImg:SetEnable(true)
  camera.targetTexture = self.renderTexture
end

function BountyHunterSceneView:ClearSceneAndAllItem()
  self:ClearScene()
  self:ClearAllItem()
end

function BountyHunterSceneView:ClearScene()
  if self.curSceneObjInfo then
    self.curSceneObjInfo:Destroy()
  end
  if self.nextSceneObjInfo then
    self.nextSceneObjInfo:Destroy()
  end
end

function BountyHunterSceneView:ClearAllItem()
  self:ClearHunterItem()
  self:ClearUAVItem()
  self:ClearAllMonsterItem()
  self:ClearAllChestItem()
end

function BountyHunterSceneView:ClearHunterItem()
  if self.hunterItem then
    self.hunterItem:Destroy()
    self.hunterItem = nil
  end
end

function BountyHunterSceneView:ClearUAVItem()
  if self.uavItem then
    self.uavItem:Destroy()
    self.uavItem = nil
  end
end

function BountyHunterSceneView:ClearAllMonsterItem()
  if not self.allMonsterItemDic then
    return
  end
  self:ClearAllMonsterClickEvent()
  self:ClearAllMonsterHpBar()
  for uuid, v in pairs(self.allMonsterItemDic) do
    v:Destroy()
  end
  self.allMonsterItemDic = {}
end

function BountyHunterSceneView:ClearAllMonsterClickEvent()
  if not self.allMonsterItemDic then
    return
  end
  for uuid, v in pairs(self.allMonsterItemDic) do
    self:RemoveItemClickEvent(uuid)
  end
end

function BountyHunterSceneView:ClearAllMonsterHpBar()
  if not self.allMonsterItemDic then
    return
  end
  for uuid, v in pairs(self.allMonsterItemDic) do
    self:RemoveMonsterHpBar(uuid)
  end
end

function BountyHunterSceneView:ClearAllChestItem()
  if not self.allChestItemDic then
    return
  end
  for uuid, v in pairs(self.allChestItemDic) do
    v:Destroy()
    self:RemoveItemClickEvent(uuid)
  end
end

function BountyHunterSceneView:OnAddOneAniAction(params)
  if not params then
    return
  end
  local actionType = params.actionType
  local triggerType = params.triggerType
  local actionQueueType = ACTION_TYPE_TO_QUEUE_TYPE[actionType]
  local targetQueueList = self.allQueueDic[actionQueueType]
  local actionFunc = self.actionFuncDic[actionType]
  if not actionFunc then
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("not find actionFunc type: " .. Const.ACTION_TYPE_ENUM_2_STR_CONFIG[actionType])
    end
    return
  end
  if triggerType == BountyHunterActionTriggerType.Immediate then
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("execute  actionFunc queue now. type: " .. self:GetActionNameByEnumId(actionType))
    end
    actionFunc(params.data)
    return
  elseif triggerType == BountyHunterActionTriggerType.ExecuteWhenQueueEmpty and #targetQueueList <= 0 then
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("execute  actionFunc queue now. type: " .. self:GetActionNameByEnumId(actionType))
    end
    actionFunc(params.data)
    return
  end
  
  local function func()
    return actionFunc(params.data)
  end
  
  local cmdBuff = {}
  cmdBuff.actionType = actionType
  cmdBuff.func = func
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("push execute actionFunc queue type: " .. self:GetActionNameByEnumId(actionType) .. " to queueType : " .. self:GetQueueNameByEnumId(actionQueueType))
  end
  local trigger = true
  if params.unique then
    for _, v in pairs(targetQueueList) do
      if v.actionType == params.actionType then
        trigger = false
        break
      end
    end
  end
  if trigger then
    table.insert(targetQueueList, cmdBuff)
  end
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("cur" .. self:GetQueueNameByEnumId(actionQueueType) .. " queue count : " .. #targetQueueList)
  end
end

function BountyHunterSceneView:CheckAndPlayActionFromQueue(queueType)
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("CheckAndPlayActionFromQueue: " .. (self:GetQueueNameByEnumId(queueType) or "null"))
  end
  for type, v in pairs(self.allQueueDic) do
    if queueType and queueType == type or not queueType then
      local targetQueueList = self.allQueueDic[type]
      if not targetQueueList or #targetQueueList <= 0 then
        if CS.UnityEngine.Application.isEditor then
          self:ShowHunterLog("CheckAndPlayActionFromQueue. cur queue is empty.")
        end
      else
        if CS.UnityEngine.Application.isEditor then
          self:ShowHunterLog("CheckAndPlayActionFromQueue. cur queue count : " .. #targetQueueList)
        end
        local cmdBuff = targetQueueList[1]
        if CS.UnityEngine.Application.isEditor then
          self:ShowHunterLog("try execute action : " .. self:GetActionNameByEnumId(cmdBuff.actionType))
        end
        local isExecuteFail = cmdBuff.func()
        if not isExecuteFail then
          table.remove(targetQueueList, 1)
          if CS.UnityEngine.Application.isEditor then
            self:ShowHunterLog("remove first action execute from queue")
          end
        elseif CS.UnityEngine.Application.isEditor then
          self:ShowHunterLog("action execute fail")
        end
      end
    end
  end
end

function BountyHunterSceneView:OnHunterAttack(data)
  if not data then
    return
  end
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("execute OnHunterAttack")
  end
  local delayTime, bulletType = self:HunterStartAttack(data)
  data.bulletType = bulletType
  self:MonsterEnterHurtState(data, delayTime or 1)
end

function BountyHunterSceneView:OnMonsterBeHurt(beHitParam)
  if not beHitParam then
    return
  end
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("execute OnMonsterBeHurt")
  end
  local monsterUuid = beHitParam.uuid
  local monsterItem = self.allMonsterItemDic[monsterUuid]
  if not monsterItem or not monsterItem.transform then
    return
  end
  if self.hunterItem and self.hunterItem.transform then
    local hitDir = Vector3.Normalize(monsterItem.transform.position - self.hunterItem.transform.position)
    beHitParam.hitDir = hitDir
  end
  EventManager:GetInstance():Broadcast(EventId.BountyHunterOnMonsterBeHit, beHitParam)
  monsterItem:ChangeBehaviourState(BountyMonsterStateType.BeHit, beHitParam)
  self:CheckMonsterHpBar(monsterItem, beHitParam)
end

function BountyHunterSceneView:CheckMonsterHpBar(monsterItem, beHitParam)
  if not monsterItem then
    return
  end
  local isHurt = monsterItem:IsHurt()
  local isBoss = monsterItem:IsBoss()
  local isCurSelectMonster = monsterItem.uuid == self.curSelectMonsterUuid
  local isCanShowNormalHp = not isBoss and (isHurt or isCurSelectMonster)
  if not isCanShowNormalHp then
    return
  end
  if not monsterItem:IsExistHpBar() then
    local hpBar = self:GetNormalMonsterHpCptFromPool()
    monsterItem:SetMonsterHpBar(hpBar)
  end
  if not beHitParam then
    beHitParam = {}
    beHitParam.newHp = monsterItem.curHp
    beHitParam.maxHp = monsterItem.maxHp
  end
  monsterItem:RefreshHpBar(beHitParam)
  if self.sceneCamera then
    monsterItem:UpdateHpBarPos(self.sceneCamera, self.rtImgRowWidth, self.rtImgRowHeight)
  end
end

function BountyHunterSceneView:RemoveMonsterHpBar(monsterUuid)
  local monsterItem = self.allMonsterItemDic[monsterUuid]
  if not monsterItem or not monsterItem:IsExistHpBar() then
    return
  end
  local hpBar = monsterItem.hpBar
  self:ReturnNormalMonsterHpCptToPool(hpBar)
  monsterItem:SetMonsterHpBar(nil)
end

function BountyHunterSceneView:HunterStartAttack(data)
  local delayHurtTime = Const.HUNTER_ATTACK_ANIM_LENGTH_DICT[BountyMonsterBulletType.Gun1]
  if not self.hunterItem then
    return delayHurtTime
  end
  local attackParam = {}
  attackParam.bulletType = BountyMonsterBulletType.Gun1
  if data then
    local targetUuid = data.uuid
    if self.allMonsterItemDic[targetUuid] then
      attackParam.targetItem = self.allMonsterItemDic[targetUuid]
      attackParam.targetWorldPos = self.allMonsterItemDic[targetUuid]:GetAimWorldPos()
      attackParam.hpChange = data.hpChange
      if attackParam.targetItem:IsBoss() then
        attackParam.bulletType = BountyMonsterBulletType.Gun2Small
        local singleBltDmg = self:GetSingleAtkDamage()
        if singleBltDmg < math.abs(data.hpChange) and Const.IS_HUNTER_GUN2_BIG_ON then
          attackParam.bulletType = BountyMonsterBulletType.Gun2Big
        end
      end
      delayHurtTime = Const.HUNTER_ATTACK_ANIM_LENGTH_DICT[attackParam.bulletType]
      local curHunterState = self.hunterItem:GetCurBehaviourState()
      if curHunterState and curHunterState.stateType == BountyHunterStateType.Idle then
        attackParam.isFromIdleState = true
        local turnFrontParam = {}
        turnFrontParam.nextStateType = BountyHunterStateType.Attack
        turnFrontParam.nextStateParam = attackParam
        self.hunterItem:ChangeBehaviourState(BountyHunterStateType.TurnFront, turnFrontParam)
        delayHurtTime = delayHurtTime + Const.HUNTER_TURN_FRONT_ANIM_LENGTH
        self.shootFlag = true
      else
        self.hunterItem:ChangeBehaviourState(BountyHunterStateType.Attack, attackParam)
      end
      self.aimAnimator:Play("attack")
    end
  end
  return delayHurtTime, attackParam.bulletType
end

function BountyHunterSceneView:MonsterEnterHurtState(params, delay)
  if not params then
    return
  end
  local hurtDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    local hurtParams = {}
    hurtParams.actionType = BountyHunterAniActionType.MonsterHurt
    hurtParams.triggerType = BountyHunterActionTriggerType.Immediate
    hurtParams.data = params
    EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, hurtParams)
    table.remove(self.allBeHitTimerList, 1)
  end, delay or 1)
  table.insert(self.allBeHitTimerList, hurtDelayTimer)
end

function BountyHunterSceneView:OnTriggerBossEvent(bossData)
  if not self:IsCanExecuteBannerEvent() then
    return true
  end
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("execute OnTriggerBossEvent")
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.BountyHunterSpecialEvent, BountyHunterEventType.BossEvent)
  EventManager:GetInstance():Broadcast(EventId.BountyHunterBossEventUpdate)
  self.genBossTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:GenerateOneMonster(bossData)
    self.genBossTimer = nil
  end, (Const.WINDOW_AUTO_CLOSE_TIME_CONFIG[BountyHunterEventType.BossEvent] or 2) + 0.1)
end

function BountyHunterSceneView:OnTriggerRandomBombEvent(monsterDamageAniList)
  if not self:IsCanExecuteBannerEvent() then
    return true
  end
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("execute OnTriggerRandomBombEvent")
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.BountyHunterSpecialEvent, BountyHunterEventType.RandomBomb)
  self.uavShowDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.uavItem and self.curSceneObjInfo.sceneObj then
      local bombTargetPosList = self:GetBombTargetWorldPos(monsterDamageAniList)
      local groundPosY = self.curSceneObjInfo.sceneObj.transform.position.y
      self.uavItem:StartAttackTargetPos(bombTargetPosList, groundPosY, self.hunterItem.transform, RANDOM_BOMB__DURATION)
    end
    self.uavShowDelayTimer = nil
  end, RANDOM_BOMB_UAV_SHOW_DELAY)
  self.randomBombDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("Exit RandomBombEvent")
    end
    self:OnRandomBombEventFinish()
    self.randomBombDelayTimer = nil
  end, RANDOM_BOMB_UAV_SHOW_DELAY + RANDOM_BOMB__DURATION)
  local damageDelay = RANDOM_BOMB_UAV_SHOW_DELAY + RANDOM_BOMB__DURATION / 2
  if monsterDamageAniList then
    for _, v in ipairs(monsterDamageAniList) do
      self:MonsterEnterHurtState(v, damageDelay)
    end
  end
end

local webmVideoPath = "Assets/Main/Video/s5_banner_01.mp4"

function BountyHunterSceneView:OnTriggerSuperShootEvent(param)
  if not self:IsCanExecuteBannerEvent() then
    return true
  end
  local fadeInTime = 1
  UIManager:GetInstance():OpenWindow(UIWindowNames.FullScreenVideoView, {anim = true}, {
    path = webmVideoPath,
    callbackAdvanceTime = 0.2,
    fadeInTime = fadeInTime,
    defaultShowSkip = true,
    onVideoCloseCallback = function(isSkip)
      EventManager:GetInstance():Broadcast(EventId.BountyHunterOnSweepRewardStart, isSkip)
    end
  })
  if self.clearMonsterTimer then
    self.clearMonsterTimer:Stop()
    self.clearMonsterTimer = nil
  end
  self.clearMonsterTimer = TimerManager:GetInstance():DelayInvoke(function()
    local params = {}
    params.actionType = BountyHunterAniActionType.AllSmallMonsterRemove
    params.triggerType = BountyHunterActionTriggerType.Immediate
    EventManager:GetInstance():Broadcast(EventId.BountyHunterAddAniActionToQueue, params)
  end, fadeInTime)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBountyHunterSweepReward, {anim = true}, param)
end

function BountyHunterSceneView:OnFullScreenAttack(monsterDamageAniList)
  if self:IsAnyEventPlayAni() or UIManager:GetInstance():IsWindowOpen(UIWindowNames.BountyHunterSpecialEvent) then
    return ture
  end
  self:SetAimShowHideState(false)
  self.isPlayingFullAtkAni = true
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("execute OnFullScreenAttack")
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.BountyHunterSpecialEvent, BountyHunterEventType.FullScreeAttack)
  self.fullAtkDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("Exit FullScreenAttack")
    end
    self:OnFullScreenAttackFinish()
    self.fullAtkDelayTimer = nil
  end, FULL_SCREEN_ATK_TIME)
  self.fullAtkAniTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.fullAtkAniTimer = nil
    if self.sceneAni:IsPlaying("FullAtk") then
      self.sceneAni:Rewind("FullAtk")
    else
      self.sceneAni:Play("FullAtk")
    end
  end, FULL_SCREEN_ATK_ANI_DELAY_TIME)
  self:LoadEff(FULL_SCREEN_ATK_EFF_PATH, nil, nil, nil, 4, function(effTrans)
    effTrans:Set_localPosition(0, 0, 0)
  end)
  local isHighQuality = GameQualitySettings.GetQuality() == EGameQuality.High
  if self.sceneCamera and isHighQuality then
    self:LoadEff(FULL_SCREEN_ATK_SCREEN_EFF_PATH, nil, nil, nil, 4, function(effTrans)
      effTrans:SetParent(self.sceneCamera.transform)
      effTrans.localPosition = Vector3.zero
      effTrans.localRotation = Quaternion.Euler(0, 0, 0)
    end)
  end
  if monsterDamageAniList then
    for _, v in ipairs(monsterDamageAniList) do
      local delayTime = FULL_SCREEN_ATK_DAMAGE_DELAY_TIME + math.random(0, 5) * 0.1
      self:MonsterEnterHurtState(v, delayTime)
    end
  end
  self.hunterItem:ChangeBehaviourState(BountyHunterStateType.FullAttack)
  self:ShowAimEffWhenFullScreenAtk()
  self.lastFullAtkBattleWave = self.curBattleWave
end

function BountyHunterSceneView:IsRepeatCastFullAtk2SameMonsterWave()
  if not self.curBattleWave or not self.lastFullAtkBattleWave then
    return false
  end
  return self.lastFullAtkBattleWave >= self.curBattleWave
end

function BountyHunterSceneView:ShowAimEffWhenFullScreenAtk()
  if not self.allMonsterItemDic then
    return
  end
  local index = 0
  local totalCount = table.count(self.allMonsterItemDic)
  for _, v in pairs(self.allMonsterItemDic) do
    if 0 < v.curHp and v.transform then
      local aimEff = AIM_EFF
      local pos = v.transform.position + Vector3(0, v.modelHeight / 2, 0)
      local delayTime = FULL_ATK_AIM_SHOW_INTERVAL_DURATION * index
      local isFinal = index == totalCount
      local aimEffTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:LoadEff(aimEff, pos, v.transform.localEulerAngles, nil, FULL_ATK_AIM_DURATION)
        if isFinal then
          for _, t in ipairs(self.allAimTimerList) do
            t:Stop()
          end
          self.allAimTimerList = {}
        end
      end, delayTime)
      table.insert(self.allAimTimerList, aimEffTimer)
      index = index + 1
    end
  end
end

function BountyHunterSceneView:StartConfuseMonster(params)
  if self:IsAnyEventPlayAni() then
    return ture
  end
  self.nextTurnDir = math.random(0, 1) == 1 and BountyHunterSceneDoorType.Right or BountyHunterSceneDoorType.Left
  if self.confuseMonsterTimer then
    self.confuseMonsterTimer:Stop()
    self.confuseMonsterTimer = nil
  end
  self.confuseMonsterTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.confuseMonsterTimer = nil
    self:OnConfuseMonsterFinish(params)
  end, Const.CONFUSE_MONSTER_DURATION)
  local turnDir = self.nextTurnDir
  self.hunterItem:ChangeBehaviourState(BountyHunterStateType.ConfuseMonster, turnDir, self.shootFlag)
  self.shootFlag = false
  local seekTargetLocalPos = self:GetConfuseBulletThrowLocalPos(turnDir)
  local seekTargetWorldPos = self.monsterHangUpPointObj.transform:TransformPoint(seekTargetLocalPos)
  if self.genConfuseBltTimer then
    self.genConfuseBltTimer:Stop()
    self.genConfuseBltTimer = nil
  end
  
  local function OnBltDropGroundFunc()
    self:AllNormalMonsterEnterTargetState(BountyMonsterStateType.Alert, seekTargetWorldPos)
  end
  
  self.genConfuseBltTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:GenConfuseBulletEffect(seekTargetWorldPos, OnBltDropGroundFunc)
  end, 0.5)
end

function BountyHunterSceneView:GenConfuseBulletEffect(targetPos, callback)
  if not self.hunterItem or not self.hunterItem.transform then
    return
  end
  local effStartPos = self.hunterItem.transform.position
  local endPos = targetPos
  local startRotate = self.hunterItem.transform.localEulerAngles
  local endRotate = Vector3(720, 0, 0)
  local time = Const.CONFUSE_BULLET_EXIST_TIME
  local bezierCtrlPos = (effStartPos + endPos) / 2 + Vector3(0, 15, 0)
  if self.confuseBltMoveTween then
    self.confuseBltMoveTween:Kill()
    self.confuseBltMoveTween = nil
  end
  self:LoadEff(CONFUSE_BULLET_EFF_PATH, effStartPos, nil, nil, time, function(effTrans)
    local x = 0
    
    local function Getter()
      return x
    end
    
    local function Setter(value)
      x = value
    end
    
    self.confuseBltMoveTween = DOTween.To(Getter, Setter, 1, Const.CONFUSE_BULLET_FLY_DURATION):SetEase(CS.DG.Tweening.Ease.Linear):OnUpdate(function()
      local p1 = Vector3.Lerp(effStartPos, bezierCtrlPos, x)
      local p2 = Vector3.Lerp(bezierCtrlPos, endPos, x)
      local p = Vector3.Lerp(p1, p2, x)
      effTrans:Set_position(p.x, p.y, p.z)
      local targetRot = Vector3.Lerp(startRotate, endRotate, x)
      effTrans:Set_localEulerAngles(targetRot.x, targetRot.y, targetRot.z)
    end):OnComplete(function()
      callback()
      self.confuseBltMoveTween = nil
      self:GenConfuseBltDropGroundEff(endPos)
    end)
  end)
end

function BountyHunterSceneView:GenConfuseBltDropGroundEff(genPos)
  self:LoadEff(CONFUSE_BULLET_GROUND_EFF_PATH, genPos, nil, nil, Const.CONFUSE_BULLET_DROP_GROUND_EXIST_TIME)
end

function BountyHunterSceneView:GetConfuseBulletThrowLocalPos(turnDir)
  local retDir = BountyHunterSceneDoorType.Left
  if turnDir == BountyHunterSceneDoorType.Left then
    retDir = BountyHunterSceneDoorType.Right
  end
  if not table.containsKey(Const.CONFUSE_BULLET_THROW_LOCAL_POS_CONFIG, retDir) then
    return Const.CONFUSE_BULLET_THROW_LOCAL_POS_CONFIG[BountyHunterSceneDoorType.Left]
  end
  return Const.CONFUSE_BULLET_THROW_LOCAL_POS_CONFIG[retDir]
end

function BountyHunterSceneView:OnConfuseMonsterFinish()
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Scene)
end

function BountyHunterSceneView:IsPlayingConfuseAni()
  return self.confuseMonsterTimer ~= nil
end

function BountyHunterSceneView:GetConfuseMonsterTargetPosByTurnDir(turnDir)
  local ret
  if turnDir == BountyHunterSceneDoorType.Left then
    ret = self.leftDoorPos
  end
end

function BountyHunterSceneView:GetBombTargetWorldPos(monsterDamageAniList)
  if not monsterDamageAniList then
    return
  end
  local retList = {}
  for _, v in ipairs(monsterDamageAniList) do
    local uuid = v.uuid
    local monsterItem = self:GetMonsterItemByUuid(uuid)
    if monsterItem.transform then
      table.insert(retList, monsterItem.transform.position)
    end
  end
  return retList
end

function BountyHunterSceneView:OnRandomBombEventFinish()
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Scene)
end

function BountyHunterSceneView:OnSuperShootEventFinish()
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Scene)
end

function BountyHunterSceneView:OnFullScreenAttackFinish()
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("OnFullScreenAttackFinish")
  end
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Scene)
end

function BountyHunterSceneView:OnMonsterBeRemove(monsterUuid)
  if not monsterUuid then
    return
  end
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("execute OnMonsterBeRemove. uid: " .. monsterUuid)
  end
  local targetMonsterItem = self.allMonsterItemDic[monsterUuid]
  if not targetMonsterItem then
    return
  end
  local monsterData = targetMonsterItem.monsterData
  if monsterData.monsterQuality == BountyMonsterQualityType.Boss then
    self:OnExitBossBattle()
  end
  targetMonsterItem:Destroy()
  local targetSlotIndex = targetMonsterItem.slotIndex
  if targetSlotIndex then
    self:ReleaseSlot(targetSlotIndex)
  end
  self:RemoveItemClickEvent(monsterUuid)
  self:RemoveMonsterHpBar(monsterUuid)
  self.allMonsterItemDic[monsterUuid] = nil
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("remove monster item from allMonsterItemDic. uid: " .. monsterUuid)
  end
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Monster)
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Hunter)
end

function BountyHunterSceneView:OnAllSmallMonsterBeRemove()
  local list = {}
  for monsterUuid, v in pairs(self.allMonsterItemDic) do
    if v.monsterQuality ~= BountyMonsterQualityType.Boss then
      table.insert(list, monsterUuid)
    end
  end
  for _, monsterUuid in pairs(list) do
    local targetMonsterItem = self.allMonsterItemDic[monsterUuid]
    targetMonsterItem:Destroy()
    local targetSlotIndex = targetMonsterItem.slotIndex
    if targetSlotIndex then
      self:ReleaseSlot(targetSlotIndex)
    end
    self:RemoveItemClickEvent(monsterUuid)
    self:RemoveMonsterHpBar(monsterUuid)
    self.allMonsterItemDic[monsterUuid] = nil
    self.allMonsterDataDic[monsterUuid] = nil
    if CS.UnityEngine.Application.isEditor then
      self:ShowHunterLog("remove monster item from allMonsterItemDic. uid: " .. monsterUuid)
    end
  end
  self:ClearAllChestItem()
  if self.sceneData then
    self.sceneData:ClearAllChestData()
  end
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Monster)
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Hunter)
end

function BountyHunterSceneView:GetCurSelectMonsterUuid()
  return self.curSelectMonsterUuid
end

function BountyHunterSceneView:IsInBossBattle()
  return self.isInBossBattle
end

function BountyHunterSceneView:OnHunterExitAttackState(params)
  local excludeUuid
  local needAlert = true
  if self.hunterItem then
    local curTarget = self.hunterItem:GetCurrentAimItem()
    if curTarget and curTarget.uuid then
      excludeUuid = curTarget.uuid
    end
    if curTarget and curTarget:IsBoss() and curTarget:IsDied() then
      needAlert = false
    end
  end
  if needAlert then
    self:AutoSelectOneMonsterWithAlert(excludeUuid)
  else
    self:AutoSelectOneMonster(excludeUuid)
  end
  self:CheckAndPlayActionFromQueue(BountyHunterAniActionQueueType.Scene)
end

function BountyHunterSceneView:OnMonsterBeHitEndState(params)
  if not params or not params.uuid then
    return
  end
  local monsterUuid = params.uuid
  local monsterItem = self.allMonsterItemDic[monsterUuid]
  if not monsterItem then
    return
  end
  if params.attackReward then
    local flyRewardParam = {}
    flyRewardParam.rewardData = {}
    flyRewardParam.rewardData.rewardDataNoBornEffect = params.attackReward
    flyRewardParam.startWorldPos = monsterItem:GetAimWorldPos()
    flyRewardParam.playJumpAnim = false
    EventManager:GetInstance():Broadcast(EventId.BountyHunterPlayStashRewardAni, flyRewardParam)
  end
end

function BountyHunterSceneView:OnMonsterEnterDeadState(params)
  if not params or not params.uuid then
    return
  end
  local monsterUuid = params.uuid
  self:RemoveItemClickEvent(monsterUuid)
  self:CheckDropChest(params)
end

function BountyHunterSceneView:CheckDropChest(params)
  if not params then
    return
  end
  local monsterUuid = params.uuid
  local monsterItem = self.allMonsterItemDic[monsterUuid]
  if not monsterItem then
    return
  end
  local mQuality = monsterItem.monsterQuality
  local dropReward = params.dropReward
  if not dropReward then
    return
  end
  local genWorldPos = self.curSceneObjInfo.sceneObj.transform.position
  if monsterItem.transform then
    genWorldPos = monsterItem.transform.position
  end
  local chestData = {}
  chestData.rewardData = {}
  chestData.rewardData.rewardDataHasBornEffect = {}
  chestData.rewardData.rewardDataNoBornEffect = {}
  chestData.type = mQuality
  chestData.prefabPath = monsterItem.monsterData.monsterTmp.drop_box
  chestData.uuid = monsterUuid
  for i, v in ipairs(dropReward) do
    if monsterItem:IsShowFreeChestBornEffect(v) then
      table.insert(chestData.rewardData.rewardDataHasBornEffect, v)
    else
      table.insert(chestData.rewardData.rewardDataNoBornEffect, v)
    end
  end
  local curSceneGroundPosY = genWorldPos.y
  if self.curSceneObjInfo.sceneObj then
    curSceneGroundPosY = self.curSceneObjInfo.sceneObj.transform.position.y
  end
  local monsterChest = self:GetOneMonsterChestFromPool(chestData.prefabPath)
  if monsterChest then
    self.curMonsterChestDic[monsterUuid] = monsterChest
    monsterChest:LoadItem(chestData, self.monsterChestHangUpPointObj, genWorldPos, curSceneGroundPosY, function(chestItem)
      self:ReturnMonsterChestToPool(chestItem)
    end)
  end
end

function BountyHunterSceneView:OnTriggerShopEvent(params)
  if not self:IsCanExecuteBannerEvent() then
    return true
  end
  if not params then
    return
  end
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("execute OnTriggerShopEvent")
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.BountyHunterSpecialEvent, BountyHunterEventType.Shop)
  self.shopEventTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.shopEventTimer = nil
  end, (Const.WINDOW_AUTO_CLOSE_TIME_CONFIG[BountyHunterEventType.Shop] or 2) + 0.1)
end

function BountyHunterSceneView:OnReceiveFreeChest(params)
  if not params then
    return
  end
  local chestUuid = params.uuid
  local rewardData = params.rewardData
  local chestItem = self.allChestItemDic[chestUuid]
  if not chestItem then
    return
  end
  chestItem:PlayOpenAndDisappearAni(rewardData, function()
    chestItem:Destroy()
    self.allChestItemDic[chestUuid] = nil
  end)
  self:RemoveItemClickEvent(chestUuid)
  if CS.UnityEngine.Application.isEditor then
    self:ShowHunterLog("OnReceiveFreeChest uuid: " .. chestUuid)
  end
end

function BountyHunterSceneView:GetNormalMonsterHpCptFromPool()
  local ret
  if #self.monsterHpPool <= 0 then
    local hpObj = self.monsterHp.gameObject:GameObjectSpawn(self.rtContent.transform)
    hpObj.transform:Set_anchorMin(0, 0)
    hpObj.transform:Set_anchorMax(0, 0)
    hpObj.transform:Set_pivot(0.5, 0.5)
    hpObj.transform:Set_localScale(self.rtScale, self.rtScale, self.rtScale)
    local name = tostring("monsterHp" .. NameCount)
    NameCount = NameCount + 1
    hpObj.name = name
    ret = self.rtContent:AddComponent(BountyHunterMonsterHpComponent, name)
  else
    ret = self.monsterHpPool[1]
    table.remove(self.monsterHpPool, 1)
  end
  return ret
end

function BountyHunterSceneView:ReturnNormalMonsterHpCptToPool(hpCpt)
  if not hpCpt or not self.monsterHpPool then
    return
  end
  hpCpt:HideHpBar()
  table.insert(self.monsterHpPool, hpCpt)
end

function BountyHunterSceneView:GetOneMonsterChestFromPool(prefabPath)
  local ret
  if not prefabPath then
    return ret
  end
  if not self.monsterChestPool[prefabPath] then
    self.monsterChestPool[prefabPath] = {}
  end
  local targetTypeList = self.monsterChestPool[prefabPath]
  if 0 < #targetTypeList then
    ret = targetTypeList[1]
    table.remove(targetTypeList, 1)
  else
    ret = BountyHunterMonsterChestItem.New(self)
  end
  ret.prefabPath = prefabPath
  return ret
end

function BountyHunterSceneView:ReturnMonsterChestToPool(chestItem)
  if not chestItem then
    return
  end
  local monsterUuid = chestItem.uuid
  self.curMonsterChestDic[monsterUuid] = nil
  chestItem:Clear()
  chestItem:Hide()
  if not self.monsterChestPool[chestItem.prefabPath] then
    self.monsterChestPool[chestItem.prefabPath] = {}
  end
  table.insert(self.monsterChestPool[chestItem.prefabPath], chestItem)
end

function BountyHunterSceneView:ShowHunterLog(info)
  if CS.UnityEngine.Application.isEditor then
    DataCenter.BountyHunterActDataManager:ShowHunterLog(info)
  end
end

function BountyHunterSceneView:SetVirtualCameraMachine(isInAttack)
  if IsNotNull(self.virtualCameraController) then
    self.virtualCameraController:SetAttackActive(isInAttack)
  end
end

function BountyHunterSceneView:SetVirtualCameraMachineShake(isShowShake)
  if IsNotNull(self.virtualCameraController) then
    self.virtualCameraController:SetAttackNoise(isShowShake)
  end
end

function BountyHunterSceneView:IsCanExecuteBannerEvent()
  if self:IsAnyEventPlayAni() then
    return false
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBountyHunterSweepReward) then
    return false
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.BountyHunterSpecialEvent) then
    return false
  end
  if self:ExistMonsterInDeadState() then
    return false
  end
  return true
end

function BountyHunterSceneView:ExistMonsterInDeadState()
  if not self.allMonsterItemDic then
    return false
  end
  for _, v in pairs(self.allMonsterItemDic) do
    if v.curState and v.curState.stateType == BountyMonsterStateType.Dead or v:IsDied() then
      return true
    end
  end
  return false
end

function BountyHunterSceneView:IsAnyEventPlayAni()
  return self.fullAtkDelayTimer or self.randomBombDelayTimer or self.enterSceneTimer or self.genBossTimer or self.changeSceneTimer or self.confuseMonsterTimer or self.shopEventTimer
end

function BountyHunterSceneView:IsExistAnyEventInQueue()
  for _, v in pairs(self.allQueueDic) do
    if 0 < #v then
      return true
    end
  end
  return false
end

function BountyHunterSceneView:IsInChangeSceneAni()
  return self.waitRewardFlyTimer or self.changeSceneTimer
end

function BountyHunterSceneView:LoadEff(prefabPath, worldPos, initRotation, scale, duration, callback)
  if string.IsNullOrEmpty(prefabPath) then
    Logger.LogError("path is null!")
    return
  end
  local loadModelReq = Resource:InstantiateAsync(prefabPath)
  loadModelReq:completed("+", function(req)
    if req.isError then
      if callback then
        callback()
      end
      Logger.LogError("bounty hunter bullet model load fail")
      return
    end
    local transform = req.gameObject.transform
    transform:Set_localScale(1, 1, 1)
    transform:SetParent(self.sceneEffHangUpPointObj.transform)
    if worldPos then
      transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
    else
      transform:Set_localPosition(0, 0, 0)
    end
    if initRotation then
      transform:Set_localRotation(initRotation.x, initRotation.y, initRotation.z, 1)
    else
      transform:Set_localRotation(0, 0, 0, 1)
    end
    if scale then
      transform:Set_localScale(scale, scale, scale)
    end
    transform.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    if callback then
      callback(transform)
    end
  end)
  table.insert(self.effLoadReqList, loadModelReq)
  duration = duration or 0
  if 0 < duration then
    local autoDestroyTimer
    autoDestroyTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:DestroyTargetEff(loadModelReq)
      table.removebyvalue(self.effLoadReqList, loadModelReq)
    end, duration)
    table.insert(self.allEffDestroyTimerList, autoDestroyTimer)
  end
  return loadModelReq
end

function BountyHunterSceneView:DestroyTargetEff(req)
  if not req then
    return
  end
  table.removebyvalue(self.effLoadReqList, req)
  req:Destroy()
end

function BountyHunterSceneView:GetQueueNameByEnumId(queueType)
  if not table.containsKey(Const.QUEUE_TYPE_ENUM_2_STR_CONFIG, queueType) then
    return "Unknown"
  end
  return Const.QUEUE_TYPE_ENUM_2_STR_CONFIG[queueType]
end

function BountyHunterSceneView:GetActionNameByEnumId(actionType)
  if not table.containsKey(Const.ACTION_TYPE_ENUM_2_STR_CONFIG, actionType) then
    return "Unknown"
  end
  return Const.ACTION_TYPE_ENUM_2_STR_CONFIG[actionType]
end

function BountyHunterSceneView:GetBattleStateByEnumId(battleState)
  if not table.containsKey(Const.BATTLE_STATE_2_STR_CONFIG, battleState) then
    return "Unknown"
  end
  return Const.BATTLE_STATE_2_STR_CONFIG[battleState]
end

function BountyHunterSceneView:IsCanAttack()
  return self.hunterItem and self.hunterItem:IsCanAttack()
end

function BountyHunterSceneView:GetSingleAtkDamage()
  local singleBltDmg = 10
  local bountyHunterData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  if not bountyHunterData or not bountyHunterData.hunterActTmpParaData then
    return singleBltDmg
  end
  singleBltDmg = bountyHunterData.hunterActTmpParaData.common_damage and toInt(bountyHunterData.hunterActTmpParaData.common_damage) or singleBltDmg
  return singleBltDmg
end

function BountyHunterSceneView:ClearAllTimer()
  if self.allBeHitTimerList then
    for _, v in ipairs(self.allBeHitTimerList) do
      v:Stop()
    end
  end
  self.allBeHitTimerList = {}
  if self.fullAtkDelayTimer then
    self.fullAtkDelayTimer:Stop()
    self.fullAtkDelayTimer = nil
  end
  if self.enterSceneTimer then
    self.enterSceneTimer:Stop()
    self.enterSceneTimer = nil
  end
  if self.randomBombDelayTimer then
    self.randomBombDelayTimer:Stop()
    self.randomBombDelayTimer = nil
  end
  if self.waitRewardFlyTimer then
    self.waitRewardFlyTimer:Stop()
    self.waitRewardFlyTimer = nil
  end
  if self.changeSceneTimer then
    self.changeSceneTimer:Stop()
    self.changeSceneTimer = nil
  end
  if self.fullAtkAniTimer then
    self.fullAtkAniTimer:Stop()
    self.fullAtkAniTimer = nil
  end
  if self.monsterEnterFleeTimer then
    self.monsterEnterFleeTimer:Stop()
    self.monsterEnterFleeTimer = nil
  end
  if self.allAimTimerList then
    for _, v in ipairs(self.allAimTimerList) do
      v:Stop()
    end
  end
  self.allAimTimerList = {}
  if self.confuseMonsterTimer then
    self.confuseMonsterTimer:Stop()
    self.confuseMonsterTimer = nil
  end
  if self.shopEventTimer then
    self.shopEventTimer:Stop()
    self.shopEventTimer = nil
  end
  if self.genConfuseBltTimer then
    self.genConfuseBltTimer:Stop()
    self.genConfuseBltTimer = nil
  end
  if self.allEffDestroyTimerList then
    for _, v in ipairs(self.allEffDestroyTimerList) do
      v:Stop()
    end
    self.allEffDestroyTimerList = nil
  end
  if self.genBossTimer then
    self.genBossTimer:Stop()
    self.genBossTimer = nil
  end
  if self.clearMonsterTimer then
    self.clearMonsterTimer:Stop()
    self.clearMonsterTimer = nil
  end
end

function BountyHunterSceneView:IsReadyToEnter()
  return self.curBatState == BattleSceneState.ReadyToEnter
end

function BountyHunterSceneView:ClearAllEff()
  if self.effLoadReqList then
    for _, v in ipairs(self.effLoadReqList) do
      v:Destroy()
    end
    self.effLoadReqList = nil
  end
end

function BountyHunterSceneView:ClearAllTween()
  if self.aimMoveTween then
    self.aimMoveTween:Kill()
    self.aimMoveTween = nil
  end
  if self.confuseBltMoveTween then
    self.confuseBltMoveTween:Kill()
    self.confuseBltMoveTween = nil
  end
end

BountyHunterSceneView.OnCreate = OnCreate
BountyHunterSceneView.OnDestroy = OnDestroy
BountyHunterSceneView.OnEnable = OnEnable
BountyHunterSceneView.OnDisable = OnDisable
BountyHunterSceneView.ComponentDefine = ComponentDefine
BountyHunterSceneView.ComponentDestroy = ComponentDestroy
BountyHunterSceneView.DataDefine = DataDefine
BountyHunterSceneView.DataDestroy = DataDestroy
return BountyHunterSceneView
