local UIModelShowCtrl = BaseClass("UIModelShowCtrl", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local GameQualitySettings = require("Util.GameQualitySettings")
local EFFECT_PATH = "Assets/Main/Prefabs/BuildEffect/MainBuild/%s.prefab"
local WORLD_MODEL_PATH = "Model/WorldModel"
local UI_MODEL_SCENE_PATH = {
  [Draw2DUIModelType.Airship] = "Assets/Main/Prefabs/UIModelScene/UIZoneMobilizationModelScene.prefab",
  [Draw2DUIModelType.KillZombieKirov] = "Assets/Main/Prefabs/UIModelScene/UIKillZombieModelScene.prefab",
  [Draw2DUIModelType.KillZombieBox] = "Assets/Main/Prefabs/UIModelScene/UIKillZombieModelScene.prefab",
  [Draw2DUIModelType.KillZombieBoxUpgrade] = "Assets/Main/Prefabs/UIModelScene/UIKillZombieBoxModelScene.prefab"
}
local UI_MODEL_PATH = {
  [Draw2DUIModelType.Airship] = "Assets/Main/Prefabs/Building/A_build_jiluofu_feiting_UI.prefab",
  [Draw2DUIModelType.KillZombieKirov] = "Assets/Main/Prefabs/Monsters/A_Monster_jiluofu_feiting_blue_ui.prefab",
  [Draw2DUIModelType.KillZombieBox] = "Assets/Main/Prefabs/Building/kill_zombie_world_box_ui.prefab",
  [Draw2DUIModelType.KillZombieBoxUpgrade] = "Assets/Main/Prefabs/Building/kill_zombie_world_box_upgrade_ui.prefab"
}
local INSTANCE_POS = {
  [Draw2DUIModelType.Airship] = {
    0,
    0,
    0
  },
  [Draw2DUIModelType.KillZombieBoxUpgrade] = {
    -0.99,
    0.81,
    4.1
  },
  [Draw2DUIModelType.KillZombieBox] = {
    -0.93,
    0,
    0
  }
}
local EFFECT_ROOT_PATH = {
  [Draw2DUIModelType.Airship] = {
    [1] = "A_build_jiluofu_longmendiao_skin/To_unity/DeformationSystem/Root",
    [2] = "A_build_jiluofu_feiting_03_skin/To_unity/DeformationSystem/Root/Roo_z/Root_M"
  },
  [Draw2DUIModelType.KillZombieKirov] = {
    [1] = "A_build_jiluofu_longmendiao_skin/To_unity/DeformationSystem/Root",
    [2] = "A_build_jiluofu_feiting_03_skin/To_unity/DeformationSystem/Root/Roo_z/Root_M"
  }
}
local LOCAL_CAMERA_PATH = "Camera"
local CAMERA_PATH = {
  [Draw2DUIModelType.KillZombieBoxUpgrade] = "DisplayScene_baoxiang/Camera"
}
local LOCAL_SCENE_MODEL_PARENT_PATH = "CitySlot"
local SCENE_MODEL_PARENT_PATH = {
  [Draw2DUIModelType.KillZombieBoxUpgrade] = "DisplayScene_baoxiang/HeroSlot"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.scene and not IsNull(self.scene.gameObject) then
    self.scene.gameObject:SetActive(true)
  end
end

local function OnDisable(self)
  if self.scene and not IsNull(self.scene.gameObject) then
    self.scene.gameObject:SetActive(false)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rawImage = self:AddComponent(UIRawImage, "")
  if self.rawImage ~= nil then
    self.rawImage:SetColorRGBA(1, 1, 1, 0)
    self.rawImage:SetActive(false)
  end
end

local function ComponentDestroy(self)
  self.rawImage = nil
end

local function DataDefine(self)
  self.camera = nil
  self.citySlot = nil
  self.rtLen = 1080
  self.simpleAnimation = nil
  self.request = nil
  self.modelNode = nil
  self.modelType = nil
  self.worldModel = nil
  self.allEffect = {}
  self.isFirstInit = true
end

local function DataDestroy(self)
  self:ReleaseTexture()
  self.camera = nil
  self.citySlot = nil
  self:ResetNode()
  self:DestroyModel()
  self:DestroyScene()
  self.rtLen = nil
  self.simpleAnimation = nil
  self.modelType = nil
  self:ClearEffect()
  self.allEffect = nil
  self.isFirstInit = nil
end

local function DestroyScene(self)
  if self.scene ~= nil then
    self.scene:Destroy()
    self.scene = nil
  end
end

local function ReleaseTexture(self)
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  self.rawImage:SetTexture(nil)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

local function Init(self, modelType)
  self.modelType = modelType
end

local function ReInit(self, nodePathStr, showEffectList, animName, callback, normalizedTime)
  self:LoadScene(nodePathStr, showEffectList, animName, callback, normalizedTime)
end

local function LoadBuilding(self, nodePathStr, showEffectList, animName, callback, normalizedTime)
  if self.request then
    self:TryShowModel(nodePathStr, showEffectList, animName, callback, normalizedTime)
  elseif not string.IsNullOrEmpty(nodePathStr) then
    local modelPath = UI_MODEL_PATH[self.modelType]
    local request = ResourceManager:InstantiateAsync(modelPath)
    self.request = request
    request:completed("+", function()
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      local trans = go.transform
      trans:SetParent(self.citySlot.transform)
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local posArr = INSTANCE_POS[self.modelType] or ResetPosition
      if posArr then
        trans:Set_localPosition(posArr[1], posArr[2], posArr[3])
      end
      trans:Set_localRotation(0, 0, 0, 1)
      self.worldModel = trans:Find(WORLD_MODEL_PATH)
      self:TryShowModel(nodePathStr, showEffectList, animName, callback, normalizedTime)
    end)
  else
    self:TryShowModel(nodePathStr, showEffectList, animName, callback, normalizedTime)
  end
end

local function TryShowModel(self, nodePathStr, showEffectList, animName, callback, normalizedTime)
  self:ResetNode()
  if self.worldModel == nil then
    return
  end
  self:ShowModel(nodePathStr)
  if self.modelNode then
    self.simpleAnimation = self.modelNode:GetComponentInChildren(typeof(CS.SimpleAnimation))
  end
  if animName then
    self:PlayAnimation(animName, callback, normalizedTime)
  else
    self:PlayAnimation("idle")
  end
  self:ClearEffect()
  if showEffectList then
    for i, v in ipairs(showEffectList) do
      self:PlayEffect(v)
    end
  end
end

local function DestroyModel(self)
  if self.request ~= nil then
    self.request:Destroy()
    self.request = nil
  end
  self.modelNode = nil
  self.worldModel = nil
end

local function ShowModel(self, nodePathStr)
end

local function OnRenderTexture(self, camera)
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
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(rtWidth, rtHeight, 24, rtFormat)
    self.renderTexture.name = "UIZoneMobilizationModelShow"
    self.rawImage:SetTexture(self.renderTexture)
    self.rawImage:SetEnable(true)
    if self.rawImage ~= nil then
      self.rawImage:SetColorRGBA(1, 1, 1, 1)
    end
  end
  if self.isFirstInit then
    self.rawImage:SetActive(true)
    self.isFirstInit = false
  end
  camera.targetTexture = self.renderTexture
end

local function LoadScene(self, nodePathStr, showEffectList, animName, callback, normalizedTime)
  if self.scene == nil then
    local scene = ResourceManager:InstantiateAsync(UI_MODEL_SCENE_PATH[self.modelType])
    self.scene = scene
    scene:completed("+", function()
      if scene.isError then
        return
      end
      local go = scene.gameObject
      go:SetActive(true)
      local trans = go.transform
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      trans.position = Vector3.New(2000, 2000, 2000)
      local cameraPath = CAMERA_PATH[self.modelType] or LOCAL_CAMERA_PATH
      self.camera = trans:Find(cameraPath):GetComponentInChildren(typeof(Camera))
      local slotPath = SCENE_MODEL_PARENT_PATH[self.modelType] or LOCAL_SCENE_MODEL_PARENT_PATH
      self.citySlot = trans:Find(slotPath)
      self:OnRenderTexture(self.camera)
      go:SetActive(true)
      self:LoadBuilding(nodePathStr, showEffectList, animName, callback, normalizedTime)
    end)
  elseif self.camera ~= nil then
    self:LoadBuilding(nodePathStr, showEffectList, animName, callback, normalizedTime)
  end
end

local function PlayAnimation(self, animName, callback, normalizedTime)
  if string.IsNullOrEmpty(animName) or self.simpleAnimation == nil then
    return
  end
  self:ClearAnimTimer()
  if callback then
    local length = self.simpleAnimation:GetClipLength(animName)
    if 0 < length then
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        callback()
        self:ClearAnimTimer()
      end, length)
    else
      callback()
    end
  end
  if not IsNull(self.simpleAnimation) then
    local aniState = self.simpleAnimation:GetState(animName)
    if not IsNull(aniState) then
      self.simpleAnimation:Stop()
      self.simpleAnimation:SampleAnimationAtTime(animName, normalizedTime or 0)
      self.simpleAnimation:Play(animName)
    end
  end
end

local function ResetNode(self)
  if self.modelNode then
    self.modelNode:SetActive(false)
    self.modelNode = nil
  end
  self.simpleAnimation = nil
end

local function ClearAnimTimer(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function PlayEffect(self, path, duration, callback, finishCb)
  if path then
    if self.allEffect == nil then
      return
    end
    return self:InstantiateAsync(path, duration, callback, finishCb)
  end
end

local function InstantiateAsync(self, path, duration, callback, finishCb)
  if path then
    local data = self.allEffect[path]
    if not data then
      data = {}
      self.allEffect[path] = data
    else
      self:RemoveEffect(path)
    end
    local req = ResourceManager:InstantiateAsync(path)
    data.request = req
    req:completed("+", function(req)
      if req.isError then
        req:Destroy()
        return
      end
      if self.camera == nil then
        req:Destroy()
        return
      end
      local go = req.gameObject
      local tf = go.transform
      tf.localScale = VecZero
      if self.modelNode then
        local parents = EFFECT_ROOT_PATH[self.modelType]
        for _, v in ipairs(parents) do
          local parent = self.modelNode.transform:Find(v)
          if parent then
            tf.parent = parent
            break
          end
        end
      end
      tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      tf:Set_localRotation(0, 0, 0, 1)
      go:SetActive(true)
      if callback then
        callback()
      end
      tf.localScale = ResetScale
      if duration and 0 < duration then
        local timer = TimerManager:GetInstance():DelayInvoke(function()
          if finishCb then
            finishCb()
          end
          self:RemoveEffect(path)
        end, duration)
        data.delayTimer = timer
      end
      data.effectObj = req.gameObject
    end)
    return req
  end
end

local function RemoveEffect(self, path)
  local data = self.allEffect[path]
  if data ~= nil then
    if data.delayTimer then
      data.delayTimer:Stop()
      data.delayTimer = nil
    end
    if data.request then
      data.request:Destroy()
      data.request = nil
    end
    data.effectObj = nil
  end
end

local function ClearEffect(self)
  if self.allEffect then
    for _, v in pairs(self.allEffect) do
      if v then
        if v.delayTimer then
          v.delayTimer:Stop()
          v.delayTimer = nil
        end
        if v.request then
          v.request:Destroy()
          v.request = nil
        end
        v.effectObj = nil
      end
    end
    self.allEffect = {}
  end
end

UIModelShowCtrl.OnCreate = OnCreate
UIModelShowCtrl.OnDestroy = OnDestroy
UIModelShowCtrl.OnEnable = OnEnable
UIModelShowCtrl.OnDisable = OnDisable
UIModelShowCtrl.ComponentDefine = ComponentDefine
UIModelShowCtrl.ComponentDestroy = ComponentDestroy
UIModelShowCtrl.DataDefine = DataDefine
UIModelShowCtrl.DataDestroy = DataDestroy
UIModelShowCtrl.DestroyScene = DestroyScene
UIModelShowCtrl.ReleaseTexture = ReleaseTexture
UIModelShowCtrl.Init = Init
UIModelShowCtrl.ReInit = ReInit
UIModelShowCtrl.LoadBuilding = LoadBuilding
UIModelShowCtrl.TryShowModel = TryShowModel
UIModelShowCtrl.DestroyModel = DestroyModel
UIModelShowCtrl.ShowModel = ShowModel
UIModelShowCtrl.DestroyModel = DestroyModel
UIModelShowCtrl.OnRenderTexture = OnRenderTexture
UIModelShowCtrl.LoadScene = LoadScene
UIModelShowCtrl.PlayAnimation = PlayAnimation
UIModelShowCtrl.ResetNode = ResetNode
UIModelShowCtrl.ClearAnimTimer = ClearAnimTimer
UIModelShowCtrl.PlayEffect = PlayEffect
UIModelShowCtrl.InstantiateAsync = InstantiateAsync
UIModelShowCtrl.RemoveEffect = RemoveEffect
UIModelShowCtrl.ClearEffect = ClearEffect
return UIModelShowCtrl
