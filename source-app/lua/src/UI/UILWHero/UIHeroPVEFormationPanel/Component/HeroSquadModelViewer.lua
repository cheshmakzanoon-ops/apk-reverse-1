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
  self.heroesLoaded = {}
  self.heroesLoading = {}
  self.lastHeroesUuid = nil
  self.heroLoadedCallback = nil
  self.curRotationX = 0
  self.onDragCallBack = onDragCallBack
  self.onTimeLineCallback = onTimeLineCallback
  self.rotateState = 0
  self.rawImage:SetEnable(false)
  HeroSquadModelViewer.openedRef = HeroSquadModelViewer.openedRef + 1
  self.refTag = HeroSquadModelViewer.openedRef
end

local function OnDestroy(self)
  RenderSetting.ToggleFurRenderFeature(false)
  HeroSquadModelViewer.openedRef = HeroSquadModelViewer.openedRef - 1
  self.refTag = nil
  self:ReleaseTexture()
  for _, v in pairs(self.heroesLoading) do
    if v ~= nil then
      v:RealDestroy()
    end
  end
  for _, v in pairs(self.heroesLoaded) do
    if v ~= nil then
      v:RealDestroy()
    end
  end
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  self.heroesLoading = nil
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
end

local function SetQuality(self, enable)
  if enable then
    shadowDistance = RenderSetting.GetShadowDistance()
    RenderSetting.SetShadowDistance(6)
  else
    RenderSetting.SetShadowDistance(shadowDistance)
  end
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

local function SetHeroesUuid(self, heroesUuid)
  self.lastHeroesUuid = self.heroesUuid
  self.heroesUuid = heroesUuid
  self.time1 = UITimeManager:GetInstance():GetServerTime()
  self:RemoveUnusedHeroes(heroesUuid)
  self:ReloadScene(function(ret)
    if not ret then
      return
    end
    self.time2 = UITimeManager:GetInstance():GetServerTime()
    if self.heroesUuid == nil then
      return
    end
    for index, v in pairs(self.heroesUuid) do
      self:ReloadHero(index, v, function(ret2)
        if ret2 then
        end
        if self.heroLoadedCallback then
          self.heroLoadedCallback()
        end
      end)
    end
  end)
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
    return
  end
  local scenePath = HeroUtils.DisplayPVESquadScenePath
  Logger.Log("#RecruitScene# HeroModelViewer  heroScenePreviewPath", scenePath)
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading = nil
      if callback ~= nil then
        callback(false)
      end
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
    self.hero1Slot = request.gameObject.transform:Find("Hero1Slot")
    self.hero2Slot = request.gameObject.transform:Find("Hero2Slot")
    self.hero3Slot = request.gameObject.transform:Find("Hero3Slot")
    self.hero4Slot = request.gameObject.transform:Find("Hero4Slot")
    self.hero5Slot = request.gameObject.transform:Find("Hero5Slot")
    self.heroSlots = {
      self.hero1Slot,
      self.hero2Slot,
      self.hero3Slot,
      self.hero4Slot,
      self.hero5Slot
    }
    self.hero1SlotDefaultPos = self.hero1Slot.position
    self.hero2SlotDefaultPos = self.hero2Slot.position
    self.hero3SlotDefaultPos = self.hero3Slot.position
    self.hero4SlotDefaultPos = self.hero4Slot.position
    self.hero5SlotDefaultPos = self.hero5Slot.position
    self.heroSlotsDefaultPos = {
      self.hero1SlotDefaultPos,
      self.hero2SlotDefaultPos,
      self.hero3SlotDefaultPos,
      self.hero4SlotDefaultPos,
      self.hero5SlotDefaultPos
    }
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function SetHeroOnSlot(self, heroModel, slotIndex)
  if heroModel == nil then
    return
  end
  if self.heroSlots == nil or self.heroSlots[slotIndex] == nil then
    return
  end
  local slot = self.heroSlots[slotIndex]
  local slotTransform = slot.transform
  local heroTransform = heroModel.transform
  heroTransform:SetParent(slotTransform)
  heroTransform:Set_localPosition(0, 0, 0)
  heroTransform:Set_localScale(1, 1, 1)
  heroTransform.localRotation = Quaternion.identity
end

