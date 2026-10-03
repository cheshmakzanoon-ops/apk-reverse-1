local TacticalLevelDisplayAirItem = BaseClass("TacticalLevelDisplayAirItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local tacticalWeaponSimpleModelViewer = require("UI.UILWTacticalWeapon.Component.TacticalWeaponSimpleModelViewer")
local weaponImg_path = "WeaponImg"
local air_title_path = "titleLayout/airTitle"
local air_icon_path = "airIcon"
local air_desc_title_path = "airDescTitle"
local air_desc_path = "airDesc"
local main_bg_path = "mainBg"
local main_bg2_path = "mainBg2"
local title_bg_path = "titleBg"
local eff_ui_saoguang_path = "mainBg2/node_mask/Eff_ui_saoguang"
local POSTER_FOLDER_PATH = "Assets/Main/TextureEx/LWUITacticalWeapon/v202408/"

function TacticalLevelDisplayAirItem:OnCreate()
  base.OnCreate(self)
  self.air_title = self:AddComponent(UITextMeshProUGUIEx, air_title_path)
  self.air_icon = self:AddComponent(UIRawImage, air_icon_path)
  self.airDescTitle = self:AddComponent(UITextMeshProUGUIEx, air_desc_title_path)
  self.airDesc = self:AddComponent(UITextMeshProUGUIEx, air_desc_path)
  self.main_bg = self:AddComponent(UIBaseContainer, main_bg_path)
  self.main_bg2 = self:AddComponent(UIBaseContainer, main_bg2_path)
  self.title_bg = self:AddComponent(UIBaseContainer, title_bg_path)
  self.effectNode = self:AddComponent(UIBaseContainer, eff_ui_saoguang_path)
  self.lockIcon = self:AddComponent(UIBaseContainer, "titleLayout/lockIcon")
end

function TacticalLevelDisplayAirItem:OnDestroy()
  self.weaponImg = nil
  self.air_title = nil
  self.air_icon = nil
  self.airDescTitle = nil
  self.airDesc = nil
  base.OnDestroy(self)
end

function TacticalLevelDisplayAirItem:OnEnable()
  base.OnEnable(self)
end

function TacticalLevelDisplayAirItem:OnDisable()
  base.OnDisable(self)
end

function TacticalLevelDisplayAirItem:SetData(param)
  self.airDescTitle:SetLocalText(param.title)
  self.airDesc:SetLocalText(param.desc)
  self.level = param.level
  self.weaponLevel = param.weaponLevel
  self.posterFullName = param.posterFullName
  self.air_icon:LoadSprite(POSTER_FOLDER_PATH .. self.posterFullName)
  local isLock = self.level > self.weaponLevel
  CS.UIGray.SetGray(self.main_bg.transform, isLock, false)
  CS.UIGray.SetGray(self.main_bg2.transform, isLock, false)
  CS.UIGray.SetGray(self.title_bg.transform, isLock, false)
  CS.UIGray.SetGray(self.air_icon.transform, isLock, false)
  self.effectNode:SetActive(not isLock)
  self.lockIcon:SetActive(isLock)
  if isLock then
    self.air_title:SetLocalText("new_uav_level_desc3", self.level)
  else
    self.air_title:SetLocalText("new_uav_level_desc4", self.level)
  end
end

return TacticalLevelDisplayAirItem
