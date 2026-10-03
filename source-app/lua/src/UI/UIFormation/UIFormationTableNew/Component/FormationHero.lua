local FormationHero = BaseClass("FormationHero", UIBaseContainer)
local base = UIBaseContainer
local hero_quality_path = "btnSelect/heroQuality"
local hero_img_path = "btnSelect/heroImg"
local level_txt_path = "btnSelect/campIcon/levelTxt"
local camp_icon_path = "btnSelect/campIcon"
local select_btn_path = "btnSelect"
local delete_btn_path = "btn_delete"
local hero_ark_grade_path = "btnSelect/ImgArkGrade"
local UIHeroStars = require("UI.UIHero2.Common.UIHeroStars")

local function OnCreate(self)
  base.OnCreate(self)
  self.hero_img = self:AddComponent(UIImage, hero_img_path)
  self.hero_quality = self:AddComponent(UIImage, hero_quality_path)
  self.camp_icon = self:AddComponent(UIImage, camp_icon_path)
  self.hero_ark_grade = self:AddComponent(UIImage, hero_ark_grade_path)
  self.level = self:AddComponent(UIText, level_txt_path)
  self.click_btn = self:AddComponent(UIButton, select_btn_path)
  self.click_btn:SetOnClick(function()
    if self.view.ctrl.isMarch > 0 then
      return
    end
    self:OnSelectClick()
  end)
  self.delete_btn = self:AddComponent(UIButton, delete_btn_path)
  self.delete_btn:SetOnClick(function()
    if self.view.ctrl.isMarch > 0 then
      return
    end
    self:OnDeleteClick()
  end)
  self.star = self:AddComponent(UIHeroStars, "NodeArrow")
end

local function OnDestroy(self)
  self.hero_img = nil
  self.camp_icon = nil
  self.index_text = nil
  self.level = nil
  self.click_btn = nil
  self.delete_btn = nil
  self.hero_ark_grade = nil
  base.OnDestroy(self)
end

local function InitData(self, heroUuid, index)
  self.uuid = heroUuid
  self.index = index
  self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
  self.hero_quality:LoadSprite(self.data.quality)
  self.hero_ark_grade:SetActive(self.data.rankId > 1)
  self.hero_ark_grade:LoadSprite(HeroUtils.GetMilitaryRankIcon(self.data.rankId))
  local param = {}
  param.showStarNum = self.data.qualityIndex
  param.maxStarNum = HeroUtils.GetMaxStarLevel(self.data.heroId)
  self.star:SetData(param)
  self.star:SetActive(true)
  self.hero_img:LoadSprite("Assets/Main/Sprites/HeroBody/" .. self.data.icon)
  self.level:SetText("Lv. " .. self.data.level)
  self.camp_icon:LoadSprite(self.data.camp)
  if index == 1 then
    self.camp_icon.transform:Set_localScale(1, 1, 1)
  elseif index == 2 or index == 3 then
    self.camp_icon.transform:Set_localScale(1.1111111111111112, 1.1111111111111112, 1.1111111111111112)
  else
    self.camp_icon.transform:Set_localScale(1.25, 1.25, 1.25)
  end
  self.delete_btn:SetActive(self.view.ctrl.isMarch <= 0)
end

local function OnSelectClick(self)
  if self.view.ctrl:NeedTakeArmy() then
    self.view:OnSelectClick()
  end
end

local function OnDeleteClick(self)
  self.view.ctrl:OnDeleteHeroByIndex(self.index)
  self.view:OnSelectHeroFinish(self.index)
  if self.view.normalState == true then
    self.view:OnHeroSelectClick()
  end
end

local function GetDeleteObj(self)
  return self.delete_btn.gameObject
end

FormationHero.OnCreate = OnCreate
FormationHero.OnDestroy = OnDestroy
FormationHero.InitData = InitData
FormationHero.OnSelectClick = OnSelectClick
FormationHero.OnDeleteClick = OnDeleteClick
FormationHero.GetDeleteObj = GetDeleteObj
return FormationHero
