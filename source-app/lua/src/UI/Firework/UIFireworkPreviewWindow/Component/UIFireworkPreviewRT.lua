local base = UIBaseContainer
local UIFireworkPreviewRT = BaseClass("UIFireworkPreviewRT", base)
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local UIDecorationMainCityPlayIdleAniManager = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCityPlayIdleAniManager")
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local previewRt_path = ""
local Terrain_World0_High = "Assets/Main/Prefabs/World/Terrain_0_High.prefab"
local effectPath = "Assets/Main/Prefabs/BuildEffect/MainBuild/%s.prefab"
local WorldBuilding = CS.WorldBuilding
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.previewRt = self:AddComponent(UIRawImage, previewRt_path)
end

local function ComponentDestroy(self)
  self.previewRt = nil
end

local function DataDefine(self)
  self.camera = nil
  self.citySlot = nil
  self.rtHeight = 440
  self.rtWidth = 670
  self.fov = 35
  self.defaultFov = nil
  self.worldBuilding = nil
  self.buildingAniSkillEffectsRequest = nil
  self.cameraDefaultPara = nil
  self._playIdleAniManager = nil
  self.rtFormat = nil
end

local function DataDestroy(self)
  self:ReleaseTexture()
  self.citySlot = nil
  self.rawImage = nil
  self:DestroyModel()
  self:DestroyScene()
  self.camera = nil
  self.rtWidth = nil
  self.rtHeight = nil
  self.fireworkItemId = nil
  self.defaultFov = nil
  self.worldBuilding = nil
  self.cameraDefaultPara = nil
  self:DeletePlayIdleAniManager()
  self.rtFormat = nil
end

local function OnRenderTexture(self, camera)
  if camera == nil then
    Logger.LogError(" OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local scale = 1
    if not GameQualitySettings.IsHighGearQuality() then
      scale = 0.5
    end
    local rtWidth = toInt(self.rtWidth * scale)
    local rtHeight = toInt(self.rtHeight * scale)
    local rtFormat = self.rtFormat or RenderTextureFormat.ARGBHalf
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "FireworkShow"
    self.previewRt:SetTexture(self.renderTexture)
    self.previewRt:SetEnable(true)
    if self.previewRt ~= nil then
      self.previewRt:SetColorRGBA(1, 1, 1, 1)
    end
    camera.aspect = rtWidth / rtHeight
  end
  camera.targetTexture = self.renderTexture
end

local function RefreshView(self)
  self:DestroyModel()
  self:DeletePlayIdleAniManager()
  local modelName = BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
  local modelPath = UIUtil.GetFullPath("Assets/Main/Prefabs/Building/", modelName, ".prefab")
  local hasAsset = ResourceManager:IsAssetDownloaded(modelPath)
  if not hasAsset then
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    local isPrepare = infoPlayer:InPreviewMode()
    local season = isPrepare and SeasonUtil.GetSeason() + 1 or SeasonUtil.GetSeason()
    UIUtil.ShowTips(Localization:GetString("skin_preview_desc3", season))
  end
  self:LoadBuild(modelName, function()
    self:LoadMainEffect()
    self:LoadTitle()
    self:LoadFirework()
  end)
  self:SetCameraPos()
  self:LoadZone()
end

local function LoadScene(self)
  if self.scene == nil then
    self.scene = ResourceManager:InstantiateAsync(UIAssets.UIDecorationWorldScene)
    self.scene:completed("+", function()
      if not self.scene or self.scene.isError then
        return
      end
      self.scene.gameObject.name = "UIFireworkWorldScene_" .. self.fireworkItemId
      self.scene.gameObject:SetActive(true)
      self.scene.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local pos = DecorationUtil.GetWorldPosNegativeNumber(0)
      self.scene.gameObject.transform.position = pos
      self.camera = self.scene.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
      self.defaultFov = self.camera.fieldOfView
      self.citySlot = self.scene.gameObject.transform:Find("CitySlot")
      self.cameraDefaultPara = self.scene.gameObject.transform:Find("CameraDefaultPara")
      self:OnRenderTexture(self.camera)
      self.gameObject:SetActive(true)
      self:RefreshView()
    end)
  elseif self.camera ~= nil then
    self:RefreshView()
  end
end

local function LoadMainEffect(self)
  local req = self.request
  if not req or IsNull(req) then
    return
  end
  local effectId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_Effect)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(effectId)
  if template == nil or template:IsDefault() then
    return
  end
  if self.effectRes then
    self.effectRes:Destroy()
    self.effectRes = nil
  end
  self.effectParent = req.gameObject.transform:Find("ModelGo/Normal")
  if not IsNull(self.effectParent) then
    local path = string.format(effectPath, template.model_world)
    if not string.IsNullOrEmpty(path) then
      self.effectRes = ResourceManager:InstantiateAsync(path)
      self.effectRes:completed("+", function()
        if not self.effectRes or self.effectRes.isError then
          return
        end
        self.effectRes.gameObject.transform:SetParent(self.effectParent)
        self.effectRes.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.effectRes.gameObject.transform:Set_localPosition(0, 0, 0)
      end)
    end
  end
