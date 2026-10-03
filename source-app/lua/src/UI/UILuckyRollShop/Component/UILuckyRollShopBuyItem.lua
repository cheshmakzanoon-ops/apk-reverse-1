local UILuckyRollShopBuyItem = BaseClass("UILuckyRollShopJumpItem", UIBaseContainer)
local base = UIBaseContainer

function UILuckyRollShopBuyItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "Bg")
  self.icon = self:AddComponent(UIImage, "Icon")
  self.nameText = self:AddComponent(UIText, "NameText")
  self.descText = self:AddComponent(UIText, "DescText")
  self.buyBtn = self:AddComponent(UIButton, "BuyBtn")
  self.buyBtn:SetOnClick(function()
    self:OnBuyBtnClick()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.buyBtnText = self:AddComponent(UIText, "BuyBtn/BuyBtnText")
  self.buyBtnText:SetLocalText(110080)
end

function UILuckyRollShopBuyItem:OnDestroy()
  base.OnDestroy(self)
end

function UILuckyRollShopBuyItem:SetData(data, actId)
  self.data = data.realData
  self.actId = actId
  local realData = data.realData
  self.icon:LoadSprite(realData.pic)
  self.nameText:SetLocalText(realData.name)
  self.descText:SetLocalText(realData.des)
end

function UILuckyRollShopBuyItem:OnBuyBtnClick()
  local goodsConf = self.data.goodsConf
  if goodsConf then
    DataCenter.CommonShopManager:Buy(goodsConf.id, goodsConf.shopType, function(buyCount)
      SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, goodsConf.id, nil, buyCount)
    end)
  end
end

return UILuckyRollShopBuyItem
