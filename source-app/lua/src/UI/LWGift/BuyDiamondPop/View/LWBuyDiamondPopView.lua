local LWBuyDiamondPopView = BaseClass("LWBuyDiamondPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ShopPageToggle = require("UI.LWGift.BuyDiamond.Component.ShopPageToggle")
local DiamondShopPage = require("UI.LWGift.BuyDiamond.Component.DiamondShopPage")
local GoldBrickStorePage = require("UI.LWGift.BuyDiamond.Component.GoldBrickStorePage")
local DailyPackage = require("UI.UIGiftPackage.Component.DailyPackage")
local PackShopPage = require("UI.UIGiftPackage.Component.GiftPackagePagePanel")
local WeekCardPage = require("UI.UIGiftPackage.Component.WeekCard.WeekCardMain")
local LWMonthCardPage = require("UI.UIGiftPackage.Component.UILWMonthCard.UILWMonthCard")
local UILWLimitedPack = require("UI.UIGiftPackage.Component.UILWLimitedPack.UILWLimitedPack")
local UILWWeeklyPackageMain = require("UI.UIGiftPackage.Component.UILWWeeklyPackage.UILWWeeklyPackageMain")
local UILWDailyMustBuyMain = require("UI.UIGiftPackage.Component.DailyMustBuy.UILWDailyMustBuyMain")
local UILWPiggyBankPage = require("UI.UIGiftPackage.Component.UIPiggyBankPanel")
local HeroMonthCardPanel = require("UI.UIGiftPackage.Component.HeroMonthCard.HeroMonthCardMain")
local tagTypeTable = {}
tagTypeTable[WelfareTagType.DiamondShop] = {
  assetPath = UIAssets.UIDiamondShopPage,
  cls = DiamondShopPage
}
tagTypeTable[WelfareTagType.GoldBrickStore] = {
  assetPath = UIAssets.UGoldBrickStorePage,
  cls = GoldBrickStorePage
}
tagTypeTable[WelfareTagType.DailyPackage] = {
  assetPath = UIAssets.UIDailyPackagePage,
  cls = DailyPackage
}
tagTypeTable[WelfareTagType.PackStore] = {
  assetPath = UIAssets.LUAGiftPackagePagePanel,
  cls = PackShopPage
}
tagTypeTable[WelfareTagType.WeekCard] = {
  assetPath = UIAssets.UIWeekCardPage,
  cls = WeekCardPage
}
tagTypeTable[WelfareTagType.MonthCard] = {
  assetPath = UIAssets.UILWMonthCardPage,
  cls = LWMonthCardPage
}
tagTypeTable[WelfareTagType.SpecialPackStoreStyle] = {
  assetPath = UIAssets.UILWLimitedPack,
  cls = UILWLimitedPack
}
tagTypeTable[WelfareTagType.WeeklyPackageNew] = {
  assetPath = UIAssets.UILWWeeklyPackageMain,
  cls = UILWWeeklyPackageMain
}
tagTypeTable[WelfareTagType.DailyMustBuy] = {
  assetPath = UIAssets.UILWDailyMustBuy,
  cls = UILWDailyMustBuyMain
}
tagTypeTable[WelfareTagType.PiggyBank] = {
  assetPath = UIAssets.UILWPiggyBank,
  cls = UILWPiggyBankPage
}
tagTypeTable[WelfareTagType.HeroMonthCardNew] = {
  assetPath = UIAssets.UILWHeroMonthCardPop,
  cls = HeroMonthCardPanel
}

function LWBuyDiamondPopView:OnCreate()
  base.OnCreate(self)
  self.gotoPackType, self.gotoPackId = self:GetUserData()
  if self.gotoPackType then
    local showTag = WelfareController.getShowTagInfoByType(self.gotoPackType)
    if showTag ~= nil then
      self.gotoPackId = showTag:getID()
    end
  end
  self:DataDefine()
  self:ComponentDefine()
  self:RefreshTabsData()
  if not table.IsNullOrEmpty(self.tabs) then
    self:SwitchPage(1)
  else
    self.ctrl:CloseSelf()
  end
end

function LWBuyDiamondPopView:OnDestroy()
  self:ClearAllContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWBuyDiamondPopView:DataDefine()
  self.packPrefabList = {}
  self.packCompList = {}
end

function LWBuyDiamondPopView:DataDestroy()
  self.packPrefabList = nil
  self.packCompList = nil
end

function LWBuyDiamondPopView:ComponentDefine()
  self.closeBg = self:AddComponent(UIButton, "closeBtn")
  self.closeBg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn2 = self:AddComponent(UIButton, "Root/TopBar/closeBtn2")
  self.closeBtn2:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.contentContainer = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/ContentContainer")
end

function LWBuyDiamondPopView:ComponentDestroy()
  self.closeBg = nil
  self.closeBtn2 = nil
  self.contentContainer = nil
end

function LWBuyDiamondPopView:RefreshTabsData()
  self.tabs = {}
  local showData = WelfareController.getShowTagInfoById(self.gotoPackId)
  if showData then
    table.insert(self.tabs, showData)
  end
end

function LWBuyDiamondPopView:OnBackBtnClick()
  self.ctrl:CloseSelf()
end

function LWBuyDiamondPopView:SwitchPage(id)
  local hasData = false
  local index = id
  hasData = self.tabs[index] ~= nil
  if not hasData then
    return
  end
  self:OnSwitchTab(index)
end

function LWBuyDiamondPopView:OnSwitchTab(newPageId)
  local newPageType = self:GetTagTypeById(newPageId)
  local newPageTagId = self:GetTagIdById(newPageId)
  local handlerData
  handlerData = tagTypeTable[newPageType]
  if not self.packPrefabList[newPageId] and handlerData and handlerData.assetPath and handlerData.cls then
    self.packPrefabList[newPageId] = self:GameObjectInstantiateAsync(handlerData.assetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.contentContainer.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = tostring(newPageId)
      go:SetActive(true)
      local pageComp = self.contentContainer:AddComponent(handlerData.cls, go.name)
      pageComp:SetOffsetMinXY(0, 0)
      pageComp:SetOffsetMaxXY(0, 0)
      self.packCompList[newPageId] = pageComp
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(pageComp.rectTransform)
      self:RefreshCompData(newPageId)
    end)
  else
    self:RefreshCompData(newPageId)
  end
end

function LWBuyDiamondPopView:RefreshCompData(newPageId)
  if self.packCompList[newPageId] == nil then
    return
  end
  self.packCompList[newPageId]:SetActive(true)
  local comp = self.packCompList[newPageId]
  local newPageType = self:GetTagTypeById(newPageId)
  local newPageTagId = self:GetTagIdById(newPageId)
  if comp then
    if newPageType == WelfareTagType.DiamondShop then
      comp:RefreshView()
    elseif newPageType == WelfareTagType.GoldBrickStore then
      comp:RefreshView()
    elseif newPageType == WelfareTagType.PackStore then
      local param = {}
      param.welfareTagType = newPageType
      comp:ReInit(param)
    elseif newPageType == WelfareTagType.MonthCard then
      local param = {}
      param.welfareTagType = newPageType
      local golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
      param.monthCardInfo = golloesMonthCard
      comp:ReInit(param, self)
    elseif newPageType == WelfareTagType.SingleActivity then
      local rechargeData = self.tabs[newPageId]
      if rechargeData and rechargeData:getInfo() then
        local actData = rechargeData:getInfo()
        comp:SetData(actData.activityId, actData.id)
      end
    elseif newPageType == WelfareTagType.DailyPackage or newPageType == WelfareTagType.WeekCard or newPageType == WelfareTagType.SpecialPackStoreStyle or newPageType == WelfareTagType.WeeklyPackageNew or newPageType == WelfareTagType.DailyMustBuy then
      comp:ReInit(newPageTagId)
    elseif newPageType == WelfareTagType.HeroMonthCardNew then
      local rechargeData = self.tabs[newPageId]
      if rechargeData then
        comp:ReInit(rechargeData:getID())
        comp:SetBuyDiamondViewType(BuyDiamondViewType.PopUp)
      end
    end
  end
  if comp and newPageType == WelfareTagType.HeroMonthCardNew then
    PostEventLog.Track(PostEventLog.Defines.HeroMonthCardPopViewOpen, {})
  end
end

function LWBuyDiamondPopView:ClearAllContent()
  if self.packCompList ~= nil then
    for k, v in pairs(self.packCompList) do
      if v ~= nil then
        self:GameObjectDestroy(v.gameObject)
      end
    end
  end
  self.packCompList = {}
  if self.packPrefabList ~= nil then
    for k, v in pairs(self.packPrefabList) do
      if v ~= nil then
        self:GameObjectDestroy(v.gameObject)
      end
    end
  end
  self.packPrefabList = {}
end

function LWBuyDiamondPopView:GetTagTypeById(id)
  local tagType
  if not self.tabs[id] then
    return tagType
  end
  tagType = self.tabs[id]:getType()
  return tagType
end

function LWBuyDiamondPopView:GetTagIdById(id)
  local tagType
  if not self.tabs[id] then
    return tagType
  end
  tagType = self.tabs[id]:getID()
  return tagType
end

return LWBuyDiamondPopView
