local DiamondItemCell = BaseClass("DiamondItemCell", UIBaseContainer)
local base = UIBaseContainer
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")

function DiamondItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DiamondItemCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function DiamondItemCell:OnEnable()
  base.OnEnable(self)
end

function DiamondItemCell:OnDisable()
  base.OnDisable(self)
end

function DiamondItemCell:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "bg")
  self.price = self:AddComponent(UIText, "bg/price")
  self.reward = self:AddComponent(UIText, "bg/reward")
  self.btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.btn:SetSafeClickMode(true)
  self.icon = self:AddComponent(UIImage, "bg/Icon")
  self.doubleContent = self:AddComponent(UIImage, "bg/Double")
  self.doubleText = self:AddComponent(UIText, "bg/Double/DoubleText")
  self.doubleText:SetLocalText(457562)
  self.doubleJPContent = self:AddComponent(UIImage, "bg/DoubleJP")
  self.doubleJPText = self:AddComponent(UIText, "bg/DoubleJP/Layout/DoubleTextJP")
  self.giftPackagePoint = self:AddComponent(UIGiftPackagePoint, "UIGiftPackagePoint")
  self.diamond_icon = self:AddComponent(UIImage, "bg/deco2")
end

function DiamondItemCell:ComponentDestroy()
  self.btn = nil
  self.price = nil
  self.reward = nil
  self.icon = nil
  self.doubleContent = nil
  self.doubleText = nil
  self.giftPackagePoint = nil
  self.doubleJPContent = nil
  self.doubleJPText = nil
end

function DiamondItemCell:DataDefine()
end

function DiamondItemCell:DataDestroy()
end

local is_JPUser

function DiamondItemCell:Refresh(param)
  self.data = param
  local price = DataCenter.PayManager:GetDollarText(self.data:getPrice(), self.data:getProductID())
  self.price:SetText(price)
  if param:hasPercent() then
    self.reward:SetText(math.floor(param:getDiamond() / 2))
  else
    self.reward:SetText(param:getDiamond())
  end
  local path = self.data:getPopupImageMini()
  self.icon:LoadSprite(path)
  local hasPercent = param:hasPercent()
  local showGoldDetail = DataCenter.PlayerInfoDataManager:ShowGoldDetail()
  self.doubleContent:SetActive(hasPercent and not showGoldDetail)
  self.doubleJPContent:SetActive(hasPercent and showGoldDetail)
  if hasPercent and showGoldDetail then
    self.doubleJPText:SetText(math.floor(param:getDiamond() / 2))
  end
  self.giftPackagePoint:RefreshPoint(param)
  local gold_path = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
  if showGoldDetail then
    gold_path = ResourceTypeIconName[ResourceType.PAID_GOLD]
  end
  self.diamond_icon:LoadSprite(gold_path)
  self.diamond_icon:SetNativeSize()
end

function DiamondItemCell:OnShowClick(param)
  Logger.Log("Buy gift:" .. self.data:getID())
  DataCenter.PayManager:BuyGift(self.data)
end

return DiamondItemCell
