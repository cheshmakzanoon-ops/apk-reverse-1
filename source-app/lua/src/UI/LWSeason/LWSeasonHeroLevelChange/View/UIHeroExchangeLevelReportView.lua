local UIHeroExchangeLevelReportView = BaseClass("UIHeroExchangeLevelReportView", UIBaseView)
local base = UIBaseView
local heroItem = require("UI.LWSeason.LWSeasonHeroLevelChange.Component.UIHeroReportItem")
local panel_path = "UICommonRewardPopUp/Panel"
local title_name_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local left_hero_path = "content/leftHero"
local right_hero_path = "content/rightHero"

function UIHeroExchangeLevelReportView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
end

function UIHeroExchangeLevelReportView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroExchangeLevelReportView:ComponentDefine()
  self.btn = self:AddComponent(UIButton, panel_path)
  self.title_name = self:AddComponent(UIText, title_name_path)
  self.title_name:SetLocalText("season_level_replacement_005")
  self.left_hero = self:AddComponent(heroItem, left_hero_path)
  self.right_hero = self:AddComponent(heroItem, right_hero_path)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.left_hero:SetHeroReportData(self.param.leftHero)
  self.right_hero:SetHeroReportData(self.param.rigthHero)
end

function UIHeroExchangeLevelReportView:ComponentDestroy()
  self.btn = nil
  self.title_name = nil
  self.left_hero = nil
  self.right_hero = nil
end

return UIHeroExchangeLevelReportView
