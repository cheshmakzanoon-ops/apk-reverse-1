local base = UIAsyncContainer
local MailSaleItemComponent = BaseClass("MailSaleItemComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function MailSaleItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailSaleItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailSaleItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textConsign = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textPrice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.jinjiejing = self:AddComponent(UIImage, "Jinjiejing")
  self.jinjiejing:LoadSpriteAsync("Assets/Main/Sprites/ItemIcons/LXY_s5_jinjiejing_icon2.png")
end

function MailSaleItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textConsign = nil
  self.textPrice = nil
  self.textCount = nil
end

function MailSaleItemComponent:DataDefine()
end

function MailSaleItemComponent:DataDestroy()
  self.data = nil
end

function MailSaleItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function MailSaleItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailSaleItemComponent:SetData(data)
  self.data = data
end

function MailSaleItemComponent:UpdateData()
  local data = self.data
  if data.sellType == HSRSellType.Consign then
    self.textConsign:SetLocalText("activity_1200044_tips14", "")
    self.compUIPlayerHead:SetActive(false)
    self.textName:SetText("")
  else
    self.textConsign:SetText("")
    self.compUIPlayerHead:SetActive(true)
    self.compUIPlayerHead:ParseHeadInfo(data)
    self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
    self.textName:SetText(UIUtil.FormatServerAllianceName(data.server, data.abbr, data.name, data.uid))
  end
  self.textPrice:SetText(data.sellPrice)
  self.textCount:SetText(data.sellNum)
end

return MailSaleItemComponent
