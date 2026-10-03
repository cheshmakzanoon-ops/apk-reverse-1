local SeasonWorldModelViewer = BaseClass("SeasonWorldModelViewer", UIBaseContainer)
local base = UIBaseContainer
local GameQualitySettings = require("Util.GameQualitySettings")
local Camera = CS.UnityEngine.Camera
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Localization = CS.GameEntry.Localization
local Physics = CS.UnityEngine.Physics
local DEBUG_MODE = false
local SeasonWorldMapPath = "Assets/Main/Prefabs/UI/LWSeasonWorld/LWSeasonWorldScene.prefab"
local OpModelSpeed = 0.1
local AutoModelSpeed = 20
local ChangeAutoStateTime = 0.2
local raw_image_path = "RawImage"
local item_hud_path = "mapItemHud/item_hud"
local touch_arena_path = "TouchArena"
SeasonWorldModelViewer.SWMVState = {
  None = 0,
  Auto = 1,
  Drag = 2,
  Click = 3
}

function SeasonWorldModelViewer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.worldData = {
    defaultScenePos = Vector3.New(-5000, 0, -5000),
    uiWorldInModel = {},
    cameraPosA = nil,
    cameraPosB = nil,
    worldModelPos = nil,
    worldModel = nil,
    worldModelRoot = nil,
    sceneCamera = nil,
    curHudMapItem = nil,
    lastHudMapItem = nil,
    selectMapItem = nil
  }
  self.dragData = {drag = false, stopSpeedDir = nil}
  self.stateData = {
    state = SeasonWorldModelViewer.SWMVState.None,
    autoCd = 0
  }
  self.mapItems = {}
  self.tweenSeq = nil
end

function SeasonWorldModelViewer:OnDestroy()
  if self.worldData.sceneCamera ~= nil then
    self.worldData.sceneCamera.transform.position = self.worldData.cameraPosB.position
  end
  self:ClearTween()
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
    self.sceneLoading = nil
  end
  if self.sceneModelPtr ~= nil then
    self.sceneModelPtr:Destroy()
    self.sceneModelPtr = nil
  end
  self.stateData = nil
  self.mapItems = nil
  self.worldData = nil
  self.dragData = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonWorldModelViewer:ComponentDefine()
  self.raw_image = self:AddComponent(UIRawImage, raw_image_path)
  self.item_hud = self:AddComponent(UITextMeshProUGUIEx, item_hud_path)
  self.touch = self:AddComponent(UIEventTrigger, touch_arena_path)
  self.touch:OnPointerClick(function()
    self:OnPointerClick()
  end)
  self.touch:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.touch:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.touch:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
end

function SeasonWorldModelViewer:ComponentDestroy()
  self.raw_image = nil
  self.touch = nil
  self.item_hud = nil
end

function SeasonWorldModelViewer:ClearTween()
  if self.tweenSeq ~= nil then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

function SeasonWorldModelViewer:Update()
  self:DoAuto()
  self:DoDrag()
  self:DoNearUi()
end

function SeasonWorldModelViewer:DoAuto()
  if self.stateData.state == SeasonWorldModelViewer.SWMVState.Auto then
    self:Auto()
  end
end

function SeasonWorldModelViewer:DoNearUi()
  local minDistance = 99999999
  local curHubMapItem = self.worldData.curHudMapItem
  if self.worldData.selectMapItem ~= nil then
    self.worldData.curHudMapItem = self.worldData.selectMapItem
  else
    self.worldData.curHudMapItem = nil
    for _, mapItem in ipairs(self.mapItems) do
      local goTran = mapItem.goTran
      if goTran ~= nil and mapItem.canShow then
        local goPos = goTran.position
        if minDistance >= goPos.z and goPos.z < self.worldData.worldModelPos.z then
          minDistance = goPos.z
          self.worldData.curHudMapItem = mapItem
        end
      end
    end
  end
  if self.worldData.curHudMapItem ~= self.worldData.lastHudMapItem then
    self.worldData.lastHudMapItem = curHubMapItem
    if self.worldData.curHudMapItem ~= nil then
      self.item_hud:SetText(Localization:GetString(self.worldData.curHudMapItem.template.big_name))
    end
  end
  curHubMapItem = self.worldData.curHudMapItem
  if curHubMapItem ~= nil then
    local curScreenPos = PosConverse.WorldToScreenPos(curHubMapItem.goTran.position, self.worldData.sceneCamera)
    curScreenPos.x = Screen.width / self.rtWidth * curScreenPos.x
    curScreenPos.y = Screen.height / self.rtHeight * curScreenPos.y
    local localPos = PosConverse.ScreenToUIPos(self.item_hud.transform.parent, curScreenPos)
    self.item_hud.rectTransform:Set_localPosition(localPos.x, localPos.y - 50, localPos.z)
  else
    self.item_hud.rectTransform:Set_localPosition(99999, 99999, 99999)
  end
