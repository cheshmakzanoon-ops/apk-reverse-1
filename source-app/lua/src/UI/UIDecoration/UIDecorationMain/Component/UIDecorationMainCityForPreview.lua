local UIDecorationMainCityForPreview = BaseClass("UIDecorationMainCityForPreview", UIBaseContainer)
local UIDecorationMainCityPlayIdleAniManager = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCityPlayIdleAniManager")
local SeasonCallbackEffectObj = require("DataCenter.SeasonCallback.SeasonCallbackEffectObj")
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local GameQualitySettings = require("Util.GameQualitySettings")
local effectPath = "Assets/Main/Prefabs/BuildEffect/MainBuild/%s.prefab"
local Terrain_World0_High = "Assets/Main/Prefabs/World/Terrain_0_High.prefab"
local Animator = CS.UnityEngine.Animator
local SimpleAnimation = CS.SimpleAnimation
local WorldBuildingAniEffect = CS.WorldBuildingAniEffect
local WorldBuildingAniEffectAni = CS.WorldBuildingAniEffectAni
local WorldBuilding = CS.WorldBuilding
local Localization = CS.GameEntry.Localization

function UIDecorationMainCityForPreview:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationMainCityForPreview:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationMainCityForPreview:ComponentDefine()
  self.rawImage = self:AddComponent(UIRawImage, "")
  if self.rawImage ~= nil then
    self.rawImage:SetColorRGBA(1, 1, 1, 0)
  end
end

function UIDecorationMainCityForPreview:ComponentDestroy()
  self.rawImage = nil
end

function UIDecorationMainCityForPreview:DataDefine()
  self.data = nil
  self.camera = nil
  self.citySlot = nil
  self.rtLen = 1080
  self.fov = 28
  self.buildingAniTimer = nil
  self.buildingAnimCameraSeq = nil
  self.worldBuilding = nil
  self.buildingAniSkillEffectsRequest = nil
  self.cameraDefaultPara = nil
  self.cameraPos1 = Vector3.New(-0.19, 19.97, -19.65)
  self._playIdleAniManager = nil
  self.rtFormat = nil
end

function UIDecorationMainCityForPreview:ReleaseTexture()
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  self.rawImage:SetTexture(nil)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UIDecorationMainCityForPreview:DataDestroy()
  self.data = nil
  self:ReleaseTexture()
  self.camera = nil
  self.citySlot = nil
  self.rawImage = nil
  self:DestroyModel()
  self:DestroyScene()
  self.rtLen = nil
  self.fov = nil
  self:ClosePlayBuildingAniTimer()
  self:CloseBuildingAnimCameraSeq()
  self.worldBuilding = nil
  self.cameraDefaultPara = nil
  self.cameraPos1 = nil
  self:DeletePlayIdleAniManager()
  self.rtFormat = nil
end

function UIDecorationMainCityForPreview:OnEnable()
  base.OnEnable(self)
  if self.scene and not IsNull(self.scene.gameObject) then
    self.scene.gameObject:SetActive(true)
  end
end

function UIDecorationMainCityForPreview:OnDisable()
  if self.scene and not IsNull(self.scene.gameObject) then
    self.scene.gameObject:SetActive(false)
  end
  base.OnDisable(self)
end

function UIDecorationMainCityForPreview:ReInit(data)
  self.data = data
  self:LoadScene()
end

function UIDecorationMainCityForPreview:ShowMainEffect(effectId)
  local req = self.request
  if not req or IsNull(req) then
    return
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(effectId)
  if template:IsDefault() then
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
        if self.effectRes.isError then
          return
        end
        self.effectRes.gameObject.transform:SetParent(self.effectParent)
        self.effectRes.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.effectRes.gameObject.transform:Set_localPosition(0, 0, 0)
      end)
    end
  end
end

