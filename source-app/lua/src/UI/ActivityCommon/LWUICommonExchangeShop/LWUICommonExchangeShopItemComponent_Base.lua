local base = UIBaseContainer
local LWUICommonExchangeShopItemComponent_Base = BaseClass("LWUICommonExchangeShopItemComponent_Base", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUICommonExchangeShopItemComponent_Base:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICommonExchangeShopItemComponent_Base:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICommonExchangeShopItemComponent_Base:ComponentDefine()
  self.btnSelf = self:AddComponent(UIButton, "")
  self.btnSelf:SetOnClick(function()
    self:OnBtnSelfClick()
  end)
  self.imgBackground = self:AddComponent(UIImage, "Background")
  self.textExchangeTime = self:AddComponent(UITextMeshProUGUIEx, "ExchangeTimeText")
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.imgTagContent = self:AddComponent(UIImage, "TagContent")
  self.textTagYellow = self:AddComponent(UITextMeshProUGUIEx, "TagContent/TagTextYellow")
  self.textTagRed = self:AddComponent(UITextMeshProUGUIEx, "TagContent/TagTextRed")
  self.compCostItemLayout = self:AddComponent(UIBaseComponent, "CostItemLayout")
  self.imgCostItem = self:AddComponent(UIImage, "CostItemLayout/CostItemImage")
  self.textCostItem = self:AddComponent(UITextMeshProUGUIEx, "CostItemLayout/CostItemText")
  self.textBuyCondition = self:AddComponent(UITextMeshProUGUIEx, "BuyConditionText")
  self.compDarkMask = self:AddComponent(UIBaseComponent, "DarkMask")
  self.textSold = self:AddComponent(UITextMeshProUGUIEx, "SoldText")
end

function LWUICommonExchangeShopItemComponent_Base:ComponentDestroy()
  self.btnSelf = nil
  self.imgBackground = nil
  self.textExchangeTime = nil
  self.compUICommonResItem = nil
  self.imgTagContent = nil
  self.textTagYellow = nil
  self.textTagRed = nil
  self.compCostItemLayout = nil
  self.imgCostItem = nil
  self.textCostItem = nil
  self.textBuyCondition = nil
  self.compDarkMask = nil
  self.textSold = nil
end

function LWUICommonExchangeShopItemComponent_Base:DataDefine()
end

function LWUICommonExchangeShopItemComponent_Base:DataDestroy()
end

function LWUICommonExchangeShopItemComponent_Base:OnAddListener()
  base.OnAddListener(self)
end

function LWUICommonExchangeShopItemComponent_Base:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICommonExchangeShopItemComponent_Base:ReInit(data)
  self.data = data
  if self.data == nil then
    return
  end
  self:RefreshAll()
end

function LWUICommonExchangeShopItemComponent_Base:RefreshAll()
  self:RefreshBackground()
  self:RefreshTimes()
  self:RefreshTargetItem()
  self:RefreshTag()
  self:RefreshCost()
  self:RefreshBuyCondition()
  self:RefreshMask()
  self:RefreshSoldText()
end

function LWUICommonExchangeShopItemComponent_Base:RefreshBackground()
  if self.data == nil then
    return
  end
  local img = self.data:GetBackgroundImage()
  if not string.IsNullOrEmpty(img) then
    self.imgBackground:LoadSprite(img)
  end
end

function LWUICommonExchangeShopItemComponent_Base:RefreshTimes()
  if self.data == nil then
    return
  end
  local showText = self.data:GetExchangeTimesText()
  local isShow = not string.IsNullOrEmpty(showText)
  self.textExchangeTime:SetActive(isShow)
  if isShow then
    self.textExchangeTime:SetText(showText)
  end
end

function LWUICommonExchangeShopItemComponent_Base:RefreshTargetItem()
  if self.data == nil then
    return
  end
  local rewardShowData = self.data:GetRewardData()
  self.compUICommonResItem:SetActive(rewardShowData ~= nil)
  if rewardShowData ~= nil then
    self.compUICommonResItem:ReInit(rewardShowData)
  end
end

function LWUICommonExchangeShopItemComponent_Base:RefreshTag()
  if self.data == nil then
    return
  end
  local showTag = false
  local yellowText = self.data:GetTagTextYellow()
  self.textTagYellow:SetActive(not string.IsNullOrEmpty(yellowText))
  if not string.IsNullOrEmpty(yellowText) then
    showTag = true
    self.textTagYellow:SetText(yellowText)
    self.imgTagContent:LoadSprite("Assets/Main/Sprites/UI/LWUICommonExchangeShop/fx_youhua_shangcheng_libao_libaoshangcheng_zhekou_huang.png")
  end
  local redText = self.data:GetTagTextRed()
  self.textTagRed:SetActive(not string.IsNullOrEmpty(redText))
  if not string.IsNullOrEmpty(redText) then
    showTag = true
    self.textTagRed:SetText(redText)
    self.imgTagContent:LoadSprite("Assets/Main/Sprites/UI/LWUICommonExchangeShop/cfm_youhua_shangcheng_libao_libaoshangcheng_zhekou.png")
  end
  self.imgTagContent:SetActive(showTag)
end

function LWUICommonExchangeShopItemComponent_Base:RefreshCost()
  if self.data == nil then
    return
  end
  local isShow = self.data:IsShowCost()
  self.compCostItemLayout:SetActive(isShow)
  if isShow then
    local img = self.data:GetCostItemImage()
    if not string.IsNullOrEmpty(img) then
      self.imgCostItem:LoadSprite(img)
    end
    self.textCostItem:SetText(self.data:GetCostItemCountText())
  end
end

function LWUICommonExchangeShopItemComponent_Base:RefreshBuyCondition()
  if self.data == nil then
    return
  end
  local text = self.data:GetBuyConditionText()
  self.textBuyCondition:SetActive(not string.IsNullOrEmpty(text))
  if not string.IsNullOrEmpty(text) then
    self.textBuyCondition:SetText(text)
  end
end

function LWUICommonExchangeShopItemComponent_Base:RefreshSoldText()
  if self.data == nil then
    return
  end
  local text = self.data:GetSoldText()
  self.textSold:SetActive(not string.IsNullOrEmpty(text))
  if not string.IsNullOrEmpty(text) then
    self.textSold:SetText(text)
  end
end

function LWUICommonExchangeShopItemComponent_Base:RefreshMask()
  if self.data == nil then
    return
  end
  local isShow = self.data:IsShowMask()
  self.compDarkMask:SetActive(isShow)
end

function LWUICommonExchangeShopItemComponent_Base:Update1000MS()
end

function LWUICommonExchangeShopItemComponent_Base:OnBtnSelfClick()
  if self.data == nil then
    return
  end
  self.data:OnExchangeClick()
end

return LWUICommonExchangeShopItemComponent_Base
