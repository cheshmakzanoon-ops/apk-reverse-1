local hero_build_in_path = LoadPath.DyHero
local default_build_in_model_name = "tank"
local HeroSquadModelViewer = BaseClass("HeroSquadModelViewer", UIBaseContainer)
local GameQualitySettings = require("Util.GameQualitySettings")
local base = UIBaseContainer
local SystemInfo = CS.UnityEngine.SystemInfo
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local Camera = CS.UnityEngine.Camera
local Screen = CS.UnityEngine.Screen
local HeroRenderLayer = "PlaneShadowObject"
local GrabRenderLayer = "Grab"
local AdvanceEffectName = "HeroAdvanceEffect"
local shadowDistance, defaultQuality
HeroSquadModelViewer.openedRef = 0

local function OnCreate(self, enableTouch, onDragCallBack, onTimeLineCallback)
  base.OnCreate(self)
  self.rtSize = DefaultScreenHeight
  self:ComponentDefine(enableTouch)
  self.defaultScenePos = Vector3.New(9999, 9999, 9999)
  self.cameraOffsetFlag = 1
  self.cameraOffset = Vector3.zero
  self.sceneLoaded = nil
  self.sceneCamera = nil
  self.heroModels = {}
  self.sceneLoading = nil
  self.heroReqs = {}
  self.heroLoadedCallback = nil
  self.curRotationX = 0
  self.onDragCallBack = onDragCallBack
  self.onTimeLineCallback = onTimeLineCallback
  self.rotateState = 0
  self.rawImage:SetEnable(false)
  HeroSquadModelViewer.openedRef = HeroSquadModelViewer.openedRef + 1
  self.refTag = HeroSquadModelViewer.openedRef
  self.weaponReq = nil
  self.weaponModel = nil
  self.weaponModeId = nil
  self.waitCallbacks = {}
end

local function OnDestroy(self)
  RenderSetting.ToggleFurRenderFeature(false)
  HeroSquadModelViewer.openedRef = HeroSquadModelViewer.openedRef - 1
  self.refTag = nil
  self.waitCallbacks = nil
  self:ReleaseTexture()
  self:UnloadDominator()
  for _, v in pairs(self.heroReqs) do
    if v ~= nil then
      v:RealDestroy()
    end
  end
  if self.weaponReq ~= nil then
    self.weaponReq:RealDestroy()
  end
  self.weaponModel = nil
  self.weaponModeId = nil
  self.heroSlots = nil
  self.heroSlotsDefaultPos = nil
  self.weaponSlot = nil
  self.weaponSlotDefaultPos = nil
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  self.sceneLoaded = nil
  self.sceneLoading = nil
  self.lastHeroId = nil
  self.curRotationX = nil
  self.sceneCamera = nil
  self.heroModels = nil
  self.onDragCallBack = nil
  self.onTimeLineCallback = nil
  self.rotateState = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(true)
  end
  self:SetQuality(true)
  RenderSetting.ToggleFurRenderFeature(true)
  if self.heroesUuid ~= nil then
    for _, v in pairs(self.heroesUuid) do
      local model = self.heroModels[v]
      local animation = model:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      if animation then
        animation:Stop()
        animation:Play("idle")
      end
    end
  end
  if self.weaponModel ~= nil then
    local animation = self.weaponModel:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if animation then
      animation:Stop()
      animation:Play("idle")
    end
  end
end

local function SetQuality(self, enable)
end

local function OnDisable(self)
  if self.sceneLoaded ~= nil then
    self.sceneLoaded.gameObject:SetActive(false)
  end
  base.OnDisable(self)
  self:SetQuality(false)
end

local function ComponentDefine(self, enableTouch)
  self.rawImage = self:AddComponent(UIRawImage, "")
end

local function ComponentDestroy(self)
end

local function SetHeroesUuid(self, heroesUuid, dominatorUuid)
  if not self.curHeroes then
    self.curHeroes = {}
  end
  table.clear(self.curHeroes)
  for i, v in pairs(heroesUuid) do
    self.curHeroes[i] = v
  end
  self.dominatorUuid = dominatorUuid
  self:RemoveUnusedHeroes(self.curHeroes)
  self:ReloadScene(function(ret)
    if not ret then
      return
    end
    if self.curHeroes == nil then
      return
    end
    for index, v in pairs(self.curHeroes) do
      self:ReloadHero(index, v, function(ret2)
        if self.heroLoadedCallback then
          self.heroLoadedCallback()
        end
      end)
    end
    self:ReloadDominator(self.dominatorUuid)
  end)
