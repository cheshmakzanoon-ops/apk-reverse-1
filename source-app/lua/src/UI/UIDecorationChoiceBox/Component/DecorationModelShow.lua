local DecorationModelShow = BaseClass("DecorationModelShow", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local Animator = CS.UnityEngine.Animator
local SimpleAnimation = CS.SimpleAnimation
local WorldBuildingAniEffect = CS.WorldBuildingAniEffect
local WorldBuildingAniEffectAni = CS.WorldBuildingAniEffectAni
local WorldBuilding = CS.WorldBuilding
local effectPath = "Assets/Main/Prefabs/BuildEffect/MainBuild/%s.prefab"

function DecorationModelShow:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DecorationModelShow:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DecorationModelShow:ComponentDefine()
  self.rawImage = self:AddComponent(UIRawImage, "")
end

function DecorationModelShow:ComponentDestroy()
  self.rawImage = nil
end

function DecorationModelShow:DataDefine()
  self.renderTextureSizeX = 100
  self.renderTextureSizeY = 100
  self.data = {}
  self.cameraPos = nil
  self.camera = nil
  self.citySlot = nil
  self.cameraDefaultPara = nil
  self.buildingAniDataIndex = nil
  self.buildingAniCurIndexNum = nil
  self.buildingAniTimer = nil
  self.worldBuilding = nil
end

function DecorationModelShow:DataDestroy()
  self.renderTextureSizeX = nil
  self.renderTextureSizeY = nil
  self.data = {}
  self.cameraPos = nil
  self:EndShow()
end

function DecorationModelShow:ReleaseTexture()
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

function DecorationModelShow:StartShow(renderTextureSizeX, renderTextureSizeY)
  if renderTextureSizeX then
    self.renderTextureSizeX = renderTextureSizeX
    self.renderTextureSizeY = renderTextureSizeX
    if renderTextureSizeY then
      self.renderTextureSizeY = renderTextureSizeY
    end
  end
  self.rawImage:SetActive(false)
  self:LoadScene()
end

function DecorationModelShow:EndShow()
  self:ReleaseTexture()
  self.camera = nil
  self.citySlot = nil
  self.cameraDefaultPara = nil
  self:DestroyModel()
  self:DestroyScene()
  self.rawImage:SetActive(false)
  self:ClosePlayBuildingAniTimer()
  self.buildingAniDataIndex = nil
  self.buildingAniCurIndexNum = nil
  self.worldBuilding = nil
end

function DecorationModelShow:SetData(data)
  self.data = data
  if self.scene ~= nil and self.camera ~= nil then
    self:RefreshView()
  end
end

local DecorationModelShowSceneIndex = {}
for i = 3, 20 do
  table.insert(DecorationModelShowSceneIndex, i)
end

function DecorationModelShow.GetAvailableSceneIndex()
  if #DecorationModelShowSceneIndex == 0 then
    return 0
  end
  local index = DecorationModelShowSceneIndex[1]
  table.remove(DecorationModelShowSceneIndex, 1)
  return index
end

function DecorationModelShow.ReturnSceneIndex(index)
  if index == 0 then
    return
  end
  table.insert(DecorationModelShowSceneIndex, index)
end

function DecorationModelShow:LoadScene()
  if self.scene == nil then
    local index = DecorationModelShow.GetAvailableSceneIndex()
    self.sceneIndex = index
    self.scene = ResourceManager:InstantiateAsync(UIAssets.UIDecorationWorldScene)
    self.scene:completed("+", function()
      if self.scene.isError then
        return
      end
      self.scene.gameObject:SetActive(true)
      self.scene.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.scene.gameObject.transform.position = DecorationUtil.GetWorldPosNegativeNumber(self.sceneIndex)
      self.camera = self.scene.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
      self.citySlot = self.scene.gameObject.transform:Find("CitySlot")
      self.cameraDefaultPara = self.scene.gameObject.transform:Find("CameraDefaultPara")
      self:OnRenderTexture(self.camera)
      self:RefreshView()
      self.rawImage:SetActive(true)
    end)
  elseif self.camera ~= nil then
    self:RefreshView()
    self.rawImage:SetActive(true)
  end
end

function DecorationModelShow:DestroyScene()
  if self.scene ~= nil then
    self.scene:Destroy()
    self.scene = nil
  end
  if self.sceneIndex then
    DecorationModelShow.ReturnSceneIndex(self.sceneIndex)
    self.sceneIndex = nil
  end
end

function DecorationModelShow:RefreshView()
  self:DestroyModel()
  if self.data == nil then
    return
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.decorationId)
  if template == nil then
    return
  end
  if template.type == DecorationType.DecorationType_Main_City then
    self:LoadBuild()
  elseif template.type == DecorationType.DecorationType_TittleName then
    self:LoadTitleBuild(template.img)
  elseif template.type == DecorationType.DecorationType_Main_Effect then
    self:LoadBuild(function(req)
      self:ShowMainEffect(req)
    end)
  end
  if self.cameraPos then
    self.camera.transform.localPosition = self.cameraPos
  elseif not IsNull(self.cameraDefaultPara) then
    self.camera.transform.position = self.cameraDefaultPara.transform.position
  end
