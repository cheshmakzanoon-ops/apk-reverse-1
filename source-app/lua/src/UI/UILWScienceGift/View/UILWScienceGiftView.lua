local UILWScienceGift = BaseClass("UILWScienceGift", UIBaseView)
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local base = UIBaseView

function UILWScienceGift:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UILWScienceGift:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "panel/Common_bg_orange/closeBtn")
  self.buyBtn = self:AddComponent(LWBtnBuyRefundRemind, "panel/giftBuyBtn")
  self.giftValueText = self:AddComponent(UIText, "panel/Common_bg_orange/infoGlodLayout/giftValueText")
  self.giftItem = self.transform:Find("panel/Common_bg_orange/gitfItem").gameObject
  self.rewardsLayout = self:AddComponent(UIBaseContainer, "panel/Common_bg_orange/PackageContent/layout")
  self.buildBtn = self:AddComponent(UIButton, "panel/Common_bg_orange/PackageContent/layout/buildBtn")
  self.panelCloseBtn = self:AddComponent(UIButton, "panel")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.buildBtn:SetOnClick(function()
    local param = {}
    param.rewardType = RewardType.Building
    param.itemId = BuildingTypes.LW_BUILE_SCIENCE_TWO
    param.alignObject = self.buildBtn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.buyBtn:SetBuyClickCallBack(function()
    self.ctrl:CloseSelf()
  end)
  self.discountText = self:AddComponent(UIText, "panel/Common_bg_orange/PackageContent/DiscountInfo/DiscountText")
end

function UILWScienceGift:ComponentDestroy()
  self.closeBtn = nil
  self.buyBtn = nil
  self.giftValueText = nil
  self.giftItem = nil
  self.rewardsLayout = nil
  self.buildBtn = nil
  self.panelCloseBtn = nil
  self.giftPackPoint = nil
end

function UILWScienceGift:ReInit()
  self.pack = self.ctrl:GetGiftInfo()
  if not self.pack then
    self.ctrl:CloseSelf()
    return
  end
  self.buyBtn:Init(self.pack)
  self.giftItem.gameObject:GameObjectCreatePool()
  self.rewardsLayout:RemoveComponents(UICommonResItem)
  self.giftItem.gameObject:GameObjectRecycleAll()
  local infos = self.pack:getItems()
  for i = 1, #infos do
    local item = self.giftItem:GameObjectSpawn(self.rewardsLayout.transform)
    item.name = "giftItem" .. i
    local obj = self.rewardsLayout:AddComponent(UICommonResItem, item.name)
    obj:ReInit(infos[i])
  end
  self.buyBtn:RefreshPoint()
  self.discountText:SetText(string.format("%s%%", self.pack:getPercent()))
end

function UILWScienceGift:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWScienceGift:DataDestroy()
  self.pack = nil
end

return UILWScienceGift
