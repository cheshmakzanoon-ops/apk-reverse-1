local OfficialSelectMemberItem = BaseClass("OfficialSelectMemberItem", UIBaseContainer)
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

function OfficialSelectMemberItem:OnCreate()
  base.OnCreate(self)
  self.checkbox = self:AddComponent(UIToggle, checkbox_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.gender_icon1 = self:AddComponent(UIImage, gender_icon1_path)
  self.gender_icon2 = self:AddComponent(UIImage, gender_icon2_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.power_text = self:AddComponent(UIText, power_text_path)
  self.on_line_text = self:AddComponent(UIText, on_line_text_path)
  self.rankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.king_icon = self:AddComponent(UIImage, "iconKing")
  self.player:SetEnableClickShowInfo(true)
  self.desc_btn = self:AddComponent(UIButton, "")
  self.desc_btn:SetOnClick(function()
    self:OnShowBtnClick(not self.select_status)
  end)
  self.checkbox:SetOnValueChanged(function(tf)
    self:OnShowBtnClick(tf)
  end)
end

function OfficialSelectMemberItem:OnDestroy()
  base.OnDestroy(self)
end

function OfficialSelectMemberItem:ReInit(select_player, data, abbr)
  self.data = data
  local presidentName
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
  if not string.IsNullOrEmpty(abbr) then
    presidentName = "[" .. abbr .. "]" .. data.name
  elseif not string.IsNullOrEmpty(data.allianceAbbr) then
    presidentName = "[" .. data.allianceAbbr .. "]" .. data.name
  elseif not string.IsNullOrEmpty(data.abbr) then
    presidentName = "[" .. data.abbr .. "]" .. data.name
  else
    presidentName = data.name
  end
  if data.serverId and data.serverId > 0 then
    presidentName = string.format("#%d %s", data.serverId, presidentName)
  end
  self.name_text:SetText(presidentName)
  self.player:SetHead(data.uid, data.pic, data.picVer or data.picver, nil, headBgImg)
  self.gender_icon1:SetActive(data.gender == 1 or data.sex == 1)
  self.gender_icon2:SetActive(data.gender == 2 or data.sex == 2)
  self.power_text:SetLocalText(100392, string.GetFormattedSeperatorNum(data.power))
  self.checkbox:SetIsOn(select_player ~= nil and select_player.uid == data.uid)
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
  local governmentInfo = DataCenter.GovernmentManager:GetPositionInfoByUID(data.uid)
  if governmentInfo ~= nil and governmentInfo.positionId ~= nil then
    local config = DataCenter.GovernmentTemplateManager:GetTemplate(governmentInfo.positionId)
    if config ~= nil then
      self.king_icon:SetActive(true)
      self.king_icon:LoadSprite(config.icon)
      self.king_icon:SetNativeSize()
    else
      self.king_icon:SetActive(false)
    end
  else
    self.king_icon:SetActive(false)
  end
end

function OfficialSelectMemberItem:OnShowBtnClick(select)
  self.view:OnCellClick(self.data, select)
  self.checkbox:SetIsOn(select)
  self.select_status = select
end

return OfficialSelectMemberItem
