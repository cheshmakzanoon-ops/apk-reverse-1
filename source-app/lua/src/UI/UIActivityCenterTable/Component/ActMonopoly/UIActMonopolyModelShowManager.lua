local UIActMonopolyModelShowManager = BaseClass("UIActMonopolyModelShowManager")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ScenePath = "Assets/Main/Prefabs/UIChristmasPerfab/ActMonopolyHeroShowScene.prefab"
local LightPath = "City/Scene_City2(Clone)/Light_City"
local defaultQuality, shadowDistance
local RenderSettings = CS.UnityEngine.RenderSettings
local Camera = CS.UnityEngine.Camera
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local Resource = CS.GameEntry.Resource
local RenderTexture = CS.UnityEngine.RenderTexture
local RoleModelManager = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyModelManager.RoleModelManager")
local MonsterModelManager = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyModelManager.MonsterModelManager")
local WeaponModelManager = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyModelManager.WeaponModelManager")
local BulletsAndEffectsModelManager = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyModelManager.BulletsAndEffectsModelManager")

function UIActMonopolyModelShowManager:__init()
  self:DataDefine()
end

function UIActMonopolyModelShowManager:__delete()
  self:OnDestroy()
end

function UIActMonopolyModelShowManager:DataDefine()
  self.sceneLoadRequest = nil
  self.scene = nil
  self.cameraRoot = nil
  self.camera = nil
  self.isMonsterShow = true
  self.roleModelManager = RoleModelManager.New()
  self.monsterModelManager = MonsterModelManager.New()
  self.weaponModelManager = WeaponModelManager.New()
  self.bulletsAndEffectsModelManager = BulletsAndEffectsModelManager.New()
end

function UIActMonopolyModelShowManager:DataDestroy()
  self.sceneLoadRequest = nil
  self.scene = nil
  self.cameraRoot = nil
  self.camera = nil
  self.isMonsterShow = nil
  if self.roleModelManager then
    self.roleModelManager:Delete()
    self.roleModelManager = nil
  end
  if self.monsterModelManager then
    self.monsterModelManager:Delete()
    self.monsterModelManager = nil
  end
  if self.weaponModelManager then
    self.weaponModelManager:Delete()
    self.weaponModelManager = nil
  end
  if self.bulletsAndEffectsModelManager then
    self.bulletsAndEffectsModelManager:Delete()
    self.bulletsAndEffectsModelManager = nil
  end
end

function UIActMonopolyModelShowManager:OnDestroy()
  self:EndShow()
  self:ReleaseRenderTexture()
  self:DataDestroy()
end

function UIActMonopolyModelShowManager:SetRawImgData(roleImg, roleImgX, roleImgY, battleImg, battleImgX, battleImgY)
  self.roleImgX = roleImgX
  self.roleImgY = roleImgY
  self.battleImgX = battleImgX
  self.battleImgY = battleImgY
  self:ReleaseRenderTexture()
  local rtWidth = battleImgX
  local rtHeight = battleImgY + roleImgY
  local rtFormat = RenderTextureFormat.ARGB32
  self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
  self:SetRawImgComp(roleImg, battleImg)
end

function UIActMonopolyModelShowManager:SetRawImgComp(roleImg, battleImg)
  if roleImg then
    self.roleImg = roleImg
    self.roleImg:SetTexture(self.renderTexture)
    self.roleImg:SetUVRectPositionAndSize(0, 0, self.roleImgX / self.battleImgX, self.roleImgY / (self.battleImgY + self.roleImgY))
  end
  if battleImg then
    self.battleImg = battleImg
    self.battleImg:SetTexture(self.renderTexture)
    self.battleImg:SetUVRectPositionAndSize(0, self.roleImgY / (self.battleImgY + self.roleImgY), 1, self.battleImgY / (self.battleImgY + self.roleImgY))
  end
end

