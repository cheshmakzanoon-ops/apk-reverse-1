local base = UIBaseView
local LWUIGiftShopView = BaseClass("LWUIGiftShopView", base)
local LWUIGiftShopItemView = require("UI.LWPlayerInfo.UILWGiftSystem.GiftShop.Component.LWUIGiftShopItemView")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local SHOP_NEW_FLAG = "SHOP_NEW_FLAG"
local diamondBar_path = "Root/TopBar/DiamondBar"
local itemBar_path = "Root/TopBar/ItemBar"
local backBtn_path = "Root/BottomBar/BtnBack"
local itemListScroll_path = "Root/PackList"
local itemList_path = "Root/PackList/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
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
  self.diamondBar = self:AddComponent(UIBaseContainer, diamondBar_path)
  self.itemBar = self:AddComponent(UIBaseContainer, itemBar_path)
  self.backBtn = self:AddComponent(UIButton, backBtn_path)
  self.itemListScroll = self:AddComponent(UIBaseContainer, itemListScroll_path)
  self.itemList = self:AddComponent(GridInfinityScrollView, itemList_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.item_bar = self:AddComponent(UITopItem, itemBar_path)
  self.diamond_bar = self:AddComponent(UITopItem, diamondBar_path)
  self.itemBarList = {
    self.diamond_bar,
    self.item_bar
  }
end

local function ComponentDestroy(self)
  if self.itemListScroll then
    self.itemListScroll:RemoveComponents(LWUIGiftShopItemView)
  end
  if self.itemList then
    self.itemList:DestroyChildNode()
  end
  self.diamondBar = nil
  self.itemBar = nil
  self.backBtn = nil
  self.itemListScroll = nil
  self.itemList = nil
end

local function DataDefine(self)
  self.hasInitScroll = false
  self.giftCells = {}
  self.listGO = {}
  self.showDataList = {}
  self.newFlags = CommonUtil.PlayerPrefsGetTable(SHOP_NEW_FLAG, {})
end

local function DataDestroy(self)
  self.hasInitScroll = false
  self.giftCells = {}
  self.listGO = {}
  self:UpdateNewFlags(true)
  self.showDataList = {}
  CommonUtil.PlayerPrefsSetTable(SHOP_NEW_FLAG, self.newFlags)
  self.newFlags = {}
end

local function OnInitScroll(self, go, index)
  local item = self.itemListScroll:AddComponent(LWUIGiftShopItemView, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local item = self.listGO[go]
  local data = self.showDataList[index + 1]
  local newFlag = false
  if data ~= nil then
    newFlag = self.newFlags[data.uid] ~= nil
  end
  item:SetData(data, newFlag)
end

local function OnDestroyScrollItem(self, go, index)
end

function LWUIGiftShopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshGoods)
end

function LWUIGiftShopView:OnRemoveListener()
  self:AddUIListener(EventId.RefreshItems, self.RefreshGoods)
  base.OnRemoveListener(self)
end

function LWUIGiftShopView:RefreshGoods()
  for i = 1, #self.itemBarList do
    self.itemBarList[i]:RefreshData()
  end
end

function LWUIGiftShopView:RefreshView()
  self.showDataList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.GiftShop)
  self:UpdateNewFlags(not next(self.newFlags))
  if not self.hasInitScroll then
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.itemList:Init(bindFunc1, bindFunc2, bindFunc3)
  end
  self.hasInitScroll = true
  local dataCount = table.count(self.showDataList)
  self.itemList:SetItemCount(dataCount)
  self.itemList:ForceUpdate()
  self.diamond_bar:SetData(nil, ResourceType.Gold, nil)
  self.item_bar:SetData(GiftSystemConst.ShopItemId, nil, function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, nil, GiftSystemConst.ShopGroupId, GiftSystemConst.ShopItemId)
  end)
end

function LWUIGiftShopView:UpdateNewFlags(init)
  if self.showDataList == nil then
    return
  end
  if init then
    for _, v in ipairs(self.showDataList) do
      self.newFlags[v.id] = true
    end
  end
end

LWUIGiftShopView.OnCreate = OnCreate
LWUIGiftShopView.OnDestroy = OnDestroy
LWUIGiftShopView.OnEnable = OnEnable
LWUIGiftShopView.OnDisable = OnDisable
LWUIGiftShopView.ComponentDefine = ComponentDefine
LWUIGiftShopView.ComponentDestroy = ComponentDestroy
LWUIGiftShopView.DataDefine = DataDefine
LWUIGiftShopView.DataDestroy = DataDestroy
LWUIGiftShopView.OnInitScroll = OnInitScroll
LWUIGiftShopView.OnUpdateScroll = OnUpdateScroll
LWUIGiftShopView.OnDestroyScrollItem = OnDestroyScrollItem
return LWUIGiftShopView
