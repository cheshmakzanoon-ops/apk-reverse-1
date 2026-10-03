local UICommonActivityGiftPackageItem = BaseClass("UICommonActivityGiftPackageItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local bgPath = "Bg"
local rawBgPath = "RawImgBg"
local glowBgPath = "GlowBg"
local nameTextPath = "NameText"
local iconPath = "Icon"
local descText = "DescText"
local freeGetBtnPath = "FreeGetBtn"
local freeGetBtnTextPath = "FreeGetBtn/FreeGetBtnText"
local goldGetBtnPath = "GoldBtn"
local goldGetBtnTextPath = "GoldBtn/GoldBtnText"
local goldGetBtnImagePath = "GoldBtn/GoldBtnImage"
local buyBtnPath = "BuyBtn"
local buyBtnTextPath = "BuyBtn/BuyBtnText"
local hotTagPath = "HotTag"
local hotTagTextPath = "HotTag/HotText"
local discountBgPath = "DiscountBg"
local discountTextPath = "DiscountBg/DiscountText"
local rewardItemsPath = "RewardItemScroll/RewardItems"
local glowBgColor = {
  [2] = Color.New(0.29, 0.94, 0.71, 1),
  [3] = Color.New(0.3, 0.92, 0.93, 1),
  [4] = Color.New(0.78, 0.59, 0.98, 1),
  [5] = Color.New(0.99, 0.86, 0.36, 1)
}

function UICommonActivityGiftPackageItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddTimer()
end

function UICommonActivityGiftPackageItem:OnDestroy()
  self:ClearRewards()
  self:ComponentDestroy()
  self:DataDestroy()
  self:DelTimer()
  base.OnDestroy(self)
end

function UICommonActivityGiftPackageItem:OnClickFreeGet()
  if not self.data or not self.data.realData then
    return
  end
  if self.data.giftPackageType == self.view.GiftPackageType.Free then
    if self.data.realData.canBuyFunc ~= nil and self.data.realData.canBuyFunc(self.data.activityId, self.data.realData.userData) and self.data.realData.clickBuyFunc then
      self.data.realData.clickBuyFunc(self.data.activityId, self.data.realData.userData)
    end
  elseif self.data.giftPackageType == self.view.GiftPackageType.Pay then
    DataCenter.PayManager:CallPayment(self.data.realData, UIWindowNames.UICommonActivityGiftPackage)
  end
end

function UICommonActivityGiftPackageItem:OnClickGoldGet()
  if not self.data or not self.data.realData then
    return
  end
  if self.data.giftPackageType == self.view.GiftPackageType.Gold then
    if self.data.realData.canBuyFunc ~= nil and self.data.realData.canBuyFunc(self.data.activityId, self.data.realData.userData) and self.data.realData.clickBuyFunc then
      self.data.realData.clickBuyFunc(self.data.activityId, self.data.realData.userData)
    end
  elseif self.data.giftPackageType == self.view.GiftPackageType.Pay then
    DataCenter.PayManager:CallPayment(self.data.realData, UIWindowNames.UICommonActivityGiftPackage)
  end
end

function UICommonActivityGiftPackageItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bgPath)
  self.rawImgBg = self:AddComponent(UIRawImage, rawBgPath)
  self.glowBg = self:AddComponent(UIImage, glowBgPath)
  self.nameText = self:AddComponent(UIText, nameTextPath)
  self.icon = self:AddComponent(UIImage, iconPath)
  self.descText = self:AddComponent(UIText, descText)
  self.freeGetBtn = self:AddComponent(UIButton, freeGetBtnPath)
  self.freeGetBtn:SetOnClick(function()
    self:OnClickFreeGet()
  end)
  self.freeGetBtnText = self:AddComponent(UIText, freeGetBtnTextPath)
  self.freeGetBtnText:SetLocalText(170004)
  self.buyBtn = self:AddComponent(LWBtnBuyRefundRemind, buyBtnPath)
  self.buyBtn:SetSafeClickMode(true)
  self.hotTag = self:AddComponent(UIImage, hotTagPath)
  self.hotTagText = self:AddComponent(UIText, hotTagTextPath)
  self.hotTagText:SetLocalText(2000353)
  self.discountBg = self:AddComponent(UIImage, discountBgPath)
  self.discountText = self:AddComponent(UIText, discountTextPath)
  self.rewardItems = self:AddComponent(UIBaseContainer, rewardItemsPath)
  self.goldGetBtn = self:AddComponent(UIButton, goldGetBtnPath)
  self.goldGetBtn:SetOnClick(function()
    self:OnClickGoldGet()
  end)
  self.goldGetBtnText = self:AddComponent(UIText, goldGetBtnTextPath)
  self.goldGetBtnImage = self:AddComponent(UIImage, goldGetBtnImagePath)
end

