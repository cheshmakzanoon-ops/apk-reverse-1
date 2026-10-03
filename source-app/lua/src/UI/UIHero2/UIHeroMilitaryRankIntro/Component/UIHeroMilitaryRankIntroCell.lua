local UIHeroMilitaryRankIntroCell = BaseClass("UIHeroMilitaryRankIntroCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroMilitaryRankIcon = require("UI.UIHero2.UIHeroInfo.Component.UIHeroMilitaryRankIcon")
local name_text_path = "nameText"
local military_icon_path = "MilitaryIcon"
local attr1_text_path = "attr1/attrText1"
local attr2_text_path = "attr2/attrText2"
local attr3_text_path = "attr3/attrText3"
local Text_num1_text_path = "attr1/Text_num1"
local Text_num2_text_path = "attr2/Text_num2"
local Text_num3_text_path = "attr3/Text_num3"
local title_bg_path = "titlebg"
local title_bg_1_path = "titlebg1"
local openConditionText_path = "openConditionText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titlebg = self:AddComponent(UIImage, title_bg_path)
  self.titlebg1 = self:AddComponent(UIImage, title_bg_1_path)
  self.military_icon = self:AddComponent(UIHeroMilitaryRankIcon, military_icon_path)
  self.attr1_text = self:AddComponent(UIText, attr1_text_path)
  self.attr2_text = self:AddComponent(UIText, attr2_text_path)
  self.attr3_text = self:AddComponent(UIText, attr3_text_path)
  self.Text_num1_text = self:AddComponent(UIText, Text_num1_text_path)
  self.Text_num2_text = self:AddComponent(UIText, Text_num2_text_path)
  self.Text_num3_text = self:AddComponent(UIText, Text_num3_text_path)
  self.Text_num1_outline = self:AddComponent(UIOutline, Text_num1_text_path)
  self.Text_num2_outline = self:AddComponent(UIOutline, Text_num2_text_path)
  self.Text_num3_outline = self:AddComponent(UIOutline, Text_num3_text_path)
  self.Text_num1_shadow = self:AddComponent(UIShadow, Text_num1_text_path)
  self.Text_num2_shadow = self:AddComponent(UIShadow, Text_num2_text_path)
  self.Text_num3_shadow = self:AddComponent(UIShadow, Text_num3_text_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.openConditionText = self:AddComponent(UIText, openConditionText_path)
end

local function ComponentDestroy(self)
end

local function SetData(self, data)
  self.data = data
  self.military_icon:SetData(data.rankId)
  self.name_text:SetLocalText(HeroUtils.GetMilitaryRankName(data.rankId))
  self.attr1_text:SetText("")
  self.attr2_text:SetText("")
  self.attr3_text:SetText("")
  self.Text_num1_text:SetText("")
  self.Text_num2_text:SetText("")
  self.Text_num3_text:SetText("")
  local level = GetTableData(TableName.HeroMilitaryRankLv, data.rankId, "level")
  self.openConditionText:SetLocalText(129218, level)
  local troopStr = GetTableData(TableName.HeroMilitaryRankLv, data.rankId, "troop")
  local atkStr = GetTableData(TableName.HeroMilitaryRankLv, data.rankId, "atk")
  local defStr = GetTableData(TableName.HeroMilitaryRankLv, data.rankId, "def")
  local troop = string.split(troopStr, "|")[data.rarity]
  local atk = string.split(atkStr, "|")[data.rarity]
  local def = string.split(defStr, "|")[data.rarity]
  self.attr1_text:SetText(Localization:GetString("140310"))
  self.attr2_text:SetText(Localization:GetString("100150"))
  self.attr3_text:SetText(Localization:GetString("130066"))
  self.Text_num1_text:SetText(tostring(troop))
  self.Text_num2_text:SetText(tostring(atk))
  self.Text_num3_text:SetText(tostring(def))
  self:SetCurrentRank(data.rankId == data.curRank)
end

local function SetCurrentRank(self, isCurrent)
  if isCurrent then
    self.titlebg:SetActive(false)
    self.titlebg1:SetActive(true)
    self.attr1_text:SetColorRGBA(0.7176470588235294, 0.4, 0.18823529411764706, 1)
    self.attr2_text:SetColorRGBA(0.7176470588235294, 0.4, 0.18823529411764706, 1)
    self.attr3_text:SetColorRGBA(0.7176470588235294, 0.4, 0.18823529411764706, 1)
    self.Text_num1_text:SetColorRGBA(0.7372549019607844, 0.9333333333333333, 0.13333333333333333, 1)
    self.Text_num2_text:SetColorRGBA(0.7372549019607844, 0.9333333333333333, 0.13333333333333333, 1)
    self.Text_num3_text:SetColorRGBA(0.7372549019607844, 0.9333333333333333, 0.13333333333333333, 1)
    self.name_text:SetColorRGBA(0.7176470588235294, 0.4, 0.18823529411764706, 1)
    self.openConditionText:SetColorRGBA(0.7176470588235294, 0.4, 0.18823529411764706, 1)
    self.Text_num1_shadow:AllEnable(true)
    self.Text_num2_shadow:AllEnable(true)
    self.Text_num3_shadow:AllEnable(true)
    self.Text_num1_outline:SetColor(Color.New(0.18823529411764706, 0.10196078431372549, 0.047058823529411764, 1))
    self.Text_num2_outline:SetColor(Color.New(0.18823529411764706, 0.10196078431372549, 0.047058823529411764, 1))
    self.Text_num3_outline:SetColor(Color.New(0.18823529411764706, 0.10196078431372549, 0.047058823529411764, 1))
  else
    self.titlebg:SetActive(true)
    self.titlebg1:SetActive(false)
    self.attr1_text:SetColorRGBA(0.7137254901960784, 0.5372549019607843, 0.4392156862745098, 1)
    self.attr2_text:SetColorRGBA(0.7137254901960784, 0.5372549019607843, 0.4392156862745098, 1)
    self.attr3_text:SetColorRGBA(0.7137254901960784, 0.5372549019607843, 0.4392156862745098, 1)
    self.Text_num1_text:SetColorRGBA(0.7137254901960784, 0.5372549019607843, 0.4392156862745098, 1)
    self.Text_num2_text:SetColorRGBA(0.7137254901960784, 0.5372549019607843, 0.4392156862745098, 1)
    self.Text_num3_text:SetColorRGBA(0.7137254901960784, 0.5372549019607843, 0.4392156862745098, 1)
    self.name_text:SetColorRGBA(0.7137254901960784, 0.5372549019607843, 0.4392156862745098, 1)
    self.openConditionText:SetColorRGBA(0.9215686274509803, 0.807843137254902, 0.6431372549019608, 1)
    self.Text_num1_shadow:AllEnable(false)
    self.Text_num2_shadow:AllEnable(false)
    self.Text_num3_shadow:AllEnable(false)
    self.Text_num1_outline:SetColor(Color.New(0.09019607843137255, 0.29411764705882354, 0.07450980392156863, 0))
    self.Text_num2_outline:SetColor(Color.New(0.09019607843137255, 0.29411764705882354, 0.07450980392156863, 0))
    self.Text_num3_outline:SetColor(Color.New(0.09019607843137255, 0.29411764705882354, 0.07450980392156863, 0))
  end
end

local function OnBtnClick(self)
end

UIHeroMilitaryRankIntroCell.OnCreate = OnCreate
UIHeroMilitaryRankIntroCell.OnDestroy = OnDestroy
UIHeroMilitaryRankIntroCell.ComponentDefine = ComponentDefine
UIHeroMilitaryRankIntroCell.ComponentDestroy = ComponentDestroy
UIHeroMilitaryRankIntroCell.SetData = SetData
UIHeroMilitaryRankIntroCell.OnBtnClick = OnBtnClick
UIHeroMilitaryRankIntroCell.SetCurrentRank = SetCurrentRank
return UIHeroMilitaryRankIntroCell