end

function DecorationModelShow:ShowMainEffect(req)
  if not req or IsNull(req) then
    return
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.decorationId)
  if template:IsDefault() then
    return
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

function DecorationModelShow:LoadBuild(loadCallBack)
  local decorationId = self:GetBuildingDecorationId()
  local modelName = DataCenter.DecorationDataManager:GetWorldBuildingSkinWithDefault(decorationId, self.data.mainLevel)
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
    if loadCallBack then
      loadCallBack(request)
    end
    self:TryPlayBuildingAni()
  end)
end

function DecorationModelShow:LoadTitleBuild(icon)
  local modelName = BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/Building/" .. modelName .. ".prefab")
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
    local iconNode = transform:Find("Icon")
    if not IsNull(iconNode) then
      iconNode.gameObject:SetActive(false)
    end
    local icon2 = transform:Find("Icon2")
    if not IsNull(icon2) then
      icon2.gameObject:SetActive(false)
    end
    self.worldLabelGo = request.gameObject.transform:Find("ModelGo/CityLabel")
    if not IsNull(self.worldLabelGo) then
      self.worldLabelGo.gameObject:SetActive(true)
      local worldLabel = self.worldLabelGo:GetComponent(typeof(CS.UIWorldLabel))
      if worldLabel ~= nil then
        if worldLabel.SetNameBgSkin ~= nil then
          worldLabel:SetNameBgSkin(self.data.decorationId)
        end
        local nameStr = LuaEntry.Player.name
        if LuaEntry.Player:IsInAlliance() then
          local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
          if allianceBase then
            nameStr = "[" .. allianceBase.abbr .. "]" .. LuaEntry.Player.name
          end
        end
        local countryFlag = LuaEntry.Player.countryFlag or DefaultNation
        worldLabel:ShowFlag(true)
        worldLabel:SetFlag(countryFlag)
        worldLabel:SetName(nameStr, WorldGreenColor)
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
          nameLabelBg:LoadSprite(icon)
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
  end)
end

function DecorationModelShow:DestroyModel()
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
end

