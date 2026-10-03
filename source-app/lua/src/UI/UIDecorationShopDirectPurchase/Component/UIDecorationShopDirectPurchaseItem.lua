local UIDecorationShopDirectPurchaseItem = BaseClass("UIDecorationShopDirectPurchaseItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local rawBgPath = "RawImgBg"
local nameTextPath = "NameText"
local descText = "DescText"
local freeGetBtnPath = "FreeGetBtn"
local freeGetBtnTextPath = "FreeGetBtn/FreeGetBtnText"
local buyBtnPath = "BuyBtn"
local buyBtnTextPath = "BuyBtn/BuyBtnText"
local newTagPath = "NewTag"
local newTagTextPath = "NewTag/NewText"
local discountBgPath = "DiscountBg"
local discountTextPath = "DiscountBg/DiscountText"
local rewardItemsPath = "RewardItemScroll/RewardItems"
local giftPackPointPath = "BuyBtn/UIGiftPackagePoint"
local refreshInfoTextPath = "RefreshInfoText"
local rewardItemScrollBgPath = "RewardItemScroll/RewardItemScrollBg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearRewards()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rawImgBg = self:AddComponent(UIRawImage, rawBgPath)
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, nameTextPath)
  self.descText = self:AddComponent(UIText, descText)
  self.freeGetBtn = self:AddComponent(UIButton, freeGetBtnPath)
  self.freeGetBtn:SetOnClick(function()
    self:OnClickFreeGet()
  end)
  self.freeGetBtnText = self:AddComponent(UIText, freeGetBtnTextPath)
  self.freeGetBtnText:SetLocalText(170004)
  self.buyBtn = self:AddComponent(UIButton, buyBtnPath)
  self.buyBtn:SetOnClick(function()
    self:OnBuyBtnClick()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.buyBtnText = self:AddComponent(UIText, buyBtnTextPath)
  self.newTag = self:AddComponent(UIImage, newTagPath)
  self.newTagText = self:AddComponent(UIText, newTagTextPath)
  self.newTagText:SetLocalText("vip_new_tip")
  self.discountBg = self:AddComponent(UIImage, discountBgPath)
  self.discountText = self:AddComponent(UIText, discountTextPath)
  self.rewardItems = self:AddComponent(UIBaseContainer, rewardItemsPath)
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, giftPackPointPath)
  self.refreshInfoText = self:AddComponent(UIText, refreshInfoTextPath)
  self.rewardItemScrollBg = self:AddComponent(UIImage, rewardItemScrollBgPath)
end

local function ComponentDestroy(self)
  self.rawImgBg = nil
  self.nameText = nil
  self.descText = nil
  self.freeGetBtn = nil
  self.freeGetBtnText = nil
  self.buyBtn = nil
  self.buyBtnText = nil
  self.newTag = nil
  self.newTagText = nil
  self.discountBg = nil
  self.discountText = nil
  self.rewardItems = nil
  self.giftPackPoint = nil
  self.refreshInfoText = nil
  self.rewardItemScrollBg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.TimerAction = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  if self.giftPackData then
    local packId = self.giftPackData:getID()
    if packId then
      DataCenter.DecorationShopDirectPurchaseManager:SetPackNotNew(packId)
    end
  end
  base.OnDisable(self)
end

local function OnClickFreeGet(self)
  if self.isFree then
    local canGet = DataCenter.DecorationShopDirectPurchaseManager:GetIfCanFreeReward(self.openType)
    if canGet then
      local id = DataCenter.DecorationShopDirectPurchaseManager:GetId(self.openType)
      DataCenter.DecorationShopDirectPurchaseManager:RequestGetFreeReward(id)
    end
  end
end

local function OnBuyBtnClick(self)
  if not self.isFree and self.giftPackData then
    DataCenter.PayManager:CallPayment(self.giftPackData, UIWindowNames.UIDecorationShopDirectPurchase)
  end
end

local function SetData(self, data)
  self.isFree = data.isFree
  self.data = data.realData
  self.openType = data.openType
  self:RefreshAll()
end

local function ClearRewards(self)
  self.rewardItems:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function RefreshRewards(self, rewards)
  self:ClearRewards()
  for i = 1, table.length(rewards) do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.rewardItems.transform)
      go.transform:Set_localScale(0.84, 0.84, 1)
      go.transform:Set_sizeDelta(98, 98)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_pivot(0.5, 0.5)
      go.name = "item" .. i
      local cell = self.rewardItems:AddComponent(UICommonResItem, go.name)
      cell:ReInit(rewards[i])
      if cell.name_text then
        cell.name_text:SetActive(false)
      end
    end)
  end
end

local ScrollBgColor = {
  [2] = Color.New(0.07058823529411765, 0.4745098039215686, 0.3058823529411765, 0.2980392156862745),
  [3] = Color.New(0.10980392156862745, 0.3411764705882353, 0.6, 0.2980392156862745),
  [4] = Color.New(0.396078431372549, 0.12156862745098039, 0.4980392156862745, 0.2980392156862745),
  [5] = Color.New(0.6901960784313725, 0.43137254901960786, 0.0392156862745098, 0.2980392156862745)
}
local textMaterial = {
  [2] = "Assets/Main/TMPFont/Main/TitleFontMat/Title-Outline_000000_02-Shadow_08804D.mat",
  [3] = "Assets/Main/TMPFont/Main/TitleFontMat/Title-Outline_000000_02-Shadow_255BB4.mat",
  [4] = "Assets/Main/TMPFont/Main/TitleFontMat/Title-Outline_000000_02-Shadow_6A0AAA.mat",
  [5] = "Assets/Main/TMPFont/Main/TitleFontMat/Title-Outline_000000_02-Shadow_B95700.mat"
}