end

local function SetWeaponMeta(self, appearanceId)
  if not appearanceId then
    return
  end
  self.lastWeaponId = appearanceId
  local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  self:CheckRemoveTacticalWeapon()
  self:ReloadScene(function(ret)
    if not ret then
      return
    end
    self:ReloadWeapon(appearanceMeta)
  end)
end

local function ExecuteWaitCallbacks(self, result)
  if self.waitCallbacks == nil then
    return
  end
  for _, v in pairs(self.waitCallbacks) do
    v(result)
  end
  self.waitCallbacks = {}
end

local function ReloadScene(self, callback)
  if self.sceneLoaded ~= nil then
    local camera = self.sceneCamera
    self:OnRenderTexture(camera)
    self.sceneLoaded.gameObject:SetActive(true)
    if callback ~= nil then
      callback(true)
    end
    return
  end
  if self.sceneLoading ~= nil then
    table.insert(self.waitCallbacks, callback)
    return
  end
  local scenePath = HeroUtils.DisplayPVPSquadScenePath
  Logger.Log("#RecruitScene# HeroModelViewer  heroScenePreviewPath", scenePath)
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading = nil
      if callback ~= nil then
        callback(false)
      end
      ExecuteWaitCallbacks(self, false)
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_localPosition(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local camera = request.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
    self.sceneLoading = nil
    self.sceneLoaded = request
    self.sceneCamera = camera
    self:ToggleSceneCamera(true)
    local hero1Slot = request.gameObject.transform:Find("Hero1Slot")
    local hero2Slot = request.gameObject.transform:Find("Hero2Slot")
    local hero3Slot = request.gameObject.transform:Find("Hero3Slot")
    local hero4Slot = request.gameObject.transform:Find("Hero4Slot")
    local hero5Slot = request.gameObject.transform:Find("Hero5Slot")
    local dominatorSlot = request.gameObject.transform:Find("Hero6Slot")
    self.heroSlots = {
      hero1Slot,
      hero2Slot,
      hero3Slot,
      hero4Slot,
      hero5Slot,
      dominatorSlot
    }
    local hero1SlotDefaultPos = hero1Slot.position
    local hero2SlotDefaultPos = hero2Slot.position
    local hero3SlotDefaultPos = hero3Slot.position
    local hero4SlotDefaultPos = hero4Slot.position
    local hero5SlotDefaultPos = hero5Slot.position
    local hero6SlotDefaultPos = dominatorSlot.position
    self.heroSlotsDefaultPos = {
      hero1SlotDefaultPos,
      hero2SlotDefaultPos,
      hero3SlotDefaultPos,
      hero4SlotDefaultPos,
      hero5SlotDefaultPos,
      hero6SlotDefaultPos
    }
    if callback ~= nil then
      callback(true)
    end
    self.weaponSlot = request.gameObject.transform:Find("WeaponSlot")
    self.weaponSlotDefaultPos = self.weaponSlot.position
    ExecuteWaitCallbacks(self, true)
  end)
end

local function SetHeroOnSlot(self, heroModel, slotIndex, isWeapon)
  if heroModel == nil then
    return
  end
  local slot
  if isWeapon then
    slot = self.weaponSlot
  elseif self.heroSlots ~= nil then
    slot = self.heroSlots[slotIndex]
  end
  if slot == nil then
    return
  end
  local slot = slot
  local slotTransform = slot.transform
  local heroTransform = heroModel.transform
  heroTransform:SetParent(slotTransform)
  heroTransform:Set_localPosition(0, 0, 0)
  heroTransform:Set_localScale(1, 1, 1)
  heroTransform:Set_localRotation(0, 0, 0, 1)
end