end

function SeasonWorldModelViewer:DoDrag()
  if self.stateData.state == SeasonWorldModelViewer.SWMVState.Drag then
    if self.dragData.drag then
      return
    end
    local stopSpeedDir = self.dragData.stopSpeedDir
    if stopSpeedDir ~= nil and stopSpeedDir:Magnitude() >= 0.1 then
      self.worldData.worldModel:Rotate(stopSpeedDir, CS.UnityEngine.Space.World)
      self.dragData.stopSpeedDir = stopSpeedDir * 0.9
    else
      self.dragData.stopSpeedDir = nil
      self:ChangeState(SeasonWorldModelViewer.SWMVState.Auto)
    end
  end
end

function SeasonWorldModelViewer:Auto()
  if self.worldData.worldModel == nil then
    return
  end
  if self.stateData.autoCd >= 0 then
    self.stateData.autoCd = self.stateData.autoCd - Time.deltaTime
    return
  end
  self.worldData.worldModelRoot:Rotate(Vector3.New(0, AutoModelSpeed * Time.deltaTime, 0), CS.UnityEngine.Space.Self)
end

function SeasonWorldModelViewer:ReloadScene(configs, callback)
  if self.sceneModelPtr ~= nil then
    local camera = self.worldData.sceneCamera
    self:OnRenderTexture(camera)
    self.sceneModelPtr.gameObject:SetActive(true)
    if callback ~= nil then
      callback(true)
    end
    return
  end
  if self.sceneLoading ~= nil then
    return
  end
  local request = ResourceManager:InstantiateAsync(SeasonWorldMapPath)
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
    request.gameObject.transform:Set_position(self.worldData.defaultScenePos.x, self.worldData.defaultScenePos.y, self.worldData.defaultScenePos.z)
    if DEBUG_MODE then
      self.debug = request.gameObject.transform:Find("Map/Debug")
    end
    local camera = request.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
    local worldModel = request.gameObject.transform:Find("Map/Root/WorldModel")
    local defaultScenePos = self.worldData.defaultScenePos
    self.worldData = {
      uiWorldInModel = {},
      defaultScenePos = defaultScenePos,
      cameraPosA = request.gameObject.transform:Find("cameraPosA"),
      cameraPosB = request.gameObject.transform:Find("cameraPosB"),
      worldModelRoot = request.gameObject.transform:Find("Map/Root"),
      worldModel = worldModel,
      worldModelPos = worldModel.position,
      sceneCamera = camera
    }
    self.sceneLoading = nil
    self.sceneModelPtr = request
    self:ToggleSceneCamera(true)
    self:RefreshUIPos()
    camera.transform.position = self.worldData.cameraPosA.position
    for index, template in ipairs(configs) do
      local canShow = template:Condition()
      self.mapItems[index] = {
        template = template,
        goTran = self.worldData.worldModel:Find(template.piece_Prefab),
        canShow = canShow
      }
      if string.IsNullOrEmpty(template.piece_Prefab) then
        self.mapItems[index].goTran = nil
      end
      if not IsNull(self.mapItems[index].goTran) then
        self.mapItems[index].goTran.gameObject:SetActive(canShow and template.activeModel)
      end
    end
    self.stateData.state = SeasonWorldModelViewer.SWMVState.Auto
    if callback ~= nil then
      callback(true)
    end
  end)
end

