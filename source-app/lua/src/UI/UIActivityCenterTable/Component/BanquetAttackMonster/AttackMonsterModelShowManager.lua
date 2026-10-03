local AttackMonsterModelShowManager = BaseClass("AttackMonsterModelShowManager")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ScenePathDefault = "Assets/Main/Prefabs/UIChristmasPerfab/BanquetAttackMonsterShowScene.prefab"
local LightPath = "City/Scene_City2(Clone)/Light_City"
local shadowDistance
local RenderSettings = CS.UnityEngine.RenderSettings
local Shader = CS.UnityEngine.Shader
local Camera = CS.UnityEngine.Camera
local FogMode = CS.UnityEngine.FogMode
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local Resource = CS.GameEntry.Resource
local RenderTexture = CS.UnityEngine.RenderTexture
local MonsterModelManager = require("UI.UIActivityCenterTable.Component.BanquetAttackMonster.AttackMonsterModelManager.MonsterModelManager")
local WeaponModelManager = require("UI.UIActivityCenterTable.Component.BanquetAttackMonster.AttackMonsterModelManager.WeaponModelManager")
local BulletsAndEffectsModelManager = require("UI.UIActivityCenterTable.Component.BanquetAttackMonster.AttackMonsterModelManager.BulletsAndEffectsModelManager")

function AttackMonsterModelShowManager:__init()
  self:DataDefine()
end

function AttackMonsterModelShowManager:__delete()
  self:OnDestroy()
end

function AttackMonsterModelShowManager:DataDefine()
  self.sceneLoadRequest = nil
  self.scene = nil
  self.cameraRoot = nil
  self.camera = nil
  self.monsterModelManager = MonsterModelManager.New()
  self.monsterModelManager:SetAttackModelShowManager(self)
  self.weaponModelManager = WeaponModelManager.New()
  self.bulletsAndEffectsModelManager = BulletsAndEffectsModelManager.New()
  self.houRender = nil
  self.qianRender = nil
  self.jinRender = nil
  self.fogBackup = nil
  self.isFogApplied = false
end

function AttackMonsterModelShowManager:DataDestroy()
  self.sceneLoadRequest = nil
  self.scene = nil
  self.cameraRoot = nil
  self.camera = nil
  self.houRender = nil
  self.qianRender = nil
  self.jinRender = nil
  self.fogBackup = nil
  self.isFogApplied = nil
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

function AttackMonsterModelShowManager:OnDestroy()
  self:EndShow()
  self:ReleaseRenderTexture()
  self:DataDestroy()
end

function AttackMonsterModelShowManager:SetRawImgData(battleImg, battleImgX, battleImgY)
  self.battleImg = battleImg
  self.battleImgX = battleImgX
  self.battleImgY = battleImgY
  if not self.originalRTHeight then
    self.originalRTHeight = battleImgY
  end
  self:ReleaseRenderTexture()
end

function AttackMonsterModelShowManager:ReleaseRenderTexture()
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function AttackMonsterModelShowManager:SetModelShowData(showData)
  self.showData = showData
  self.monsterModelManager:SetModelShowData(showData.monsterData)
  self.weaponModelManager:SetModelShowData(showData.weaponData)
end

function AttackMonsterModelShowManager:SetCurData(curData)
  self.curData = curData
  self.monsterModelManager:SetCurData(curData.monsterData)
end

function AttackMonsterModelShowManager:StartShow(template)
  if self.sceneLoadRequest ~= nil then
    return
  end
  shadowDistance = RenderSetting.GetShadowDistance()
  self:SetCityLightActive(false)
  self:CloseMainCamera()
  RenderSetting.SetShadowDistance(60)
  self:ApplyBanquetShowFog()
  local scene = not (template == nil or string.IsNullOrEmpty(template.scene)) and template.scene or ScenePathDefault
  self:CreateLevel(scene)
end

function AttackMonsterModelShowManager:EndShow()
  if shadowDistance ~= nil then
    RenderSetting.SetShadowDistance(shadowDistance)
  end
  self:RestoreFog()
  self:SetCityLightActive(true)
  self:RecoverMainCamera()
  self:UnInitCamera()
  self.bulletsAndEffectsModelManager:EndShow()
  self.monsterModelManager:EndShow()
  self.weaponModelManager:EndShow()
  if self.sceneLoadRequest then
    self.sceneLoadRequest:Destroy()
    self.sceneLoadRequest = nil
  end
end

