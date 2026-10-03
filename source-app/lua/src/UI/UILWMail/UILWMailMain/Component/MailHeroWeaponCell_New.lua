local MailHeroWeaponCell_New = BaseClass("MailHeroWeaponCell_New", UIBaseContainer)
local base = UIBaseContainer
local UWEnhanceCommonUnitIcon = require("UI.UILWMail.UILWMailMain.Component.MailBattle.UWEnhanceCommonUnitIcon")
local Localization = CS.GameEntry.Localization
local img_icon_path = "iconBG/imgIcon"
local text_level_path = "textLevel"
local model_preview_img_path = "modelPreviewImg"
local unitList_path = "unitList"
local unitIconPrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UniqueWeapon/UWEnhanceCommonUnitIcon.prefab"

function MailHeroWeaponCell_New:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailHeroWeaponCell_New:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailHeroWeaponCell_New:ComponentDefine()
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.text_level = self:AddComponent(UIText, text_level_path)
  self.modelIcon = self:AddComponent(UIImage, model_preview_img_path)
  self.unitList = self:AddComponent(UIBaseContainer, unitList_path)
end

function MailHeroWeaponCell_New:ComponentDestroy()
  self.img_icon = nil
  self.text_level = nil
end

function MailHeroWeaponCell_New:SetData(heroId, uniqeWeaponLv, units, skinId)
  local uniqueWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, uniqeWeaponLv)
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if not heroTemplate then
    self:SetActive(false)
    return
  end
  local modelId = heroTemplate.appearance
  if uniqueWeaponTemplate then
    modelId = uniqueWeaponTemplate.modelId
  end
  local iconPath = HeroUtils.GetHeroIconPath(modelId, HeroIconType.small_icon, skinId)
  self.img_icon:LoadSpriteAuto(iconPath)
  self.modelIcon.gameObject:SetActive(uniqueWeaponTemplate.model_icon)
  if uniqueWeaponTemplate.model_icon then
    self.modelIcon:LoadSpriteAuto(uniqueWeaponTemplate.model_icon)
  end
  self.text_level:SetText("Lv." .. tostring(uniqeWeaponLv))
  if self.unitIcons then
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
    table.insert(self.units, unit)
  end
end

function MailHeroWeaponCell_New:DataDefine()
end

function MailHeroWeaponCell_New:DataDestroy()
end

return MailHeroWeaponCell_New