local function SetQuality(self, quality)
  local qualityNum = tonumber(quality)
  if qualityNum < 2 or 5 < qualityNum then
    return
  end
  self.rawImgBg:LoadSprite(string.format("Assets/Main/TextureEx/LWDecorationShopDirectPurchase/FX_zhuangshiwushangdian_diban_%d.png", qualityNum))
  self.rewardItemScrollBg:SetColor(ScrollBgColor[qualityNum])
  self.nameText:ChangeNewMaterial(textMaterial[qualityNum])
end

local function RefreshAll(self)
  if not self.data then
    return
  end
  if self.isFree then
    local canGet = DataCenter.DecorationShopDirectPurchaseManager:GetIfCanFreeReward(self.openType)
    if not canGet then
      CS.UIGray.SetGray(self.freeGetBtn.transform, true, false)
    else
      CS.UIGray.SetGray(self.freeGetBtn.transform, false, true)
    end
    self.nameText:SetLocalText(2000348)
    self.descText:SetActive(false)
    self.freeGetBtn:SetActive(true)
    self.buyBtn:SetActive(false)
    self.newTag:SetActive(false)
    self.discountBg:SetActive(false)
    SetQuality(self, 2)
    RefreshRewards(self, self.data.rewards)
    local refreshInfo = DataCenter.DecorationShopDirectPurchaseManager:GetGiftFreeRefreshInfo(self.openType)
    if not refreshInfo or table.count(refreshInfo) == 0 then
      Logger.LogError("refreshInfo is nil")
      return
    end
    if refreshInfo.refreshFreeTime and refreshInfo.maxTime then
      self.refreshInfoText:SetText(Localization:GetString("decorationshop_giftbuy_desc6", refreshInfo.refreshFreeTime, refreshInfo.maxTime))
    else
      self.refreshInfoText:SetText("")
    end
  else
    self.giftPackData = self.data
    self.descText:SetActive(true)
    if not self.giftPackData then
      Logger.LogError("giftPackData is nil")
      return
    end
    local buyCount = 0
    if self.giftPackData._serverData then
      buyCount = self.giftPackData._serverData.buys or 0
      self.descText:SetLocalText(2000790, buyCount)
    end
    self.freeGetBtn:SetActive(false)
    self.buyBtn:SetActive(true)
    if buyCount <= 0 then
      CS.UIGray.SetGray(self.buyBtn.transform, true, false)
      self.buyBtnText:SetLocalText("decorationshop_giftbuy_desc4")
      self.giftPackPoint:SetActive(false)
    else
      CS.UIGray.SetGray(self.buyBtn.transform, false, true)
      self.buyBtnText:SetText(self.giftPackData:getPriceText())
      self.giftPackPoint:SetActive(true)
      self.giftPackPoint:RefreshPoint(self.giftPackData)
    end
    self.nameText:SetText(self.giftPackData:getNameText())
    local percent = self.giftPackData:getPercent()
    if percent then
      self.discountBg:SetActive(true)
      self.discountText:SetText(string.format("%s%%", tostring(percent)))
    else
      self.discountBg:SetActive(false)
    end
    local packId = self.giftPackData:getID()
    local isNewGift = DataCenter.DecorationShopDirectPurchaseManager:GetPackIfNew(packId)
    self.newTag:SetActive(isNewGift)
    local quality = self.giftPackData:getQuality()
    SetQuality(self, quality)
    RefreshRewards(self, self.giftPackData:getItems(true))
    local refreshInfo = DataCenter.DecorationShopDirectPurchaseManager:GetGiftRefreshInfo(self.openType, packId)
    if not refreshInfo or table.count(refreshInfo) == 0 then
      Logger.LogError("refreshInfo is nil")
      return
    end
    if refreshInfo.buyCount and refreshInfo.maxBuyCount then
      self.refreshInfoText:SetText(Localization:GetString("decorationshop_giftbuy_desc6", refreshInfo.buyCount, refreshInfo.maxBuyCount))
    else
      self.refreshInfoText:SetText("")
    end
  end
end

UIDecorationShopDirectPurchaseItem.OnCreate = OnCreate
UIDecorationShopDirectPurchaseItem.OnDestroy = OnDestroy
UIDecorationShopDirectPurchaseItem.ComponentDefine = ComponentDefine
UIDecorationShopDirectPurchaseItem.ComponentDestroy = ComponentDestroy
UIDecorationShopDirectPurchaseItem.DataDefine = DataDefine
UIDecorationShopDirectPurchaseItem.DataDestroy = DataDestroy
UIDecorationShopDirectPurchaseItem.OnEnable = OnEnable
UIDecorationShopDirectPurchaseItem.OnDisable = OnDisable
UIDecorationShopDirectPurchaseItem.SetData = SetData
UIDecorationShopDirectPurchaseItem.RefreshAll = RefreshAll
UIDecorationShopDirectPurchaseItem.ClearRewards = ClearRewards
UIDecorationShopDirectPurchaseItem.RefreshRewards = RefreshRewards
UIDecorationShopDirectPurchaseItem.OnClickFreeGet = OnClickFreeGet
UIDecorationShopDirectPurchaseItem.OnBuyBtnClick = OnBuyBtnClick
return UIDecorationShopDirectPurchaseItem
