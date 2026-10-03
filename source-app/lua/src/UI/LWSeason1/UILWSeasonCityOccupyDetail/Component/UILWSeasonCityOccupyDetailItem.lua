local UILWSeasonCityOccupyDetailItem = BaseClass("UILWSeasonCityOccupyDetailItem", UIBaseContainer)
local base = UIBaseContainer

function UILWSeasonCityOccupyDetailItem:OnCreate()
  base.OnCreate(self)
  self.item = self:AddComponent(UIImage, "")
  self.titleRoot = self:AddComponent(UIBaseComponent, "Content1")
  self.valueRoot = self:AddComponent(UIBaseComponent, "Content2")
  self.t1 = self:AddComponent(UIText, "Content1/t1")
  self.t2 = self:AddComponent(UIText, "Content1/t2")
  self.v1 = self:AddComponent(UIText, "Content2/v1")
  self.v2 = self:AddComponent(UIText, "Content2/v2")
end

function UILWSeasonCityOccupyDetailItem:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyDetailItem:ReInit(level, isTitleBar, title, desc)
  self.titleRoot:SetActive(isTitleBar)
  self.valueRoot:SetActive(not isTitleBar)
  if isTitleBar then
    self.item:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di2.png")
  else
    if level % 2 == 0 then
      self.item:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di3.png")
    else
      self.item:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di1.png")
    end
    self.v1:SetText(title)
    self.v2:SetText(desc)
  end
end

return UILWSeasonCityOccupyDetailItem
