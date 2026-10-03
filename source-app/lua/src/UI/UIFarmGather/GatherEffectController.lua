local GatherEffectController = BaseClass("GatherEffectController", Singleton)
local GatherEffect = require("UI.UIFarmGather.Component.GatherEffect")
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self.list = {}
  self:AddListener()
end

local function __delete(self)
  self.list = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.GatherEffectEnd, self.OnFlyComplete)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.GatherEffectEnd, self.OnFlyComplete)
end

local function AddOneEffect(self, pointIndex)
  if self.list[pointIndex] == nil then
    local request = ResourceManager:InstantiateAsync(UIAssets.GatherEffectStar)
    request:completed("+", function()
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(2, 2, 2)
      request.gameObject.name = "GatherEffect_" .. pointIndex
      local tmp = GatherEffect.New()
      tmp:OnCreate(request)
      tmp:ReInit(pointIndex)
      self.list[pointIndex] = tmp
    end)
  else
    self.list[pointIndex]:ReInit(pointIndex)
    self.list[pointIndex].gameObject:SetActive(true)
  end
end

local function OnFlyComplete(pointIndex)
  GatherEffectController:GetInstance():RemoveOneEffect(pointIndex)
end

local function RemoveOneEffect(self, pointIndex)
  if self.list ~= nil and self.list[pointIndex] ~= nil then
    self.list[pointIndex]:OnDestroy()
    self.list[pointIndex].request:Destroy()
    self.list[pointIndex] = nil
  end
end

local function RemoveAllEffect(self, pointIndex)
  if self.list ~= nil then
    table.walk(self.list, function(k, v)
      self.list[pointIndex]:OnDestroy()
      self.list[pointIndex].request:Destroy()
    end)
  end
  self.list = {}
end

GatherEffectController.__init = __init
GatherEffectController.__delete = __delete
GatherEffectController.AddListener = AddListener
GatherEffectController.RemoveListener = RemoveListener
GatherEffectController.AddOneEffect = AddOneEffect
GatherEffectController.OnFlyComplete = OnFlyComplete
GatherEffectController.RemoveOneEffect = RemoveOneEffect
GatherEffectController.RemoveAllEffect = RemoveAllEffect
return GatherEffectController
