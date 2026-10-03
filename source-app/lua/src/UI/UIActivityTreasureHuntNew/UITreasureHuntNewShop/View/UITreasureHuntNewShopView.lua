local base = UIBaseView
local UITreasureHuntNewShopView = BaseClass("UITreasureHuntNewShopView", base)
local Localization = CS.GameEntry.Localization
local UITreasureHuntShopItem = require("UI/UIActivityTreasureHuntNew/UITreasureHuntNewShop/Component/UITreasureHuntNewShopItem")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local title_txt_path = "Root/TopBar/TextTitle"
local back_btn_path = "Root/BottomBar/BtnBack"
local item_bar_path = "Root/TopBar/ItemBar"
local diamond_bar_path = "Root/TopBar/DiamondBar"
local pack_list_path = "Root/PackList"
local pack_list_content_path = "Root/PackList/Viewport/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self.actId, self.packGroup, self.costItemId = self:GetUserData()
  self.actData = DataCenter.ActivityTreasureHuntNewManager:GetDigInfo(self.actId)
  self:ComponentDefine()
  self:DataDefine()
  self.diamond_bar:SetData(nil, ResourceType.Gold, nil)
  self.item_bar:SetData(self.costItemId, nil, nil)
  self:Refresh()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function RefreshData(self)
  self.packDataList = {}
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if activityInfo then
    local freePackData = {}
    freePackData.isGoto = true
    freePackData.realData = {}
    freePackData.realData.actId = self.actId
    freePackData.realData.GotoId = activityInfo:GetFirstActiveJumpTo()
    table.insert(self.packDataList, freePackData)
  end
  local giftPack = GiftPackManager.GetPacksByGroupId(self.packGroup, false)
  for _, v in pairs(giftPack) do
    local giftPackData = {}
    giftPackData.isGoto = false
    giftPackData.realData = v
    table.insert(self.packDataList, giftPackData)
  end
end

local function Refresh(self)
  RefreshData(self)
  self:ClearScroll()
  if self.packDataList == nil or #self.packDataList == 0 then
    self.pack_list:SetActive(false)
  else
    self.pack_list:SetActive(true)
    self.pack_list:SetListItemCount(#self.packDataList, false, false)
    self.pack_list:RefreshAllShownItem()
  end
end

local function RefreshGold(self)
end

local function RefreshGoods(self)
  if self.item_bar then
    self.item_bar:RefreshData()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGold)
  self:AddUIListener(EventId.RefreshItems, self.RefreshGoods)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGold)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshGoods)
end

local function ClearScroll(self)
  self.pack_list_content:RemoveComponents(UITreasureHuntShopItem)
  self.pack_list:ClearAllItems()
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.packDataList then
    return nil
  end
  local packData = self.packDataList[index]
  local item = loopScroll:NewListViewItem("PackItem")
  local script = self.pack_list_content:GetComponent(item.gameObject.name, UITreasureHuntShopItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.pack_list_content:AddComponent(UITreasureHuntShopItem, objectName)
  end
  script:SetActive(true)
  script:SetData(packData)
  return item
end

local function ComponentDefine(self)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.pack_list = self:AddComponent(UILoopListView2, pack_list_path)
  self.pack_list:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.pack_list_content = self:AddComponent(UIBaseContainer, pack_list_content_path)
  self.item_bar = self:AddComponent(UITopItem, item_bar_path)
  self.diamond_bar = self:AddComponent(UITopItem, diamond_bar_path)
  self.item_bar:SetShowAddBtn(false)
  self.diamond_bar:SetShowAddBtn(false)
end

local function ComponentDestroy(self)
  self.title_txt = nil
  self.back_btn = nil
  self.pack_list = nil
  self.pack_content_list = nil
  self.item_bar = nil
  self.diamond_bar = nil
end

local function DataDefine(self)
  self.itemIndex = 0
end

local function DataDestroy(self)
end

UITreasureHuntNewShopView.OnCreate = OnCreate
UITreasureHuntNewShopView.OnDestroy = OnDestroy
UITreasureHuntNewShopView.OnAddListener = OnAddListener
UITreasureHuntNewShopView.OnRemoveListener = OnRemoveListener
UITreasureHuntNewShopView.ComponentDefine = ComponentDefine
UITreasureHuntNewShopView.ComponentDestroy = ComponentDestroy
UITreasureHuntNewShopView.DataDefine = DataDefine
UITreasureHuntNewShopView.DataDestroy = DataDestroy
UITreasureHuntNewShopView.ClearScroll = ClearScroll
UITreasureHuntNewShopView.Refresh = Refresh
UITreasureHuntNewShopView.RefreshGold = RefreshGold
UITreasureHuntNewShopView.RefreshGoods = RefreshGoods
return UITreasureHuntNewShopView
