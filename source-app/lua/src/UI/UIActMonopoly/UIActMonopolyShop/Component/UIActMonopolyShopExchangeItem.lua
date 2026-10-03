local UIActMonopolyShopExchangeItem = BaseClass("UIActMonopolyShopExchangeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local SoftMaskUtil = CS.SoftMaskUtil
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local u_i_common_res_item_path = "UICommonResItem"
local content_path = "Rect_Reward/Viewport/Content"
local special_item_path = "Rect_Reward/Viewport/Content/specialItem"
local special_u_i_common_res_item_path = "Rect_Reward/Viewport/Content/specialItem/specialUICommonResItem"
local special_item_name_path = "Rect_Reward/Viewport/Content/specialItem/specialItemName"
local normal_item_content_path = "Rect_Reward/Viewport/Content/normalItemContent"
local btn_buy_path = "Btn_Buy"
local txt_price_path = "Btn_Buy/Txt_Price"
local u_i_gift_package_point_path = "Btn_Buy/UIGiftPackagePoint"
local discount_path = "Discount"
local discount_txt_path = "Discount/DiscountTxt"

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

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.btn_buy = self:AddComponent(UIButton, btn_buy_path)
  self.btn_buy_img = self:AddComponent(UIImage, btn_buy_path)
  self.txt_price = self:AddComponent(UITextMeshProUGUIEx, txt_price_path)
  self.u_i_gift_package_point = self:AddComponent(UIGiftPackagePoint, u_i_gift_package_point_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.special_item = self:AddComponent(UIBaseContainer, special_item_path)
  self.special_u_i_common_res_item = self:AddComponent(UICommonResItem, special_u_i_common_res_item_path)
  self.special_item_name = self:AddComponent(UITextMeshProUGUIEx, special_item_name_path)
  self.normal_item_content = self:AddComponent(UIBaseContainer, normal_item_content_path)
  self.discount = self:AddComponent(UIImage, discount_path)
  self.discount_txt = self:AddComponent(UITextMeshProUGUIEx, discount_txt_path)
  self.btn_buy:SetOnClick(function()
    self:OnBgBtnClick()
  end)
  self.u_i_common_res_item:SetActive(false)
  self.itemList = {}
  self.u_i_common_res_item.gameObject:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  self.btn_buy = nil
  self.txt_price = nil
  self.u_i_gift_package_point = nil
  self.u_i_common_res_item = nil
  self.content = nil
  self.special_item = nil
  self.special_u_i_common_res_item = nil
  self.special_item_name = nil
  self.normal_item_content = nil
  self.discount = nil
  self.discount_txt = nil
end

local function DataDefine(self)
  self.actId = nil
  self.shopData = nil
  self.index = nil
  self.itemData = nil
  self.packageInfo = nil
end

local function DataDestroy(self)
  self.actId = nil
  self.shopData = nil
  self.index = nil
  self.itemData = nil
  self.packageInfo = nil
end

local function SetData(self, actId, shopData, index)
  self.actId = actId
  self.shopData = shopData
  self.index = index
  self.itemData = self.shopData.shopArr[self.index]
  if self.itemData.exchangeid and not string.IsNullOrEmpty(self.itemData.exchangeid) and tonumber(self.itemData.exchangeid) > 0 then
    local exchangeStrId = self.itemData.exchangeid
    self.packageInfo = GiftPackageData.get(exchangeStrId)
  end
  local goodsId
  local goodsNum = 0
  local goodsName = ""
  local goodsStr = self.itemData.goodsid
  local goodsArr = string.string2array_i_oneSep(goodsStr, ";")
  if #goodsArr == 2 then
    goodsId = goodsArr[1]
    goodsNum = goodsArr[2]
    goodsName = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, goodsId)
  end
  local rewardData = {
    count = goodsNum,
    itemId = goodsId,
    rewardType = RewardType.GOODS
  }
  self.special_u_i_common_res_item:ReInit(rewardData)
  if self.packageInfo then
    goodsName = self.packageInfo:getNameText()
  end
  local showTxt = Localization:GetString("2000291", self.itemData.buy_times - self.itemData.num)
  self.special_item_name:SetText(showTxt)
  self.special_item_name.unity_tmpro:ForceMeshUpdate()
  SoftMaskUtil.AddSoftMaskable(self.special_item_name.transform)
  local discount = self.packageInfo:getPercent()
  if discount then
    self.discount:SetActive(true)
    self.discount_txt:SetText(string.format("%d%%", discount))
  else
    self.discount:SetActive(false)
  end
  local rewardList = self.packageInfo:getItems(true)
  local showRewardList = {}
  for k, v in ipairs(rewardList) do
    if v.rewardType ~= RewardType.GOODS or v.itemId ~= goodsId then
      table.insert(showRewardList, v)
    end
  end
  if #showRewardList ~= #self.itemList then
    self:ClearAllItem()
    for k, v in ipairs(showRewardList) do
      local index = k
      local item = self.u_i_common_res_item.gameObject:GameObjectSpawn(self.normal_item_content.transform)
      item.name = index
      local obj = self.normal_item_content:AddComponent(UICommonResItem, item.name)
      obj:SetActive(true)
      self.itemList[index] = obj
    end
  end
  for k, v in ipairs(showRewardList) do
    self.itemList[k]:ReInit(v)
  end
  if self.itemData.num < self.itemData.buy_times then
    if self.itemData.buy_type == ActMonopolyShopBuyType.Money then
      local priceStr = ""
      if self.packageInfo then
        priceStr = self.packageInfo:getPriceText()
      end
      self.txt_price:SetText(priceStr)
      self.txt_price.unity_tmpro:ForceMeshUpdate()
      self.u_i_gift_package_point:SetActive(true)
      self.u_i_gift_package_point:RefreshPoint(self.packageInfo)
    else
    end
    SoftMaskUtil.SetGray(self.root.transform, false)
  else
    self.txt_price:SetLocalText(320268)
    self.txt_price.unity_tmpro:ForceMeshUpdate()
    self.u_i_gift_package_point:SetActive(false)
    SoftMaskUtil.SetGray(self.root.transform, true)
  end
end

local function OnBgBtnClick(self)
  if self.itemData.num >= self.itemData.buy_times then
    return
  end
  if self.itemData.buy_type == ActMonopolyShopBuyType.Money then
    if self.packageInfo then
      DataCenter.PayManager:BuyGift(self.packageInfo)
    else
    end
  elseif self.itemData.buy_type == ActMonopolyShopBuyType.Item then
  end
end

local function ClearAllItem(self)
  self.normal_item_content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.normal_item_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_common_res_item.gameObject:GameObjectRecycleAll()
  self.gridItemDict = {}
end

UIActMonopolyShopExchangeItem.OnCreate = OnCreate
UIActMonopolyShopExchangeItem.OnDestroy = OnDestroy
UIActMonopolyShopExchangeItem.ComponentDefine = ComponentDefine
UIActMonopolyShopExchangeItem.ComponentDestroy = ComponentDestroy
UIActMonopolyShopExchangeItem.DataDefine = DataDefine
UIActMonopolyShopExchangeItem.DataDestroy = DataDestroy
UIActMonopolyShopExchangeItem.ClearAllItem = ClearAllItem
UIActMonopolyShopExchangeItem.SetData = SetData
UIActMonopolyShopExchangeItem.OnBgBtnClick = OnBgBtnClick
return UIActMonopolyShopExchangeItem
