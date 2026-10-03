local UIDecorationMainCity = BaseClass("UIDecorationMainCity", UIBaseContainer)
local UIDecorationMainCityPlayIdleAniManager = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCityPlayIdleAniManager")
local Localization = CS.GameEntry.Localization
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local GameQualitySettings = require("Util.GameQualitySettings")
local effectPath = "Assets/Main/Prefabs/BuildEffect/MainBuild/%s.prefab"
local Terrain_World0_High = "Assets/Main/Prefabs/World/Terrain_0_High.prefab"
local WorldBuilding = CS.WorldBuilding
local btn_gm_select_path = "BtnGMSelect"
local BODY_RT_PATH = "Assets/Main/TMPFont/Main/BodyFontMat/Body-RT.mat"

function UIDecorationMainCity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationMainCity:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationMainCity:ComponentDefine()
  self.rawImage = self:AddComponent(UIRawImage, "")
  if self.rawImage ~= nil then
    self.rawImage:SetColorRGBA(1, 1, 1, 0)
  end
  local tranGM = self.transform:Find(btn_gm_select_path)
  if tranGM then
    self.btnGm = self:AddComponent(UIButton, tranGM.gameObject)
    self.btnGm:SetOnClick(function()
      self:ClickGMBtn()
    end)
    if self.btnGm then
      self.btnGm:SetActive(false)
    end
  end
end

function UIDecorationMainCity:ComponentDestroy()
  self.rawImage = nil
end

function UIDecorationMainCity:DataDefine()
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
  self._playIdleAniManager = nil
end

function UIDecorationMainCity:ReleaseTexture()
  self.rtFormat = nil
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  self.rawImage:SetTexture(nil)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UIDecorationMainCity:DataDestroy()
  self.data = nil
  self.templateType = nil
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
  self:DeletePlayIdleAniManager()
end

function UIDecorationMainCity:OnEnable()
  base.OnEnable(self)
  if self.scene and not IsNull(self.scene.gameObject) then
    self.scene.gameObject:SetActive(true)
  end
end

function UIDecorationMainCity:OnDisable()
  if self.scene and not IsNull(self.scene.gameObject) then
    self.scene.gameObject:SetActive(false)
  end
  base.OnDisable(self)
end

function UIDecorationMainCity:ReInit(data)
  self.data = data
  self:LoadScene()
end

function UIDecorationMainCity:SetRtFormat(format)
  self.rtFormat = format
end

function UIDecorationMainCity:SetRawDefRGBA(r, g, b, a)
  if self.renderTexture == nil and self.rawImage ~= nil then
    self.rawImage:SetColorRGBA(r, g, b, a)
  end
end

function UIDecorationMainCity:ShowMainEffect(effectId)
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

function UIDecorationMainCity:RefreshView()
  self:DestroyModel()
  self:DeletePlayIdleAniManager()
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.decorationId)
  if not template or not template.type then
    return
  end
  self.templateType = template.type
  if template.type == DecorationType.DecorationType_Main_City then
    self:LoadBuild(nil, function()
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
  end
  self:CloseBuildingAnimCameraSeq()
  self:ClosePlayBuildingAniTimer()
  self:SetCameraDefaultPos()
  self:LoadZone(self.data.zoneType)
  self:RefreshGMBtnState()
end

function UIDecorationMainCity:LoadBuild(buildModelName, loadCallBack)
  local lv = self.data.mainLevel or self.data.lv or LuaEntry.Player.level
  local modelName = buildModelName
  if string.IsNullOrEmpty(modelName) then
    modelName = DataCenter.DecorationDataManager:GetWorldBuildingSkinWithDefault(self.data.decorationId, lv, true)
  end
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

function UIDecorationMainCity:InitPlayIdleAniManager(skinId)
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

function UIDecorationMainCity:DeletePlayIdleAniManager()
  if self._playIdleAniManager ~= nil then
    self._playIdleAniManager:Delete()
    self._playIdleAniManager = nil
  end
end

function UIDecorationMainCity:TryLoadSeasonEffect(skinId)
  skinId = skinId or DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
  local seasonData = DataCenter.SeasonCallbackManager:GetConfigDataByCallbackId(SeasonCallbackType.Base, skinId)
  if seasonData then
    local SeasonCallbackEffectObj = require("DataCenter.SeasonCallback.SeasonCallbackEffectObj")
    self.seasonEffect = SeasonCallbackEffectObj.New()
    self.seasonEffect:SetData(-1, self.request.gameObject, seasonData.callback_show_world, seasonData.callback_show_world_offset)
  end
end

function UIDecorationMainCity:LoadTitleBuild(titleSkinId, loadCallBack)
  local modelName = BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
  self:LoadBuild(modelName, function()
    self:LoadTitle(titleSkinId, loadCallBack)
    self:TryLoadSeasonEffect()
  end)
end

function UIDecorationMainCity:LoadTitle(titleSkinId, loadCallBack)
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
    UIManager:GetInstance():SetNewTMProFontMaterial(BODY_RT_PATH, function(newMat)
      if IsNotNull(worldLabel) then
        worldLabel:SetNameMaterial(newMat)
      end
    end)
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

function UIDecorationMainCity:LoadZone(zoneType)
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

function UIDecorationMainCity:DestroyModel()
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

function UIDecorationMainCity:OnRenderTexture(camera)
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

function UIDecorationMainCity:LoadScene()
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
      self:SetActive(true)
      self:RefreshView()
    end)
  elseif self.camera ~= nil then
    self:RefreshView()
  end
