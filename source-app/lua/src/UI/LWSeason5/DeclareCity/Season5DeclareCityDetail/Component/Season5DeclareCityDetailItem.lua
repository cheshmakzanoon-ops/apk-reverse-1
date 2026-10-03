local Season5DeclareCityDetailItem = BaseClass("Season5DeclareCityDetailItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function Season5DeclareCityDetailItem:OnCreate()
  base.OnCreate(self)
  self.item = self:AddComponent(UIImage, "")
  self.titleRoot = self:AddComponent(UIBaseComponent, "Content1")
  self.valueRoot = self:AddComponent(UIBaseComponent, "Content2")
  self.t1 = self:AddComponent(UIText, "Content1/t1")
  self.t2 = self:AddComponent(UIText, "Content1/t2")
  self.t3 = self:AddComponent(UIText, "Content1/t3")
  self.t4 = self:AddComponent(UIText, "Content1/t4")
  self.v1 = self:AddComponent(UIText, "Content2/v1")
  self.v2 = self:AddComponent(UIText, "Content2/v2")
  self.v3 = self:AddComponent(UIText, "Content2/v3")
  self.v4 = self:AddComponent(UIText, "Content2/v4")
end

function Season5DeclareCityDetailItem:OnDestroy()
  base.OnDestroy(self)
end

function Season5DeclareCityDetailItem:ReInit(level, isTitleBar)
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
    local cityInfo = DataCenter.AllianceCityTemplateManager:GetCityByLevel(level, nil, 1)
    if cityInfo then
      self.v1:SetLocalText("140002", level)
      self.v2:SetText(string.GetFormattedSeparatorNum(cityInfo.force))
      self.v3:SetText("x" .. cityInfo.loot_rewards)
      self.v4:SetText("x" .. cityInfo.sever_loot_reward)
    else
      self.v1:SetText("")
      self.v2:SetText("")
      self.v3:SetText("")
      self.v4:SetText("")
    end
  end
end

return Season5DeclareCityDetailItem