function UICommonActivityGiftPackageItem:ComponentDestroy()
  self.bg = nil
  self.glowBg = nil
  self.nameText = nil
  self.icon = nil
  self.descText = nil
  self.freeGetBtn = nil
  self.freeGetBtnText = nil
  self.buyBtn = nil
  self.buyBtnText = nil
  self.goldGetBtnImage = nil
  self.hotTag = nil
  self.hotTagText = nil
  self.discountBg = nil
  self.discountText = nil
  self.rewardItems = nil
  self.giftPackPoint = nil
end

function UICommonActivityGiftPackageItem:DataDefine()
end

function UICommonActivityGiftPackageItem:DataDestroy()
  self.TimerAction = nil
end

function UICommonActivityGiftPackageItem:OnEnable()
  base.OnEnable(self)
end

function UICommonActivityGiftPackageItem:OnDisable()
  base.OnDisable(self)
end

function UICommonActivityGiftPackageItem:SetData(data)
  self.data = data
  self:RefreshAll()
end

function UICommonActivityGiftPackageItem:ClearRewards()
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

function UICommonActivityGiftPackageItem:RefreshRewards(rewards)
  self:ClearRewards()
  if rewards == nil then
    return
  end
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

function UICommonActivityGiftPackageItem:RefreshGoldBtn()
  if self.data == nil or self.data.realData == nil then
    return
  end
  local canBuy = false
  if self.data.realData.canBuyFunc ~= nil then
    canBuy = self.data.realData.canBuyFunc(self.data.activityId, self.data.realData.userData)
  end
  if canBuy then
    CS.UIGray.SetGray(self.goldGetBtn.transform, false, true)
  else
    CS.UIGray.SetGray(self.goldGetBtn.transform, true, true)
  end
  self.goldGetBtnText:SetText(tostring(self.data.realData.costGoldNum or 0))
  self.goldGetBtnImage:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_gold.png")
end

function UICommonActivityGiftPackageItem:RefreshPay()
  if self.data == nil or self.data.realData == nil then
    return
  end
  local giftPackData = self.data.realData
  local buyType = giftPackData:GetBuyType()
  local residueBuys = giftPackData._serverData.buy_times - (giftPackData._serverData.buys or 0)
  self.descText:SetActive(true)
  if self.data.itemContentType == self.view.ItemContentType.GiftInAct then
    if 0 < residueBuys then
      self.descText:SetLocalText("package_tips_limit_20", residueBuys)
      self.descText:SetActive(true)
    else
      self.descText:SetActive(false)
    end
  else
    self.descText:SetLocalText(2000790, residueBuys)
  end
  self.nameText:SetText(giftPackData:getNameText())
  self.freeGetBtn:SetActive(false)
  self.goldGetBtn:SetActive(false)
  self.rawImgBg:SetActive(false)
  local isBestBuy = giftPackData:IsBestBuy()
  self.hotTag:SetActive(isBestBuy)
  local quality = giftPackData:getQuality()
  local qualityNum = tonumber(quality)
  if 1 <= qualityNum and qualityNum <= 5 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UILuckyRoll/cfm_huodong_dazhuanpan_libao_ka_%d.png", qualityNum))
    if 1 < qualityNum then
      self.glowBg:SetActive(true)
      self.glowBg:SetColor(glowBgColor[qualityNum])
    else
      self.glowBg:SetActive(false)
    end
  end
  local showIcon = false
  if self.data.exchangeGiftPackageIcon ~= nil then
    showIcon = true
    self.icon:LoadSprite(self.data.exchangeGiftPackageIcon)
    self.icon:SetNativeSize()
  end
  self.icon:SetActive(showIcon)
  self.buyBtn:SetActive(buyType == GiftPackageBuyType.Money)
  self.freeGetBtn:SetActive(buyType == GiftPackageBuyType.Free)
  self.goldGetBtn:SetActive(buyType == GiftPackageBuyType.PlayerGold)
  if buyType == GiftPackageBuyType.Money then
    self.buyBtn:Init(giftPackData)
    self.buyBtn:RefreshPoint()
    self:RefreshRewards(giftPackData:getItems(true))
    local percent = giftPackData:getPercent()
    if percent then
      self.discountBg:SetActive(true)
      self.discountText:SetText(string.format("%s%%", tostring(percent)))
    else
      self.discountBg:SetActive(false)
    end
    self.buyBtn:SetGray(false, true)
    if residueBuys == 0 then
      self.buyBtn:SetPriceText(Localization:GetString("129060"))
      self.buyBtn:SetGray(true, false)
    end
  elseif buyType == GiftPackageBuyType.Free then
    self:RefreshRewards(giftPackData:getFreeAndGoldBuyReward())
    self.discountBg:SetActive(false)
  elseif buyType == GiftPackageBuyType.PlayerGold then
    self:RefreshRewards(giftPackData:getFreeAndGoldBuyReward())
    local resourceType, num = giftPackData:GetResourceBuyCostTypeAndNum()
    if resourceType ~= nil then
      self.goldGetBtnImage:LoadSprite(CommonUtil.GetResOrItemIcon(resourceType))
      self.goldGetBtnText:SetText(num)
    else
      Logger.LogError("\231\173\150\229\136\146\233\133\141\233\148\153\228\186\134\239\188\129  exchangeId:" .. giftPackData._tableData.id)
    end
    self.discountBg:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.goldGetBtn.transform)
  end
