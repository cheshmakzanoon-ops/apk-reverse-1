local UIActMonopolyShopResItem = BaseClass("UIActMonopolyShopResItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local SoftMaskUtil = CS.SoftMaskUtil
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local root_path = ""
local bg_path = "bg"
local UICommonResItem_path = "UICommonResItem"
local itemName_path = "itemName"
local privceTxt_path = "priceContent/privceTxt"
local imgCostItem_path = "priceContent/ImgCostItem"
local giftPackPoint_path = "priceContent/UIGiftPackagePoint"

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
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.bgBtn = self:AddComponent(UIButton, bg_path)
  self.bgBtn:SetOnClick(function()
    self:OnBgBtnClick()
  end)
  self.uiCommonResItem = self:AddComponent(UICommonResItem, UICommonResItem_path)
  self.bgRawImg = self:AddComponent(UIRawImage, bg_path)
  self.itemName = self:AddComponent(UIText, itemName_path)
  self.imgCostItem = self:AddComponent(UIImage, imgCostItem_path)
  self.privceTxt = self:AddComponent(UIText, privceTxt_path)
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, giftPackPoint_path)
end

local function ComponentDestroy(self)
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
  self.uiCommonResItem:ReInit(rewardData)
  if self.packageInfo then
    goodsName = self.packageInfo:getNameText()
  end
  local showTxt = Localization:GetString("2000291", self.itemData.buy_times - self.itemData.num)
  self.itemName:SetText(showTxt)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if activityInfo then
    local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(activityInfo.richman_para)
    if paraTemp ~= nil and not string.IsNullOrEmpty(paraTemp.shop_text_color) then
      local splitPara = string.split(paraTemp.shop_text_color, "|")
      if #splitPara == 3 then
        local splitTextColor = string.split(splitPara[3], ",")
        if #splitTextColor == 4 then
          self.itemName:SetColorRGBA255(tonumber(splitTextColor[1]), tonumber(splitTextColor[2]), tonumber(splitTextColor[3]), tonumber(splitTextColor[4]))
        end
      end
    end
  end
  self.itemName.unity_tmpro:ForceMeshUpdate()
  if self.itemData.num < self.itemData.buy_times then
    if self.itemData.buy_type == ActMonopolyShopBuyType.Money then
      self.imgCostItem:SetActive(false)
      local priceStr = ""
      if self.packageInfo then
        priceStr = self.packageInfo:getPriceText()
      end
      self.privceTxt:SetText(priceStr)
      self.privceTxt.unity_tmpro:ForceMeshUpdate()
      SoftMaskUtil.AddSoftMaskable(self.privceTxt.transform)
      self.giftPackPoint:SetActive(true)
      self.giftPackPoint:RefreshPoint(self.packageInfo)
    else
      self.imgCostItem:SetActive(true)
      local spritePath = DataCenter.RewardManager:GetPicByType(RewardType.GOLD)
      self.imgCostItem:LoadSprite(spritePath)
      local costNum = tonumber(self.itemData.cost_list)
      local curNum = LuaEntry.Player.gold
      local showStr = costNum
      if costNum > curNum then
        showStr = string.format("<color=#dd2828> %s</color>", costNum)
      end
      self.privceTxt:SetText(showStr)
      self.privceTxt.unity_tmpro:ForceMeshUpdate()
      SoftMaskUtil.AddSoftMaskable(self.privceTxt.transform)
      self.giftPackPoint:SetActive(false)
    end
    SoftMaskUtil.SetGray(self.root.transform, false)
  else
    self.imgCostItem:SetActive(false)
    self.privceTxt:SetLocalText(320268)
    self.privceTxt.unity_tmpro:ForceMeshUpdate()
    SoftMaskUtil.AddSoftMaskable(self.privceTxt.transform)
    self.giftPackPoint:SetActive(false)
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
    local costNum = tonumber(self.itemData.cost_list)
    local curNum = LuaEntry.Player.gold
    if costNum <= curNum then
      SFSNetwork.SendMessage(MsgDefines.RichManShopBuy, self.actId, self.shopData.storeKey, self.itemData.id)
    else
    end
  end
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  local showTemp = activityInfo:GetShowConfigTemp()
  local imgStr = showTemp.pic_spec4
  local imgList = string.split(imgStr, "|")
  if #imgList == 7 then
    self.bgRawImg:LoadSprite(string.format(UIAssets.UIActMonopolyTexturePath, imgList[4]))
  end
end

UIActMonopolyShopResItem.OnCreate = OnCreate
UIActMonopolyShopResItem.OnDestroy = OnDestroy
UIActMonopolyShopResItem.ComponentDefine = ComponentDefine
UIActMonopolyShopResItem.ComponentDestroy = ComponentDestroy
UIActMonopolyShopResItem.DataDefine = DataDefine
UIActMonopolyShopResItem.DataDestroy = DataDestroy
UIActMonopolyShopResItem.SetData = SetData
UIActMonopolyShopResItem.OnBgBtnClick = OnBgBtnClick
return UIActMonopolyShopResItem
