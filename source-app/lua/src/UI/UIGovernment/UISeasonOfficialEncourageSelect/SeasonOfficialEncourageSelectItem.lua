local SeasonOfficialEncourageSelectItem = BaseClass("SeasonOfficialEncourageSelectItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local checkbox_path = "checkbox"
local player_path = "player"
local gender_icon1_path = "GenderIcon1"
local gender_icon2_path = "GenderIcon2"
local name_text_path = "NameText"
local power_text_path = "PowerText"
local on_line_text_path = "OnLineText"
local rank_icon_path = "RankIcon"

function SeasonOfficialEncourageSelectItem:OnCreate()
  base.OnCreate(self)
  self.checkbox = self:AddComponent(UIToggle, checkbox_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.gender_icon1 = self:AddComponent(UIImage, gender_icon1_path)
  self.gender_icon2 = self:AddComponent(UIImage, gender_icon2_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.power_text = self:AddComponent(UIText, power_text_path)
  self.on_line_text = self:AddComponent(UIText, on_line_text_path)
  self.rankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.player:SetEnableClickShowInfo(true)
  self.desc_btn = self:AddComponent(UIButton, "")
  self.desc_btn:SetOnClick(function()
    if self.showCheckBox then
      self:OnShowBtnClick(not self.select_status)
    end
  end)
  self.checkbox:SetOnValueChanged(function(tf)
    self:OnShowBtnClick(tf)
  end)
end

function SeasonOfficialEncourageSelectItem:OnDestroy()
  base.OnDestroy(self)
end

function SeasonOfficialEncourageSelectItem:ReInit(select, data, abbr, serverId, buildingId)
  self.data = data
  local presidentName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, data.name)
  if not string.IsNullOrEmpty(abbr) then
    presidentName = "[" .. abbr .. "]" .. presidentName
  elseif not string.IsNullOrEmpty(data.allianceAbbr) then
    presidentName = "[" .. data.allianceAbbr .. "]" .. presidentName
  elseif not string.IsNullOrEmpty(data.abbr) then
    presidentName = "[" .. data.abbr .. "]" .. presidentName
  end
  if data.serverId and data.serverId > 0 then
    presidentName = string.format("#%d %s", data.serverId, presidentName)
  end
  self.name_text:SetText(presidentName)
  self.player:SetHead(data.uid, data.pic, data.picVer or data.picver)
  local isMale = data.gender == 1 or data.sex == 1
  local isFemale = data.gender == 2 or data.sex == 2
  local isDouble = isMale and isFemale
  if isDouble then
    Logger.LogError("\230\128\167\229\136\171\233\148\153\232\175\175\239\188\140 uid=" .. data.uid)
  end
  self.gender_icon1:SetActive(isFemale)
  self.gender_icon2:SetActive(isMale)
  self.power_text:SetLocalText(100392, string.GetFormattedSeperatorNum(data.power))
  self.checkbox:SetIsOn(select)
  self.showCheckBox = not DataCenter.BuildingOfficialManager:IsGetReward(serverId, buildingId, data.uid)
  self.checkbox:SetActive(self.showCheckBox)
  local rank = data.rank or 0
  local memberData = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(data.uid)
  if memberData then
    rank = memberData.rank or 0
    self.on_line_text:SetText(DataCenter.AllianceMemberDataManager:GetOnlineText(memberData.online, memberData.offLineTime))
    if memberData.online then
      self.on_line_text:SetColorRGBA255(95, 239, 135, 255)
    else
      self.on_line_text:SetColorRGBA255(239, 137, 96, 255)
    end
  else
    self.on_line_text:SetText("")
  end
  local rankInfo = LWAlMemberRankParam[rank]
  if rankInfo then
    self.rankIcon:LoadSprite(rankInfo.Icon)
    self.rankIcon:SetActive(true)
  else
    self.rankIcon:SetActive(false)
  end
end

function SeasonOfficialEncourageSelectItem:OnShowBtnClick(select)
  self.view:OnCellClick(self.data.uid, select)
  self.checkbox:SetIsOn(select)
  self.select_status = select
end

return SeasonOfficialEncourageSelectItem