function UIDecorationMainCityForPreview:RefreshView()
  self:DestroyModel()
  self:DeletePlayIdleAniManager()
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.decorationId)
  if template.type == DecorationType.DecorationType_Main_City then
    local buildModelName = self.data and self.data.original and template.model_world or nil
    if string.IsNullOrEmpty(buildModelName) then
      local modelName = DataCenter.DecorationDataManager:GetWorldBuildingSkinWithDefault(self.data.decorationId, self.data.mainLevel)
      local modelPath = UIUtil.GetFullPath("Assets/Main/Prefabs/Building/", modelName, ".prefab")
      local hasAsset = UIUtil.CheckAssetDownloaded(modelPath)
      if not hasAsset then
        buildModelName = template.model_world
        local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
        local isPrepare = infoPlayer:InPreviewMode()
        local season = isPrepare and SeasonUtil.GetSeason() + 1 or SeasonUtil.GetSeason()
        UIUtil.ShowTips(Localization:GetString("skin_preview_desc3", season))
      end
    end
    self:LoadBuild(buildModelName, function()
      self:TryLoadSeasonEffect(self.data.decorationId)
      if self.data.onLoad then
        self.data.onLoad()
      end
    end)
  elseif template.type == DecorationType.DecorationType_TittleName then
    self:LoadTitleBuild(self.data.decorationId, self.data.onLoad)
  elseif template.type == DecorationType.DecorationType_Main_Effect then
    local modelName = BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
    self:LoadBuild(modelName, function()
      self:ShowMainEffect(self.data.decorationId)
      self:TryLoadSeasonEffect()
      if self.data.onLoad then
        self.data.onLoad()
      end
    end)
  elseif template.type == DecorationType.DecorationType_TacticalWeapon then
    self:LoadDrone(template)
  end
  self:CloseBuildingAnimCameraSeq()
  self:ClosePlayBuildingAniTimer()
  self:SetCameraDefaultPos()
  self:LoadZone(self.data.zoneType)
end

function UIDecorationMainCityForPreview:LoadBuild(buildModelName, loadCallBack)
  local modelName = not string.IsNullOrEmpty(buildModelName) and buildModelName or DataCenter.DecorationDataManager:GetWorldBuildingSkinWithDefault(self.data.decorationId, self.data.mainLevel)
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
    local skinId = 0
    local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.decorationId)
    if template.type == DecorationType.DecorationType_Main_City then
      skinId = self.data.decorationId
      if self.data.colourId and 0 < self.data.colourId then
        local temp = DataCenter.DecorationDazzleManager:GetDazzleSkinTemplateById(skinId, self.data.colourId)
        if temp and 0 < temp.decoration_id_new then
          skinId = temp.decoration_id_new
        end
      end
    else
      skinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
    end
    self.worldBuilding:InitDynamicModel(skinId, function()
      local idleAniName = "idle"
      self:InitPlayIdleAniManager(skinId)
      self:PlayAnimationAndEffectReturnTime(idleAniName)
    end)
    if loadCallBack then
      loadCallBack()
    end
  end)
end

function UIDecorationMainCityForPreview:InitPlayIdleAniManager(skinId)
  local isHaveIdleDataStr = false
  local idleDataStr
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
      aniTime = self:PlayCrossFadeAnim(s, f)
      return aniTime
    end)
  else
    self:DeletePlayIdleAniManager()
  end
end

function UIDecorationMainCityForPreview:DeletePlayIdleAniManager()
  if self._playIdleAniManager ~= nil then
    self._playIdleAniManager:Delete()
    self._playIdleAniManager = nil
  end
end

function UIDecorationMainCityForPreview:TryLoadSeasonEffect(skinId)
  skinId = skinId or DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
  local seasonData = DataCenter.SeasonCallbackManager:GetConfigDataByCallbackId(SeasonCallbackType.Base, skinId)
  if seasonData then
    self.seasonEffect = SeasonCallbackEffectObj.New()
    self.seasonEffect:SetData(-1, self.request.gameObject, seasonData.callback_show_world, seasonData.callback_show_world_offset)
  end
end

function UIDecorationMainCityForPreview:LoadTitleBuild(titleSkinId, loadCallBack)
  local modelName = BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
  self:LoadBuild(modelName, function()
    self:LoadTitle(titleSkinId, loadCallBack)
    self:TryLoadSeasonEffect()
  end)
end

