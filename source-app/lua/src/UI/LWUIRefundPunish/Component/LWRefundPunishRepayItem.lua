local base = UIBaseContainer
local LWRefundPunishRepayItem = BaseClass("LWRefundPunishRepayItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWRefundPunishRepayItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWRefundPunishRepayItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWRefundPunishRepayItem:ComponentDefine()
  self.textPrice = self:AddComponent(UITextMeshProUGUIEx, "Price/PriceText")
  self.textItemNum = self:AddComponent(UITextMeshProUGUIEx, "ItemNode/ItemNumText")
  self.btnPrice = self:AddComponent(UIButton, "Price/PriceBtn")
  self.btnPrice:SetOnClick(function()
    self:OnBtnPriceClick()
  end)
  self.imgBrick = self:AddComponent(UIImage, "BrickImage")
  self.compItemNode = self:AddComponent(UIBaseContainer, "ItemNode")
  self.black_bg = self:AddComponent(UIImage, "Price/PriceBtn/BlackBg")
end

function LWRefundPunishRepayItem:ComponentDestroy()
  self.textPrice = nil
  self.textItemNum = nil
  self.btnPrice = nil
  self.imgBrick = nil
  self.compItemNode = nil
  self.black_bg = nil
end

function LWRefundPunishRepayItem:DataDefine()
  self.packageData = {}
  self.packageGoldBrickNum = 0
end

function LWRefundPunishRepayItem:DataDestroy()
  self.packageData = nil
  self.packageGoldBrickNum = nil
end

function LWRefundPunishRepayItem:OnAddListener()
  base.OnAddListener(self)
end

function LWRefundPunishRepayItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWRefundPunishRepayItem:OnBtnPriceClick()
  local curBrickNum = DataCenter.GoldBrickDataManager:GetGoldBrickCount() or 0
  local afterBuy = DataCenter.LWRefundPunishManager:GetBrickNumById(self.packageData:getID(), Config.IsPC()) + curBrickNum
  UIUtil.ShowMessage(Localization:GetString("refund_window_repay_description", curBrickNum, afterBuy), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    DataCenter.PayManager:BuyGift(self.packageData)
  end, nil, nil, "100378")
end

function LWRefundPunishRepayItem:ReInit(index, packageData, isPC)
  if isPC then
    self.packageData = packageData.exchangeInfo
    self.index = index
    local price = packageData.currency_symbol .. packageData.amount
    self.textPrice:SetText(price)
    local iconPath = self.packageData:getPopupImageMini()
    self.imgBrick:LoadSprite(iconPath)
    self.imgBrick:SetNativeSize()
    local brickNum = packageData.brickNum
    self.textItemNum:SetText("x" .. brickNum)
  else
    self.packageData = packageData
    self.index = index
    self.textPrice:SetText(self.packageData:getPriceText())
    local width = self.textPrice.unity_tmpro:GetPreferredValues().x
    width = math.max(174, math.min(width, 200))
    self.black_bg:SetSizeDeltaX(width)
    local iconPath = self.packageData:getPopupImageMini()
    self.imgBrick:LoadSprite(iconPath)
    self.imgBrick:SetNativeSize()
    local brickNum = DataCenter.LWRefundPunishManager:GetBrickNumById(self.packageData:getID())
    self.textItemNum:SetText("x" .. brickNum)
  end
end

return LWRefundPunishRepayItem
