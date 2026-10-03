local FormationDefenceHeroItem = BaseClass("FormationDefenceHeroItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local hero_path = "UIHeroCellSmall"
local in_march_obj_path = "inMarchObj"
local in_march_des_path = "inMarchObj/inMarchDes"

local function OnCreate(self)
  base.OnCreate(self)
  self.heroBase = self:AddComponent(UIHeroCell, hero_path)
  self.in_march_obj = self:AddComponent(UIBaseContainer, in_march_obj_path)
  self.in_march_des = self:AddComponent(UIText, in_march_des_path)
  self.hpBar = self:AddComponent(UISlider, "HpBar")
  self.in_march_des:SetLocalText(120166)
  self.btn = self:AddComponent(UIButton, hero_path)
  self.btn:SetOnClick(function()
  end)
end

local function InitData(self, data, heroIndex, formationUid)
  if type(data) == "number" then
    self.uuid = data
    self.heroBase:SetData(self.uuid)
    self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
    self.in_march_obj:SetActive(self.data.isInMarch)
    self.hpBar:SetValue(0)
  else
    self.heroTable = data
    self.heroBase:InitWithConfigId(data.heroId, data.heroQuality, data.heroLevel, data.rankLv, data.weaponLv, data.awakenLv, data.heroSkinId)
    self.in_march_obj:SetActive(false)
    self.hpBar:SetValue(0)
  end
  self.formationUid = formationUid
  self.heroIndex = heroIndex
end

local function OnSelectClick(self)
  self.view:OnSelectClick(self.formationUid, self.heroIndex)
end

FormationDefenceHeroItem.OnCreate = OnCreate
FormationDefenceHeroItem.InitData = InitData
FormationDefenceHeroItem.OnSelectClick = OnSelectClick
return FormationDefenceHeroItem
