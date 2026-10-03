local base = UIBaseView
local UILuckyRollBuyView = BaseClass("UILuckyRollBuyView", base)
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local bg_path = "Bg"
local banner_path = "Root/Bg1"
local other_banner_path = "Root/OtherBanner"
local descText_path = "Root/DescText"
local titleText_path = "Root/Titile/TitleText"
local confirmToggle_path = "Root/Confirm/ConfirmToggle"
local confirmToggleText_path = "Root/Confirm/ConfirmText"
local confirmBuyBtn_path = "Root/BuyBtn"
local confirmBuyBtnPriceIcon_path = "Root/BuyBtn/Price/PriceIcon"
local confirmBuyBtnPriceText_path = "Root/BuyBtn/Price/PriceText"
local packContent_path = "Root/PackContent"
local packNameText_path = "Root/PackContent/PackNameText"
local buyPackBtn_path = "Root/PackContent/BuyPackBtn"
local buyPackBtnText_path = "Root/PackContent/BuyPackBtn/BuyPackText"
local discountBg_path = "Root/PackContent/DiscountBg"
local discountText_path = "Root/PackContent/DiscountBg/DiscountText"
local packRewards_path = "Root/PackContent/RewardItemScroll/RewardItems"
local packagePoint_path = "Root/PackContent/BuyPackBtn/UIGiftPackagePoint"
local tipText_path = "Root/TipText"

local function OnCreate(self)
  base.OnCreate(self)
  self.itemId, self.packGroupId, self.buyCount, self.activityId, self.type = self:GetUserData()
  self.actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

local function ClearRewards(self)
  self.packRewards:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function OnDestroy(self)
  self:ClearRewards()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function RefreshGold(self)
  if self.cost then
    local have = CommonUtil.GetResOrItemCount(ResourceType.Gold)
    if have < self.cost then
      self.confirmBuyBtnPriceText:SetColor(LackResourceRedColor)
    else
      self.confirmBuyBtnPriceText:SetColor(WhiteColor)
    end
  end
end

local function Refresh(self)
  self.itemTempalte = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  if self.itemTempalte then
    self.itemPrice = self.itemTempalte.price
    self.cost = self.itemPrice * self.buyCount
    self.descText:SetLocalText(2000351, self.cost, self.buyCount)
    self.tipText:SetLocalText(self.itemTempalte.name)
    self.confirmBuyBtnPriceText:SetText(self.cost)
    self:RefreshGold()
  end
  self.confirmBuyBtnPriceIcon:LoadSprite(CommonUtil.GetResOrItemIcon(ResourceType.Gold))
  self.packGroup = GiftPackManager.GetPacksByGroupId(self.packGroupId, false)
  if not table.IsNullOrEmpty(self.packGroup) then
    self.packContent:SetActive(true)
    self.packGfit = self.packGroup[1]
    self.packNameText:SetText(self.packGfit:getNameText())
    self.buyPackBtnText:SetText(self.packGfit:getPriceText())
    self.packPoint:RefreshPoint(self.packGfit)
    local percent = self.packGfit:getPercent()
    if percent then
      self.discountText:SetText(string.format("%s%%", tostring(percent)))
      self.discountBg:SetActive(true)
    else
      self.discountBg:SetActive(false)
    end
    local rewards = self.packGfit:getItems(true)
    self:ClearRewards()
    for i = 1, table.length(rewards) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.packRewards.transform)
        go.transform:Set_localScale(0.7, 0.7, 1)
        go.transform:Set_sizeDelta(82, 82)
        go.transform:Set_localPosition(0, 0, 0)
        go.transform:Set_pivot(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.packRewards:AddComponent(UICommonResItem, go.name)
        cell:ReInit(rewards[i])
      end)
    end
  else
    self.packContent:SetActive(false)
  end
  self.other_banner:SetActive(false)
  if self.actInfo then
    if self.actInfo.type == EnumActivity.LuckyRoll.Type then
      if self.actInfo.subViewType == LuckyRollType.SpringFestival then
        self.banner:LoadSprite("Assets/Main/Sprites/UI/UILuckyRoll/lrb_chunjiezhuanpan_tanchuang.png")
      elseif self.actInfo.subViewType == LuckyRollType.Easter then
        self.banner:LoadSprite("Assets/Main/Sprites/UI/UILuckyRoll/zyf_fuhuojie_dazhuanpan_tanchuang_diban.png")
        self.other_banner:SetActive(true)
      else
        self.banner:LoadSprite("Assets/Main/Sprites/UI/UILuckyRoll/cfm_huodong_dazhuanpan_libaotanchuang.png")
      end
    elseif self.actInfo.type == EnumActivity.ScratchOffGame.Type then
      self.banner:LoadSprite("Assets/Main/Sprites/UI/UIScratchOff/banner.png")
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGold)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.Refresh)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGold)
end

