local base = UIBaseContainer
local SelectBoxItem = BaseClass("SelectBoxItem", base)
local selectedFrame_path = "SelectedFrame"
local commonItem_path = "UICommonResItem"
local btn_path = ""

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
  self.selectedFrame = self:AddComponent(UIImage, selectedFrame_path)
  self.commonItem = self:AddComponent(UIBaseContainer, commonItem_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.commonResItem = self:AddComponent(UICommonResItem, commonItem_path)
  self.btn:SetOnClick(function()
    if self.clickCallback then
      self.clickCallback(self, self.goodsId)
    end
  end)
end

local function ComponentDestroy(self)
  self.selectedFrame = nil
  self.commonItem = nil
  self.btn = nil
  self.commonResItem = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.clickCallback = nil
end

local function SetData(self, goodsId, clickCallback)
  if not self.showGoodsData then
    self.showGoodsData = {}
    self.showGoodsData.rewardType = RewardType.GOODS
  end
  self.showGoodsData.itemId = goodsId
  local count = DataCenter.ItemData:GetItemCount(goodsId)
  self.showGoodsData.count = count
  self.commonResItem:ReInit(self.showGoodsData)
  self.goodsId = goodsId
  self.clickCallback = clickCallback
end

local function SetSelected(self, selected)
  self.selectedFrame:SetActive(selected)
end

SelectBoxItem.OnCreate = OnCreate
SelectBoxItem.OnDestroy = OnDestroy
SelectBoxItem.OnEnable = OnEnable
SelectBoxItem.OnDisable = OnDisable
SelectBoxItem.ComponentDefine = ComponentDefine
SelectBoxItem.ComponentDestroy = ComponentDestroy
SelectBoxItem.DataDefine = DataDefine
SelectBoxItem.DataDestroy = DataDestroy
SelectBoxItem.SetData = SetData
SelectBoxItem.SetSelected = SetSelected
return SelectBoxItem
