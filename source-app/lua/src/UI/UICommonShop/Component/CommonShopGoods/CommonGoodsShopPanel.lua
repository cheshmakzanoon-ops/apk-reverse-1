local base = UIBaseView
local CommonGoodsShopPanel = BaseClass("CommonGoodsShopPanel", base)
local Localization = CS.GameEntry.Localization
local CommonGoodsShopItem = require("UI.UICommonShop.Component.CommonShopGoods.CommonGoodsShopItem")
local svGoods_path = "ScrollView"
local content_path = "ScrollView/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.svGoodsN = self:AddComponent(UIBaseContainer, svGoods_path)
  self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.contentN:Init(bindFunc1, bindFunc2, bindFunc3)
end

local function ComponentDestroy(self)
  self:ClearItemCell()
  self.svGoodsN = nil
  self.contentN = nil
end

local function DataDefine(self)
  self.curShowType = nil
  self.goodsList = {}
  self.goodsItemsList = {}
  self.listGO = {}
end

local function DataDestroy(self)
  self.curShowType = nil
  self.goodsList = nil
  self.goodsItemsList = nil
  self.listGO = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:AddUIListener(EventId.RefreshItems, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function ShowPanel(self, shopType)
  self.curShowType = shopType
  self:RefreshAll()
end

local function RefreshAll(self, shopType)
  if shopType and shopType ~= self.curShowType then
    return
  end
  self.goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(self.curShowType)
  local line, hide
  for i = #self.goodsList, 1, -1 do
    line = LocalController:instance():getLine(TableName.LW_Shop, self.goodsList[i].id)
    if line then
      if string.IsNullOrEmpty(line:getValue("is_hide")) then
        hide = 0
      else
        hide = tonumber(line:getValue("is_hide"))
      end
      if hide ~= 0 then
        table.remove(self.goodsList, i)
      end
    end
  end
  self.contentN:SetItemCount(#self.goodsList)
end

local function OnInitScroll(self, go, index)
  local item = self.svGoodsN:AddComponent(CommonGoodsShopItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local conf = self.goodsList[index + 1]
  if conf == nil then
    return
  end
  go.name = conf.id
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  cellItem:SetItem(self.goodsList[index + 1])
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearItemCell(self)
  self.svGoodsN:RemoveComponents(CommonGoodsShopItem)
  self.contentN:DestroyChildNode()
end

CommonGoodsShopPanel.OnCreate = OnCreate
CommonGoodsShopPanel.OnDestroy = OnDestroy
CommonGoodsShopPanel.OnAddListener = OnAddListener
CommonGoodsShopPanel.OnRemoveListener = OnRemoveListener
CommonGoodsShopPanel.ComponentDefine = ComponentDefine
CommonGoodsShopPanel.ComponentDestroy = ComponentDestroy
CommonGoodsShopPanel.DataDefine = DataDefine
CommonGoodsShopPanel.DataDestroy = DataDestroy
CommonGoodsShopPanel.ShowPanel = ShowPanel
CommonGoodsShopPanel.RefreshAll = RefreshAll
CommonGoodsShopPanel.OnInitScroll = OnInitScroll
CommonGoodsShopPanel.OnUpdateScroll = OnUpdateScroll
CommonGoodsShopPanel.OnDestroyScrollItem = OnDestroyScrollItem
CommonGoodsShopPanel.ClearItemCell = ClearItemCell
return CommonGoodsShopPanel