local function ResetUnit(self, obj, appearanceMeta, slotIndex, isWeapon)
  if IsNull(obj) then
    return
  end
  local go_rt = obj.transform
  obj:SetActive(true)
  go_rt:Set_localPosition(0, 0, 0)
  go_rt:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  go_rt.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(HeroRenderLayer))
  SetHeroOnSlot(self, obj, slotIndex, isWeapon)
  local director = go_rt:GetComponentInChildren(typeof(PlayableDirector), true)
  local timeLineCamera = go_rt:GetComponentInChildren(typeof(Camera), true)
  if not IsNull(director) then
    director.enabled = false
  end
  local animation = go_rt:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not IsNull(animation) then
    animation:Stop()
    animation:Play("idle")
  end
  if not IsNull(timeLineCamera) then
    timeLineCamera.gameObject:SetActive(false)
  end
  if appearanceMeta then
    local canon_path = appearanceMeta.canon_path
    if string.IsNullOrEmpty(canon_path) then
      return
    end
    local cannon = go_rt:Find(canon_path)
    if not IsNull(cannon) then
      local localForward = Vector3.New(0, 0, 0)
      local canonFix = appearanceMeta.canon_rotation
      if canonFix and #canonFix == 3 then
        localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
      end
      cannon:Set_localEulerAngles(localForward)
    end
  end
end

