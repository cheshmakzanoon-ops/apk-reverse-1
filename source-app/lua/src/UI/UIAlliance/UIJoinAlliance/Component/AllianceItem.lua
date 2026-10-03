local AllianceItem = BaseClass("AllianceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local name_path = "nameTxt"
local state_path = "stateTxt"
local power_path = "powerTxt"
local people_path = "peopleTxt"
local language_path = "languageTxt"
local level_path = "levelTxt"
local countryFlag_path = "country"
local flag_path = "flag/AllianceFlag"
local select_obj_path = "select"
local btn_path = "Button"
local info_btn_path = "flagBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.name = self:AddComponent(UIText, name_path)
  self.state = self:AddComponent(UIText, state_path)
  self.power = self:AddComponent(UIText, power_path)
  self.people = self:AddComponent(UIText, people_path)
  self.language = self:AddComponent(UIText, language_path)
  self.flag = self:AddComponent(AllianceFlagItem, flag_path)
  self.select_obj = self:AddComponent(UIBaseContainer, select_obj_path)
  self.level = self:AddComponent(UIText, level_path)
  self.level:SetActive(false)
  self.countryFlagN = self:AddComponent(UIImage, countryFlag_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickInfoBtn()
  end)
  self:SetActive(true)
end

local function SetItemShow(self, uid)
  self.allianceId = uid
  local allianceData = self.view.ctrl:GetOneAllianceByUid(self.allianceId)
  local currentAlliance = self.view.ctrl:GetCurrentAlliance()
  self.name:SetText("[" .. allianceData.abbr .. "]" .. allianceData.allianceName)
  self.state:SetActive(true)
  if allianceData.recruitTotal == 1 then
    self.state:SetLocalText(390798)
  else
    self.state:SetLocalText(390797)
  end
  self.power:SetText(string.GetFormattedSeperatorNum(allianceData.fightPower))
  self.people:SetText(allianceData.curMember .. "/" .. allianceData.maxMember)
  if not LuaEntry.GlobalData:IsChina() then
    self.countryFlagN:SetActive(true)
    local nationTemplate = allianceData:GetCountryFlagTemplate()
    self.countryFlagN:LoadSprite(nationTemplate:GetNationFlagPath())
  else
    self.countryFlagN:SetActive(false)
  end
  if allianceData.language ~= nil and allianceData.language ~= "" then
    self.language:SetLocalText(allianceData.language)
  else
    self.language:SetLocalText(390254)
  end
  self.select_obj:SetActive(currentAlliance.uid == self.allianceId)
  self.flag:SetData(allianceData.icon)
end

local function OnClick(self)
  local currentAlliance = self.view.ctrl:GetCurrentAlliance()
  if self.allianceId ~= currentAlliance.uid then
    self.view.ctrl:SelectOneAllianceItem(self.allianceId)
    self.select_obj:SetActive(true)
  end
end

local function OnClickInfoBtn(self)
  self:OnClick()
  self.view.ctrl:OnInfoClick()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CLICK_ALLIANCE_ITEM, self.RefreshItemState)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CLICK_ALLIANCE_ITEM, self.RefreshItemState)
end

local function RefreshItemState(self, data)
  if self.allianceId == data then
    local currentAlliance = self.view.ctrl:GetCurrentAlliance()
    self.select_obj:SetActive(currentAlliance.uid == self.allianceId)
  end
end

AllianceItem.OnCreate = OnCreate
AllianceItem.SetItemShow = SetItemShow
AllianceItem.OnClick = OnClick
AllianceItem.OnAddListener = OnAddListener
AllianceItem.OnRemoveListener = OnRemoveListener
AllianceItem.RefreshItemState = RefreshItemState
AllianceItem.OnClickInfoBtn = OnClickInfoBtn
return AllianceItem
