local FormationRestraintItem = BaseClass("FormationRestraintItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local des_txt_path = "desTxt"
local icon_path = "CampRestraintItem/icon"
local camp_img_path = "CampRestraintItem/icon/camp_faction"
local num_path = "CampRestraintItem/icon/num"
local value_txt_path = "valueTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.camp_img = self:AddComponent(UIImage, camp_img_path)
  self.num = self:AddComponent(UIText, num_path)
  self.value_txt = self:AddComponent(UIText, value_txt_path)
end

local function OnDestroy(self)
  self.bg = nil
  self.des_txt = nil
  self.icon = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function InitData(self, campIndex, campNum, effectNum, index)
  if 0 <= campIndex then
    self.icon:LoadSprite(HeroUtils.GetCampIconPath(campIndex))
    self.camp_img:LoadSprite(HeroUtils.GetCampCircleImgPath(campIndex))
    if campNum == index then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_huang.png")
      self.des_txt:SetColor(Color.New(0.86, 0.49, 0, 1))
      self.value_txt:SetColor(Color.New(1, 0.43, 0.21, 1))
    else
      self.des_txt:SetColor(Color.New(0.66, 0.66, 0.66, 1))
      self.value_txt:SetColor(Color.New(0.66, 0.66, 0.66, 1))
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_hui.png")
    end
    local name, desc = HeroUtils.GetCampNameAndDesc(campIndex)
    self.des_txt:SetText(Localization:GetString("150223", index, name))
  else
    self.des_txt:SetColor(Color.New(0.66, 0.66, 0.66, 1))
    self.value_txt:SetColor(Color.New(0.66, 0.66, 0.66, 1))
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UITroopsNew/UITroopsNew_img_hui.png")
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIHeroList/ui_camp_-1.png")
    self.camp_img:LoadSprite("Assets/Main/Sprites/UI/UIHeroList/hero_faction_-1.png")
    self.des_txt:SetText(Localization:GetString("150223", index, Localization:GetString("150224")))
  end
  self.num:SetText(index)
  local str = Localization:GetString("150226") .. "+" .. math.floor(effectNum) .. "%"
  self.value_txt:SetText(str)
end

FormationRestraintItem.OnCreate = OnCreate
FormationRestraintItem.OnDestroy = OnDestroy
FormationRestraintItem.InitData = InitData
FormationRestraintItem.OnEnable = OnEnable
FormationRestraintItem.OnDisable = OnDisable
return FormationRestraintItem
