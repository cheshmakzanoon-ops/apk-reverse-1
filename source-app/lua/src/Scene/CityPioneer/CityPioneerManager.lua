local CityPioneerManager = BaseClass("CityPioneerManager")
local Const = require("Scene.CityPioneer.Const")
local Data = CS.GameEntry.Data

function CityPioneerManager:__init()
  self.cityCameraFov = nil
  self.cityCameraZoom = nil
  self.cityCameraZoomParams = nil
end

function CityPioneerManager:__delete()
  self:Destroy()
  self.cityCameraFov = nil
  self.cityCameraZoom = nil
  self.cityCameraZoomParams = nil
end

function CityPioneerManager:Startup()
end

function CityPioneerManager:Destroy()
  self:DoPrologueUnInit()
end

function CityPioneerManager:DoPrologueInit()
  if SceneUtils.GetIsInCity() then
    if self:IsBeforePrologue() then
      RenderSetting.SettingHeightFog(20, 10, BlackFogColor, BlackFogColor, 1)
      RenderSetting.SetHeightFogVisible(true)
      Data.Fog:InitFogDataByCacheInWasteLand()
      CityPioneerFog:GetInstance():InitFog()
      CityPioneerFog:GetInstance():Startup()
    end
    CityGarbageManager:GetInstance():Create()
    CitySpaceMan:GetInstance():Startup()
    CityPioneerArchive:GetInstance():Startup()
    CityTriggerPointManager:GetInstance():Startup()
    local load_ok = CityPioneerArchive:GetInstance():Load()
    CityTriggerPointManager:GetInstance():Init()
    DataCenter.CityTriggerPointDataManager:InitAllTriggerPoints()
    DataCenter.CityNpcManager:InitNpc()
    DataCenter.CityNoMovePointManager:InitNoMovePoint()
    self:RefreshPrologueModel()
    if load_ok ~= false or self:IsBeforePrologue() then
    end
  end
end

function CityPioneerManager:DoPrologueUnInit()
  self:ClearDig()
  CitySpaceMan:GetInstance():Delete()
  CityTriggerPointManager:GetInstance():Delete()
  CityPioneerFog:GetInstance():Delete()
  CityPioneerArchive:GetInstance():Delete()
  WastelandFarmManager:GetInstance():DeleteObj()
  CityGarbageManager:GetInstance():RemoveAllGarbage()
  CityGarbageManager:GetInstance():Destroy()
end

function CityPioneerManager:EnterDigCamera()
  local cityScene = CS.SceneManager.World
  if cityScene ~= nil then
    self.cityCameraFov = cityScene:GetFOV()
    self.cityCameraZoom = cityScene.Zoom
    self.cityCameraZoomParams = cityScene:GetZoomParams()
    cityScene:SetCameraFOV(10)
    cityScene:SetZoomParams(1, 17.85, 20, 25)
    cityScene.Zoom = CS.GameEntry.Setting:GetPrivateFloat(SettingKeys.DigCameraHeightSnap, 12)
  end
end

function CityPioneerManager:ExitDigCamera()
  if self.cityCameraFov == nil or self.cityCameraZoom == nil or self.cityCameraZoomParams == nil then
    return
  end
  local cityScene = CS.SceneManager.World
  if cityScene ~= nil then
    local cameraParamLevel1 = self.cityCameraZoomParams[1]
    cityScene:SetCameraFOV(self.cityCameraFov)
    cityScene.Zoom = self.cityCameraZoom
    cityScene:SetZoomParams(1, cameraParamLevel1.posY, cameraParamLevel1.offsetZ, cameraParamLevel1.sensitivity)
    cityScene:SetCameraTouchEnable(true)
  end
end

function CityPioneerManager:ClearPrologue()
  DataCenter.CityNpcManager:RemoveAll()
  self:RefreshPrologueModel()
end

function CityPioneerManager:RefreshPrologueModel()
  local cityScene = CS.SceneManager.World
  if cityScene ~= nil then
    if self:IsBeforePrologue() then
      SceneUtils.PlayGuideSceneBgMusic()
      DataCenter.GuideManager:SetNoShowUIMain(true)
      self:EnterDigCamera()
      CityPioneerFog:GetInstance():SetCityFogCanVisible(true)
      if CitySpaceMan:GetInstance():IsNeedCreate() then
        CitySpaceMan:GetInstance():CreateGameObject()
      end
      WastelandFarmManager:GetInstance():Load()
      WastelandModelMgr:GetInstance():Load()
    else
      DataCenter.GuideManager:SetNoShowUIMain(false)
      cityScene:SetCameraTouchEnable(true)
      DataCenter.CityTriggerPointDataManager:RemoveAll()
      if not CitySpaceMan:GetInstance():IsNeedCreate() then
        CitySpaceMan:GetInstance():Delete()
      end
      DataCenter.CityPioneerYellowArrowManager:RemoveAll()
      DataCenter.CityPrologueBuildManager:RemoveAll()
      WastelandFarmManager:GetInstance():ToggleArrow(false)
      WastelandFarmManager:GetInstance():RemoveAll()
      WastelandFarmManager:GetInstance():DeleteObj()
      WastelandModelMgr:GetInstance():RemoveAllModel()
      CityPioneerArchive:GetInstance():Save()
      CityPioneerFog:GetInstance():SetCityFogCanVisible(false)
      CityPioneerFog:GetInstance():Delete()
      CityTriggerPointManager:GetInstance():Delete()
      CityPioneerArchive:GetInstance():Delete()
      CityGarbageManager:GetInstance():RemoveAllGarbage()
      CityGarbageManager:GetInstance():Destroy()
      CS.SceneManager.World:SetFogVisible(false)
      CS.SceneManager.World:SetWorldSize(70)
    end
  end
end

function CityPioneerManager:IsBeforePrologue()
  return DataCenter.GuideManager:GetSaveGuideValue(BeforePrologue) == SaveGuideDoneValue
end

function CityPioneerManager:ClearDig()
  if SceneUtils.GetIsInCity() then
    CS.SceneManager.World:EndDig()
  end
end

function CityPioneerManager:EndDig()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMain, {})
  self:ExitDigCamera()
  DataCenter.GuideManager:SendSaveGuideMessage(BeforePrologue, "")
  self:ClearPrologue()
  DataCenter.BuildManager:UILoadingExitSignal()
  DataCenter.LandLockManager:RefreshAll()
end

function CityPioneerManager:CheckResReachGuide()
  local list = DataCenter.GuideManager:GetPrologueOwnNumTriggerGuide()
  if list ~= nil then
    for k, v in ipairs(list) do
      local canTrigger = true
      for k2, v2 in ipairs(v.needRes) do
        local resType = Const.UnlockToResType[v2.resType]
        local own = CitySpaceMan:GetInstance():GetResTypeCount(resType)
        if own < v2.count then
          canTrigger = false
          break
        end
      end
      if canTrigger and DataCenter.GuideManager:CheckDoTriggerGuide(v.triggerType, v.triggerPara) then
        break
      end
    end
  end
end

return CityPioneerManager
