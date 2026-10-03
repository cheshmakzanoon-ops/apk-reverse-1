local base = UIBaseContainer
local UILWBlackMarketProductItem = BaseClass("UILWBlackMarketProductItem", base)
local UIGray = CS.UIGray
local bg_img_path = "root/itemBg_img"
local item_path = "root/realItem"
local remainCount_txt_path = "root/remainCount_txt"
local costItem_img_path = "root/priceLayout/costItem_img"
local price_txt_path = "root/priceLayout/price_txt"
local btn_path = ""
local tag_img_path = "tag"
local tag_txt_path = "tag/tag_txt"
local root_path = "root"

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
  self.bg_img = self:AddComponent(UIImage, bg_img_path)
  self.item = self:AddComponent(UIBaseContainer, item_path)
  self.remainCount_txt = self:AddComponent(UIText, remainCount_txt_path)
  self.costItem_img = self:AddComponent(UIImage, costItem_img_path)
  self.price_txt = self:AddComponent(UIText, price_txt_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.tag_img = self:AddComponent(UIImage, tag_img_path)
  self.tag_txt = self:AddComponent(UIText, tag_txt_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.commonResItem = self:AddComponent(UICommonResItem, item_path)
  self.btn:SetOnClick(function()
    self.holder:TryBuyProduct(self.productData)
  end)
  self.btn:SetSafeClickMode(true)
end

local function ComponentDestroy(self)
  self.bg_img = nil
  self.item = nil
  self.remainCount_txt = nil
  self.costItem_img = nil
  self.price_txt = nil
  self.btn = nil
  self.tag_img = nil
  self.tag_txt = nil
  self.root = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshCostText(self)
  if self.productData and self.productData.buyTimeLimit > self.productData.num then
    if self.productData.costItem <= 0 or 0 >= self.productData.costNum then
      self.costItem_img:SetActive(false)
      self.price_txt:SetLocalText("blackmarket_desc5")
    else
      self.costItem_img:SetActive(true)
      if not self.costItemId or self.costItemId ~= self.productData.costItem then
        local itemIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.productData.costItem)
        self.costItem_img:LoadSprite(itemIcon)
        self.costItemId = self.productData.costItem
      end
      self.price_txt:SetText(self.productData.costNum)
      local curHaveItemCount = DataCenter.ItemData:GetItemCount(self.productData.costItem)
      if curHaveItemCount < self.productData.costNum then
        self.price_txt:SetColor(LackResourceRedColor)
      else
        self.price_txt:SetColor(WhiteColor)
      end
    end
  end
end

local function SetData(self, productItemData)
  if not productItemData then
    self:SetActive(false)
    return
  end
  self.productData = productItemData
  self.bg_img:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWBlackMarket/zyf_heishishangcheng_diban_%d.png", self.productData.displayType))
  self.commonResItem:ReInit(productItemData.reward[1])
  if productItemData.extraDisplay == nil or productItemData.extraDisplay <= 0 then
    self.tag_img:SetActive(false)
  else
    self.tag_img:SetActive(true)
    self.tag_img:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWBlackMarket/zyf_heishishangcheng_tag_%d.png", productItemData.extraDisplay))
    if productItemData.extraDisplay == 1 then
      self.tag_txt:SetLocalText("blackmarket_desc1")
    elseif productItemData.extraDisplay == 2 then
      self.tag_txt:SetLocalText("blackmarket_desc2")
    elseif productItemData.extraDisplay == 3 then
      self.tag_txt:SetLocalText("blackmarket_desc3")
    end
  end
  if productItemData.num >= productItemData.buyTimeLimit then
    self.remainCount_txt:SetLocalText("blackmarket_desc4", 0)
    self.price_txt:SetLocalText("blackmarket_desc6")
    self.price_txt:SetColor(WhiteColor)
    self.costItem_img:SetActive(false)
    UIGray.SetGray(self.root.transform, true, true)
    return
  else
    self.remainCount_txt:SetLocalText("blackmarket_desc4", productItemData.buyTimeLimit - productItemData.num)
    self:RefreshCostText()
    UIGray.SetGray(self.root.transform, false, true)
  end
  self:SetActive(true)
end

local function OnItemUpdate(self)
  self:RefreshCostText()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, OnItemUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, OnItemUpdate)
end

UILWBlackMarketProductItem.OnCreate = OnCreate
UILWBlackMarketProductItem.OnDestroy = OnDestroy
UILWBlackMarketProductItem.OnEnable = OnEnable
UILWBlackMarketProductItem.OnDisable = OnDisable
UILWBlackMarketProductItem.ComponentDefine = ComponentDefine
UILWBlackMarketProductItem.ComponentDestroy = ComponentDestroy
UILWBlackMarketProductItem.DataDefine = DataDefine
UILWBlackMarketProductItem.DataDestroy = DataDestroy
UILWBlackMarketProductItem.SetData = SetData
UILWBlackMarketProductItem.OnItemUpdate = OnItemUpdate
UILWBlackMarketProductItem.RefreshCostText = RefreshCostText
UILWBlackMarketProductItem.OnAddListener = OnAddListener
UILWBlackMarketProductItem.OnRemoveListener = OnRemoveListener
return UILWBlackMarketProductItem