end

local function LoadTitle(self)
  local request = self.request
  if self.request == nil or IsNull(self.worldLabelGo) then
    return
  end
  self.worldLabelGo.gameObject:SetActive(true)
  local worldLabel = self.worldLabelGo:GetComponent(typeof(CS.UIWorldLabel))
  local skinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_TittleName)
  if worldLabel ~= nil then
    if worldLabel.SetNameBgSkin ~= nil then
      worldLabel:SetNameBgSkin(skinId)
    end
    local nameStr = LuaEntry.Player:GetFullName()
    local countryFlag = LuaEntry.Player.countryFlag or DefaultNation
    worldLabel:ShowFlag(true)
    worldLabel:SetFlag(countryFlag)
    local color = CS.GameDefines.CityLabelColorType.Green
    worldLabel:SetName(nameStr, color)
    worldLabel:SetLevel(LuaEntry.Player.level)
  else
    local levelLabel = request.gameObject.transform:Find("ModelGo/CityLabel/LevelLabel/LevelText"):GetComponent((typeof(CS.SuperTextMesh)))
    local nameLabel = request.gameObject.transform:Find("ModelGo/CityLabel/NameLabel/NameText"):GetComponent((typeof(CS.SuperTextMesh)))
    local nameLabelBg = request.gameObject.transform:Find("ModelGo/CityLabel/NameLabel"):GetComponent((typeof(CS.UnityEngine.SpriteRenderer)))
    local flag = request.gameObject.transform:Find("ModelGo/CityLabel/NameLabel/Flag")
    if flag ~= nil then
      flag.gameObject:SetActive(false)
    end
    if levelLabel then
      levelLabel.text = tostring(LuaEntry.Player.level)
    end
    if nameLabel then
      nameLabel.text = LuaEntry.Player.name
      nameLabel.color32 = WorldGreenColor32
      nameLabelBg.size = Vector2.New(1.6, nameLabelBg.size.y)
    end
    if nameLabelBg then
      local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
      nameLabelBg:LoadSprite(template.img)
    end
  end
  self.levelLabel = request.gameObject.transform:Find("ModelGo/CityLabel/levelLabel")
  if not IsNull(self.levelLabel) then
    self.levelLabelAdjustScales = self.levelLabel:GetComponents(typeof(CS.AutoAdjustScale))
  end
  if not IsNull(self.levelLabelAdjustScales) then
    if self.levelLabelAdjustScales ~= nil then
      for i = 0, self.levelLabelAdjustScales.Length - 1 do
        if not IsNull(self.levelLabelAdjustScales[i]) then
          self.levelLabelAdjustScales[i].enabled = false
        end
      end
    end
    self.levelLabel.eulerAngles = Vector3.New(45, 0, 0)
    self.levelLabel.localScale = Vector3.New(3, 3, 3)
  end
  self.worldLabelAutoFace = self.worldLabelGo:GetComponent(typeof(CS.AutoFaceToCamera))
  if not IsNull(self.worldLabelAutoFace) then
    self.worldLabelAutoFace.enabled = false
  end
  self.worldLabelGo.eulerAngles = Vector3.New(45, 0, 0)
end

local function LoadZone(self)
  self.zoneWorldTypeRequest = ResourceManager:InstantiateAsync(Terrain_World0_High)
  self.zoneWorldTypeRequest:completed("+", function(request)
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(self.citySlot.transform)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_localPosition(-500, 0, -500)
    local meta = CS.SceneSkinManager.Instance:GetCurSkinMeta()
    if meta then
      local meshRenders = request.gameObject.transform:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer))
      if not IsNull(meshRenders) then
        local length = meshRenders.Length
        local path = meta.world_terrain
        if 0 < length and not string.IsNullOrEmpty(path) then
          local matAsset = ResourceManager:LoadAsset(path, typeof(CS.UnityEngine.Material))
          if not IsNull(matAsset) and not IsNull(matAsset.asset) then
            local mat = CS.UnityEngine.Material(matAsset.asset)
            for i = 0, length - 1 do
              meshRenders[i].sharedMaterial = mat
            end
          end
        end
      end
    end
  end)