local function ReloadHero(self, slotIndex, heroId, callback)
  if self.heroesLoading[heroId] ~= nil then
    return
  end
  if heroId == nil then
    if callback ~= nil then
      callback(false)
    end
    return
  end
  if self.heroesLoaded[heroId] ~= nil then
    self.heroesLoaded[heroId].gameObject:SetActive(true)
    SetHeroOnSlot(self, self.heroesLoaded[heroId].gameObject, slotIndex)
    if callback ~= nil then
      callback(true)
    end
    return
  end
  local modelPath, appearanceId
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroId)
  if heroData ~= nil then
    modelPath, appearanceId = heroData:GetHeroModelData(HeroModelType.Battle)
  end
  if string.IsNullOrEmpty(modelPath) or appearanceId == nil then
    return
  end
  local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  local request = ResourceManager:InstantiateAsync(modelPath)
  self.heroesLoading[heroId] = request
  request:completed("+", function()
    if request.isError then
      Logger.LogError("#RecruitScene# ModelViewer ReloadHero Error! heroId:" .. heroId .. ", Error:" .. request.error)
      self.heroesLoading[heroId] = nil
      if callback ~= nil then
        callback(false)
      end
      return
    end
    self.time3 = UITimeManager:GetInstance():GetServerTime()
    local currentScene = self.sceneLoaded
    local go_rt = request.gameObject.transform
    local spawnPoint = currentScene.gameObject.transform:Find("SpawnPoint")
    request.gameObject:SetActive(true)
    go_rt:SetParent(spawnPoint ~= nil and spawnPoint or currentScene.gameObject.transform)
    go_rt:Set_localPosition(0, 0, 0)
    go_rt:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.heroesLoading[heroId] = nil
    go_rt.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer(HeroRenderLayer))
    self.heroModels[heroId] = go_rt
    SetHeroOnSlot(self, request.gameObject, slotIndex)
    local director = go_rt:GetComponentInChildren(typeof(PlayableDirector), true)
    local timeLineCamera = go_rt:GetComponentInChildren(typeof(Camera), true)
    if director then
      director.enabled = false
    end
    local animation = go_rt:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if animation then
      animation:Stop()
      animation:Play("idle")
    end
    if timeLineCamera ~= nil then
      timeLineCamera.gameObject:SetActive(false)
    end
    local canon_path = appearanceMeta.canon_path
    local cannon = go_rt:Find(canon_path)
    if cannon ~= nil then
      local localForward = Vector3.New(0, 0, 0)
      local canonFix = appearanceMeta.canon_rotation
      if canonFix and #canonFix == 3 then
        localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
      end
      cannon:Set_localEulerAngles(localForward)
    end
    self.heroesLoading[heroId] = nil
    self.heroesLoaded[heroId] = request
    if callback ~= nil then
      callback(true)
    end
  end)
end

local function RemoveUnusedHeroes(self, heroesUuid)
  if self.heroesLoading ~= nil then
    for k, v in pairs(self.heroesLoading) do
      if not table.hasvalue(heroesUuid, k) then
        v:RealDestroy()
        self.heroesLoading[k] = nil
      end
    end
  end
  if self.heroesLoaded ~= nil then
    for k, v in pairs(self.heroesLoaded) do
      if not table.hasvalue(heroesUuid, k) then
        v:RealDestroy()
        self.heroesLoaded[k] = nil
      end
    end
  end
  if self.heroModels ~= nil then
    for k, v in pairs(self.heroModels) do
      if not table.hasvalue(heroesUuid, k) then
        self.heroModels[k] = nil
      end
    end
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

local function DebugTimeCamera(self)
  local function CheckAngle(a)
    return 180 < a and a - 360 or a
  end
  
  if self.curTimeLineCamera ~= nil then
    local parent = self.curTimeLineCamera.parent
    local pos = self.curTimeLineCamera.transform.position
    local angles = self.curTimeLineCamera.transform.rotation.eulerAngles
    local scale = self.curTimeLineCamera.transform.localScale
    local lossyScale = self.curTimeLineCamera.transform.lossyScale
    local posStr = string.format("%.3f|%.3f|%.3f", pos.x, pos.y, pos.z)
    local anglesStr = string.format("%.3f|%.3f|%.3f", CheckAngle(angles.x), CheckAngle(angles.y), CheckAngle(angles.z))
    local scaleStr = string.format("%.3f|%.3f|%.3f", lossyScale.x, lossyScale.y, lossyScale.z)
    local focalLength = self.curTimeLineCamera.focalLength
    local sensorSize = self.curTimeLineCamera.sensorSize
    local sensorStr = string.format("%.3f|%.3f", sensorSize.x, sensorSize.y)
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

local function Update(self)
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

local function SetLensShift(self, x, y)
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
  for i, v in ipairs(self.heroSlots) do
    v.transform:DOKill()
    v.transform.position = self.heroSlotsDefaultPos[i]
  end
end

local function MoveHeroSlotPos(self, index, screenPos)
  local slot = self.heroSlots[index]
  if slot then
    slot.transform.position = self.sceneCamera:ScreenToWorldPoint(Vector3.New(screenPos.x, screenPos.y, 12))
  end
end

local function HeroSlotMoveToIndex(self, index, dstIndex, time)
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
HeroSquadModelViewer.Update = Update
HeroSquadModelViewer.SetHeroLoadedCallback = SetHeroLoadedCallback
HeroSquadModelViewer.SetBeginDragListener = SetBeginDragListener
HeroSquadModelViewer.SetEndDragListener = SetEndDragListener
HeroSquadModelViewer.SetDefaultScenePos = SetDefaultScenePos
HeroSquadModelViewer.DebugTimeCamera = DebugTimeCamera
HeroSquadModelViewer.SetLensShift = SetLensShift
HeroSquadModelViewer.ApplyCameraLensShift = ApplyCameraLensShift
HeroSquadModelViewer.SetQuality = SetQuality
HeroSquadModelViewer.ChangeToPreview = ChangeToPreview
HeroSquadModelViewer.DoCameraAttrAni = DoCameraAttrAni
HeroSquadModelViewer.FindTagRecursively = FindTagRecursively
HeroSquadModelViewer.ToggleSceneVisible = ToggleSceneVisible
HeroSquadModelViewer.ResetPositions = ResetPositions
HeroSquadModelViewer.MoveHeroSlotPos = MoveHeroSlotPos
HeroSquadModelViewer.HeroSlotMoveToIndex = HeroSlotMoveToIndex
HeroSquadModelViewer.CampCameraPosTable = 9999
return HeroSquadModelViewer