function SeasonWorldModelViewer:RefreshUIPos()
  for _, v in ipairs(self.view.configs) do
    local posName = "pos" .. v.season
    local posTran = self.view.pos.transform:Find(posName)
    if IsNull(posTran) then
      local posGo = CS.UnityEngine.GameObject(posName)
      posTran = posGo:AddComponent(typeof(CS.UnityEngine.RectTransform))
      posTran:SetParent(self.view.pos.transform)
      posTran:Set_localEulerAngles(0, 0, 0)
      posTran:Set_localPosition(0, 0, 0)
      posTran.localScale = Vector3.New(1, 1, 1)
      posTran:Set_anchorMax(1, 0)
      posTran:Set_anchorMin(1, 0)
      posTran:Set_pivot(1, 0)
      local offset = v.world_model_offset or Vector2.New(0, 0)
      posTran:Set_anchoredPosition(offset.x, offset.y)
    end
    local uiScreenPos = PosConverse.UIWorldToScreenPos(posTran.position)
    uiScreenPos = Vector3.New(uiScreenPos.x, uiScreenPos.y, self.worldData.sceneCamera.nearClipPlane)
    uiScreenPos.x = self.rtWidth / Screen.width * uiScreenPos.x
    uiScreenPos.y = self.rtHeight / Screen.height * uiScreenPos.y
    local ray = self.worldData.sceneCamera:ScreenPointToRay(uiScreenPos)
    local hits = Physics.RaycastAll(ray, SceneTouchDistance, LayerMask.GetMask("Terrain"))
    if IsNotNull(hits) and 0 < hits.Length then
      local hit = hits[0]
      local hitPosition = hit.point
      if DEBUG_MODE then
        self.debug.position = hitPosition
      end
      self.worldData.uiWorldInModel[v.season] = hitPosition
    end
  end
end