local function ComponentDefine(self)
  self.banner = self:AddComponent(UIImage, banner_path)
  self.other_banner = self:AddComponent(UIRawImage, other_banner_path)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.descText = self:AddComponent(UIText, descText_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.titleText:SetLocalText(2000350)
  self.confirmToggle = self:AddComponent(UIToggle, confirmToggle_path)
  self.confirmToggle:SetOnValueChanged(function(value)
    if self.actInfo then
      if self.actInfo.type == EnumActivity.LuckyRoll.Type then
        DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.BuyLuckyRollTip, not value)
      elseif self.actInfo.type == EnumActivity.ScratchOffGame.Type then
        DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.BuyScratchTip, not value)
      end
    end
  end)
  self.confirmToggleText = self:AddComponent(UIText, confirmToggleText_path)
  self.confirmToggleText:SetLocalText(2000352)
  self.confirmBuyBtn = self:AddComponent(UIButton, confirmBuyBtn_path)
  self.confirmBuyBtn:SetOnClick(function()
    local have = CommonUtil.GetResOrItemCount(ResourceType.Gold)
    if self.cost then
      if have < self.cost then
        GoToUtil.GotoPayTips(self.cost)
      elseif self.actInfo then
        if self.actInfo.type == EnumActivity.LuckyRoll.Type then
          SFSNetwork.SendMessage(MsgDefines.LuckyRollBuyAndUse, self.itemId, self.buyCount, toInt(self.activityId), self.type)
          EventManager:GetInstance():Broadcast(EventId.LuckyRollStart)
        elseif self.actInfo.type == EnumActivity.ScratchOffGame.Type then
          SFSNetwork.SendMessage(MsgDefines.ScratchDiamondExchangeItem, self.itemId, self.buyCount, toInt(self.activityId), self.type)
        end
        self.ctrl:CloseSelf()
      end
    end
  end)
  self.confirmBuyBtnPriceIcon = self:AddComponent(UIImage, confirmBuyBtnPriceIcon_path)
  self.confirmBuyBtnPriceText = self:AddComponent(UIText, confirmBuyBtnPriceText_path)
  self.packContent = self:AddComponent(UIBaseContainer, packContent_path)
  self.packNameText = self:AddComponent(UIText, packNameText_path)
  self.buyPackBtn = self:AddComponent(UIButton, buyPackBtn_path)
  self.buyPackBtn:SetOnClick(function()
    if self.packGfit then
      DataCenter.PayManager:CallPayment(self.packGfit, UIWindowNames.UILuckyRollBuy)
    end
  end)
  self.buyPackBtn:SetSafeClickMode(true)
  self.buyPackBtnText = self:AddComponent(UIText, buyPackBtnText_path)
  self.discountBg = self:AddComponent(UIImage, discountBg_path)
  self.discountText = self:AddComponent(UIText, discountText_path)
  local toggleState = true
  if self.actInfo then
    if self.actInfo.type == EnumActivity.LuckyRoll.Type then
      toggleState = not DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.BuyLuckyRollTip)
    elseif self.actInfo.type == EnumActivity.ScratchOffGame.Type then
      toggleState = not DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.BuyScratchTip)
    end
  end
  self.confirmToggle:SetIsOn(toggleState)
  self.packRewards = self:AddComponent(UIBaseContainer, packRewards_path)
  self.packPoint = self:AddComponent(UIGiftPackagePoint, packagePoint_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.banner = nil
  self.other_banner = nil
  self.descText = nil
  self.titleText = nil
  self.confirmToggle = nil
  self.confirmToggleText = nil
  self.confirmBuyBtn = nil
  self.confirmBuyBtnPriceIcon = nil
  self.confirmBuyBtnPriceText = nil
  self.packContent = nil
  self.packNameText = nil
  self.buyPackBtn = nil
  self.buyPackBtnText = nil
  self.discountBg = nil
  self.discountText = nil
  self.packRewards = nil
  self.packPoint = nil
  self.tipText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UILuckyRollBuyView:OnEnable()
  base.OnEnable(self)
  self:Refresh()
end

UILuckyRollBuyView.OnCreate = OnCreate
UILuckyRollBuyView.OnDestroy = OnDestroy
UILuckyRollBuyView.OnAddListener = OnAddListener
UILuckyRollBuyView.OnRemoveListener = OnRemoveListener
UILuckyRollBuyView.ComponentDefine = ComponentDefine
UILuckyRollBuyView.ComponentDestroy = ComponentDestroy
UILuckyRollBuyView.DataDefine = DataDefine
UILuckyRollBuyView.DataDestroy = DataDestroy
UILuckyRollBuyView.Refresh = Refresh
UILuckyRollBuyView.RefreshGold = RefreshGold
UILuckyRollBuyView.ClearRewards = ClearRewards
return UILuckyRollBuyView
