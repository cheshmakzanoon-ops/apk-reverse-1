local MailScoutTroopItem = BaseClass("MailScoutTroopItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local troop_lv_node_path = "LvBg"
local troop_lv_txt_path = "LvBg/Lv"
local troop_count_txt_path = "Count"
local infoBtn_path = "Troop/IconBg"

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.TroopIconN = self:AddComponent(UIImage, infoBtn_path)
  self.TroopLvRootN = self:AddComponent(UIBaseContainer, troop_lv_node_path)
  self.TroopLvNumN = self:AddComponent(UIText, troop_lv_txt_path)
  self.TroopCountNumN = self:AddComponent(UIText, troop_count_txt_path)
  self.InfoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.InfoBtnN:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickGo()
  end)
end

local function ComponentDestroy(self)
  self.TroopIconN = nil
  self.TroopLvRootN = nil
  self.TroopLvNumN = nil
  self.TroopCountNumN = nil
  self.InfoBtnN = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshData(self, scoutTroop)
  self.scoutTroop = scoutTroop
  if not scoutTroop.armsId or scoutTroop.armsId == "" then
    local tempIcon = self:GetTroopTypeIcon(scoutTroop.type.value)
    self.TroopIconN:LoadSprite(string.format(LoadPath.SoldierIcons, tempIcon))
    self.TroopLvRootN:SetActive(false)
  else
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(scoutTroop.armsId)
    if template ~= nil then
      self.TroopIconN:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
      self.TroopLvRootN:SetActive(true)
      self.TroopLvNumN:SetText(RomeNum[template.level])
    end
  end
  self.TroopCountNumN:SetText(string.GetFormattedStr(scoutTroop.total.value))
end

local function GetTroopTypeIcon(self, intType)
  if intType == 1 then
    return "SoldierIcons_tank_1"
  elseif intType == 2 then
    return "SoldierIcons_infantry_1"
  elseif intType == 3 then
    return "SoldierIcons_aircraft_1"
  end
end

local function GetTroopTypeName(self, troopType)
  if troopType == 1 then
    return Localization:GetString("100639")
  elseif troopType == 2 then
    return Localization:GetString("100640")
  elseif troopType == 3 then
    return Localization:GetString("100641")
  end
end

local function OnClickGo(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.InfoBtnN.transform.position + Vector3.New(0, 50, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  if not self.scoutTroop.armsId or self.scoutTroop.armsId == "" then
    param.content = self:GetTroopTypeName(self.scoutTroop.type.value)
  else
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.scoutTroop.armsId)
    if template ~= nil then
      local tempType = template.arm
      param.title = self:GetTroopTypeName(tempType)
      param.content = Localization:GetString(template.name)
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

MailScoutTroopItem.OnCreate = OnCreate
MailScoutTroopItem.OnDestroy = OnDestroy
MailScoutTroopItem.OnEnable = OnEnable
MailScoutTroopItem.OnDisable = OnDisable
MailScoutTroopItem.ComponentDefine = ComponentDefine
MailScoutTroopItem.ComponentDestroy = ComponentDestroy
MailScoutTroopItem.DataDefine = DataDefine
MailScoutTroopItem.DataDestroy = DataDestroy
MailScoutTroopItem.RefreshData = RefreshData
MailScoutTroopItem.GetTroopTypeIcon = GetTroopTypeIcon
MailScoutTroopItem.OnClickGo = OnClickGo
MailScoutTroopItem.GetTroopTypeName = GetTroopTypeName
return MailScoutTroopItem