function UIDecorationMainCityForPreview:LoadTitle(titleSkinId, loadCallBack)
  local request = self.request
  if self.request == nil or IsNull(self.worldLabelGo) then
    return
  end
  self.worldLabelGo.gameObject:SetActive(true)
  local worldLabel = self.worldLabelGo:GetComponent(typeof(CS.UIWorldLabel))
  if worldLabel ~= nil then
    if worldLabel.SetNameBgSkin ~= nil then
      worldLabel:SetNameBgSkin(titleSkinId or self.data.decorationId)
    end
    local nameStr = self.data.name or LuaEntry.Player.name
    if not self.data.robot then
      local abbr = self.data.abbr
      if abbr == nil then
        local allianceBase = LuaEntry.Player:IsInAlliance() and DataCenter.AllianceBaseDataManager:GetAllianceBaseData() or nil
        if allianceBase then
          abbr = allianceBase.abbr
        end
      end
      if not string.IsNullOrEmpty(abbr) then
        nameStr = "[" .. abbr .. "]" .. nameStr
      end
    end
    if self.data.countryFlag == "" then
      worldLabel:ShowFlag(false)
    else
      local countryFlag = LuaEntry.Player.countryFlag or DefaultNation
      worldLabel:ShowFlag(true)
      worldLabel:SetFlag(countryFlag)
    end
    local color = CS.GameDefines.CityLabelColorType.Green
    if self.data.uid then
      color = self.data.uid == LuaEntry.Player:GetUid() and CS.GameDefines.CityLabelColorType.Green or CS.GameDefines.CityLabelColorType.White
    end
    worldLabel:SetName(nameStr, color)
    worldLabel:SetLevel(self.data.lv or LuaEntry.Player.level)
  else
    local levelLabel = request.gameObject.transform:Find("ModelGo/CityLabel/LevelLabel/LevelText"):GetComponent((typeof(CS.SuperTextMesh)))
    local nameLabel = request.gameObject.transform:Find("ModelGo/CityLabel/NameLabel/NameText"):GetComponent((typeof(CS.SuperTextMesh)))
    local nameLabelBg = request.gameObject.transform:Find("ModelGo/CityLabel/NameLabel"):GetComponent((typeof(CS.UnityEngine.SpriteRenderer)))
    local flag = request.gameObject.transform:Find("ModelGo/CityLabel/NameLabel/Flag")
    if flag ~= nil then
      flag.gameObject:SetActive(false)
    end
    if levelLabel then
      levelLabel.text = tostring(self.data.lv or LuaEntry.Player.level)
    end
    if nameLabel then
      nameLabel.text = self.data.name or LuaEntry.Player.name
      nameLabel.color32 = WorldGreenColor32
      nameLabelBg.size = Vector2.New(1.6, nameLabelBg.size.y)
    end
    if nameLabelBg then
      local template = DataCenter.DecorationTemplateManager:GetTemplate(titleSkinId or self.data.decorationId)
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
  if loadCallBack then
    loadCallBack()
  end
end

function UIDecorationMainCityForPreview:LoadDrone(template)
  if template.appearance == nil then
    Logger.LogError("Drone appearance is nil for decorationId:" .. template.id)
    return
  end
  local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(template.appearance)
  if appearanceTemplate == nil then
    Logger.LogError("Appearance template is nil for decorationId:" .. template.id)
    return
  end
  local modelPath = appearanceTemplate.world_model_path
  if string.IsNullOrEmpty(modelPath) then
    Logger.LogError("Model path is nil or empty for decorationId:" .. template.id)
    return
  end
  self.request = ResourceManager:InstantiateAsync(modelPath)
  self.request:completed("+", function(go)
    if go.isError then
      return
    end
    local droneObj = go.gameObject
    droneObj.transform:SetParent(self.citySlot.transform)
    droneObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    droneObj.transform:Set_localPosition(0, 0, 0)
    droneObj.transform:Set_localEulerAngles(0, 225, 0)
    local animator = droneObj:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if not IsNull(animator) then
      animator:Play(AnimName.Idle)
    end
  end)
end

