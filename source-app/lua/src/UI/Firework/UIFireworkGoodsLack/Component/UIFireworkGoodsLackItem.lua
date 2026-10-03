local UIFireworkGoodsLackItem = BaseClass("UIFireworkGoodsLackItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIFireworkGoodsLackItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFireworkGoodsLackItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIFireworkGoodsLackItem:OnEnable()
  base.OnEnable(self)
end

function UIFireworkGoodsLackItem:OnDisable()
  base.OnDisable(self)
end

function UIFireworkGoodsLackItem:OnAddListener()
  base.OnAddListener(self)
end

function UIFireworkGoodsLackItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFireworkGoodsLackItem:ComponentDefine()
  self.title1 = self:AddComponent(UIText, "ItemNameInfo")
  self.title2 = self:AddComponent(UIText, "ItemPowerInfo")
  self.iconBg = self:AddComponent(UIImage, "ImgQuality")
  self.icon = self:AddComponent(UIImage, "ItemIcon")
  self.gotoBtn = self:AddComponent(UIButton, "GotoBtn")
  self.gotoBtnText = self:AddComponent(UIText, "GotoBtn/GotoBtnTxt")
  self.gotoBtnImg = self:AddComponent(UIImage, "GotoBtn")
  self.gotoBtn:SetOnClick(function()
    self:OnGoToBtnClick()
  end)
  self.gotoBtnText:SetText(Localization:GetString("firework_btn_1001"))
end

function UIFireworkGoodsLackItem:ComponentDestroy()
  self.title1 = nil
  self.title2 = nil
  self.iconBg = nil
  self.icon = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.gotoBtnImg = nil
end

function UIFireworkGoodsLackItem:DataDefine()
end

function UIFireworkGoodsLackItem:DataDestroy()
end

function UIFireworkGoodsLackItem:RefreshBgIcon(template)
  self.iconBg:SetActive(false)
  if not template then
    return
  end
  local color = template.color
  if 0 < color then
    self.iconBg:SetActive(true)
    self.iconBg:LoadSprite(UIUtil.GetItemQualityBg(color))
  end
end

function UIFireworkGoodsLackItem:Refresh(itemId)
  self.itemId = itemId
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if itemTemplate then
    if not string.IsNullOrEmpty(itemTemplate.icon) then
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
    end
    self:RefreshBgIcon(itemTemplate)
    local rawName = Localization:GetString(itemTemplate.name)
    self.title1:SetText(rawName)
    local have = DataCenter.ItemData:GetItemCount(self.itemId)
    if 0 < have then
      self.title2:SetText(Localization:GetString("450019", have))
    else
      self.title2:SetText(string.format("<color=#F53C3D>%s</color>", Localization:GetString("450019", have)))
    end
  end
end

function UIFireworkGoodsLackItem:OnGoToBtnClick()
  DataCenter.LWFireworkManager:SetDefaultFireworkItemId(self.itemId)
  UIUtil.ShowTipsId("firework_tips_1021")
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFireworkGoodsLack)
end

return UIFireworkGoodsLackItem