function AttackMonsterModelShowManager:CreateLevel(scene)
  self.sceneLoadRequest = nil
  local req = Resource:InstantiateAsync(scene)
  req:completed("+", function()
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_localPosition(0, 0, 0)
    self.scene = req.gameObject
    self.cameraRoot = self.scene.transform:Find("A_Mongster@Boss_xueren_cam_show_Variant/root/cam/Camera")
    local qianBoxObj = self.scene.transform:Find("qian")
    local have, componentQian = qianBoxObj:TryGetComponent(typeof(CS.UnityEngine.MeshRenderer))
    self.qianRender = componentQian
    if self.qianRender then
      self:QianRenderSetAlpha(0 < DataCenter.ActBanquetV2Data.blood and 1 or 0)
    end
    local houRenderObj = self.scene.transform:Find("hou")
    local have1, componentHou = houRenderObj:TryGetComponent(typeof(CS.UnityEngine.MeshRenderer))
    self.houRender = componentHou
    local jinRenderObj = self.scene.transform:Find("jin")
    local have2, componentJin = jinRenderObj:TryGetComponent(typeof(CS.UnityEngine.MeshRenderer))
    self.jinRender = componentJin
    if self.jinRender then
      self:JinRenderSetAlpha(0 < DataCenter.ActBanquetV2Data.blood and 0 or 1)
    end
    local have3, componentShMapping = self.scene.transform:TryGetComponent(typeof(CS.ShMapping))
    self.shMapping = componentShMapping
    self.cameraAni = self.scene.transform:Find("A_Mongster@Boss_xueren_cam_show_Variant"):GetComponent(typeof(CS.SimpleAnimation))
    self:OnLoadedScene()
  end)
  self.sceneLoadRequest = req
end

function AttackMonsterModelShowManager:OnLoadedScene()
  self:ApplyBanquetShowFog()
  self:InitCamera()
  self.monsterModelManager:StartShow(self)
  self.weaponModelManager:StartShow(self)
  self.bulletsAndEffectsModelManager:StartShow(self)
  local showHouRender = DataCenter.ActBanquetV2Data.blood > 0
  self:ShowHouBoxRender(showHouRender)
  if not showHouRender then
    self:PlayCameraPushIdle()
  else
    self:PlayCameraPullIdle()
  end
  EventManager:GetInstance():Broadcast(EventId.BanquetLevelCreateSuccess)
end

function AttackMonsterModelShowManager:SaveFogBackup()
  if self.fogBackup ~= nil then
    return
  end
  self.fogBackup = {
    fog = RenderSettings.fog,
    fogColor = RenderSettings.fogColor,
    fogMode = RenderSettings.fogMode,
    fogStartDistance = RenderSettings.fogStartDistance,
    fogEndDistance = RenderSettings.fogEndDistance,
    fogDensity = RenderSettings.fogDensity
  }
end

function AttackMonsterModelShowManager:ApplyBanquetShowFog()
  self:SaveFogBackup()
  RenderSettings.fog = true
  RenderSettings.fogMode = FogMode.Linear
  RenderSettings.fogColor = CS.UnityEngine.Color.New(0.6666666666666666, 0.7843137254901961, 0.9803921568627451, 1)
  RenderSettings.fogStartDistance = 46
  RenderSettings.fogEndDistance = 57.5
  self.isFogApplied = true
end

function AttackMonsterModelShowManager:RestoreFog()
  if not self.fogBackup then
    self.isFogApplied = false
    return
  end
  if not self.isFogApplied then
    return
  end
  RenderSettings.fog = self.fogBackup.fog
  RenderSettings.fogColor = self.fogBackup.fogColor
  RenderSettings.fogMode = self.fogBackup.fogMode
  RenderSettings.fogStartDistance = self.fogBackup.fogStartDistance
  RenderSettings.fogEndDistance = self.fogBackup.fogEndDistance
  RenderSettings.fogDensity = self.fogBackup.fogDensity
  self.isFogApplied = false
end

