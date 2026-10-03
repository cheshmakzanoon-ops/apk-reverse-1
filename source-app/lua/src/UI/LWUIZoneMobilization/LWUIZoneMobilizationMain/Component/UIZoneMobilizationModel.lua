local UIZoneMobilizationModel = BaseClass("UIZoneMobilizationModel", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local GameQualitySettings = require("Util.GameQualitySettings")
local effectPath = "Assets/Main/Prefabs/BuildEffect/MainBuild/%s.prefab"
local worldModelPath = "Model/WorldModel"
local UIModelPath = {
  [Draw2DUIModelType.Airship] = "Assets/Main/Prefabs/Building/A_build_jiluofu_feiting_UI.prefab"
}
local GuaDianPath = {
  [Draw2DUIModelType.Airship] = "A_build_jiluofu_longmendiao_skin/To_unity/DeformationSystem/Root/GuaDian"
}
local InstancePos = {
  [Draw2DUIModelType.Airship] = {
    0,
    0,
    0
  }
}
local EffectRootPath = {
  [1] = "A_build_jiluofu_longmendiao_skin/To_unity/DeformationSystem/Root",
  [2] = "A_build_jiluofu_feiting_03_skin/To_unity/DeformationSystem/Root/Roo_z/Root_M"
}

function UIZoneMobilizationModel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIZoneMobilizationModel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIZoneMobilizationModel:ComponentDefine()
  self.rawImage = self:AddComponent(UIRawImage, "")
  if self.rawImage ~= nil then
    self.rawImage:SetColorRGBA(1, 1, 1, 0)
    self.rawImage:SetActive(false)
  end
end

function UIZoneMobilizationModel:ComponentDestroy()
  self.rawImage = nil
end

function UIZoneMobilizationModel:DataDefine()
  self.camera = nil
  self.citySlot = nil
  self.rtLen = 1080
  self.buildingAnim = nil
  self.cameraDefaultPara = nil
  self.request = nil
  self.modelNode = nil
  self.subNode = nil
  self.modelType = nil
  self.worldModel = nil
  self.allEffect = {}
  self.isFirstInit = true
end

function UIZoneMobilizationModel:DataDestroy()
  self:ReleaseTexture()
  self.camera = nil
  self.citySlot = nil
  self:ResetNode()
  self:DestroyModel()
  self:DestroyScene()
  self.rtLen = nil
  self.buildingAnim = nil
  self.cameraDefaultPara = nil
  self.modelType = nil
  self:ClearEffect()
  self.allEffect = nil
  self.isFirstInit = nil
end

function UIZoneMobilizationModel:DestroyScene()
  if self.scene ~= nil then
    self.scene:Destroy()
    self.scene = nil
  end
end

function UIZoneMobilizationModel:ReleaseTexture()
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  self.rawImage:SetTexture(nil)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
end

function UIZoneMobilizationModel:OnEnable()
  base.OnEnable(self)
  if self.scene and not IsNull(self.scene.gameObject) then
    self.scene.gameObject:SetActive(true)
  end
end

function UIZoneMobilizationModel:OnDisable()
  if self.scene and not IsNull(self.scene.gameObject) then
    self.scene.gameObject:SetActive(false)
  end
  base.OnDisable(self)
end

function UIZoneMobilizationModel:Init(modelType)
  self.modelType = modelType
end

function UIZoneMobilizationModel:ReInit(nodePathStr, showEffectList, animName)
  self:LoadScene(nodePathStr, showEffectList, animName)
end

function UIZoneMobilizationModel:ShowMainEffect(effectId)
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
  self.effectParent = req.gameObject.transform:Find(worldModelPath)
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

function UIZoneMobilizationModel:LoadBuilding(nodePathStr, showEffectList, animName)
  if self.request then
    self:ShowModel(nodePathStr, showEffectList, animName)
  elseif not string.IsNullOrEmpty(nodePathStr) then
    local modelPath = UIModelPath[self.modelType]
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
      local posArr = InstancePos[self.modelType]
      trans:Set_localPosition(posArr[1], posArr[2], posArr[3])
      self.worldModel = trans:Find(worldModelPath)
      self:ShowModel(nodePathStr, showEffectList, animName)
    end)
  else
    self:ShowModel(nodePathStr, showEffectList, animName)
  end
