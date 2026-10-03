local base = UIAsyncContainer
local UWEnhanceConditionIcon = BaseClass("UWEnhanceConditionIcon", base)
local icon_path = "icon"
local need_lv_txt_path = "lv_txt"
local ICON_PATHS = {
  [HeroUWEnhanceUnitType.Weapon] = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_weixuanzhong_paotou2.png",
  [HeroUWEnhanceUnitType.Energy] = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_weixuanzhong_xuhang2.png",
  [HeroUWEnhanceUnitType.Armor] = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_weixuanzhong_hujia2.png"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.need_lv_txt = self:AddComponent(UIText, need_lv_txt_path)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.need_lv_txt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UWEnhanceConditionIcon:SetData(type, level, isFullfilled)
  self.type = type
  self.level = level
  if not self:AsyncLoadDone() then
    return
  end
  self.icon:LoadSprite(ICON_PATHS[type])
  self.need_lv_txt:SetText(string.format("Lv.%d", level))
  if isFullfilled then
    self.need_lv_txt:SetColor(Color.white)
  else
    self.need_lv_txt:SetColorRGBA255(249, 112, 119, 255)
  end
end

UWEnhanceConditionIcon.OnCreate = OnCreate
UWEnhanceConditionIcon.OnDestroy = OnDestroy
UWEnhanceConditionIcon.OnEnable = OnEnable
UWEnhanceConditionIcon.OnDisable = OnDisable
UWEnhanceConditionIcon.ComponentDefine = ComponentDefine
UWEnhanceConditionIcon.ComponentDestroy = ComponentDestroy
UWEnhanceConditionIcon.DataDefine = DataDefine
UWEnhanceConditionIcon.DataDestroy = DataDestroy
return UWEnhanceConditionIcon