local function ReloadHero(self, slotIndex, heroId, callback)
  if heroId == nil then
    if callback ~= nil then
      callback(false)
    end
    return
  end
  if self.heroModels[heroId] ~= nil then
    self.heroModels[heroId].gameObject:SetActive(true)
    SetHeroOnSlot(self, self.heroModels[heroId], slotIndex)
    if callback ~= nil then
      callback(true)
    end
    return
  end
  local modelPath
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroId)
  local modelName = ""
  if heroData ~= nil then
    modelName = heroData:GetHeroModelData(HeroModelType.Queue)
  end
  if modelName == nil or modelName == "" then
    Logger.LogError("#HeroPreview# ReloadHero Error! prefab_high is nil!, heroId:" .. heroId)
    modelPath = string.format(hero_build_in_path, default_build_in_model_name)
  else
    modelPath = modelName
  end
  if self.heroReqs[heroId] ~= nil then
    return
  end
  local request = ResourceManager:InstantiateAsync(modelPath)
  self.heroReqs[heroId] = request
  request:completed("+", function()
    if request.isError then
      Logger.LogError("#RecruitScene# ModelViewer ReloadHero Error! heroId:" .. heroId .. ", Error:" .. request.error)
      if callback ~= nil then
        callback(false)
      end
      return
    end
    local go_rt = request.gameObject
    local slotIndex
    for i, v in pairs(self.curHeroes) do
      if v == heroId then
        slotIndex = i
        break
      end
    end
    if slotIndex == nil then
      Logger.LogError("slotIndex is nil")
      return
    end
    ResetUnit(self, go_rt, heroData, slotIndex)
    self.heroModels[heroId] = go_rt
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function RemoveUnusedHeroes(self, heroesUuid)
  if self.heroModels ~= nil then
    for k, v in pairs(self.heroModels) do
      if not table.hasvalue(heroesUuid, k) then
        self.heroModels[k] = nil
      end
    end
  end
  if self.heroReqs ~= nil then
    for k, v in pairs(self.heroReqs) do
      if not table.hasvalue(heroesUuid, k) then
        v:RealDestroy()
        self.heroReqs[k] = nil
      end
    end
  end
end

local function ReloadWeapon(self, appearanceMeta, callback)
  if not appearanceMeta then
    if callback ~= nil then
      callback(false)
    end
    return
  end
  if self.weaponModeId == appearanceMeta.id then
    return
  end
  local modelPath = appearanceMeta.queue_model_path
  if string.IsNullOrEmpty(modelPath) then
    if callback ~= nil then
      callback(false)
    end
    return
  end
  local request = ResourceManager:InstantiateAsync(modelPath)
  self.weaponReq = request
  self.weaponModeId = appearanceMeta.id
  request:completed("+", function()
    if request.isError then
      Logger.LogError("#RecruitScene# ModelViewer ReWeapon Error! modelPath:" .. modelPath .. ", Error:" .. request.error)
      self.weaponReq = nil
      if callback ~= nil then
        callback(false)
      end
      return
    end
    local go_rt = request.gameObject
    self.weaponModel = go_rt
    ResetUnit(self, go_rt, appearanceMeta, nil, true)
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function CheckRemoveTacticalWeapon(self, appearanceMeta)
  if appearanceMeta ~= nil and appearanceMeta.id == self.weaponModeId then
    return
  end
  if self.weaponModel ~= nil then
    self.weaponModel = nil
  end
  if self.weaponReq ~= nil then
    self.weaponReq:RealDestroy()
    self.weaponReq = nil
  end
end

local function OnRenderTexture(self, camera)
  if camera == nil then
    Logger.LogError("#zlh# OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local scale = 1
    if not GameQualitySettings.IsHighGearQuality() then
      scale = 0.8
    end
    local rtWidth = self.rtSize
    local rtHeight = self.rtSize
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "HeroShow"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    self.rawImage:SetColor(Color.New(1, 1, 1, 1))
  end
  camera.targetTexture = self.renderTexture
end

local function ReleaseTexture(self)
  self.rawImage:SetTexture(nil)
  if self.sceneCamera ~= nil then
    self.sceneCamera.targetTexture = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function ToggleSceneCamera(self, b)
  local sceneCamera = self.sceneCamera
  if sceneCamera ~= nil then
    sceneCamera.gameObject:SetActive(b)
    if b then
      self:ApplyCameraLensShift()
      self:OnRenderTexture(sceneCamera)
    else
      sceneCamera.targetTexture = nil
    end
  end
end

local function SetCameraOffset(self, vector3Offset)
  self.cameraOffset = vector3Offset
  if self.sceneCamera then
    local v3 = HeroSquadModelViewer.CampCameraPosTable + self.cameraOffset
    self.sceneCamera.transform:Set_localPosition(v3.x, v3.y, v3.z)
  end
end

local function ApplyCameraLensShift(self)
  local camera
  camera = self.curTimeLineCamera
  if camera ~= nil and self.lensShift ~= nil then
    camera.lensShift = self.lensShift
  end
end

local function SetHeroLoadedCallback(self, callback)
  self.heroLoadedCallback = callback
end

local function SetBeginDragListener(self, listener)
  self.beginDragListener = listener
end

local function SetEndDragListener(self, listener)
  self.endDragListener = listener
end

local function SetDefaultScenePos(self, defaultPos)
  self.defaultScenePos = defaultPos
end

local function ChangeToPreview(self)
  local camera = self.sceneCamera
  local duration = 0.2
  self:DoCameraAttrAni(camera, "lensShift", Vector2.New(0, 0), duration)
  self:DoCameraAttrAni(camera, "focalLength", 21, duration)
end

local function DoCameraAttrAni(self, camera, attr, endValue, duration)
  local function Getter()
    return camera[attr]
  end
  
  local function Setter(x)
    camera[attr] = x
  end
  
  DOTween.To(Getter, Setter, endValue, duration):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

local function FindTagRecursively(t, tagName, level)
  local ret1 = {}
  for k = 0, t.childCount - 1 do
    local child = t:GetChild(k)
    if child.gameObject.tag == tagName then
      table.insert(ret1, child)
    elseif 1 < level then
      local ret2 = FindTagRecursively(child, tagName, level - 1)
      table.insertto(ret1, ret2)
    end
  end
  return ret1
end

local function ToggleSceneVisible(self, t)
  if self.sceneLoaded then
    self.sceneLoaded.gameObject:SetActive(t)
  end
end

local function ResetPositions(self)
  if table.IsNullOrEmpty(self.heroSlots) then
    return
  end
  for i, v in pairs(self.heroSlots) do
    v.transform:DOKill()
    v.transform.position = self.heroSlotsDefaultPos[i]
  end
end

local function MoveHeroSlotPos(self, index, screenPos)
  if table.IsNullOrEmpty(self.heroSlots) then
    return
  end
  local slot = self.heroSlots[index]
  if slot then
    slot.transform.position = self.sceneCamera:ScreenToWorldPoint(Vector3.New(screenPos.x, screenPos.y, 12))
  end
end

local function HeroSlotMoveToIndex(self, index, dstIndex, time)
  if table.IsNullOrEmpty(self.heroSlots) then
    return
  end
  local animTime = time or 0.2
  if animTime <= 0 then
    local slot = self.heroSlots[index]
    if slot then
      slot.transform.position = self.heroSlotsDefaultPos[dstIndex]
    end
  else
    local slot = self.heroSlots[index]
    if slot then
      local pos = self.heroSlotsDefaultPos[dstIndex]
      slot.transform:DOMove(pos, animTime)
    end
  end
end

function HeroSquadModelViewer:ReloadDominator(dominatorUuid)
  if dominatorUuid == nil then
    self:UnloadDominator()
    return
  end
  local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
  if not dominatorInfo then
    return
  end
  local appearanceId = dominatorInfo:GetAppearanceId()
  if self.dominatorAppId ~= nil and self.dominatorAppId == appearanceId then
    return
  end
  local appearnaceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  if appearnaceTemplate == nil then
    return
  end
  self:UnloadDominator()
  self.dominatorUuid = dominatorUuid
  self.dominatorAppId = appearanceId
  local modelPath = appearnaceTemplate.queue_model_path
  if self.dominatorModel ~= nil then
    self.dominatorModel.gameObject:SetActive(true)
    SetHeroOnSlot(self, self.dominatorModel, 6)
    return
  end
  local request = ResourceManager:InstantiateAsync(modelPath)
  self.dominatorReq = request
  request:completed("+", function()
    if request.isError then
      Logger.LogError("#RecruitScene# ModelViewer ReloadDominator Error! dominatorUuid:" .. dominatorUuid .. ", Error:" .. request.error)
      return
    end
    local go_rt = request.gameObject
    ResetUnit(self, go_rt, appearnaceTemplate, 6)
    self.dominatorModel = go_rt
  end)
end

function HeroSquadModelViewer:UnloadDominator()
  if self.dominatorModel ~= nil then
    self.dominatorModel = nil
  end
  if self.dominatorReq ~= nil then
    self.dominatorReq:RealDestroy()
    self.dominatorReq = nil
  end
  self.dominatorUuid = nil
  self.dominatorAppId = nil
end

HeroSquadModelViewer.OnCreate = OnCreate
HeroSquadModelViewer.OnDestroy = OnDestroy
HeroSquadModelViewer.OnEnable = OnEnable
HeroSquadModelViewer.OnDisable = OnDisable
HeroSquadModelViewer.ComponentDefine = ComponentDefine
HeroSquadModelViewer.ComponentDestroy = ComponentDestroy
HeroSquadModelViewer.SetHeroesUuid = SetHeroesUuid
HeroSquadModelViewer.ReloadScene = ReloadScene
HeroSquadModelViewer.ReloadHero = ReloadHero
HeroSquadModelViewer.RemoveUnusedHeroes = RemoveUnusedHeroes
HeroSquadModelViewer.OnRenderTexture = OnRenderTexture
HeroSquadModelViewer.ReleaseTexture = ReleaseTexture
HeroSquadModelViewer.ToggleSceneCamera = ToggleSceneCamera
HeroSquadModelViewer.SetCameraOffset = SetCameraOffset
HeroSquadModelViewer.SetHeroLoadedCallback = SetHeroLoadedCallback
HeroSquadModelViewer.SetBeginDragListener = SetBeginDragListener
HeroSquadModelViewer.SetEndDragListener = SetEndDragListener
HeroSquadModelViewer.SetDefaultScenePos = SetDefaultScenePos
HeroSquadModelViewer.ApplyCameraLensShift = ApplyCameraLensShift
HeroSquadModelViewer.SetQuality = SetQuality
HeroSquadModelViewer.ChangeToPreview = ChangeToPreview
HeroSquadModelViewer.DoCameraAttrAni = DoCameraAttrAni
HeroSquadModelViewer.FindTagRecursively = FindTagRecursively
HeroSquadModelViewer.ToggleSceneVisible = ToggleSceneVisible
HeroSquadModelViewer.ResetPositions = ResetPositions
HeroSquadModelViewer.MoveHeroSlotPos = MoveHeroSlotPos
HeroSquadModelViewer.HeroSlotMoveToIndex = HeroSlotMoveToIndex
HeroSquadModelViewer.SetWeaponMeta = SetWeaponMeta
HeroSquadModelViewer.CheckRemoveTacticalWeapon = CheckRemoveTacticalWeapon
HeroSquadModelViewer.ReloadWeapon = ReloadWeapon
HeroSquadModelViewer.CampCameraPosTable = 9999
return HeroSquadModelViewer