function UIActMonopolyModelShowManager:SetIsMonsterShow(isMonsterShow)
  self.isMonsterShow = isMonsterShow
end

function UIActMonopolyModelShowManager:ReleaseRenderTexture()
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UIActMonopolyModelShowManager:StartShow()
  if self.sceneLoadRequest ~= nil then
    return
  end
  shadowDistance = RenderSetting.GetShadowDistance()
  self:SetCityLightActive(false)
  self:CloseMainCamera()
  RenderSetting.SetShadowDistance(30)
  self:CreateLevel()
end

function UIActMonopolyModelShowManager:EndShow()
  if shadowDistance ~= nil then
    RenderSetting.SetShadowDistance(shadowDistance)
  end
  self:SetCityLightActive(true)
  self:RecoverMainCamera()
  self:UnInitCamera()
  self.bulletsAndEffectsModelManager:EndShow()
  self.roleModelManager:EndShow()
  self.monsterModelManager:EndShow()
  self.weaponModelManager:EndShow()
  if self.sceneLoadRequest then
    self.sceneLoadRequest:RealDestroy()
    self.sceneLoadRequest = nil
  end
end

function UIActMonopolyModelShowManager:CreateLevel()
  self.sceneLoadRequest = nil
  local req = Resource:InstantiateAsync(ScenePath)
  req:completed("+", function()
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_localPosition(1000, 0, 1000)
    self.scene = req.gameObject
    self.cameraRoot = self.scene.transform:Find("Camera")
    self:OnLoadedScene()
  end)
  self.sceneLoadRequest = req
end

function UIActMonopolyModelShowManager:OnLoadedScene()
  self:InitCamera()
  self.roleModelManager:StartShow(self)
  if self.isMonsterShow then
    self.monsterModelManager:StartShow(self)
    self.weaponModelManager:StartShow(self)
  end
  self.bulletsAndEffectsModelManager:StartShow(self)
end

function UIActMonopolyModelShowManager:InitCamera()
  self.camera = self.cameraRoot:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
  self.camera.targetTexture = self.renderTexture
end

function UIActMonopolyModelShowManager:UnInitCamera()
  if self.camera then
    self.camera.targetTexture = nil
    self.camera = nil
  end
end

function UIActMonopolyModelShowManager:SetCityLightActive(val)
  local light = CS.UnityEngine.GameObject.Find(LightPath)
  if light ~= nil then
    light:SetActive(val)
  end
end

function UIActMonopolyModelShowManager:CloseMainCamera()
  self.mainCamera = Camera.main
  self.mainCullingMask = self.mainCamera.cullingMask
  self.mainCamera.cullingMask = 0
end

function UIActMonopolyModelShowManager:RecoverMainCamera()
  if self.mainCamera ~= nil and self.mainCullingMask ~= nil then
    self.mainCamera.cullingMask = self.mainCullingMask
  end
end

function UIActMonopolyModelShowManager:SetRoleData(isWalking, dir)
  self.roleModelManager:SetRoleData(isWalking, dir)
end

function UIActMonopolyModelShowManager:SetMonsterIsWeak(isWeak)
  self.monsterModelManager:SetMonsterIsWeak(isWeak)
end

function UIActMonopolyModelShowManager:AddBulletAniData(damageData, aniTime)
  self.bulletsAndEffectsModelManager:AddBulletAniData(damageData, aniTime)
end

function UIActMonopolyModelShowManager:SetRoleResPath(path, aniPath)
  self.roleModelManager:SetRoleResPath(path, aniPath)
end

function UIActMonopolyModelShowManager:OnUpdate()
  if not self.isMonsterShow then
    return
  end
  local deltaTime = Time.deltaTime
  self.monsterModelManager:OnUpdate(deltaTime)
  self.weaponModelManager:OnUpdate(deltaTime)
  self.bulletsAndEffectsModelManager:OnUpdate(deltaTime)
end

return UIActMonopolyModelShowManager
