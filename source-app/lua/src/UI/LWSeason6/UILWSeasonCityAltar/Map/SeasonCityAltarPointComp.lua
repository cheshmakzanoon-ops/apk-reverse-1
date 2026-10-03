local base = UIAsyncContainer
local SeasonCityAltarPointComp = BaseClass("SeasonCityAltarPointComp", base)

function SeasonCityAltarPointComp:ComponentDefine()
  local p_content_no_occupy_path = "content_occupy/p_content_no_occupy"
  local p_content_player_path = "content_occupy/p_content_player"
  local p_comp_head_path = "content_occupy/p_content_player/Head/PlayerBtn/p_comp_head"
  local p_text_office_name_path = "content_occupy/p_content_player/p_text_office_name"
  local p_text_user_name_path = "content_occupy/p_content_player/p_text_user_name"
  local text_no_user_path = "content_occupy/p_content_player/text_no_user"
  local p_btn_user_info_path = "content_occupy/p_content_player/p_btn_user_info"
  local content_skill_path = "content_skill"
  local p_skill_icon_path = "content_skill/content/skill_base/p_skill_icon"
  local p_text_skill_title_path = "content_skill/content/p_text_skill_title"
  local p_text_skill_desc_path = "content_skill/content/p_text_skill_desc"
  local p_text_give_up_path = "content_first_occupy/p_text_give_up"
  local content_first_occupy_path = "content_first_occupy"
  local p_text_fisrt_occupy_path = "content_first_occupy/content_first_occupy/p_text_fisrt_occupy"
  local p_text_open_time_path = "p_text_open_time"
  local p_text_limit_path = "p_text_limit"
  self.root = self:AddComponent(UIBaseContainer, "")
  self.p_content_no_occupy = self:AddComponent(UIBaseContainer, p_content_no_occupy_path)
  self.p_content_player = self:AddComponent(UIImage, p_content_player_path)
  self.p_comp_head = self:AddComponent(UICommonHead, p_comp_head_path)
  self.p_text_office_name = self:AddComponent(UITextMeshProUGUIEx, p_text_office_name_path)
  self.p_text_user_name = self:AddComponent(UITextMeshProUGUIEx, p_text_user_name_path)
  self.text_no_user = self:AddComponent(UITextMeshProUGUIEx, text_no_user_path)
  self.p_btn_user_info = self:AddComponent(UIButton, p_btn_user_info_path)
  self.p_btn_user_info:SetOnClick(BindCallback(self, self.OnUserInfoClicked))
  self.content_skill = self:AddComponent(UIImage, content_skill_path)
  self.p_skill_icon = self:AddComponent(UIImage, p_skill_icon_path)
  self.p_text_skill_title = self:AddComponent(UITextMeshProUGUIEx, p_text_skill_title_path)
  self.p_text_skill_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_skill_desc_path)
  self.p_text_give_up = self:AddComponent(UITextMeshProUGUIEx, p_text_give_up_path)
  self.content_first_occupy = self:AddComponent(UIImage, content_first_occupy_path)
  self.p_text_fisrt_occupy = self:AddComponent(UITextMeshProUGUIEx, p_text_fisrt_occupy_path)
  self.p_text_open_time = self:AddComponent(UITextMeshProUGUIEx, p_text_open_time_path)
  self.p_text_limit = self:AddComponent(UITextMeshProUGUIEx, p_text_limit_path)
end

function SeasonCityAltarPointComp:ComponentDestroy()
  self.p_content_no_occupy = nil
  self.p_content_player = nil
  self.p_comp_head = nil
  self.p_text_office_name = nil
  self.p_text_user_name = nil
  self.text_no_user = nil
  self.p_btn_user_info = nil
  self.content_skill = nil
  self.p_skill_icon = nil
  self.p_text_skill_title = nil
  self.p_text_skill_desc = nil
  self.p_text_give_up = nil
  self.content_first_occupy = nil
  self.p_text_fisrt_occupy = nil
  self.p_text_open_time = nil
  self.p_text_limit = nil
end

function SeasonCityAltarPointComp:DataDefine()
  self.AltarUserInfo = nil
end

function SeasonCityAltarPointComp:DataDestroy()
  self.AltarUserInfo = nil
end

function SeasonCityAltarPointComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCityAltarPointComp:OnDestroy()
  self.AltarUserInfo = nil
  DataCenter.SeasonCityAltarManager:ClearSendGetAltarInfoTime()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCityAltarPointComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCityAltarGetAltarInfo, self.OnAltarInfoCallback)
end

function SeasonCityAltarPointComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCityAltarGetAltarInfo, self.OnAltarInfoCallback)
  base.OnRemoveListener(self)
end

function SeasonCityAltarPointComp:ReInit(data)
  self:InitData(data)
  self:RefreshView()
end

function SeasonCityAltarPointComp:InitData(data)
  if data ~= nil and data.altarData ~= nil then
    self.Data = data
    self.AltarData = data.altarData
    self.CityCell = data.meta
    DataCenter.SeasonCityAltarManager:SendGetAltarInfo(self.AltarData.CityId, self.AltarData.ServerId)
    return true
  end
  return false
end

function SeasonCityAltarPointComp:UpdateData()
  self:UpdateOccupy()
  self:UpdateSkill()
  self:UpdateFirstOccupy()
  self:UpdateLimit()
  self.p_text_open_time:SetActive(true)
  self:Update1000MS()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_first_occupy.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
end

