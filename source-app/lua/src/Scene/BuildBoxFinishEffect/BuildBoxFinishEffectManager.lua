local BuildBoxFinishEffectManager = BaseClass("BuildBoxFinishEffectManager", Singleton)
local BuildBoxFinishEffect = require("Scene.BuildBoxFinishEffect.BuildBoxFinishEffect")
local ResourceManager = CS.GameEntry.Resource

local function __init(self)
  self.allEffect = {}
  self:AddListener()
end

local function __delete(self)
  self.allEffect = nil
  self:RemoveListener()
end

local function BuildBoxOpenFinishSignal(data)
  local bUuid = tonumber(data)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if info ~= nil then
    local pointId = info.pointId
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
    if buildTemplate ~= nil then
      BuildBoxFinishEffectManager:GetInstance():ShowOneEffect(bUuid, pointId, buildTemplate.tileX, buildTemplate.tileY)
    end
  end
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.BuildBoxOpenFinish, self.BuildBoxOpenFinishSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BuildBoxOpenFinish, self.BuildBoxOpenFinishSignal)
end

local function ShowOneEffect(self, bUuid, pointId, tileX, tileY)
  if self.allEffect[bUuid] ~= nil then
    return
  end
  local url = string.format(UIAssets.BuildBoxFinishEffect, tileX)
  local request = ResourceManager:InstantiateAsync(url)
  self.allEffect[bUuid] = request
  request:completed("+", function()
    if request.isError then
      self.allEffect[bUuid] = nil
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local buildEffect = BuildBoxFinishEffect.New()
    buildEffect:OnCreate(request)
    local param = {}
    param.pointId = pointId
    param.bUuid = bUuid
    param.tileX = tileX
    param.tileY = tileY
    param.request = request
    buildEffect:ReInit(param)
  end)
end

local function RemoveOneEffect(self, bUuid)
  if self.allEffect[bUuid] ~= nil then
    self.allEffect[bUuid]:Destroy()
  end
  self.allEffect[bUuid] = nil
end

BuildBoxFinishEffectManager.__init = __init
BuildBoxFinishEffectManager.__delete = __delete
BuildBoxFinishEffectManager.RemoveOneEffect = RemoveOneEffect
BuildBoxFinishEffectManager.BuildBoxOpenFinishSignal = BuildBoxOpenFinishSignal
BuildBoxFinishEffectManager.AddListener = AddListener
BuildBoxFinishEffectManager.RemoveListener = RemoveListener
BuildBoxFinishEffectManager.ShowOneEffect = ShowOneEffect
return BuildBoxFinishEffectManager