end

local function ShowModel(self, nodePathStr, showEffectList, animName)
  self:ResetNode()
  if self.worldModel == nil then
    return
  end
  if not string.IsNullOrEmpty(nodePathStr) then
    local nodeArr = string.split(nodePathStr, ",")
    if 1 < #nodeArr then
      local node = self.worldModel:Find(nodeArr[1])
      if node then
        node.gameObject:SetActive(true)
        local subNode = node:Find(GuaDianPath[self.modelType] .. "/" .. nodeArr[2])
        if subNode then
          subNode.gameObject:SetActive(true)
          self.subNode = subNode.gameObject
        end
        self.modelNode = node.gameObject
      end
    else
      if self.subNode then
        self.subNode:SetActive(false)
        self.subNode = nil
      end
      local node = self.worldModel:Find(nodeArr[1])
      if node then
        node.gameObject:SetActive(true)
        self.modelNode = node.gameObject
      end
    end
  end
  if self.modelNode then
    self.buildingAnim = self.modelNode:GetComponentInChildren(typeof(CS.SimpleAnimation))
  end
  if animName then
    self:PlayAnimation(animName)
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

function UIZoneMobilizationModel:TryLoadChangeEffect()
end

function UIZoneMobilizationModel:DestroyModel()
  if self.effectRes then
    self.effectRes:Destroy()
    self.effectRes = nil
  end
  if not IsNull(self.effectParent) then
    self.effectParent = nil
  end
  if self.request ~= nil then
    self.request:Destroy()
    self.request = nil
  end
  self.modelNode = nil
  self.subNode = nil
  self.worldModel = nil
end

function UIZoneMobilizationModel:OnRenderTexture(camera)
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

function UIZoneMobilizationModel:LoadScene(nodePathStr, showEffectList, animName)
  if self.scene == nil then
    local scene = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UIModelScene/UIZoneMobilizationModelScene.prefab")
    self.scene = scene
    scene:completed("+", function()
      if scene.isError then
        return
      end
      local go = scene.gameObject
      go.name = "UIZoneMobilizationModelScene"
      go:SetActive(true)
      local trans = go.transform
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      trans.position = Vector3.New(2000, 2000, 2000)
      self.camera = trans:Find("Camera"):GetComponentInChildren(typeof(Camera))
      self.citySlot = trans:Find("CitySlot")
      self.cameraDefaultPara = trans:Find("CameraDefaultPara")
      self:OnRenderTexture(self.camera)
      go:SetActive(true)
      self:LoadBuilding(nodePathStr, showEffectList, animName)
    end)
  elseif self.camera ~= nil then
    self:LoadBuilding(nodePathStr, showEffectList, animName)
  end
end

function UIZoneMobilizationModel:SetRTLen(len)
  self.rtLen = len
end

function UIZoneMobilizationModel:PlayAnimation(animName)
  if string.IsNullOrEmpty(animName) then
    return
  end
  if not IsNull(self.buildingAnim) then
    local aniState = self.buildingAnim:GetState(animName)
    if not IsNull(aniState) then
      self.buildingAnim:Stop()
      self.buildingAnim:SampleAnimationAtTime(animName, 0)
      self.buildingAnim:Play(animName)
    end
  end
end

local function ResetNode(self)
  if self.subNode then
    self.subNode:SetActive(false)
    self.subNode = nil
  end
  if self.modelNode then
    self.modelNode:SetActive(false)
    self.modelNode = nil
  end
  self.buildingAnim = nil
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
        for i, v in ipairs(EffectRootPath) do
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

local function RemoveEffect(self, flag)
  local data = self.allEffect[flag]
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

UIZoneMobilizationModel.ShowModel = ShowModel
UIZoneMobilizationModel.ResetNode = ResetNode
UIZoneMobilizationModel.PlayEffect = PlayEffect
UIZoneMobilizationModel.InstantiateAsync = InstantiateAsync
UIZoneMobilizationModel.RemoveEffect = RemoveEffect
UIZoneMobilizationModel.ClearEffect = ClearEffect
return UIZoneMobilizationModel