function UIDecorationMainCityForPreview:LoadZone(zoneType)
  if zoneType == nil then
    return
  end
  if zoneType == MainCityPreviewZoneType.City then
    self.zoneCityTypeRequest = ResourceManager:InstantiateAsync(UIAssets.UIDecorationCityZone)
    self.zoneCityTypeRequest:completed("+", function(request)
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(self.citySlot.transform)
      request.gameObject.transform:Set_localScale(50, ResetScale.y, 50)
      request.gameObject.transform:Set_localPosition(0, -0.1, 0)
    end)
  elseif zoneType == MainCityPreviewZoneType.World then
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
end

function UIDecorationMainCityForPreview:DestroyModel()
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
  if self.seasonEffect then
    self.seasonEffect:Delete()
    self.seasonEffect = nil
  end
  if self.request ~= nil then
    self.request:Destroy()
    self.request = nil
  end
  if self.zoneWorldTypeRequest ~= nil then
    self.zoneWorldTypeRequest:Destroy()
    self.zoneWorldTypeRequest = nil
  end
  if self.zoneCityTypeRequest ~= nil then
    self.zoneCityTypeRequest:Destroy()
    self.zoneCityTypeRequest = nil
  end
  self:ClearBuildingAniSkillEffectRequest()
end

function UIDecorationMainCityForPreview:OnRenderTexture(camera)
  if camera == nil then
    Logger.LogError(" OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local scale = 1
    if not GameQualitySettings.IsHighGearQuality() then
      scale = 0.5
    end
    local rtWidth = self.rtLen * scale
    local rtHeight = self.rtLen * scale
    local rtFormat = self.rtFormat or RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "CityShow"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    if self.rawImage ~= nil then
      self.rawImage:SetColorRGBA(1, 1, 1, 1)
    end
  end
  camera.fieldOfView = self.fov
  camera.targetTexture = self.renderTexture
end

function UIDecorationMainCityForPreview:LoadScene()
  if self.scene == nil then
    self.scene = ResourceManager:InstantiateAsync(UIAssets.UIDecorationWorldScene)
    self.scene:completed("+", function()
      if self.scene.isError then
        return
      end
      self.scene.gameObject.name = "UIDecorationWorldScene_" .. (self.data.uid or self.data.decorationId)
      self.scene.gameObject:SetActive(true)
      self.scene.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local offSet = 0
      if self.data.uid then
        local side = self.data.side
        if side ~= nil and side ~= 0 then
          offSet = side == 1 and 100 or -100
        else
          offSet = self.data.uid == LuaEntry.Player:GetUid() and 100 or -100
        end
      end
      local pos = DecorationUtil.GetWorldPosNegativeNumber(self.data.posIndex)
      pos.x = pos.x + offSet
      self.scene.gameObject.transform.position = pos
      self.camera = self.scene.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
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

function UIDecorationMainCityForPreview:DestroyScene()
  if self.scene ~= nil then
    self.scene:Destroy()
    self.scene = nil
  end
end

function UIDecorationMainCityForPreview:SetRTLen(len)
  self.rtLen = len
end

function UIDecorationMainCityForPreview:ClosePlayBuildingAniTimer()
  if self.buildingAniTimer ~= nil then
    self.buildingAniTimer:Stop()
  end
  self.buildingAniTimer = nil
end

function UIDecorationMainCityForPreview:CloseBuildingAnimCameraSeq()
  if self.buildingAnimCameraSeq ~= nil then
    self.buildingAnimCameraSeq:Kill()
    self.buildingAnimCameraSeq = nil
  end
end

function UIDecorationMainCityForPreview:SetCameraDefaultPos()
  self:CloseBuildingAnimCameraSeq()
  if self.cameraDefaultPara ~= nil and self.data ~= nil and self.data.decorationId ~= nil then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.decorationId)
    if template then
      if template.type == DecorationType.DecorationType_Main_Effect then
        self.camera.transform.localPosition = self.cameraPos1
      else
        self.camera.transform.position = self.cameraDefaultPara.transform.position
      end
    end
  end
end

function UIDecorationMainCityForPreview:GetCameraTargetPos(height)
  local pos = self.cameraDefaultPara.transform.localPosition
  if height > pos.y then
    local curY = pos.y
    local curZ = pos.z
    pos.y = height
    pos.z = height / curY * curZ
  end
  return pos
end

function UIDecorationMainCityForPreview:PlayAnimation(animName, crossTime)
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

function UIDecorationMainCityForPreview:TryPlaySkillShow(skillId)
  local skillTemp = DataCenter.DecorationSkillTemplateManager:GetTemplate(skillId)
  if not skillTemp then
    return
  end
  local act_para = skillTemp.act_para
  if act_para <= 0 then
    return
  end
  local meta = LocalController:instance():getLine(TableName.StatusTab, tostring(act_para))
  if not meta then
    return
  end
  local skillTime = meta.time
  local para1 = meta.para1
  local actData = string.split(para1, "|")
  local camera_height = skillTemp.camera_height
  local aniName = ""
  if #actData == 3 then
    aniName = actData[2]
  elseif #actData == 2 then
    aniName = actData[1]
  end
  self:SetCameraDefaultPos()
  local targetPos = self:GetCameraTargetPos(camera_height / 5)
  self:CloseBuildingAnimCameraSeq()
  self:ClosePlayBuildingAniTimer()
  self:ClearBuildingAniSkillEffectRequest()
  self.buildingAnimCameraSeq = DOTween.Sequence()
  self.buildingAnimCameraSeq:Append(self.camera.transform:DOLocalMove(targetPos, 0.2):SetEase(CS.DG.Tweening.Ease.Linear))
  self.buildingAnimCameraSeq:OnComplete(function()
    self:CloseBuildingAnimCameraSeq()
  end)
  local effectPathList = skillTemp:GetSkillEffectList()
  if not table.IsNullOrEmpty(effectPathList) then
    local index = 1
    self.buildingAniSkillEffectsRequest = {}
    for _, effect in ipairs(effectPathList) do
      local buildingAniSkillEffectRequest = ResourceManager:InstantiateAsync(effect[1])
      if buildingAniSkillEffectRequest then
        buildingAniSkillEffectRequest:completed("+", function(request)
          if request.isError then
            return
          end
          request.gameObject:SetActive(true)
          request.gameObject.transform:SetParent(self.citySlot.transform)
          request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          request.gameObject.transform:Set_localPosition(0, 0, 0)
        end)
        self.buildingAniSkillEffectsRequest[index] = buildingAniSkillEffectRequest
        index = index + 1
      end
    end
  end
  self:PlayAnimationAndEffectReturnTime(aniName)
  self.buildingAniTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ClosePlayBuildingAniTimer()
    self:ClearBuildingAniSkillEffectRequest()
    self:PlayAnimationAndEffectReturnTime("idle")
    self:CloseBuildingAnimCameraSeq()
    self.buildingAnimCameraSeq = DOTween.Sequence()
    self.buildingAnimCameraSeq:Append(self.camera.transform:DOMove(self.cameraDefaultPara.transform.position, 0.2):SetEase(CS.DG.Tweening.Ease.Linear))
    self.buildingAnimCameraSeq:OnComplete(function()
      self:CloseBuildingAnimCameraSeq()
    end)
  end, skillTime)
