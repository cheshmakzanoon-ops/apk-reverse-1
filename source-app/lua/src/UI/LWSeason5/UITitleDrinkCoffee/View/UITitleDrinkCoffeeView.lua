local UITitleDrinkCoffeeView = BaseClass("UITitleDrinkCoffeeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UITitleDrinkCoffeeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
  DataCenter.LWSoundManager:PlaySound(5100008, false)
end

function UITitleDrinkCoffeeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITitleDrinkCoffeeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
end

function UITitleDrinkCoffeeView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UITitleDrinkCoffeeView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitleTxt = nil
  self.imgIcon = nil
  self.textDesc = nil
  self.btnPanel = nil
end

function UITitleDrinkCoffeeView:InitView()
  self.coffeeId = self:GetUserData()
  self.config = DataCenter.MakingCoffeeTemplateManager:GetTemplate(self.coffeeId)
  self.imgIcon:LoadSpriteAsync(self.config.icon)
  self.textTitleTxt:SetLocalText(self.config.name)
  self.textDesc:SetLocalText(self.config.desc)
end

function UITitleDrinkCoffeeView:DataDefine()
end

function UITitleDrinkCoffeeView:DataDestroy()
end

function UITitleDrinkCoffeeView:OnAddListener()
  base.OnAddListener(self)
end

function UITitleDrinkCoffeeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UITitleDrinkCoffeeView
