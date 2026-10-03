local BuildFixEffectManager = BaseClass("BuildFixEffectManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local BuildFixEffect = require("Scene.BuildFixEffect.BuildFixEffect")

local function __init(self)
  self.allEffect = {}
  self.OnCreateEffect = {}
  self:AddListener()
end

local function __delete(self)
  for k, v in pairs(self.allEffect) do
    local request = v.request
    v.script:OnDestroy()
    request:Destroy()
  end
  for k, v in pairs(self.OnCreateEffect) do
    if v ~= nil then
      v:Destroy()
    end
  end
  self.allEffect = nil
  self.OnCreateEffect = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.ShowBuildFixEffect, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.BUILD_OUT_VIEW, self.BuildOutViewSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.ShowBuildFixEffect, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_OUT_VIEW, self.BuildOutViewSignal)
end

local function ShowBuildFixEffect(self, bUuid, posIndex, tileX, tileY)
  local param = {}
  param.bUuid = bUuid
  param.tileX = tileX
  param.tileY = tileY
  param.posIndex = posIndex
  if self.allEffect[bUuid] == nil and self.OnCreateEffect[bUuid] == nil then
    local modelName = "Assets/_Art/Effect/prefab/scene/VFX_feiqu_xiufu_" .. tile .. ".prefab"
    local request = ResourceManager:InstantiateAsync(modelName)
    local par = {}
    par.request = request
    self.OnCreateEffect[bUuid] = request
    request:completed("+", function()
      self.OnCreateEffect[bUuid] = nil
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local effect = BuildFixEffect.New()
      effect:OnCreate(request)
      effect:ReInit(param)
      par.script = effect
      self.allEffect[bUuid] = par
    end)
  end
end

local function RemoveOneEffect(self, bUuid)
  local temp = self.allEffect[bUuid]
  if temp ~= nil then
    local request = temp.request
    temp.script:OnDestroy()
    request:Destroy()
    self.allEffect[bUuid] = nil
  end
  if self.OnCreateEffect[bUuid] ~= nil then
    local request = self.OnCreateEffect[bUuid]
    request:Destroy()
    self.OnCreateEffect[bUuid] = nil
  end
end

local function BuildInViewSignal(uuid)
  BuildFixEffectManager:GetInstance():CheckShowEffect(tonumber(uuid))
end

local function BuildOutViewSignal(uuid)
  BuildFixEffectManager:GetInstance():RemoveOneEffect(tonumber(uuid))
end

local function CheckShowEffect(self, bUuid)
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info ~= nil then
    cast(info, typeof(CS.BuildPointInfo))
    if info.destroyStartTime <= 0 then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
      if buildTemplate ~= nil then
        self:ShowBuildFixEffect(bUuid, info.mainIndex, buildTemplate.tileX, buildTemplate.tileY)
      end
    else
      self:RemoveOneEffect(bUuid)
    end
  end
end

BuildFixEffectManager.__init = __init
BuildFixEffectManager.__delete = __delete
BuildFixEffectManager.AddListener = AddListener
BuildFixEffectManager.RemoveListener = RemoveListener
BuildFixEffectManager.BuildInViewSignal = BuildInViewSignal
BuildFixEffectManager.BuildOutViewSignal = BuildOutViewSignal
BuildFixEffectManager.RemoveOneEffect = RemoveOneEffect
BuildFixEffectManager.CheckShowEffect = CheckShowEffect
BuildFixEffectManager.ShowBuildFixEffect = ShowBuildFixEffect
return BuildFixEffectManager