end

function UIDecorationMainCityForPreview:ClearBuildingAniSkillEffectRequest()
  if self.buildingAniSkillEffectsRequest ~= nil then
    for i, v in ipairs(self.buildingAniSkillEffectsRequest) do
      v:Destroy()
    end
    self.buildingAniSkillEffectsRequest = nil
  end
end

function UIDecorationMainCityForPreview:GetAniTime(animName)
  local time = 0
  if string.IsNullOrEmpty(animName) then
    return time
  end
  if not IsNull(self.worldBuilding) then
    time = self.worldBuilding:GetAnimationLength(animName)
  end
  return time
end

function UIDecorationMainCityForPreview:Update()
  if self._playIdleAniManager ~= nil then
    self._playIdleAniManager:OnUpdate()
  end
end

function UIDecorationMainCityForPreview:PlayCrossFadeAnim(animName, crossTime)
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

function UIDecorationMainCityForPreview:PlayAnimationAndEffectReturnTime(animName)
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
    if isBreakIdle and isBreakIdleNeeedCross and crossTime == 0 then
      crossTime = 0.2
    end
    self:PlayAnimation(animName, crossTime)
  end
end

function UIDecorationMainCityForPreview:SetRtFormat(format)
  self.rtFormat = format
end

return UIDecorationMainCityForPreview