function AttackMonsterModelShowManager:InitCamera()
  self.camera = self.cameraRoot:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
  if not self.baseFOV then
    self.baseFOV = self.camera.fieldOfView
  end
  if self.battleImg and self.battleImg.rectTransform then
    local rtImgWidth = self.battleImg.rectTransform.rect.width
    local rtImgHeight = self.battleImg.rectTransform.rect.height
    if 0 < rtImgWidth and 0 < rtImgHeight then
      self:ReleaseRenderTexture()
      local maxHeight = DefaultScreenHeight
      local newHeight = math.min(rtImgHeight, maxHeight)
      local newWidth = newHeight / (rtImgHeight / rtImgWidth)
      local rtWidth = math.floor(newWidth)
      local rtHeight = math.floor(newHeight)
      local rtFormat = RenderTextureFormat.ARGB32
      self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
      self.battleImg:SetTexture(self.renderTexture)
      self.battleImg:SetUVRectPositionAndSize(0, 0, 1, 1)
      self:AdjustCameraFOVByRTSize(rtWidth, rtHeight)
      if self.camera then
        local rtAspect = rtWidth / rtHeight
        self.camera.aspect = rtAspect
      end
    end
  end
  if self.camera and self.renderTexture then
    self.camera.targetTexture = self.renderTexture
    if not (self.battleImg and self.battleImg.rectTransform and self.battleImg.rectTransform.rect.width > 0) or not (self.battleImg.rectTransform.rect.height > 0) then
      local rtAspect = self.renderTexture.width / self.renderTexture.height
      self.camera.aspect = rtAspect
    end
  end
end

function AttackMonsterModelShowManager:UnInitCamera()
  if self.camera then
    self:CoverCameraFOV()
    self.camera.targetTexture = nil
    self.camera = nil
  end
end

function AttackMonsterModelShowManager:SetCityLightActive(val)
  local light = CS.UnityEngine.GameObject.Find(LightPath)
  if light ~= nil then
    light:SetActive(val)
  end
end

function AttackMonsterModelShowManager:CloseMainCamera()
  self.mainCamera = Camera.main
  local curCullingMask = self.mainCamera.cullingMask
  if curCullingMask and curCullingMask ~= 0 then
    self.mainCullingMask = curCullingMask
  else
    self.mainCullingMask = nil
  end
  self.mainCamera.cullingMask = 0
end

function AttackMonsterModelShowManager:RecoverMainCamera()
  if self.mainCamera ~= nil and self.mainCullingMask ~= nil then
    self.mainCamera.cullingMask = self.mainCullingMask
  end
end

function AttackMonsterModelShowManager:OnUpdate()
  local deltaTime = Time.deltaTime
  self.monsterModelManager:OnUpdate(deltaTime)
  self.weaponModelManager:OnUpdate(deltaTime)
  self.bulletsAndEffectsModelManager:OnUpdate(deltaTime)
end

function AttackMonsterModelShowManager:BulletDataStart(data)
  self.weaponModelManager:BulletDataStart(data)
end

function AttackMonsterModelShowManager:TryBulletModelStart(data)
  self.bulletsAndEffectsModelManager:TryBulletModelStart(data)
end

function AttackMonsterModelShowManager:HouFadeOut(duration)
  if not self.houRender or IsNull(self.houRender) then
    return
  end
  self.houRender.material:DOKill()
  self:FadeInOrOut(self.houRender.material, 0, duration)
end

function AttackMonsterModelShowManager:HouFadeIn(duration)
  if not self.houRender or IsNull(self.houRender) then
    return
  end
  self.houRender.material:DOKill()
  self:FadeInOrOut(self.houRender.material, 1, duration)
end

function AttackMonsterModelShowManager:FadeInOrOut(material, endValue, duration)
  duration = duration or 1.0
  local startColor = material.color
  local startAlpha = startColor.a
  CS.DG.Tweening.DOTween.To(function(value)
    local newColor = CS.UnityEngine.Color.New(startColor.r, startColor.g, startColor.b, value)
    material.color = newColor
  end, startAlpha, endValue, duration):SetEase(CS.DG.Tweening.Ease.OutQuad)
end

function AttackMonsterModelShowManager:ShowHouBoxRender(showBox)
  if self.houRender and not IsNull(self.houRender) then
    local targetAlpha = 0
    if showBox then
      targetAlpha = 1
    end
    local material = self.houRender.material
    local startColor = material.color
    local newColor = CS.UnityEngine.Color.New(startColor.r, startColor.g, startColor.b, targetAlpha)
    self.houRender.material.color = newColor
  end
end

function AttackMonsterModelShowManager:AdjustCameraFOVByRTSize(rtWidth, rtHeight)
  if not (self.camera and self.baseFOV) or not self.originalRTHeight then
    return
  end
  local heightRatio = rtHeight / self.originalRTHeight
  local newFOV = self.baseFOV * heightRatio
  self.camera.fieldOfView = newFOV
end

function AttackMonsterModelShowManager:CoverCameraFOV()
  if not self.camera or not self.baseFOV then
    return
  end
  self.camera.fieldOfView = self.baseFOV
end

function AttackMonsterModelShowManager:RefreshScene()
  if self.shMapping and not IsNull(self.shMapping) then
    self.shMapping.enabled = false
    self.shMapping.enabled = true
  end