function DecorationModelShow:OnRenderTexture(camera)
  if camera == nil then
    Logger.LogError(" OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local scale = 1
    local rtWidth = self.renderTextureSizeX * scale
    local rtHeight = self.renderTextureSizeY * scale
    local rtFormat = self.rtFormat or RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "CityShow"
    self.rawImage:SetTexture(self.renderTexture)
  end
  camera.targetTexture = self.renderTexture
end

function DecorationModelShow:ClosePlayBuildingAniTimer()
  if self.buildingAniTimer ~= nil then
    self.buildingAniTimer:Stop()
  end
  self.buildingAniTimer = nil
end

function DecorationModelShow:GetBuildingDecorationId()
  if self.data == nil then
    return
  end
  local decorationId = self.data.decorationId
  if self.data.mainCitySkinId then
    decorationId = self.data.mainCitySkinId
  end
  return decorationId
end

function DecorationModelShow:TryPlayBuildingAni()
  if self.data == nil then
    return
  end
  local decorationId = self:GetBuildingDecorationId()
  local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
  if template == nil then
    return
  end
  if template.type ~= DecorationType.DecorationType_Main_City and template.type ~= DecorationType.DecorationType_Dazzle then
    return
  end
  self.worldBuilding = self.request.gameObject.transform:GetComponentInChildren(typeof(WorldBuilding))
  if IsNull(self.worldBuilding) then
    return
  end
  self.worldBuilding:InitDynamicModel(decorationId, function()
    if self.data.decorationAniList == nil or #self.data.decorationAniList == 0 then
      self:ClosePlayBuildingAniTimer()
      local aniTime = self.worldBuilding:GetCurIdleAniTIme()
      if 0 < aniTime then
        self.buildingAniTimer = TimerManager:GetInstance():DelayInvoke(function()
          self:ClosePlayBuildingAniTimer()
          self:TryPlayNextIdleAni()
        end, aniTime)
      end
    else
      self.buildingAniDataIndex = 0
      self.buildingAniCurIndexNum = 0
      self:TryPlayNextBuildingAni()
    end
  end)
end

function DecorationModelShow:TryPlayNextIdleAni()
  self:ClosePlayBuildingAniTimer()
  self.worldBuilding:SetIdleAniManagerTryToNextAni()
  local aniTime = self.worldBuilding:GetCurIdleAniTIme()
  if 0 < aniTime then
    self.buildingAniTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:ClosePlayBuildingAniTimer()
      self:TryPlayNextIdleAni()
    end, aniTime)
  end
end

function DecorationModelShow:TryPlayNextBuildingAni()
  self:ClosePlayBuildingAniTimer()
  self.buildingAniCurIndexNum = self.buildingAniCurIndexNum + 1
  local aniList = self.data.decorationAniList
  local aniListLen = #aniList
  local curAniDataIndex = self.buildingAniDataIndex % aniListLen + 1
  local curAniData = aniList[curAniDataIndex]
  local aniName = curAniData[1]
  local aniNum = curAniData[2]
  if aniNum <= 0 then
    return
  end
  if aniNum < self.buildingAniCurIndexNum then
    self.buildingAniDataIndex = self.buildingAniDataIndex + 1
    self.buildingAniCurIndexNum = 1
    curAniDataIndex = self.buildingAniDataIndex % aniListLen + 1
    curAniData = aniList[curAniDataIndex]
    aniName = curAniData[1]
    aniNum = curAniData[2]
    if aniNum <= 0 then
      return
    end
  end
  local aniTime = self:GetAniTime(aniName)
  if aniTime <= 0 then
    return
  end
  self:PlayAnimation(aniName)
  self.buildingAniTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ClosePlayBuildingAniTimer()
    self:TryPlayNextBuildingAni()
  end, aniTime)
end

function DecorationModelShow:GetAniTime(animName)
  local time = 0
  if string.IsNullOrEmpty(animName) then
    return time
  end
  if not IsNull(self.worldBuilding) then
    time = self.worldBuilding:GetAnimationLength(animName)
  end
  return time
end

function DecorationModelShow:PlayAnimation(animName)
  if string.IsNullOrEmpty(animName) then
    return
  end
  if not IsNull(self.worldBuilding) then
    self.worldBuilding:PlayAnimationAndEffectReturnTime(animName)
  end
end

function DecorationModelShow:SetCameraPos(cameraPos)
  self.cameraPos = cameraPos
end

function DecorationModelShow:SetRtFormat(format)
  self.rtFormat = format
end

return DecorationModelShow