end

function UICommonActivityGiftPackageItem:RefreshFree()
  if self.data == nil or self.data.realData == nil then
    return
  end
  self:RefreshFreeBtn()
  self.nameText:SetActive(true)
  if self.data.realData.title ~= nil then
    self.nameText:SetText(self.data.realData.title)
  else
    self.nameText:SetLocalText(2000348)
  end
  local showIcon = false
  if self.data.realData.icon ~= nil then
    showIcon = true
    self.icon:LoadSprite(self.data.realData.icon)
    self.icon:SetNativeSize()
  end
  self.icon:SetActive(showIcon)
  self.glowBg:SetActive(showIcon)
  self.descText:SetActive(false)
  self.freeGetBtn:SetActive(true)
  self.buyBtn:SetActive(false)
  self.hotTag:SetActive(false)
  self.discountBg:SetActive(false)
  self.goldGetBtn:SetActive(false)
  local showBg = false
  if self.data.realData.background ~= nil then
    showBg = true
    self.rawImgBg:LoadSpriteAuto(self.data.realData.background)
  end
  self.rawImgBg:SetActive(showBg)
  self:RefreshRewards(self.data.realData.rewards)
end

function UICommonActivityGiftPackageItem:RefreshFreeBtn()
  if self.data == nil or self.data.realData == nil then
    return
  end
  local canBuy = false
  if self.data.realData.canBuyFunc ~= nil then
    canBuy = self.data.realData.canBuyFunc(self.data.activityId, self.data.realData.userData)
  end
  if canBuy then
    CS.UIGray.SetGray(self.freeGetBtn.transform, false, true)
  else
    CS.UIGray.SetGray(self.freeGetBtn.transform, true, true)
  end
end

function UICommonActivityGiftPackageItem:RefreshGold()
  if self.data == nil or self.data.realData == nil then
    return
  end
  self:RefreshGoldBtn()
  self.nameText:SetActive(self.data.realData.title ~= nil)
  if self.data.realData.title ~= nil then
    self.nameText:SetText(self.data.realData.title)
  end
  local showIcon = false
  if self.data.realData.icon ~= nil then
    showIcon = true
    self.icon:LoadSprite(self.data.realData.icon)
    self.icon:SetNativeSize()
  end
  self.icon:SetActive(showIcon)
  local qualityNum = checknumber(self.data.realData.quality)
  if 1 <= qualityNum and qualityNum <= 5 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UILuckyRoll/cfm_huodong_dazhuanpan_libao_ka_%d.png", qualityNum))
    if 1 < qualityNum then
      self.glowBg:SetActive(true)
      self.glowBg:SetColor(glowBgColor[qualityNum])
    else
      self.glowBg:SetActive(false)
    end
  end
  self.descText:SetActive(false)
  self.freeGetBtn:SetActive(false)
  self.buyBtn:SetActive(false)
  self.hotTag:SetActive(false)
  self.discountBg:SetActive(false)
  self.goldGetBtn:SetActive(true)
  self.rawImgBg:SetActive(false)
  local showBg = false
  if self.data.realData.background ~= nil then
    showBg = true
    self.bg:LoadSpriteAuto(self.data.realData.background)
  end
  self.bg:SetActive(showBg)
  self:RefreshRewards(self.data.realData.rewards)
end

function UICommonActivityGiftPackageItem:RefreshAll()
  if not self.data then
    return
  end
  self:DelTimer()
  if self.data.giftPackageType == self.view.GiftPackageType.Pay then
    self:RefreshPay()
  end
  if self.data.giftPackageType == self.view.GiftPackageType.Free then
    self:RefreshFree()
  end
  if self.data.giftPackageType == self.view.GiftPackageType.Gold then
    self:RefreshGold()
  end
end

function UICommonActivityGiftPackageItem:AddTimer()
  function self.TimerAction()
    self:OnSecondTick()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

function UICommonActivityGiftPackageItem:OnSecondTick()
  if self.data == nil then
    return
  end
  if self.data.giftPackageType == self.view.GiftPackageType.Free then
    self:RefreshFreeBtn()
  end
  if self.data.giftPackageType == self.view.GiftPackageType.Free then
    self:RefreshGoldBtn()
  end
end

function UICommonActivityGiftPackageItem:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

return UICommonActivityGiftPackageItem
