local ParkourBonusGoldPanel = BaseClass("ParkourBonusGoldPanel", UIBaseContainer)
local GameQualitySettings = require("Util.GameQualitySettings")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIMainResourceProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainResourceProgress")
local ResourceArray = {
  ResourceType.Wood,
  ResourceType.Metal,
  ResourceType.Food
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
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textResourceNum = self:AddComponent(UITextMeshProUGUIEx, "ResNode/root/resourceNum")
  self.imgResourceIcon = self:AddComponent(UIImage, "ResNode/root/resourceIcon")
  self.resNode = self:AddComponent(UIMainResourceProgress, "ResNode")
  local param = {}
  param.resourceType = ResourceType.Wood
  param.iconName = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Wood)
  param.showCount = 0
  self.resNode:SetZero(param)
end

local function ComponentDestroy(self)
  self.textResourceNum = nil
  self.imgResourceIcon = nil
end

local function DataDefine(self)
  self.resData = {}
  for i, v in ipairs(ResourceArray) do
    self.resData[v] = 0
  end
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, param)
  self.goldMaxNum = param.goldMaxNum
  self.textResourceNum:SetText(0)
end

local function Refresh(self, param)
  local pic = DataCenter.ResourceManager:GetResourceIconByType(param.goodsId)
  local srcPos = CS.CSUtils.WorldPositionToUISpacePosition(param.worldPosition)
  local targetPos = self.resNode:GetResourcePos()
  local FlyParkourPath = "Assets/_Art/Effect/prefab/ui/Common/FlyParkour.prefab"
  if GameQualitySettings.IsLowGearQuality() then
    FlyParkourPath = "Assets/_Art/Effect/prefab/ui/Common/FlyParkourNoTrail.prefab"
  end
  DataCenter.FlyController.DoFlyForLua(pic, nil, 1, srcPos, targetPos, 40, 40, function()
    self:AddRes(param.goodsId, param.goodsCount)
  end, FlyParkourPath, nil, -50, nil, nil)
end

local function AddRes(self, goodsId, goodsCount)
  local param = {}
  param.resourceType = goodsId
  local newCount = self.resData[goodsId] + goodsCount
  if self.goldMaxNum and newCount > self.goldMaxNum then
    newCount = self.goldMaxNum
    Logger.LogError("ParkourBonusGoldPanel The upper limit is exceeded:" .. self.goldMaxNum)
  end
  self.resData[goodsId] = newCount
  param.showCount = self.resData[goodsId]
  self.resNode:SetData(param)
end

ParkourBonusGoldPanel.OnCreate = OnCreate
ParkourBonusGoldPanel.OnDestroy = OnDestroy
ParkourBonusGoldPanel.OnEnable = OnEnable
ParkourBonusGoldPanel.OnDisable = OnDisable
ParkourBonusGoldPanel.ComponentDefine = ComponentDefine
ParkourBonusGoldPanel.ComponentDestroy = ComponentDestroy
ParkourBonusGoldPanel.DataDefine = DataDefine
ParkourBonusGoldPanel.DataDestroy = DataDestroy
ParkourBonusGoldPanel.OnAddListener = OnAddListener
ParkourBonusGoldPanel.OnRemoveListener = OnRemoveListener
ParkourBonusGoldPanel.Refresh = Refresh
ParkourBonusGoldPanel.SetData = SetData
ParkourBonusGoldPanel.AddRes = AddRes
return ParkourBonusGoldPanel
