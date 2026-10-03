local CampRestraintItem = BaseClass("CampRestraintItem", UIBaseContainer)
local base = UIBaseContainer
local icon_path = "icon"
local img_path = "icon/camp_faction"
local num_path = "icon/num"
local effect_path = "VFX_ui_restraintbtn_blue"

local function OnCreate(self)
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.img = self:AddComponent(UIImage, img_path)
  self.num = self:AddComponent(UIText, num_path)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.effect:SetActive(false)
  self.showNum = nil
end

local function OnDestroy(self)
  self.icon = nil
  self.img = nil
  self.num = nil
  base.OnDestroy(self)
end

local function InitData(self, camp, num, showEffectFlag)
  self.effect:SetActive(false)
  self.effect:SetActive(showEffectFlag and self.showNum ~= nil and num ~= nil and num > self.showNum)
  self.showNum = num or 0
  if camp ~= nil and 0 <= camp then
    self.icon:LoadSprite(HeroUtils.GetCampIconPath(camp))
    self.img:SetActive(true)
    self.img:LoadSprite(HeroUtils.GetCampCircleImgPath(camp))
    self.num:SetText(num)
  else
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIHeroList/ui_camp_-1.png")
    self.img:SetActive(false)
    self.num:SetText("")
  end
end

CampRestraintItem.OnCreate = OnCreate
CampRestraintItem.OnDestroy = OnDestroy
CampRestraintItem.InitData = InitData
return CampRestraintItem
