local AirDropGarbageManager = BaseClass("AirDropGarbageManager")
local ResourceManager = CS.GameEntry.Resource
local AirDropGarbage = require("Scene.AirDropGarbage.AirDropGarbage")
local ShowAirDropScene = require("Scene.AirDropGarbage.ShowAirDropScene")

function AirDropGarbageManager:__init()
  self.model = {}
  self.scene = {}
  self.useGuideTimelineMarker = false
  self:AddListener()
end

function AirDropGarbageManager:__delete()
  self.model = {}
  self.scene = {}
  self.useGuideTimelineMarker = false
  self:RemoveListener()
  self:DestroyAllObject()
end

function AirDropGarbageManager:Startup()
end

function AirDropGarbageManager:AddListener()
  function self.OnTimelineMarker(id)
    self:OnTimelineMarkerSignal(id)
  end
  
  EventManager:GetInstance():AddListener(EventId.GuideTimelineMarker, self.OnTimelineMarker)
end

function AirDropGarbageManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.GuideTimelineMarker, self.OnTimelineMarker)
  self.OnTimelineMarker = nil
end

function AirDropGarbageManager:LoadShowGarbageScene()
  self.useGuideTimelineMarker = true
  DataCenter.GuideManager:SetNoShowUIMain(true)
  local request = ResourceManager:InstantiateAsync(UIAssets.ShowAirDropScene)
  local para = {}
  self.scene = para
  para.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local effect = ShowAirDropScene.New()
    effect:OnCreate(request)
    para.model = effect
    effect:ReInit()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_guide_air_drop, false)
  end)
end

function AirDropGarbageManager:DestroyAllObject()
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v.model ~= nil then
        v.model:OnDestroy()
      end
      if v.request ~= nil then
        v.request:Destroy()
      end
    end
    self.model = {}
  end
end

function AirDropGarbageManager:DestroyAirDrop(pointId)
  if self.model ~= nil and self.model[pointId] ~= nil then
    if self.model[pointId].model ~= nil then
      self.model[pointId].model:OnDestroy()
    end
    if self.model[pointId].request ~= nil then
      self.model[pointId].request:Destroy()
    end
    self.model[pointId] = nil
  end
end

function AirDropGarbageManager:LoadAirGarbage()
  local list = CS.SceneManager.World:GetGarbagePoint()
  if list ~= nil and list.Count > 0 then
    for i = 0, list.Count - 1 do
      local request = ResourceManager:InstantiateAsync(UIAssets.AirDropGarbage)
      local para = {}
      self.model[list[i]] = para
      local param = {}
      param.pointId = list[i]
      para.request = request
      request:completed("+", function()
        if request.isError then
          return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local effect = AirDropGarbage.New()
        effect:OnCreate(request)
        para.model = effect
        effect:ReInit(param)
      end)
    end
  end
  DataCenter.GuideManager:DoNext()
end

function AirDropGarbageManager:DestroyScene()
  self.useGuideTimelineMarker = false
  DataCenter.GuideManager:SetNoShowUIMain(false)
  if self.scene ~= nil then
    if self.scene.model ~= nil then
      self.scene.model:OnDestroy()
    end
    if self.scene.request ~= nil then
      self.scene.request:Destroy()
    end
    self.scene = nil
  end
end

function AirDropGarbageManager:OnTimelineMarkerSignal(id)
  if self.useGuideTimelineMarker and id == GuideTimeLineShowMarkerType.End then
    self:DestroyScene()
    self:LoadAirGarbage()
  end
end

return AirDropGarbageManager
