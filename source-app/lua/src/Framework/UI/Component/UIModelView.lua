local UIModelView = BaseClass("UIModelView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIModelView:OnCreate(enableTouch)
  base.OnCreate(self)
  self.rawImage = self:AddComponent(UIRawImage, "")
  self:SetTouchEnable(enableTouch)
end

function UIModelView:OnDestroy()
  self:Clear()
  self:SetEnable(false)
  self.rawImage:SetTexture(nil)
  RTManager:GetInstance():RecycleCtrl(self.ctrl)
  self.ctrl = nil
  base.OnDestroy(self)
end

function UIModelView:OnEnable()
  base.OnEnable(self)
  if self.ctrl then
    self.ctrl:Show()
  end
  DataCenter.CityLightManager:AddDeactiveRef()
  self:SetQuality(true)
end

function UIModelView:OnDisable()
  if self.ctrl then
    self.ctrl:Hide()
  end
  self:SetQuality(false)
  DataCenter.CityLightManager:DecreaseDeactiveRef()
  base.OnDisable(self)
end

function UIModelView:ReInit(path, clearCache, customCamera)
  if self.ctrl == nil then
    self.ctrl = RTManager:GetInstance():GetCtrl()
  end
  if not self.ctrl then
    return
  end
  if clearCache == true then
    self:Clear()
  end
  if customCamera then
    self.ctrl:SetCustomCamera(customCamera)
  end
  local param = {}
  param.scenePath = path
  param.sceneParam = {
    resPos = self.defaultScenePos,
    resAngles = self.defaultSceneAngles,
    resScale = self.defaultSceneScale
  }
  param.texParam = {
    rtFormat = self.rtFormat,
    containerWidth = self.rawImage.rectTransform.rect.width,
    containerHeight = self.rawImage.rectTransform.rect.height,
    containerAnchorMin = self.rawImage:GetAnchorMin(),
    containerAnchorMax = self.rawImage:GetAnchorMax()
  }
  
  function param.onRenderHandler(renderTexture)
    self:SetEnable(true)
    self.rawImage:SetTexture(renderTexture)
    if self.onRenderHandler then
      self.onRenderHandler()
    end
  end
  
  function param.onLoadSceneHandler(success)
    if self.onLoadSceneHandler then
      self:onLoadSceneHandler(success)
    end
  end
  
  self.ctrl:Init(param)
  self.ctrl:LoadScene()
  self.ctrl:Show()
end

function UIModelView:Clear()
  self:ClearTouch()
  self.lastLoadPath = nil
  self.modelSimpleAnimation = nil
  self.modelAnimator = nil
  self.onRenderHandler = nil
  self.onLoadSceneHandler = nil
  self.defaultScenePos = nil
  self.defaultSceneAngles = nil
  self.defaultSceneScale = nil
  self.rtFormat = nil
end

function UIModelView:SetEnable(enable)
  if self.rawImage then
    self.rawImage:SetEnable(enable)
  end
end

function UIModelView:ChangeModel(path, onModelLoadComplete)
  if not self.ctrl then
    return
  end
  if self.lastLoadPath and self.lastLoadPath == path then
    return
  end
  self.lastLoadPath = path
  self.ctrl:ChangeModel(path, function(status, model)
    if status then
      self.modelSimpleAnimation = model:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      if self.modelSimpleAnimation == nil then
        Logger.LogError("SimpleAnimation not find on model")
      end
    end
    if onModelLoadComplete then
      onModelLoadComplete(status, model)
    end
  end)
end

function UIModelView:ChangeNodeChild(nodePath, resPath, onLoadCompleteHandler)
  if not self.ctrl then
    return
  end
  self.ctrl:ChangeNodeChild(nodePath, resPath, onLoadCompleteHandler)
end

function UIModelView:AddNodeChild(nodePath, resPath, onLoadCompleteHandler, instanceId)
  if not self.ctrl then
    return
  end
  return self.ctrl:AddPrefab(resPath, nodePath, onLoadCompleteHandler, instanceId)
end

function UIModelView:RemoveNodeChild(instanceId)
  if not self.ctrl then
    return false
  end
  return self.ctrl:RemovePrefab(instanceId)
end

function UIModelView:SetDefaultSceneTrans(pos, angles, scale)
  self.defaultScenePos = pos
  self.defaultSceneAngles = angles
  self.defaultSceneScale = scale
end

function UIModelView:SetOnLoadSceneHandler(callback)
  self.onLoadSceneHandler = callback
end

function UIModelView:SetOnRenderHandler(callback)
  self.onRenderHandler = callback
end

function UIModelView:SetRTSize(width, height)
end

function UIModelView:SetRTFormat(format)
  self.rtFormat = format or RenderTextureFormat.ARGB32
end

function UIModelView:GetSceneRoot()
  if self.ctrl then
    return self.ctrl:GetSceneRoot()
  end
end

function UIModelView:GetSceneNode(path)
  if self.ctrl then
    return self.ctrl:GetSceneNode(path)
  end
end

function UIModelView:IsSceneLoaded(path)
  if self.ctrl then
    return self.ctrl:IsSceneLoaded(path)
  end
  return false
end

function UIModelView:GetRenderCamera()
  if self.ctrl then
    return self.ctrl:GetRenderCamera()
  end
end

function UIModelView:GetAniCpt(path)
  if not self.ctrl then
    Logger.LogError("UIModelView:GetAniCpt not init")
    return
  end
  local node = self:GetSceneNode(path)
  if not node then
    Logger.LogError("UIModelView:GetAniCpt not find node:" .. path)
    return
  end
  local aniCpt = node:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not aniCpt then
    Logger.LogError("UIModelView:GetAniCpt not find aniCpt:" .. path)
    return
  end
  return aniCpt
end

function UIModelView:PlayDefault()
  if self.modelSimpleAnimation then
    self.modelSimpleAnimation:Play()
  end
end

function UIModelView:PlayAni(aniKey)
  if self.modelSimpleAnimation then
    self.modelSimpleAnimation:Play(aniKey)
  end
end

function UIModelView:PlayAniQueued(aniKey)
  if self.modelSimpleAnimation then
    self.modelSimpleAnimation:PlayQueued(aniKey)
  end
end

function UIModelView:IsPlaying(aniKey)
  if self.modelSimpleAnimation then
    return self.modelSimpleAnimation:isPlaying(aniKey)
  end
end

function UIModelView:Rewind(aniKey)
  if self.modelSimpleAnimation then
    return self.modelSimpleAnimation:Rewind(aniKey)
  end
end

function UIModelView:SetTouchEnable(enable)
  if enable == true and not self.event_trigger then
    self.event_trigger = self:AddComponent(UIEventTrigger, "")
    self.event_trigger:OnBeginDrag(function(eventData)
      self:OnBeginDrag(eventData)
    end)
    self.event_trigger:OnDrag(function(eventData)
      self:OnDrag(eventData)
    end)
    self.event_trigger:OnEndDrag(function(eventData)
      self:OnEndDrag(eventData)
    end)
  elseif enable == nil then
    enable = false
  end
  self.enableTouch = enable
end

function UIModelView:SetBeginDragHandler(callback)
  self.onBeginDragHandler = callback
end

function UIModelView:SetEndDragHandler(callback)
  self.onEndDragHandler = callback
end

function UIModelView:OnBeginDrag(eventData)
  if not self.enableTouch then
    return
  end
  self.lastDragPosX = eventData.position.x
  if self.onBeginDragHandler ~= nil then
    self.onBeginDragHandler()
  end
  self.dragging = true
end

function UIModelView:OnDrag(eventData)
  if not self.enableTouch then
    return
  end
  local currentPosX = eventData.position.x
  if currentPosX > Screen.width then
    return
  end
  if self.lastDragPosX then
    local offset = self.lastDragPosX - currentPosX
    self.lastDragPosX = currentPosX
    self:Rotate(offset)
  end
end

function UIModelView:OnEndDrag(eventData)
  if not self.enableTouch then
    return
  end
  if self.onEndDragHandler ~= nil then
    self.onEndDragHandler()
  end
  self.dragging = false
end

function UIModelView:Rotate(offset)
  if self.ctrl == nil then
    return
  end
  local model = self.ctrl:GetSceneModel()
  if model ~= nil then
    local y = model.transform.rotation.eulerAngles.y + offset
    model.transform.rotation = Quaternion.Euler(0, y, 0)
  end
end

function UIModelView:ResetRotation()
  if self.ctrl == nil then
    return
  end
  local model = self.ctrl:GetSceneModel()
  if model ~= nil then
    local curRotation = model.transform.rotation
    if curRotation ~= Quaternion.identity then
      model.transform:Set_localEulerAngles(0, 0, 0)
    end
  end
end

local shadowDistance

function UIModelView:SetQuality(enable, shadowDistanceValue)
  if enable then
    shadowDistance = RenderSetting.GetShadowDistance()
    local finalShadow = shadowDistanceValue and shadowDistanceValue or 110
    RenderSetting.SetShadowDistance(finalShadow)
  else
    RenderSetting.SetShadowDistance(shadowDistance)
  end
end

function UIModelView:ClearTouch()
  self.enableTouch = nil
  self.lastDragPosX = nil
  self.dragging = nil
  self.onBeginDragHandler = nil
  self.onEndDragHandler = nil
end

function UIModelView:GetCtrl()
  return self.ctrl
end

return UIModelView
