local MailOtherItem = BaseClass("MailOtherItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local attrition_name_text1_path = "left/AttritionNameText1"
local attrition_name_text2_path = "right/AttritionNameText2"
local attrition_power_val_text1_path = "left/AttritionPowerValText1"
local attrition_power_val_text2_path = "right/AttritionPowerValText2"
local iconPath = {
  [ExtraPowerInfoType.AllianceScience] = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbaoyouhua_lianmengkeji_icon.png",
  [ExtraPowerInfoType.Mastery] = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbaoyouhua_zhiyejineng_icon.png",
  [ExtraPowerInfoType.BattleField] = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbaoyouhua_zhanchang_icon.png"
}
local nameLocalizationKey = {
  [ExtraPowerInfoType.AllianceScience] = "power_display_new_014",
  [ExtraPowerInfoType.Mastery] = "power_display_new_015",
  [ExtraPowerInfoType.BattleField] = "power_display_new_005"
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
  self.OtherImg1 = self:AddComponent(UIImage, "left/HonorCellTiny1/imgIcon1")
  self.OtherImg2 = self:AddComponent(UIImage, "right/HonorCellTiny2/imgIcon2")
  self.nameText1 = self:AddComponent(UIText, attrition_name_text1_path)
  self.nameText2 = self:AddComponent(UIText, attrition_name_text2_path)
  self.powerText1 = self:AddComponent(UIText, attrition_power_val_text1_path)
  self.powerText2 = self:AddComponent(UIText, attrition_power_val_text2_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function MailOtherItem:SetData(extraPowerType, playerData1, playerData2)
  local path = iconPath[extraPowerType]
  if not string.IsNullOrEmpty(path) then
    self.OtherImg1:LoadSprite(path)
    self.OtherImg2:LoadSprite(path)
    self.OtherImg1:SetNativeSize()
    self.OtherImg2:SetNativeSize()
  end
  local nameKey = nameLocalizationKey[extraPowerType]
  if not string.IsNullOrEmpty(nameKey) then
    self.nameText1:SetLocalText(nameKey)
    self.nameText2:SetLocalText(nameKey)
  else
    self.nameText1:SetText("")
    self.nameText2:SetText("")
  end
  self.powerText1:SetText(BattleReportUtil.GetNewOtherPowerStrAfterFormat(playerData1, extraPowerType))
  self.powerText2:SetText(BattleReportUtil.GetNewOtherPowerStrAfterFormat(playerData2, extraPowerType))
end

MailOtherItem.OnCreate = OnCreate
MailOtherItem.OnDestroy = OnDestroy
MailOtherItem.OnEnable = OnEnable
MailOtherItem.OnDisable = OnDisable
MailOtherItem.ComponentDefine = ComponentDefine
MailOtherItem.ComponentDestroy = ComponentDestroy
MailOtherItem.DataDefine = DataDefine
MailOtherItem.DataDestroy = DataDestroy
MailOtherItem.OnAddListener = OnAddListener
MailOtherItem.OnRemoveListener = OnRemoveListener
return MailOtherItem
