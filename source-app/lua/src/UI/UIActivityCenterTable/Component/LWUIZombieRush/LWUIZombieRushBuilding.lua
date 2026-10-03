local LWUIZombieRushBuilding = BaseClass("LWUIZombieRushBuilding", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local GameQualitySettings = require("Util.GameQualitySettings")

function LWUIZombieRushBuilding:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIZombieRushBuilding:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIZombieRushBuilding:ComponentDefine()
  self.rawImage = self:AddComponent(UIRawImage, "")
  if self.rawImage ~= nil then
    self.rawImage:SetColorRGBA(1, 1, 1, 0)
  end
end

function LWUIZombieRushBuilding:ComponentDestroy()
  self.rawImage = nil
end

function LWUIZombieRushBuilding:DataDefine()
  self.buildingId = 0
  self.camera = nil
  self.sceneRequest = nil
  self.citySlot = nil
  self.renderTexture = nil
  self.buildingRequest = nil
  self.buildingModelName = ""
  self.sceneActive = true
end

function LWUIZombieRushBuilding:DataDestroy()
  self.buildingId = nil
  self:ReleaseTexture()
  self:DestroyBuilding()
  self:DestroyScene()
  self.camera = nil
  self.sceneRequest = nil
  self.citySlot = nil
  self.renderTexture = nil
  self.buildingRequest = nil
  self.buildingModelName = nil
  self.sceneActive = nil
end

function LWUIZombieRushBuilding:ReInit(buildingId)
  self.buildingId = buildingId
  self:SetActive(true)
  self:LoadScene()
end

function LWUIZombieRushBuilding:SetActive(active)
  self.sceneActive = active
  if self.sceneRequest ~= nil and self.sceneRequest.gameObject ~= nil then
    self.sceneRequest.gameObject:SetActive(active)
  end
end

function LWUIZombieRushBuilding:LoadScene()
  if self.sceneRequest == nil then
    self.sceneRequest = ResourceManager:InstantiateAsync(UIAssets.LWUIZombieRushWorldScene)
    self.sceneRequest:completed("+", function()
      if self.sceneRequest.isError then
        return
      end
      self.sceneRequest.gameObject:SetActive(self.sceneActive)
      self.sceneRequest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.sceneRequest.gameObject.transform.position = DecorationUtil.GetWorldPos()
      self.camera = self.sceneRequest.gameObject.transform:Find("Camera"):GetComponentInChildren(typeof(Camera))
      self.citySlot = self.sceneRequest.gameObject.transform:Find("CitySlot")
      self:OnRenderTexture(self.camera)
      self:RefreshView()
    end)
  elseif self.camera ~= nil then
    self:RefreshView()
  end
end

function LWUIZombieRushBuilding:DestroyScene()
  if self.sceneRequest ~= nil then
    self.sceneRequest:Destroy()
    self.sceneRequest = nil
  end
end

function LWUIZombieRushBuilding:RefreshView()
  local allianceMineTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.buildingId)
  if allianceMineTemplate ~= nil then
    local modelPath = allianceMineTemplate:GetModelPath()
    if self.buildingModelName ~= modelPath then
      self:DestroyBuilding()
      self:LoadBuilding()
    end
  end
end

function LWUIZombieRushBuilding:LoadBuilding()
  local allianceMineTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.buildingId)
  if allianceMineTemplate ~= nil then
    local modelPath = allianceMineTemplate:GetModelPath()
    self.buildingModelName = modelPath
    self.buildingRequest = ResourceManager:InstantiateAsync(modelPath .. ".prefab")
    self.buildingRequest:completed("+", function()
      if self.buildingRequest.isError then
        return
      end
      self.buildingRequest.gameObject:SetActive(true)
      self.buildingRequest.gameObject.transform:SetParent(self.citySlot.transform)
      self.buildingRequest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.buildingRequest.gameObject.transform:Set_localPosition(0, 0, 0)
      self.cityLabel = self.buildingRequest.gameObject.transform:Find("ModelGo/CityLabel")
      if not IsNull(self.cityLabel) then
        self.cityLabel.gameObject:SetActive(false)
      end
    end)
  end
end

function LWUIZombieRushBuilding:DestroyBuilding()
  if not IsNull(self.cityLabel) then
    self.cityLabel.gameObject:SetActive(true)
  end
  self.cityLabel = nil
  if self.buildingRequest ~= nil then
    self.buildingRequest:Destroy()
    self.buildingRequest = nil
  end
end

function LWUIZombieRushBuilding:OnRenderTexture(camera)
  if camera == nil then
    Logger.LogError(" OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local scale = 1
    if not GameQualitySettings.IsHighGearQuality() then
      scale = 0.5
    end
    local rtWidth = 500 * scale
    local rtHeight = 500 * scale
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "ZombieRushBuildingShow"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    if self.rawImage ~= nil then
      self.rawImage:SetColorRGBA(1, 1, 1, 1)
    end
  end
  camera.targetTexture = self.renderTexture
end

function LWUIZombieRushBuilding:ReleaseTexture()
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  self.rawImage:SetTexture(nil)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

return LWUIZombieRushBuilding
