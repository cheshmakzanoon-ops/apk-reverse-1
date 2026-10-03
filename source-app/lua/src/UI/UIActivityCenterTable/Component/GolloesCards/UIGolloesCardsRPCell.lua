local UIGolloesCardsRPCell = BaseClass("UIGolloesCardsRPCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

function UIGolloesCardsRPCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIGolloesCardsRPCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGolloesCardsRPCell:ComponentDefine()
  self.obj = self:AddComponent(UIBaseContainer, "")
  self.icon = self:AddComponent(UIImage, "UICommonResItem/clickBtn/ItemIcon")
  self.icon_bg = self:AddComponent(UIImage, "UICommonResItem/clickBtn/ImgQuality")
  self.btn = self:AddComponent(UIButton, "UICommonResItem/clickBtn")
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRewardClick()
  end)
  self.flag_text = self:AddComponent(UIText, "UICommonResItem/clickBtn/FlagGo/FlagText")
  self.flag_go = self:AddComponent(UIBaseContainer, "UICommonResItem/clickBtn/FlagGo")
  self.count = self:AddComponent(UIText, "UICommonResItem/clickBtn/NumText")
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, "UICommonResItem/clickBtn/HeroDebris")
  self.nodeHeroDebris:SetActive(false)
end

function UIGolloesCardsRPCell:ComponentDestroy()
  self.icon = nil
  self.icon_bg = nil
  self.btn = nil
  self.flag_text = nil
  self.flag_go = nil
  self.nodeHeroDebris = nil
end

function UIGolloesCardsRPCell:SetData(param)
  self.nodeHeroDebris:SetActive(false)
  self.param = param
  self:SetFlagActive(false)
  self.count:SetText(param.count)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
  if goods ~= nil then
    self.icon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
    self.icon_bg:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
  else
    local resourceType = tonumber(param.itemId)
    if resourceType < 100 and DataCenter.ResourceManager:GetResourceIconByType(resourceType) then
      self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
      self.icon_bg:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
    end
  end
end

function UIGolloesCardsRPCell:SetFlagActive(value)
  self.flag_go:SetActive(value)
end

function UIGolloesCardsRPCell:SetFlagText(value)
  self.flag_text:SetText(value)
end

function UIGolloesCardsRPCell:OnRewardClick()
  if self.param.itemId ~= nil then
    local param = {}
    param.itemId = self.param.itemId
    param.alignObject = self.icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

return UIGolloesCardsRPCell
