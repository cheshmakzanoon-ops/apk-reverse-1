local LWUIActBountyHunterShopExchangeItemComponent = BaseClass("LWUIActBountyHunterShopExchangeItemComponent", UIBaseContainer)
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
local btn_free_path = "FreeButton"
local text_btn_free_path = "FreeButton/Content/ButtonText"
local txt_price_path = "Btn_Buy/Txt_Price"
local u_i_gift_package_point_path = "Btn_Buy/UIGiftPackagePoint"
local discount_path = "Discount"
local discount_txt_path = "Discount/DiscountTxt"

function LWUIActBountyHunterShopExchangeItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterShopExchangeItemComponent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterShopExchangeItemComponent:ComponentDefine()
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
  self.btn_free = self:AddComponent(UIButton, btn_free_path)
  self.btn_free:SetOnClick(function()
    self:OnFreeBtnClick()
  end)
  self.text_btn_free = self:AddComponent(UITextMeshProUGUIEx, text_btn_free_path)
  self.u_i_common_res_item:SetActive(false)
  self.itemList = {}
  self.u_i_common_res_item.gameObject:GameObjectCreatePool()
end

function LWUIActBountyHunterShopExchangeItemComponent:ComponentDestroy()
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
  self.btn_free = nil
  self.text_btn_free = nil
end

function LWUIActBountyHunterShopExchangeItemComponent:DataDefine()
  self.actId = nil
  self.shopData = nil
  self.index = nil
  self.itemData = nil
  self.packageInfo = nil
end

function LWUIActBountyHunterShopExchangeItemComponent:DataDestroy()
  self.actId = nil
  self.shopData = nil
  self.index = nil
  self.itemData = nil
  self.packageInfo = nil
end

function LWUIActBountyHunterShopExchangeItemComponent:SetData(activityId, data, uuid)
  self.activityId = activityId
  self.data = data
  self.packageInfo = nil
  self.uuid = uuid
  if self.activityId == nil or self.data == nil then
    return
  end
  if self.data.giftData.exchangeId and not string.IsNullOrEmpty(self.data.giftData.exchangeId) and tonumber(self.data.giftData.exchangeId) > 0 then
    local exchangeStrId = tostring(self.data.giftData.exchangeId)
    self.packageInfo = GiftPackageData.get(exchangeStrId)
  end
  self.btn_buy:SetActive(self.data.tmpData.buy_type ~= 4)
  self.btn_free:SetActive(self.data.tmpData.buy_type == 4)
  local goodsId
  local goodsNum = 0
  local goodsStr = self.data.tmpData.goodsid
  local goodsArr = string.string2array_i_oneSep(goodsStr, ";")
  if #goodsArr == 2 then
    goodsId = goodsArr[1]
    goodsNum = goodsArr[2]
  end
  local rewardData = {
    count = goodsNum,
    itemId = goodsId,
    rewardType = RewardType.GOODS
  }
  self.special_u_i_common_res_item:ReInit(rewardData)
  local showTxt = Localization:GetString("2000291", self.data.tmpData.buy_times - self.data.giftData.buyCount)
  self.special_item_name:SetText(showTxt)
  if self.data.tmpData.buy_type == 4 then
    self.discount:SetActive(false)
    self.normal_item_content:SetActive(false)
    if self.data.giftData.buyCount < self.data.tmpData.buy_times then
      self.text_btn_free:SetLocalText("activity_hunter_trade_desc3")
      CS.UIGray.SetGray(self.root.transform, false, true)
    else
      self.text_btn_free:SetLocalText(320268)
      CS.UIGray.SetGray(self.root.transform, true, true)
    end
  else
    if self.packageInfo == nil then
      return
    end
    local rewardList = self.packageInfo:getItems(true)
    local showRewardList = {}
    for k, v in ipairs(rewardList) do
      if v.rewardType ~= RewardType.GOODS or v.itemId ~= goodsId then
        table.insert(showRewardList, v)
      end
    end
    self.normal_item_content:SetActive(true)
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
    local discount = self.packageInfo:getPercent()
    if discount then
      self.discount:SetActive(true)
      self.discount_txt:SetText(string.format("%d%%", discount))
    else
      self.discount:SetActive(false)
    end
    if self.data.giftData.buyCount < self.data.tmpData.buy_times then
      local priceStr = self.packageInfo:getPriceText()
      self.txt_price:SetText(priceStr)
      self.u_i_gift_package_point:SetActive(true)
      self.u_i_gift_package_point:RefreshPoint(self.packageInfo)
      CS.UIGray.SetGray(self.root.transform, false, true)
    else
      self.txt_price:SetLocalText(320268)
      self.u_i_gift_package_point:SetActive(false)
      CS.UIGray.SetGray(self.root.transform, true, true)
    end
  end
end

function LWUIActBountyHunterShopExchangeItemComponent:OnBgBtnClick()
  if self.activityId == nil or self.data == nil or self.uuid == nil then
    return
  end
  if self.data.giftData.buyCount >= self.data.tmpData.buy_times then
    return
  end
  if self.packageInfo then
    DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.LWUIActBountyHunterShop, nil, self.activityId, tostring(self.uuid))
  end
end

function LWUIActBountyHunterShopExchangeItemComponent:ClearAllItem()
  self.normal_item_content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.normal_item_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_common_res_item.gameObject:GameObjectRecycleAll()
  self.gridItemDict = {}
end

function LWUIActBountyHunterShopExchangeItemComponent:OnFreeBtnClick()
  if self.activityId == nil or self.data == nil then
    return
  end
  if self.data.giftData.buyCount >= self.data.tmpData.buy_times then
    return
  end
  if self.data.tmpData.buy_type == 4 then
    SFSNetwork.SendMessage(MsgDefines.BountyHunterEventShopBuy, tonumber(self.activityId), self.data.giftData.confId, self.uuid)
  end
end

return LWUIActBountyHunterShopExchangeItemComponent
