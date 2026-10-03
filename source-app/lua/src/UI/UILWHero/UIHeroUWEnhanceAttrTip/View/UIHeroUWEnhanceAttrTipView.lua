local UIHeroUWEnhanceAttrTipView = BaseClass("UIHeroUWEnhanceAttrTipView", UIBaseView)
local base = UIBaseView
local AttrLine = require("UI.UILWHero.UIHeroUWEnhanceAttrTip.Component.AttrLine")
local SELF_ATTRS = {
  HeroEffectDefine.UniqueWeaponHp_result,
  HeroEffectDefine.UniqueWeaponAtk_result,
  HeroEffectDefine.UniqueWeaponDef_result,
  HeroEffectDefine.EquipDamageReduceRateBase,
  HeroEffectDefine.HeroSkillMaxLevelAdd
}
local ALL_ATTRS = {
  51003,
  51053,
  51103
}
local LINE_PREFAB_PATH = "Assets/Main/Prefabs/UI/UIHero/LWHero/UniqueWeapon/UWEnhanceAttrLine.prefab"

function UIHeroUWEnhanceAttrTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshShow()
end

function UIHeroUWEnhanceAttrTipView:OnDestroy()
  base.OnDestroy(self)
  self:ComponentDestroy()
end

function UIHeroUWEnhanceAttrTipView:ComponentDefine()
  self.self_attr_title_txt = self:AddComponent(UIText, "Root/ImgBg/Content/self_attr_title_txt")
  self.self_attr_list = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/self_attr_list")
  self.all_attr_title_txt = self:AddComponent(UIText, "Root/ImgBg/Content/all_attr_title_txt")
  self.all_attr_list = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/all_attr_list")
  self.bg_panel = self:AddComponent(UIButton, "Panel")
  self.bg_panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.self_attr_lines = {}
  self.all_attr_lines = {}
end

function UIHeroUWEnhanceAttrTipView:ComponentDestroy()
  self.self_attr_title_txt = nil
  self.self_attr_list = nil
  self.all_attr_title_txt = nil
  self.all_attr_list = nil
end

function UIHeroUWEnhanceAttrTipView:RemoveAllAttrLines()
  for _, line in ipairs(self.self_attr_lines) do
    self:RemoveAsyncComponent(line)
  end
  for _, line in ipairs(self.all_attr_lines) do
    self:RemoveAsyncComponent(line)
  end
end

function UIHeroUWEnhanceAttrTipView:RefreshShow()
  local heroData = self:GetUserData()
  if not heroData then
    self.ctrl:CloseSelf()
    return
  end
  local effects = heroData:GetAllUWAttrs()
  self:RemoveAllAttrLines()
  for _, effectId in ipairs(SELF_ATTRS) do
    local line = self:LoadComponentAsync(AttrLine, LINE_PREFAB_PATH, self.self_attr_list, function(view, go, self, callback_params)
      self:SetData(heroData, effectId, effects[effectId] or 0)
    end)
    table.insert(self.self_attr_lines, line)
  end
  for _, effectId in ipairs(ALL_ATTRS) do
    local line = self:LoadComponentAsync(AttrLine, LINE_PREFAB_PATH, self.all_attr_list, function(view, go, self, callback_params)
      self:SetData(heroData, effectId, effects[effectId] or 0)
    end)
    table.insert(self.all_attr_lines, line)
  end
end

return UIHeroUWEnhanceAttrTipView
