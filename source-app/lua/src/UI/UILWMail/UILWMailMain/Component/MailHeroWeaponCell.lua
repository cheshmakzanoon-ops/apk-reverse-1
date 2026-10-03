local MailHeroWeaponCell = BaseClass("MailHeroWeaponCell", UIBaseContainer)
local UWEnhanceCommonUnitIcon = require("UI.UILWMail.UILWMailMain.Component.MailBattle.UWEnhanceCommonUnitIcon")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local img_quality_path = "imgQuality"
local img_icon_path = "imgIcon"
local text_level_path = "textLevel"
local unitList_path = "unitList"
local unitIconPrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UniqueWeapon/UWEnhanceCommonUnitIcon.prefab"

function MailHeroWeaponCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailHeroWeaponCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailHeroWeaponCell:ComponentDefine()
  self.img_quality = self:AddComponent(UIImage, img_quality_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.text_level = self:AddComponent(UIText, text_level_path)
  self.unitList = self:AddComponent(UIBaseContainer, unitList_path)
end

function MailHeroWeaponCell:ComponentDestroy()
  self.img_quality = nil
  self.img_icon = nil
  self.text_level = nil
end

function MailHeroWeaponCell:SetData(heroId, uniqeWeaponLv, units, skinId)
  local uniqueWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, uniqeWeaponLv)
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if not heroTemplate then
    self:SetActive(false)
    return
  end
  local modelId = heroTemplate.appearance
  local quality = heroTemplate.quality
  if uniqueWeaponTemplate then
    modelId = uniqueWeaponTemplate.modelId
  end
  local iconPath = HeroUtils.GetHeroIconPath(modelId, HeroIconType.small_icon, skinId)
  self.img_icon:LoadSpriteAuto(iconPath)
  self.text_level:SetText("Lv." .. tostring(uniqeWeaponLv))
  self.img_quality:LoadSprite(HeroUtils.GetQualityIconPath(quality, false))
  if self.units then
    for i, v in ipairs(self.units) do
      self:RemoveAsyncComponent(v)
    end
  end
  self.units = nil
  if table.IsNullOrEmpty(units) then
    return
  end
  self.units = {}
  for unitType, lv in pairs(units) do
    local unit = self:LoadComponentAsync(UWEnhanceCommonUnitIcon, unitIconPrefabPath, self.unitList, function(view, go, self, callback_param)
      self:SetData(unitType, lv)
    end)
  end
end

function MailHeroWeaponCell:DataDefine()
end

function MailHeroWeaponCell:DataDestroy()
end

return MailHeroWeaponCell