function SeasonWorldModelViewer:OnRenderTexture(camera)
  if camera == nil then
    Logger.LogError("# OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local scale = 1
    if not GameQualitySettings.IsHighGearQuality() then
      scale = 0.5
    end
    local rtWidth = UIManager:GetInstance():GetUIContainerRect().sizeDelta.x
    local rtHeight = UIManager:GetInstance():GetUIContainerRect().sizeDelta.y
    self.rtWidth = math.floor(rtWidth * scale)
    self.rtHeight = math.floor(rtHeight * scale)
    local rtFormat = RenderTextureFormat.ARGBHalf
    self.renderTexture = RenderTexture.GetTemporary(self.rtWidth, self.rtHeight, 24, rtFormat)
    self.renderTexture.name = "SeasonWorldShow"
    self.raw_image:SetTexture(self.renderTexture)
    self.raw_image:SetEnable(true)
    self.raw_image:SetColor(Color.New(1, 1, 1, 1))
  end
  camera.targetTexture = self.renderTexture
end

function SeasonWorldModelViewer:ToggleSceneCamera(enable)
  local sceneCamera = self.worldData.sceneCamera
  if sceneCamera ~= nil then
    sceneCamera.gameObject:SetActive(enable)
    if enable then
      self:OnRenderTexture(sceneCamera)
    else
      sceneCamera.targetTexture = nil
    end
  end
end

function SeasonWorldModelViewer:OnBeginDrag(eventData)
  if self.stateData.state == SeasonWorldModelViewer.SWMVState.Click then
    return
  end
  if self.dragData.drag then
    return
  end
  self.dragData.drag = true
  self:ChangeState(SeasonWorldModelViewer.SWMVState.Drag)
end

function SeasonWorldModelViewer:OnDrag(eventData)
  if self.stateData.state == SeasonWorldModelViewer.SWMVState.Click then
    return
  end
  if not self.dragData.drag then
    return
  end
  local deltaX = eventData.delta.x
  local deltaY = eventData.delta.y
  local rotationDir = OpModelSpeed * Vector3.New(deltaY, -1 * deltaX, 0)
  rotationDir = Vector3.ClampMagnitude(rotationDir, 20)
  if self.worldData and self.worldData.worldModel then
    self.worldData.worldModel.transform:Rotate(rotationDir, CS.UnityEngine.Space.World)
  end
  self.dragData.stopSpeedDir = rotationDir
end

function SeasonWorldModelViewer:OnEndDrag(eventData)
  if not self.dragData.drag then
    return
  end
  self.dragData.drag = false
end

function SeasonWorldModelViewer:OnPointerClick()
  if self.dragData.drag then
    return
  end
  if self.rtWidth == nil or self.worldData == nil or self.worldData.worldModel == nil then
    return
  end
  local uiScreenPos = CS.UnityEngine.Input.mousePosition
  local camera = self.worldData.sceneCamera
  uiScreenPos.x = self.rtWidth / Screen.width * uiScreenPos.x
  uiScreenPos.y = self.rtHeight / Screen.height * uiScreenPos.y
  uiScreenPos = Vector3.New(uiScreenPos.x, uiScreenPos.y, camera.nearClipPlane)
  local ray = camera:ScreenPointToRay(uiScreenPos)
  local hits = Physics.RaycastAll(ray, SceneTouchDistance, LayerMask.GetMask("UIObject3D"))
  local hasResult = IsNotNull(hits) and hits.Length > 0
  if not hasResult then
    if self.stateData.state == SeasonWorldModelViewer.SWMVState.Click then
      self:ClearTween()
      self.view.select_season:SetActive(false)
      self.item_hud:SetActive(true)
      self.view.curIndex = -1
      self.tweenSeq = DOTween.Sequence()
      self.tweenSeq:Append(self.worldData.sceneCamera.transform:DOMove(self.worldData.cameraPosA.position, 0.5):SetEase(CS.DG.Tweening.Ease.InQuad))
      self.tweenSeq:AppendCallback(function()
        self:ChangeState(SeasonWorldModelViewer.SWMVState.Auto)
      end)
      self.worldData.selectMapItem = nil
    end
  elseif self.stateData.state ~= SeasonWorldModelViewer.SWMVState.Click then
    local hitGO = hits[0]
    for _, mapItem in ipairs(self.mapItems) do
      if IsNotNull(mapItem.goTran) and mapItem.goTran == hitGO.collider.transform.parent then
        self.view:OnClickItem(mapItem.template, true)
        break
      end
    end
  end
end

function SeasonWorldModelViewer:SetUpModeState(state)
  self.stateData.state = state
end

function SeasonWorldModelViewer:Switch(template, modelClick, callback)
  local opMapItem = self.mapItems[template.season + 1]
  if opMapItem == nil or IsNull(opMapItem.goTran) then
    return
  end
  self:ClearTween()
  local worldModel = self.worldData.worldModel
  local worldModelPos = self.worldData.worldModelPos
  local curModelDir = self.worldData.uiWorldInModel[template.season] - worldModelPos
  local tarModelDir = opMapItem.goTran.position - worldModelPos
  local rotationAxis = Vector3.unity_vector3.Cross(tarModelDir, curModelDir)
  local angle = Vector3.unity_vector3.Angle(curModelDir, tarModelDir)
  local targetRotation = Quaternion.unity_quaternion.AngleAxis(angle, rotationAxis) * worldModel.rotation
  local needRotationTime = angle / 120
  if self.stateData.state == SeasonWorldModelViewer.SWMVState.Click then
    needRotationTime = angle / 80
  elseif 90 < angle then
    needRotationTime = 0.75
  end
  needRotationTime = math.max(needRotationTime, 0.8)
  needRotationTime = math.min(needRotationTime, 1.2)
  self:ChangeState(SeasonWorldModelViewer.SWMVState.Click)
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:Append(worldModel:DORotate(targetRotation.eulerAngles, needRotationTime):SetEase(CS.DG.Tweening.Ease.InOutQuart))
  local targetPos = self.worldData.cameraPosB.position
  local cameraPos = self.worldData.sceneCamera.transform.position
  if Vector3.Distance(targetPos, cameraPos) > 0.1 then
    self.tweenSeq:Append(self.worldData.sceneCamera.transform:DOMove(self.worldData.cameraPosB.position, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuart))
  end
  if not modelClick then
    self.item_hud:SetActive(false)
  end
  self.tweenSeq:AppendCallback(function()
    self.worldData.selectMapItem = opMapItem
    self.item_hud:SetActive(true)
    if callback ~= nil then
      callback(template)
    end
  end)
end

function SeasonWorldModelViewer:RefreshMapItem()
  for _, v in ipairs(self.mapItems) do
    if IsNull(v.goTran) then
      return
    end
    v.goTran.gameObject:SetActive(v.template:Condition())
  end
end

function SeasonWorldModelViewer:ChangeState(state)
  self.stateData.state = state
  if self.stateData.state == SeasonWorldModelViewer.SWMVState.Auto then
    self.stateData.autoCd = ChangeAutoStateTime
  end
end

return SeasonWorldModelViewer