end

local function LoadBuild(self, buildModelName, loadCallBack)
  local modelName = buildModelName
  local modelPath = UIUtil.GetFullPath("Assets/Main/Prefabs/Building/", modelName, ".prefab")
  local request = ResourceManager:InstantiateAsync(modelPath)
  self.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(self.citySlot.transform)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_localPosition(0, 0, 0)
    local transform = request.gameObject.transform
    local icon = transform:Find("Icon")
    if not IsNull(icon) then
      icon.gameObject:SetActive(false)
    end
    local icon2 = transform:Find("Icon2")
    if not IsNull(icon2) then
      icon2.gameObject:SetActive(false)
    end
    self.worldLabelGo = request.gameObject.transform:Find("ModelGo/CityLabel")
    if not IsNull(self.worldLabelGo) then
      self.worldLabelGo.gameObject:SetActive(false)
    end
    self.worldBuilding = self.request.gameObject.transform:GetComponentInChildren(typeof(WorldBuilding))
    local idleAniName = "idle"
    self:InitPlayIdleAniManager()
    self:PlayAnimationAndEffectReturnTime(idleAniName)
    self.worldBuilding:InitDynamicModel(DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City))
    if loadCallBack then
      loadCallBack()
    end
  end)
end

local function LoadFirework(self)
  local modelPath = GetTableData(TableName.Firework, self.fireworkItemId, "effect", "")
  local request = ResourceManager:InstantiateAsync(modelPath .. ".prefab")
  self.fireworkRequest = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(self.citySlot.transform)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_localPosition(0, 0, 0)
  end)
end

local function PlayCrossFadeAnim(self, animName, crossTime)
  local result = 0
  if not IsNull(self.worldBuilding) then
    if crossTime and 0 < crossTime then
      self.worldBuilding:PlayCrossFadeAnimation(animName, crossTime)
    else
      self.worldBuilding:PlayAnimation(animName, 0)
    end
    result = self.worldBuilding:GetAnimationLength(animName)
    self.worldBuilding:PlayAnimationEffect(animName, 0)
    self.worldBuilding:PlayAnimationEffectAni(animName, 0)
  end
  return result
end

local function InitPlayIdleAniManager(self)
  local isHaveIdleDataStr = false
  local idleDataStr
  local skinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
  if skinId and 0 < skinId then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
    if template then
      idleDataStr = template.act_idle_status_para
      if not string.IsNullOrEmpty(idleDataStr) then
        isHaveIdleDataStr = true
      end
    end
  end
  if isHaveIdleDataStr then
    if self._playIdleAniManager == nil then
      self._playIdleAniManager = UIDecorationMainCityPlayIdleAniManager.New()
    end
    self._playIdleAniManager:InitData(idleDataStr, function(s, f)
      local aniTime = 0
      aniTime = PlayCrossFadeAnim(self, s, f)
      return aniTime
    end)
  else
    self:DeletePlayIdleAniManager()
  end
end

local function DeletePlayIdleAniManager(self)
  if self._playIdleAniManager ~= nil then
    self._playIdleAniManager:Delete()
    self._playIdleAniManager = nil
  end
end

local function PlayAnimationAndEffectReturnTime(self, animName)
  local isIdle = animName == "idle"
  local isPlayIdleAni = false
  local isBreakIdle = false
  local isBreakIdleNeeedCross = false
  if self._playIdleAniManager ~= nil then
    if isIdle == true then
      self._playIdleAniManager:OnStart()
      isPlayIdleAni = true
    else
      if self._playIdleAniManager.isPlaying == true then
        isBreakIdle = true
        isBreakIdleNeeedCross = self._playIdleAniManager:GetCurAniNeedMix()
      end
      self._playIdleAniManager:OnStop()
    end
  end
  if isPlayIdleAni == false then
    local crossTime = 0
    if isBreakIdle and isBreakIdleNeeedCross then
      crossTime = 0.2
    end
    self:PlayAnimation(animName, crossTime)
  end
end

local function PlayAnimation(self, animName, crossTime)
  if string.IsNullOrEmpty(animName) then
    return
  end
  if not IsNull(self.worldBuilding) then
    if crossTime and 0 < crossTime then
      self.worldBuilding:PlayCrossFadeAnimation(animName, crossTime)
    else
      self.worldBuilding:PlayAnimation(animName, 0)
    end
    self.worldBuilding:PlayAnimationEffect(animName, 0)
    self.worldBuilding:PlayAnimationEffectAni(animName, 0)
  end
end

