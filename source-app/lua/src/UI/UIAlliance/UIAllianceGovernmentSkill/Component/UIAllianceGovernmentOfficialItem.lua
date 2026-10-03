local UIAllianceGovernmentOfficialItem = BaseClass("UIAllianceGovernmentOfficialItem", UIBaseContainer)
local base = UIBaseContainer
local ui_player_head_path = "Player/UIPlayerHead"
local power_path = "Player/Power"
local power_text_path = "Player/Power/Bg/PowerText"
local player_level_path = "Info/PlayerLevel"
local player_name_path = "Info/PlayerName"
local desc_text_path = "Info/desc/DescText"

function UIAllianceGovernmentOfficialItem:OnCreate()
  base.OnCreate(self)
  self.seasonType = SeasonUtil.GetSeasonType()
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.powerRoot = self:AddComponent(UIBaseComponent, power_path)
  self.icon = self:AddComponent(UIImage, "Player/icon")
  self.power_text = self:AddComponent(UITextMeshProUGUIEx, power_text_path)
  self.player_level = self:AddComponent(UITextMeshProUGUIEx, player_level_path)
  self.player_name = self:AddComponent(UITextMeshProUGUIEx, player_name_path)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.player_head:SetEnableClickShowInfo(true, true)
end

function UIAllianceGovernmentOfficialItem:OnDestroy()
  self.player_head = nil
  self.power_text = nil
  self.player_level = nil
  self.player_name = nil
  self.desc_text = nil
  self.powerRoot = nil
  self.icon = nil
  base.OnDestroy(self)
end

function UIAllianceGovernmentOfficialItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceMember, self.UpdateData)
end

function UIAllianceGovernmentOfficialItem:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceMember, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIAllianceGovernmentOfficialItem:SetOfficialType(officialType)
  self.officialType = officialType
  self:UpdateData()
end

function UIAllianceGovernmentOfficialItem:UpdateData()
  local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(self.officialType)
  if memberInfo == nil then
    self.player_head:SetActive(false)
    self.powerRoot:SetActive(false)
    self.player_level:SetActive(false)
    self.player_name:SetLocalText("457033")
  else
    self.player_head:SetActive(true)
    self.powerRoot:SetActive(true)
    if memberInfo.mainCityLv then
      self.player_level:SetActive(true)
      self.player_level:SetText("Lv." .. toInt(memberInfo.mainCityLv or 1))
    else
      self.player_level:SetActive(false)
    end
    self.player_name:SetText(memberInfo.name)
    self.player_head:ParseHeadInfo(memberInfo)
    self.power_text:SetText(string.GetFormattedStr(memberInfo.power or 0))
  end
  local iconPath = LWAlMemberOffcialParam[self.officialType].Icon
  if self.officialType == LWAlMemberOffcialType.Deputy_Al_Leader then
    self.desc_text:SetLocalText("season_alliance_government_skill_13")
  elseif self.officialType == LWAlMemberOffcialType.War_Commander then
    self.desc_text:SetLocalText("season_alliance_government_skill_goddess_13")
  elseif self.officialType == LWAlMemberOffcialType.Al_Goddess then
    self.desc_text:SetLocalText("391064")
  elseif self.officialType == LWAlMemberOffcialType.Al_Ambassadoe then
    self.desc_text:SetLocalText("alliance_government_10005_02")
  end
  self.icon:LoadSprite(iconPath)
end

return UIAllianceGovernmentOfficialItem
