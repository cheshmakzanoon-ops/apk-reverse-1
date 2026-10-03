local UICostItem = BaseClass("UICostItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.itemId = nil
  self.count = 0
end

local function DataDestroy(self)
  self.itemId = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.countText = self:AddComponent(UIText, "CountText")
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.countText = nil
end

local function ClickCallBack(self, param)
  if self.costCount ~= nil and self.count > self.costCount then
    local desc = DataCenter.RewardManager:GetDescByType(param.rewardType, param.itemId)
    local name = DataCenter.RewardManager:GetNameByType(param.rewardType, param.itemId)
    local param = {}
    param.itemName = name
    param.itemDesc = desc
    param.alignObject = self.resItem
    param.isLocal = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  else
    LWResourceLackUtil:GotoResourceItemLack(param.itemId, self.costCount)
    return
  end
end

local function RefreshShowState(self)
  if self.itemId ~= nil and self.costCount ~= nil then
    self.count = DataCenter.ResourceItemDataManager:GetCountByItemId(self.itemId)
    if self.count >= self.costCount then
      self.countText:SetText(string.format("<color=#FFFFFF>%s</color>/%s", string.GetFormattedStr(self.count), string.GetFormattedStr(self.costCount)))
    else
      self.countText:SetText(string.format("<color=#FF0000>%s</color>/%s", string.GetFormattedStr(self.count), string.GetFormattedStr(self.costCount)))
    end
  end
end

local function SetData(self, itemId, costCount)
  self.itemId = itemId
  self.costCount = costCount
  local param1 = {
    rewardType = RewardType.RESOURCE_ITEM,
    itemId = self.itemId,
    clickCallBack = Bind(self, ClickCallBack)
  }
  self.resItem:ReInit(param1)
  RefreshShowState(self)
end

UICostItem.OnCreate = OnCreate
UICostItem.OnDestroy = OnDestroy
UICostItem.OnEnable = OnEnable
UICostItem.OnDisable = OnDisable
UICostItem.DataDefine = DataDefine
UICostItem.DataDestroy = DataDestroy
UICostItem.ComponentDefine = ComponentDefine
UICostItem.ComponentDestroy = ComponentDestroy
UICostItem.SetData = SetData
UICostItem.RefreshShowState = RefreshShowState
return UICostItem
