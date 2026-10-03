local UIActMonopolyModelNewManager = BaseClass("UIActMonopolyModelNewManager")
local ModelNewGridItemManager = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyModelNewManager.ModelNewGridItemManager")
local ModelNewRoleManager = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyModelNewManager.ModelNewRoleManager")
local DefaultScenePath = "Assets/Main/Prefabs/UIChristmasPerfab/ActMonopolyModelScene.prefab"
local LightPath = "City/Scene_City2(Clone)/Light_City"
local shadowDistance
local Camera = CS.UnityEngine.Camera
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local Resource = CS.GameEntry.Resource
local RenderTexture = CS.UnityEngine.RenderTexture

function UIActMonopolyModelNewManager:__init()
  self:DataDefine()
end

function UIActMonopolyModelNewManager:__delete()
  self:OnDestroy()
end

function UIActMonopolyModelNewManager:DataDefine()
  self.sceneLoadRequest = nil
  self.scene = nil
  self.cameraRoot = nil
  self.camera = nil
  self.modelRoot = nil
  self.isMonsterShow = true
  self.modelNewGridItemManagerInitFin = false
  self.modelNewRoleManagerInitFin = false
  self.modelNewGridItemManager = ModelNewGridItemManager.New()
  self.modelNewRoleManager = ModelNewRoleManager.New()
end

function UIActMonopolyModelNewManager:DataDestroy()
  self.sceneLoadRequest = nil
  self.scene = nil
  self.cameraRoot = nil
  self.camera = nil
  self.modelRoot = nil
  self.isMonsterShow = nil
  if self.modelNewGridItemManager then
    self.modelNewGridItemManager:Delete()
    self.modelNewGridItemManager = nil
  end
  if self.modelNewRoleManager then
    self.modelNewRoleManager:Delete()
    self.modelNewRoleManager = nil
  end
end

function UIActMonopolyModelNewManager:OnDestroy()
  self:EndShow()
  self:ReleaseRenderTexture()
  self:DataDestroy()
end

function UIActMonopolyModelNewManager:SetRawImgData(showImg, showImgX, showImgY)
  self.showImg = showImg
  self.showImgX = showImgX
  self.showImgY = showImgY
  self:ReleaseRenderTexture()
  local rtWidth = showImgX
  local rtHeight = showImgY
  local rtFormat = RenderTextureFormat.ARGB2101010
  self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
  self:SetRawImgComp(self.showImg)
end

function UIActMonopolyModelNewManager:SetRawImgComp(showImg)
  if showImg then
    self.showImg = showImg
    self.showImg:SetTexture(self.renderTexture)
    self.showImg:SetUVRectPositionAndSize(0, 0, 1, 1)
  end
end

function UIActMonopolyModelNewManager:SetIsMonsterShow(isMonsterShow)
  self.isMonsterShow = isMonsterShow
end

function UIActMonopolyModelNewManager:ReleaseRenderTexture()
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UIActMonopolyModelNewManager:StartShow(richman_para)
  if self.sceneLoadRequest ~= nil then
    self:CheckAllLoadFinish()
    return
  end
  self.richman_para = richman_para
  shadowDistance = RenderSetting.GetShadowDistance()
  self:SetCityLightActive(false)
  self:CloseMainCamera()
  RenderSetting.SetShadowDistance(30)
  self.modelNewGridItemManagerInitFin = false
  self.modelNewRoleManagerInitFin = false
  self:CreateLevel()
end

function UIActMonopolyModelNewManager:EndShow()
  if shadowDistance ~= nil then
    RenderSetting.SetShadowDistance(shadowDistance)
  end
  self:SetCityLightActive(true)
  self:RecoverMainCamera()
  self:UnInitCamera()
  self.modelNewGridItemManager:EndShow()
  self.modelNewRoleManager:EndShow()
  if self.sceneLoadRequest then
    self.sceneLoadRequest:Destroy()
    self.sceneLoadRequest = nil
  end
end

function UIActMonopolyModelNewManager:CreateLevel()
  self.sceneLoadRequest = nil
  local scenePath = ""
  if self.richman_para then
    local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(self.richman_para)
    if paraTemp then
      scenePath = paraTemp.scenePath
    end
  end
  if string.IsNullOrEmpty(scenePath) then
    scenePath = DefaultScenePath
  end
  local req = Resource:InstantiateAsync(scenePath)
  req:completed("+", function()
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_localPosition(0, 0, 0)
    self.scene = req.gameObject
    self.cameraRoot = self.scene.transform:Find("Camera")
    self.modelRoot = self.scene.transform:Find("ModelRoot")
    self:OnLoadedScene()
  end)
  self.sceneLoadRequest = req
end

function UIActMonopolyModelNewManager:OnLoadedScene()
  self:InitCamera()
  self.modelNewGridItemManager:StartShow(self)
  self.modelNewRoleManager:StartShow(self)
end

function UIActMonopolyModelNewManager:InitCamera()
  self.camera = self.cameraRoot:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
  self.camera.targetTexture = self.renderTexture
end

function UIActMonopolyModelNewManager:UnInitCamera()
  if self.camera then
    self.camera.targetTexture = nil
    self.camera = nil
  end
end

function UIActMonopolyModelNewManager:SetCityLightActive(val)
  local light = CS.UnityEngine.GameObject.Find(LightPath)
  if light ~= nil then
    light:SetActive(val)
  end
end

function UIActMonopolyModelNewManager:CloseMainCamera()
  self.mainCamera = Camera.main
  local curCullingMask = self.mainCamera.cullingMask
  if curCullingMask and curCullingMask ~= 0 then
    self.mainCullingMask = curCullingMask
  else
    self.mainCullingMask = nil
  end
  self.mainCamera.cullingMask = 0
end

function UIActMonopolyModelNewManager:RecoverMainCamera()
  if self.mainCamera ~= nil and self.mainCullingMask ~= nil then
    self.mainCamera.cullingMask = self.mainCullingMask
  end
end

function UIActMonopolyModelNewManager:SetRoleLocalPosByGridIndex(gridIndex)
  local gridLocalPos = self.modelNewGridItemManager:GetGridItemRoleLocalPosByIndex(gridIndex)
  self.modelNewRoleManager:SetRoleLocalPos(gridLocalPos)
end

function UIActMonopolyModelNewManager:GetIsAllLoadFinish()
  local isAllLoadFin = false
  if self.modelNewGridItemManagerInitFin and self.modelNewRoleManagerInitFin then
    isAllLoadFin = true
  end
  return isAllLoadFin
end

function UIActMonopolyModelNewManager:CheckAllLoadFinish()
  local isAllLoadFin = self:GetIsAllLoadFinish()
  if isAllLoadFin then
    TimerManager:GetInstance():DelayInvoke(function()
      EventManager:GetInstance():Broadcast(EventId.ActMonopolyRoleLoadFin)
    end, 0.01)
  end
end

function UIActMonopolyModelNewManager:OnUpdate()
end

function UIActMonopolyModelNewManager:OnUpdate1000MS()
  self.modelNewGridItemManager:OnUpdate1000MS()
end

return UIActMonopolyModelNewManager