local function SetCameraPos(self)
  if self.cameraDefaultPara and self.camera then
    self.camera.fieldOfView = self.fov
    self.camera.transform.position = self.cameraDefaultPara.transform.position
    self.camera.transform.rotation = self.cameraDefaultPara.transform.rotation * Quaternion.Euler(-9, 0, 0)
  end
end

local function RecoverCameraDefaultPos(self)
  if self.cameraDefaultPara and self.camera then
    self.camera.fieldOfView = self.defaultFov or 28
    self.camera.aspect = 1
    self.camera.transform.position = self.cameraDefaultPara.transform.position
    self.camera.transform.rotation = self.cameraDefaultPara.transform.rotation
    self.camera.targetTexture = nil
  end
end

local function SetData(self, fireworkItemId, width, height)
  self.rtWidth = width and 0 < width and width or self.rtWidth
  self.rtHeight = height and 0 < height and height or self.rtHeight
  self.fireworkItemId = fireworkItemId
  if not self.fireworkItemId then
    return
  end
  self:LoadScene()
end

local function DestroyModel(self)
  if self.worldBuilding then
    self.worldBuilding:UnloadDynamicModel()
  end
  if self.effectRes then
    self.effectRes:Destroy()
    self.effectRes = nil
  end
  if not IsNull(self.effectParent) then
    self.effectParent = nil
  end
  if not IsNull(self.worldLabelGo) then
    self.worldLabelGo.gameObject:SetActive(true)
  end
  if not IsNull(self.levelLabelAdjustScales) then
    for i = 0, self.levelLabelAdjustScales.Length - 1 do
      if not IsNull(self.levelLabelAdjustScales[i]) then
        self.levelLabelAdjustScales[i].enabled = true
      end
    end
  end
  self.levelLabel = nil
  self.worldLabelGo = nil
  if not IsNull(self.worldLabelAutoFace) then
    self.worldLabelAutoFace.enabled = true
  end
  self.worldLabelAutoFace = nil
  if self.request ~= nil then
    self.request:Destroy()
    self.request = nil
  end
  if self.fireworkRequest ~= nil then
    self.fireworkRequest:Destroy()
    self.fireworkRequest = nil
  end
  if self.zoneWorldTypeRequest ~= nil then
    self.zoneWorldTypeRequest:Destroy()
    self.zoneWorldTypeRequest = nil
  end
end

local function DestroyScene(self)
  if self.scene ~= nil then
    self:RecoverCameraDefaultPos()
    self.scene:Destroy()
    self.scene = nil
  end
end

local function ReleaseTexture(self)
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  self.previewRt:SetTexture(nil)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

UIFireworkPreviewRT.OnCreate = OnCreate
UIFireworkPreviewRT.OnDestroy = OnDestroy
UIFireworkPreviewRT.OnEnable = OnEnable
UIFireworkPreviewRT.OnDisable = OnDisable
UIFireworkPreviewRT.ComponentDefine = ComponentDefine
UIFireworkPreviewRT.ComponentDestroy = ComponentDestroy
UIFireworkPreviewRT.DataDefine = DataDefine
UIFireworkPreviewRT.DataDestroy = DataDestroy
UIFireworkPreviewRT.RefreshView = RefreshView
UIFireworkPreviewRT.OnRenderTexture = OnRenderTexture
UIFireworkPreviewRT.LoadMainEffect = LoadMainEffect
UIFireworkPreviewRT.LoadTitle = LoadTitle
UIFireworkPreviewRT.LoadBuild = LoadBuild
UIFireworkPreviewRT.LoadScene = LoadScene
UIFireworkPreviewRT.LoadZone = LoadZone
UIFireworkPreviewRT.LoadFirework = LoadFirework
UIFireworkPreviewRT.InitPlayIdleAniManager = InitPlayIdleAniManager
UIFireworkPreviewRT.DeletePlayIdleAniManager = DeletePlayIdleAniManager
UIFireworkPreviewRT.PlayAnimationAndEffectReturnTime = PlayAnimationAndEffectReturnTime
UIFireworkPreviewRT.PlayAnimation = PlayAnimation
UIFireworkPreviewRT.SetCameraPos = SetCameraPos
UIFireworkPreviewRT.RecoverCameraDefaultPos = RecoverCameraDefaultPos
UIFireworkPreviewRT.DestroyModel = DestroyModel
UIFireworkPreviewRT.DestroyScene = DestroyScene
UIFireworkPreviewRT.ReleaseTexture = ReleaseTexture
UIFireworkPreviewRT.SetData = SetData
return UIFireworkPreviewRT