end

function AttackMonsterModelShowManager:PlayShowMonsterCameraAni()
  self.cameraAni:PlayQueued("cameraShow")
end

function AttackMonsterModelShowManager:PlayShowMonsterCameraPush()
  if self.cameraAni then
    if self.cameraAni:IsPlaying("camera_push") then
      self.cameraAni:Rewind("camera_push")
    else
      self.cameraAni:Play("camera_push")
    end
  end
  self:RenderDOPush()
end

function AttackMonsterModelShowManager:PlayShowMonsterCameraPull()
  if self.cameraAni then
    if self.cameraAni:IsPlaying("camera_pull") then
      self.cameraAni:Rewind("camera_pull")
    else
      self.cameraAni:Play("camera_pull")
    end
  end
  self:RenderDOPull()
end

function AttackMonsterModelShowManager:RenderDOPush()
  if not self.houRender or IsNull(self.houRender) then
    return
  end
  if not self.qianRender or IsNull(self.qianRender) then
    return
  end
  if not self.jinRender or IsNull(self.jinRender) then
    return
  end
  local perFrameTime = 0.03333333333333333
  local frameDuration = 5 * perFrameTime
  TimerManager:GetInstance():DelayInvoke(function()
    if self.qianRender and not IsNull(self.qianRender) then
      self.qianRender.material:DOKill()
      self:FadeInOrOut(self.qianRender.material, 0, frameDuration * 5)
    end
  end, perFrameTime * 15)
  TimerManager:GetInstance():DelayInvoke(function()
    if self.houRender and not IsNull(self.houRender) then
      self.houRender.material:DOKill()
      self:FadeInOrOut(self.houRender.material, 0, frameDuration)
    end
  end, perFrameTime * 12)
  TimerManager:GetInstance():DelayInvoke(function()
    if self.jinRender and not IsNull(self.jinRender) then
      self.jinRender.material:DOKill()
      self:FadeInOrOut(self.jinRender.material, 1, frameDuration)
    end
  end, perFrameTime * 17)
end

function AttackMonsterModelShowManager:RenderDOPull()
  if not self.houRender or IsNull(self.houRender) then
    return
  end
  if not self.qianRender or IsNull(self.qianRender) then
    return
  end
  if not self.jinRender or IsNull(self.jinRender) then
    return
  end
  local perFrameTime = 0.03333333333333333
  self:QianRenderSetAlpha(1)
  if self.houRender and not IsNull(self.houRender) then
    self.houRender.material:DOKill()
    self:FadeInOrOut(self.houRender.material, 1, perFrameTime * 5)
  end
  if self.jinRender and not IsNull(self.jinRender) then
    self.jinRender.material:DOKill()
    self:FadeInOrOut(self.jinRender.material, 0, perFrameTime * 3)
  end
end

function AttackMonsterModelShowManager:QianRenderSetAlpha(target)
  if not self.qianRender or IsNull(self.qianRender) then
    return
  end
  local material = self.qianRender.material
  local startColor = material.color
  local startAlpha = target
  local newColor = CS.UnityEngine.Color.New(startColor.r, startColor.g, startColor.b, startAlpha)
  self.qianRender.material.color = newColor
end

function AttackMonsterModelShowManager:JinRenderSetAlpha(target)
  if not self.jinRender or IsNull(self.jinRender) then
    return
  end
  local material = self.jinRender.material
  local startColor = material.color
  local startAlpha = target
  local newColor = CS.UnityEngine.Color.New(startColor.r, startColor.g, startColor.b, startAlpha)
  material.color = newColor
end

function AttackMonsterModelShowManager:ShowWeapon(show)
  if self.weaponModelManager and self.weaponModelManager.weapon and not IsNull(self.weaponModelManager.weapon) then
    self.weaponModelManager.weapon:SetActive(show)
  end
end

function AttackMonsterModelShowManager:PlayCameraPushIdle()
  if self.cameraAni then
    if self.cameraAni:IsPlaying("camera_pushIdle") then
      self.cameraAni:Rewind("camera_pushIdle")
    else
      self.cameraAni:Play("camera_pushIdle")
    end
  end
end

function AttackMonsterModelShowManager:PlayCameraPullIdle()
  if self.cameraAni then
    if self.cameraAni:IsPlaying("camera_pullIdle") then
      self.cameraAni:Rewind("camera_pullIdle")
    else
      self.cameraAni:Play("camera_pullIdle")
    end
  end
end

return AttackMonsterModelShowManager
