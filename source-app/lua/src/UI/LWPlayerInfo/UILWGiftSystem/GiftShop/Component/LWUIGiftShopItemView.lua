local base = UIBaseContainer
local LWUIGiftShopItemView = BaseClass("LWUIGiftShopItemView", base)
local BG_ICON_PATH = {
  Lock = "Assets/Main/Sprites/UI/LWUIGiftSystem/lrb_liwushangdian_qvse.png",
  UnLock = "Assets/Main/Sprites/UI/LWUIGiftSystem/lrb_pifuzhuangshishangdian_ban.png"
}
local qualityImg_path = "Corner"
local giftIconImg_path = "Icon"
local giftNameTxt_path = "Name"
local addCharmTxt_path = "AddCharm"
local detailBtn_path = "DetailBtn"
local lockGo_path = "LockGo"
local unlockGo_path = "UnlockGo"
local currencyNum_path = "UnlockGo/Num"
local bg_path = "Bg"
local newFlag_path = "NewFlag"

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
  self.qualityImg = self:AddComponent(UIImage, qualityImg_path)
  self.giftIconImg = self:AddComponent(UIImage, giftIconImg_path)
  self.giftNameTxt = self:AddComponent(UIText, giftNameTxt_path)
  self.addCharmTxt = self:AddComponent(UIText, addCharmTxt_path)
  self.detailBtn = self:AddComponent(UIButton, detailBtn_path)
  self.lockGo = self:AddComponent(UIBaseContainer, lockGo_path)
  self.unlockGo = self:AddComponent(UIBaseContainer, unlockGo_path)
  self.currencyNum = self:AddComponent(UIText, currencyNum_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.newFlag = self:AddComponent(UIImage, newFlag_path)
  self.detailBtn:SetOnClick(function()
    self:OnClickBuyBtn()
  end)
end

local function ComponentDestroy(self)
  self.qualityImg = nil
  self.giftIconImg = nil
  self.giftNameTxt = nil
  self.addCharmTxt = nil
  self.detailBtn = nil
  self.lockGo = nil
  self.unlockGo = nil
  self.currencyNum = nil
  self.bg = nil
  self.newFlag = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function LWUIGiftShopItemView:SetData(data, isNew)
  self.goodsConf = data
  local canBuy = self:CanBuy()
  self.bg:LoadSprite(canBuy and BG_ICON_PATH.UnLock or BG_ICON_PATH.Lock)
  self.template = DataCenter.ItemTemplateManager:GetItemTemplate(data.itemId)
  local quality = self.template.color
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(data.itemId)
  self.qualityImg:LoadSprite(GiftSystemConst.GetGiftDetailQualityIcon(quality))
  self.giftIconImg:LoadSprite(GiftSystemConst.GetIconPath(goods.icon_mid))
  self.giftIconImg:SetNativeSize()
  self.giftNameTxt:SetLocalText(self.template.name)
  self.addCharmTxt:SetText("+" .. goods.add_exp)
  self.detailBtn:SetActive(true)
  self.unlockGo:SetActive(canBuy)
  self.lockGo:SetActive(not canBuy)
  self.currencyNum:SetText(self.goodsConf.configData.currency_num)
  self.newFlag:SetActive(isNew)
end

function LWUIGiftShopItemView:OnClickBuyBtn()
  local canBuy = self:CanBuy()
  if not canBuy then
    UIUtil.ShowTipsId("gift_store_lock_tips")
    return
  end
  local goodsConf = self.goodsConf
  if goodsConf then
    DataCenter.CommonShopManager:Buy(goodsConf.id, goodsConf.shopType, function(buyCount)
      SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, goodsConf.id, nil, buyCount)
    end)
  end
end

function LWUIGiftShopItemView:CanBuy()
  if self.goodsConf == nil then
    return false
  end
  if self.goodsConf.configData == nil then
    return false
  end
  local canBuy = true
  local buy_condition = self.goodsConf.configData.buy_condition
  if buy_condition ~= nil and buy_condition ~= "" then
    local lvl = DataCenter.GiftSystemManager:GetGiftLevel()
    local condType, value = string.match(buy_condition, "([^;]+);([^;]+)")
    if tonumber(condType) == 502 then
      local needLevel = tonumber(value) or 0
      canBuy = lvl >= needLevel
    end
  end
  return canBuy
end

LWUIGiftShopItemView.OnCreate = OnCreate
LWUIGiftShopItemView.OnDestroy = OnDestroy
LWUIGiftShopItemView.OnEnable = OnEnable
LWUIGiftShopItemView.OnDisable = OnDisable
LWUIGiftShopItemView.ComponentDefine = ComponentDefine
LWUIGiftShopItemView.ComponentDestroy = ComponentDestroy
LWUIGiftShopItemView.DataDefine = DataDefine
LWUIGiftShopItemView.DataDestroy = DataDestroy
return LWUIGiftShopItemView
