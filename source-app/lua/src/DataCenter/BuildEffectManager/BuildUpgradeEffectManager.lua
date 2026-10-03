local BuildUpgradeEffectManager = BaseClass("BuildUpgradeEffectManager")
local ResourceManager = CS.GameEntry.Resource
local BuildUpgradeCompleteEffect = require("UI.BuildUpgradeCompleteEffect.View.BuildUpgradeCompleteEffect")
local AutoCloseTime = 5

local function __init(self)
  self.allEffect = {}
  self:AddListener()
end

local function __delete(self)
  for k, v in pairs(self.allEffect) do
    for k1, v1 in pairs(v) do
      local request = v1.request
      v1:OnDestroy()
      request:Destroy()
    end
  end
  self.allEffect = nil
  self:RemoveListener()
end

local function Startup()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.BuildUpgradeAnimationFinish, self.OnBuildUpgradeFinishSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeAnimationFinish, self.OnBuildUpgradeFinishSignal)
end

local function ShowOneEffect(self, posIndex, tile)
  local request = ResourceManager:InstantiateAsync(string.format(UIAssets.BuildUpgradeCompleteEffect, tile))
  if self.allEffect[posIndex] == nil then
    self.allEffect[posIndex] = {}
  end
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.BuildBubbleNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local buildUpgradeCompleteEffect = BuildUpgradeCompleteEffect.New()
    buildUpgradeCompleteEffect:OnCreate(request)
    table.insert(self.allEffect[posIndex], buildUpgradeCompleteEffect)
    local param = {}
    param.tile = tile
    param.posIndex = posIndex
    param.request = request
    param.modelHeight = CS.SceneManager.World:GetBuildingHeight(posIndex)
    buildUpgradeCompleteEffect:ReInit(param)
    param.timer = TimerManager:GetInstance():GetTimer(AutoCloseTime, self.TimeCallBack, buildUpgradeCompleteEffect.param, true, false, false)
    param.timer:Start()
  end)
end

local function TimeCallBack(param)
  if param.timer ~= nil then
    param.timer:Stop()
    param.timer = nil
  end
  if param.request ~= nil then
    param.request:Destroy()
  end
  local list = DataCenter.BuildUpgradeEffectManager.allEffect[param.posIndex]
  if list ~= nil then
    for i = #list, 1, -1 do
      if list[i].param == param then
        table.remove(list, i)
      end
    end
  end
end

local function OnBuildUpgradeFinishSignal(data)
  local bUuid = data
  if DataCenter.BuildManager:IsBuildInView(bUuid) then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData ~= nil and buildData.itemId ~= BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
      if buildTemplate ~= nil then
        DataCenter.BuildUpgradeEffectManager:ShowOneEffect(buildData.pointId, buildTemplate.tileX, buildTemplate.tileY)
      end
    end
  end
end

BuildUpgradeEffectManager.__init = __init
BuildUpgradeEffectManager.__delete = __delete
BuildUpgradeEffectManager.Startup = Startup
BuildUpgradeEffectManager.AddListener = AddListener
BuildUpgradeEffectManager.RemoveListener = RemoveListener
BuildUpgradeEffectManager.ShowOneEffect = ShowOneEffect
BuildUpgradeEffectManager.OnBuildUpgradeFinishSignal = OnBuildUpgradeFinishSignal
BuildUpgradeEffectManager.TimeCallBack = TimeCallBack
return BuildUpgradeEffectManager
