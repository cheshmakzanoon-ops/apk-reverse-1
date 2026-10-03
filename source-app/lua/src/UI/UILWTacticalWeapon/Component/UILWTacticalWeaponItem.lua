local UILWTacticalWeaponItem = BaseClass("UILWTacticalWeaponItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, "clickBtn")
  self.bg = self:AddComponent(UIImage, "clickBtn/Bg")
  self.icon = self:AddComponent(UIImage, "clickBtn/Icon")
  self.levelText = self:AddComponent(UIText, "clickBtn/LevelText")
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.bg = nil
  self.icon = nil
  self.levelText = nil
end

local function DataDestroy(self)
  self.weaponInfo = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function SetData(self, weaponInfo, appearanceId)
  if not weaponInfo then
    return
  end
  self.weaponInfo = weaponInfo
  if appearanceId == nil then
    appearanceId = weaponInfo:GetAppearance()
  end
  local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  if appearanceMeta == nil then
    self.icon:SetActive(false)
  else
    self.icon:SetActive(true)
    self.icon:LoadSpriteAuto(LoadPath.HeroIconsSmallPath .. appearanceMeta.queue_icon_path)
  end
  self.levelText:SetText(string.format("Lv.%s", weaponInfo.level))
end

local function SetConfigId(self, id, level, skinId)
  if id == nil then
    return
  end
  self.weaponInfo = TacticalWeaponInfo.New()
  self.weaponInfo:CreateFromTemplate(id, level)
  local appearanceId = self.weaponInfo:GetAppearance()
  if skinId and 0 < skinId then
    appearanceId = DataCenter.DecorationTemplateManager:GetAppearanceIdBySkinId(skinId)
  end
  local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  if appearanceMeta == nil then
    self.icon:SetActive(false)
  else
    self.icon:SetActive(true)
    self.icon:LoadSpriteAuto(LoadPath.HeroIconsSmallPath .. appearanceMeta.queue_icon_path)
  end
  self.levelText:SetText(string.format("Lv.%s", self.weaponInfo.level))
end

local function SetLevelText(self, str)
  self.levelText:SetText(str)
end

UILWTacticalWeaponItem.OnCreate = OnCreate
UILWTacticalWeaponItem.OnDestroy = OnDestroy
UILWTacticalWeaponItem.OnEnable = OnEnable
UILWTacticalWeaponItem.OnDisable = OnDisable
UILWTacticalWeaponItem.ComponentDefine = ComponentDefine
UILWTacticalWeaponItem.DataDefine = DataDefine
UILWTacticalWeaponItem.ComponentDestroy = ComponentDestroy
UILWTacticalWeaponItem.DataDestroy = DataDestroy
UILWTacticalWeaponItem.SetData = SetData
UILWTacticalWeaponItem.SetConfigId = SetConfigId
UILWTacticalWeaponItem.SetLevelText = SetLevelText
return UILWTacticalWeaponItem