end

function UIDecorationMainCity:DestroyScene()
  if self.scene ~= nil then
    self.scene:Destroy()
    self.scene = nil
  end
end

function UIDecorationMainCity:SetRTLen(len)
  self.rtLen = len
end

function UIDecorationMainCity:SetFov(fov)
  self.fov = fov
end

function UIDecorationMainCity:ClosePlayBuildingAniTimer()
  if self.buildingAniTimer ~= nil then
    self.buildingAniTimer:Stop()
  end
  self.buildingAniTimer = nil
end

function UIDecorationMainCity:CloseBuildingAnimCameraSeq()
  if self.buildingAnimCameraSeq ~= nil then
    self.buildingAnimCameraSeq:Kill()
    self.buildingAnimCameraSeq = nil
  end
end

function UIDecorationMainCity:SetCameraDefaultPos()
  self:CloseBuildingAnimCameraSeq()
  if self.cameraDefaultPara ~= nil then
    local localPosition = self.cameraDefaultPara.transform.localPosition
    if self.data.cameraY then
      localPosition.y = self.data.cameraY
    end
    self.camera.transform.localPosition = localPosition
  end
end

function UIDecorationMainCity:GetCameraTargetPos(height)
  local pos = self.cameraDefaultPara.transform.localPosition
  if height > pos.y then
    local curY = pos.y
    local curZ = pos.z
    pos.y = height
    pos.z = height / curY * curZ
  end
  return pos
end

function UIDecorationMainCity:PlayAnimation(animName, crossTime)
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

function UIDecorationMainCity:TryPlaySkillShow(skillId)
  if skillId <= 0 then
    return
  end
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

function UIDecorationMainCity:ClearBuildingAniSkillEffectRequest()
  if self.buildingAniSkillEffectsRequest ~= nil then
    for i, v in ipairs(self.buildingAniSkillEffectsRequest) do
      v:Destroy()
    end
    self.buildingAniSkillEffectsRequest = nil
  end
end

function UIDecorationMainCity:GetAniTime(animName)
  local time = 0
  if string.IsNullOrEmpty(animName) then
    return time
  end
  if not IsNull(self.worldBuilding) then
    time = self.worldBuilding:GetAnimationLength(animName)
  end
  return time
end

function UIDecorationMainCity:Update()
  if self._playIdleAniManager ~= nil then
    self._playIdleAniManager:OnUpdate()
  end
end

function UIDecorationMainCity:PlayCrossFadeAnim(animName, crossTime)
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

function UIDecorationMainCity:PlayAnimationAndEffectReturnTime(animName)
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

function UIDecorationMainCity:ClickGMBtn()
  if not GMUtils.IsGM() then
    self.btnGm:SetActive(false)
    return
  end
  if not self.templateType or not self.data then
    return
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.decorationId)
  local name = Localization:GetString(template and template.name)
  if self.templateType == DecorationType.DecorationType_Main_City then
    UIUtil.ShowTips(string.format("[Debug\232\176\131\232\175\149]\n\230\137\128\230\156\137\231\142\169\229\174\182\229\159\186\229\156\176\231\154\174\232\130\164\233\131\189\229\176\134\230\152\190\231\164\186\228\184\186:\n%s", name))
    GMUtils.SetInt(GMConst.DebugBuildSkinID, self.data.decorationId)
  elseif self.templateType == DecorationType.DecorationType_Main_Effect then
    UIUtil.ShowTips(string.format("[Debug\232\176\131\232\175\149]\n\230\137\128\230\156\137\231\142\169\229\174\182\229\159\186\229\156\176\231\137\185\230\149\136\233\131\189\229\176\134\230\152\190\231\164\186\230\136\144:\n%s", name))
    GMUtils.SetInt(GMConst.DebugBuildSkinEffId, self.data.decorationId)
  end
end

function UIDecorationMainCity:RefreshGMBtnState()
  if not self.btnGm then
    return
  end
  local showGMBtn = false
  if GMUtils.IsGM() and self.templateType then
    showGMBtn = self.templateType == DecorationType.DecorationType_Main_City or self.templateType == DecorationType.DecorationType_Main_Effect
  end
  self.btnGm:SetActive(showGMBtn)
end

return UIDecorationMainCity