function SeasonCityAltarPointComp:UpdateOffice()
  local skillCell = DataCenter.SeasonCityAltarManager:GetAltarSkillCell(self.AltarData.CityId, self.AltarData.ServerId)
  if skillCell ~= nil then
    local officeType = checknumber(skillCell.type)
    local name = LWAlMemberOffcialParam[officeType].Text
    local icon = LWAlMemberOffcialParam[officeType].Icon
    if not string.IsNullOrEmpty(name) then
      self.p_text_office_name:SetLocalText(name)
    end
    if not string.IsNullOrEmpty(icon) then
      self.p_content_player:LoadSpriteAsync(icon)
      self.p_content_player:SetActive(true)
      if officeType == LWAlMemberOffcialType.Al_MASTER then
        self.p_content_player:SetSizeDeltaXY(190, 105)
      else
        self.p_content_player:SetSizeDeltaXY(124, 124)
      end
    else
      self.p_content_player:SetActive(false)
    end
  else
    self.p_content_player:SetActive(false)
  end
  self:UpdateUser()
end

function SeasonCityAltarPointComp:UpdateUser()
  if self.AltarUserInfo == nil then
    self.text_no_user:SetActive(true)
    self.p_text_user_name:SetActive(false)
    self.p_comp_head:SetActive(false)
  else
    self.text_no_user:SetActive(false)
    self.p_text_user_name:SetActive(true)
    self.p_text_user_name:SetLocalText("season_s6_activity1200109_desc17", string.format("[%s] %s", self.AltarUserInfo.abbr, self.AltarUserInfo.name))
    self.p_comp_head:SetActive(true)
    self.p_comp_head:SetHeadAndFrame(self.AltarUserInfo.uid, self.AltarUserInfo.pic, self.AltarUserInfo.picVer, false, self.AltarUserInfo.headSkinId, self.AltarUserInfo.headSkinET)
  end
end

function SeasonCityAltarPointComp:UpdateOccupy()
  if self.AltarData.Owner == nil then
    self.p_content_no_occupy:SetActive(true)
    self.p_content_player:SetActive(false)
  else
    self.p_content_no_occupy:SetActive(false)
    self:UpdateOffice()
  end
end

function SeasonCityAltarPointComp:UpdateSkill()
  local skillCell = DataCenter.SeasonCityAltarManager:GetAltarSkillCell(self.AltarData.CityId, self.AltarData.ServerId)
  if skillCell == nil then
    self.content_skill:SetActive(false)
  else
    self.content_skill:SetActive(true)
    self.p_skill_icon:LoadSpriteAsync(skillCell.skill_icon)
    self.p_text_skill_title:SetLocalText(skillCell.name)
    self.p_text_skill_desc:SetLocalText(skillCell.desc)
  end
end

function SeasonCityAltarPointComp:UpdateFirstOccupy()
  if self.AltarData.FirstOccupyUser == nil then
    self.content_first_occupy:SetActive(false)
  else
    self.content_first_occupy:SetActive(true)
    local time = checknumber(self.AltarData.FirstOccupyTime)
    if 0 < time then
      self.p_text_fisrt_occupy:SetLocalText("season_s6_activity1200109_desc18", UITimeManager:GetInstance():TimeStampToTimeForServer(time))
    end
  end
  self.p_text_give_up:SetActive(self.AltarData:IsGivingUp())
end

function SeasonCityAltarPointComp:UpdateLimit()
  if self.CityCell == nil or string.IsNullOrEmpty(self.CityCell.mutex_flag) or string.IsNullOrEmpty(self.CityCell.flag) then
    self.p_text_limit:SetActive(false)
    return
  end
  local mutexName = DataCenter.SeasonCityAltarManager:GetCityNameByFlag(self.CityCell.mutex_flag, self.AltarData.ServerId)
  self.p_text_limit:SetActive(true)
  self.p_text_limit:SetLocalText("season_s6_activity1200109_desc12", self.CityCell:GetFullName(), mutexName)
end

function SeasonCityAltarPointComp:OnAltarInfoCallback(evt)
  if self.AltarData ~= nil and evt ~= nil and self.AltarData.CityId == checknumber(evt.cfgId) then
    self.AltarUserInfo = nil
    if evt.skill ~= nil then
      self.AltarUserInfo = evt.skill.user
    end
    self:UpdateUser()
  end
end

function SeasonCityAltarPointComp:OnUserInfoClicked()
  if self.AltarUserInfo ~= nil and self.AltarUserInfo.uid ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.AltarUserInfo.uid)
  elseif self.AltarData ~= nil and self.AltarData:BelongMyAlliance() and DataCenter.AllianceBaseDataManager:IsR5() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMember, {anim = true, hideTop = true})
  end
end

function SeasonCityAltarPointComp:Update1000MS()
  if self.AltarData == nil then
    return
  end
  local timeState, time = self.AltarData:GetTimeState()
  local timeLeft = UITimeManager:GetInstance():MilliSecondToFmtString(Mathf.Max(0, checknumber(time) - UITimeManager:GetInstance():GetServerTime()))
  if timeState == AllianceCityShowTimeState.AltarLock then
    self.p_text_open_time:SetLocalText("season_s6_activity1200109_desc15", timeLeft)
  elseif timeState == AllianceCityShowTimeState.AltarBattle then
    self.p_text_open_time:SetLocalText("season_s6_activity1200109_desc25", timeLeft)
  elseif timeState == AllianceCityShowTimeState.AltarOver then
    self.p_text_open_time:SetLocalText("season_s6_activity1200109_desc03")
  end
  if self.AltarData:IsGivingUp() then
    local giveUpTime = UITimeManager:GetInstance():MilliSecondToFmtString(self.AltarData:GetGiveUpLeftTime())
    self.p_text_give_up:SetLocalText("season_s6_activity1200109_desc28", giveUpTime)
  end
end

return SeasonCityAltarPointComp
