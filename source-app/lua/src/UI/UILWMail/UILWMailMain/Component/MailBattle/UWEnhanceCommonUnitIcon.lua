local base = UIAsyncContainer
local UWEnhanceCommonUnitIcon = BaseClass("UWEnhanceCommonUnitIcon", base)
local icon_path = "icon"
local lv_txt_path = "lv_txt"
local ICON_PATHS = {
  [HeroUWEnhanceUnitType.Weapon] = "Assets/Main/Sprites/UI/UIHeroCommon/FX_zhuanwu_btn_weixuanzhong_paotou3.png",
  [HeroUWEnhanceUnitType.Energy] = "Assets/Main/Sprites/UI/UIHeroCommon/FX_zhuanwu_btn_weixuanzhong_xuhang3.png",
  [HeroUWEnhanceUnitType.Armor] = "Assets/Main/Sprites/UI/UIHeroCommon/FX_zhuanwu_btn_weixuanzhong_hujia3.png"
}
local TYPE_POSITIONS = {
  [HeroUWEnhanceUnitType.Weapon] = -49.63,
  [HeroUWEnhanceUnitType.Energy] = 0.25,
  [HeroUWEnhanceUnitType.Armor] = 50.14
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
  self.lv_txt = self:AddComponent(UIText, lv_txt_path)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.lv_txt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UWEnhanceCommonUnitIcon:SetData(type, level)
  self.type = type
  self.level = level
  if not self:AsyncLoadDone() then
    return
  end
  self.icon:LoadSprite(ICON_PATHS[type])
  self.lv_txt:SetText(level)
  self:SetLocalPositionXYZ(TYPE_POSITIONS[type], 0, 0)
end

UWEnhanceCommonUnitIcon.OnCreate = OnCreate
UWEnhanceCommonUnitIcon.OnDestroy = OnDestroy
UWEnhanceCommonUnitIcon.OnEnable = OnEnable
UWEnhanceCommonUnitIcon.OnDisable = OnDisable
UWEnhanceCommonUnitIcon.ComponentDefine = ComponentDefine
UWEnhanceCommonUnitIcon.ComponentDestroy = ComponentDestroy
UWEnhanceCommonUnitIcon.DataDefine = DataDefine
UWEnhanceCommonUnitIcon.DataDestroy = DataDestroy
return UWEnhanceCommonUnitIcon
