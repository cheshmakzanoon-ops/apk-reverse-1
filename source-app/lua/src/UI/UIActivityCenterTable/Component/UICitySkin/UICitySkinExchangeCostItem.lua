local UICitySkinExchangeCostItem = BaseClass("UICitySkinExchangeCostItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local needCountTextPath = "NeedCountText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.commonResItem = self:AddComponent(UICommonResItem, "")
  self.needCountText = self:AddComponent(UIText, needCountTextPath)
end

local function ComponentDestroy(self)
  self.commonResItem = nil
  self.needCountText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshNeedCount(self)
  if not self.data then
    return
  end
  if self.data.onlyShowNeedCount then
    self.needCountText:SetText(self.data.count)
  else
    local have = DataCenter.ItemData:GetItemRealCount(self.data.id)
    if have >= self.data.count then
      self.needCountText:SetText("<color=#FFFFFF>" .. have .. "</color>/" .. self.data.count)
    else
      self.needCountText:SetText("<color=#F53C3D>" .. have .. "</color>/" .. self.data.count)
    end
  end
end

local function SetData(self, data)
  self.data = data
  local showData = {}
  showData.rewardType = RewardType.GOODS
  showData.itemId = data.id
  showData.itemCount = data.count
  self.commonResItem:ReInit(showData)
  self:RefreshNeedCount()
end

UICitySkinExchangeCostItem.OnCreate = OnCreate
UICitySkinExchangeCostItem.OnDestroy = OnDestroy
UICitySkinExchangeCostItem.OnEnable = OnEnable
UICitySkinExchangeCostItem.OnDisable = OnDisable
UICitySkinExchangeCostItem.ComponentDefine = ComponentDefine
UICitySkinExchangeCostItem.ComponentDestroy = ComponentDestroy
UICitySkinExchangeCostItem.DataDefine = DataDefine
UICitySkinExchangeCostItem.DataDestroy = DataDestroy
UICitySkinExchangeCostItem.OnAddListener = OnAddListener
UICitySkinExchangeCostItem.OnRemoveListener = OnRemoveListener
UICitySkinExchangeCostItem.SetData = SetData
UICitySkinExchangeCostItem.RefreshNeedCount = RefreshNeedCount
return UICitySkinExchangeCostItem
