local BuildCanUpgradeEffectManager = BaseClass("BuildCanUpgradeEffectManager")
local ResourceManager = CS.GameEntry.Resource
local BuildCanUpgradeEffect = require("UI.BuildCanUpgradeEffect.BuildCanUpgradeEffect")

local function __init(self)
  self.allEffect = {}
  self.freeEffect = {}
  self.hasListener = false
  self:AddListener()
end

local function __delete(self)
  if self.allEffect then
    for k, v in pairs(self.allEffect) do
      local request = v.request
      v.script:OnDestroy()
      request:Destroy()
    end
    self.allEffect = nil
  end
  if self.freeEffect then
    for k, v in pairs(self.freeEffect) do
      local request = v.request
      v.script:OnDestroy()
      request:Destroy()
    end
    self.freeEffect = nil
  end
  if self.hasListener then
    self:RemoveListener()
  end
end

local function Startup()
end

local function AddListener(self)
  self.hasListener = true
  EventManager:GetInstance():AddListener(EventId.RefreshItems, self.OnRefreshSignal)
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.OnRefreshSignal)
  EventManager:GetInstance():AddListener(EventId.ResourceUpdated, self.OnRefreshSignal)
end

local function RemoveListener(self)
  self.hasListener = false
  EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.OnRefreshSignal)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.OnRefreshSignal)
  EventManager:GetInstance():RemoveListener(EventId.ResourceUpdated, self.OnRefreshSignal)
end

local function ShowOneEffect(self, bUuid, posIndex, tileX, tileY)
  local param = {}
  param.tileX = tileX
  param.tileY = tileY
  param.posIndex = posIndex
  if #self.freeEffect > 0 then
    local temp = table.remove(self.freeEffect)
    if temp ~= nil then
      temp.script.gameObject:SetActive(true)
      temp.script:ReInit(param)
      self.allEffect[bUuid] = temp
    end
  else
    local request = ResourceManager:InstantiateAsync(UIAssets.BuildCanUpgradeEffect)
    local par = {}
    par.request = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local buildCanUpgradeEffect = BuildCanUpgradeEffect.New()
      buildCanUpgradeEffect:OnCreate(request)
      buildCanUpgradeEffect:ReInit(param)
      par.script = buildCanUpgradeEffect
      self.allEffect[bUuid] = par
    end)
  end
end

local function RemoveOneEffect(self, bUuid)
  local temp = self.allEffect[bUuid]
  if temp ~= nil then
    temp.script.gameObject:SetActive(false)
    table.insert(self.freeEffect, temp)
    self.allEffect[bUuid] = nil
  end
end

local function OnRefreshSignal()
  DataCenter.BuildCanUpgradeEffectManager:CheckAllEffect()
end

local function CheckAllEffect(self)
  for k, v in pairs(self.allEffect) do
    if v.script ~= nil then
      v.script.gameObject:SetActive(false)
      table.insert(self.freeEffect, v)
    end
  end
  self.allEffect = {}
  local allBUuid = DataCenter.BuildManager.inViewBuild
  for k, v in pairs(allBUuid) do
    self:CheckShowEffect(k)
  end
end

local function CheckShowEffect(self, bUuid)
  do return end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil and buildData.updateTime <= 0 then
    local level = buildData.level
    local buildId = buildData.itemId
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if buildTemplate ~= nil and level < buildTemplate.max_level then
      local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if buildLevelTemplate ~= nil then
        if not buildLevelTemplate:IsPreBuildConditionValid() then
          return
        end
        local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(bUuid)
        if not ret.enough then
          return
        end
        self:ShowOneEffect(bUuid, buildData.pointId, buildTemplate.tileX, buildTemplate.tileY)
      end
    end
  end
end

local function TryShowOneEffect(self, bUuid)
  self:RemoveOneEffect(bUuid)
  self:CheckShowEffect(bUuid)
end

BuildCanUpgradeEffectManager.__init = __init
BuildCanUpgradeEffectManager.__delete = __delete
BuildCanUpgradeEffectManager.Startup = Startup
BuildCanUpgradeEffectManager.AddListener = AddListener
BuildCanUpgradeEffectManager.RemoveListener = RemoveListener
BuildCanUpgradeEffectManager.ShowOneEffect = ShowOneEffect
BuildCanUpgradeEffectManager.OnRefreshSignal = OnRefreshSignal
BuildCanUpgradeEffectManager.RemoveOneEffect = RemoveOneEffect
BuildCanUpgradeEffectManager.CheckShowEffect = CheckShowEffect
BuildCanUpgradeEffectManager.CheckAllEffect = CheckAllEffect
BuildCanUpgradeEffectManager.TryShowOneEffect = TryShowOneEffect
return BuildCanUpgradeEffectManager
