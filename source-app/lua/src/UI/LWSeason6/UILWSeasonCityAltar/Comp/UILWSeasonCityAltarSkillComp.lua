local base = UIBaseContainer
local UILWSeasonCityAltarSkillComp = BaseClass("UILWSeasonCityAltarSkillComp", UIBaseContainer)

function UILWSeasonCityAltarSkillComp:ComponentDefine()
  local p_img_city_icon_path = "p_img_city_icon"
  local p_text_city_name_path = "p_text_city_name"
  local p_text_city_state_path = "p_text_city_state"
  local p_content_city_time_path = "p_content_city_time"
  local p_text_day_path = "p_content_city_time/content_day/p_text_day"
  local p_text_hour_path = "p_content_city_time/content_hour/p_text_hour"
  local p_text_div_1_path = "p_content_city_time/p_text_div_1"
  local p_text_min_path = "p_content_city_time/content_min/p_text_min"
  local p_text_div_2_path = "p_content_city_time/p_text_div_2"
  local p_text_sec_path = "p_content_city_time/content_sec/p_text_sec"
  local p_btn_goto_skill_path = "btns/p_btn_goto_skill"
  local p_content_skill_path = "p_content_skill"
  local p_skill_icon_path = "p_content_skill/img_panel/content/skill_base/p_skill_icon"
  local p_text_skill_title_path = "p_content_skill/img_panel/content/p_text_skill_title"
  local p_text_skill_desc_path = "p_content_skill/img_panel/content/p_text_skill_desc"
  local p_text_altar_limit_path = "p_content_skill/img_panel/p_text_altar_limit"
  self.p_img_city_icon = self:AddComponent(UIRawImage, p_img_city_icon_path)
  self.p_text_city_name = self:AddComponent(UITextMeshProUGUIEx, p_text_city_name_path)
  self.p_text_city_name:OnPointerClick(function()
    self:GotoCity()
  end)
  self.p_text_city_state = self:AddComponent(UITextMeshProUGUIEx, p_text_city_state_path)
  self.p_content_city_time = self:AddComponent(UIBaseContainer, p_content_city_time_path)
  self.p_text_day = self:AddComponent(UITextMeshProUGUIEx, p_text_day_path)
  self.p_text_hour = self:AddComponent(UITextMeshProUGUIEx, p_text_hour_path)
  self.p_text_div_1 = self:AddComponent(UITextMeshProUGUIEx, p_text_div_1_path)
  self.p_text_min = self:AddComponent(UITextMeshProUGUIEx, p_text_min_path)
  self.p_text_div_2 = self:AddComponent(UITextMeshProUGUIEx, p_text_div_2_path)
  self.p_text_sec = self:AddComponent(UITextMeshProUGUIEx, p_text_sec_path)
  self.p_btn_goto_skill = self:AddComponent(UIButton, p_btn_goto_skill_path)
  self.p_btn_goto_skill:SetOnClick(BindCallback(self, self.OnGotoSkillClicked))
  self.p_content_skill = self:AddComponent(UIBaseContainer, p_content_skill_path)
  self.p_skill_icon = self:AddComponent(UIImage, p_skill_icon_path)
  self.p_text_skill_title = self:AddComponent(UITextMeshProUGUIEx, p_text_skill_title_path)
  self.p_text_skill_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_skill_desc_path)
  self.p_text_altar_limit = self:AddComponent(UITextMeshProUGUIEx, p_text_altar_limit_path)
end

function UILWSeasonCityAltarSkillComp:ComponentDestroy()
  self.p_img_city_icon = nil
  self.p_text_city_name = nil
  self.p_text_city_state = nil
  self.p_content_city_time = nil
  self.p_text_day = nil
  self.p_text_hour = nil
  self.p_text_div_1 = nil
  self.p_text_min = nil
  self.p_text_div_2 = nil
  self.p_text_sec = nil
  self.p_btn_goto_skill = nil
  self.p_content_skill = nil
  self.p_skill_icon = nil
  self.p_text_skill_title = nil
  self.p_text_skill_desc = nil
  self.p_text_altar_limit = nil
end

function UILWSeasonCityAltarSkillComp:DataDefine()
  self.OpenState = {
    UnOpen = 1,
    Opening = 2,
    Finished = 3
  }
end

function UILWSeasonCityAltarSkillComp:DataDestroy()
end

function UILWSeasonCityAltarSkillComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonCityAltarSkillComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityAltarSkillComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
  end
end

function UILWSeasonCityAltarSkillComp:InitData(data)
  if data ~= nil then
    self.Data = data
    self.CityCell = data.CityCell
    return self.CityCell ~= nil
  end
  return false
end

function UILWSeasonCityAltarSkillComp:InitUi()
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.CityCell.id, LuaEntry.Player:GetSourceServerId())
  if cityTemplate ~= nil then
    self.p_text_city_name:SetText(cityTemplate:GetFullName())
    self.p_img_city_icon:LoadSpriteAsync(cityTemplate:GetBigIconPath())
  end
  local skillCell = self:GetSkillCell()
  if skillCell ~= nil then
    self.p_content_skill:SetActive(true)
    self.p_skill_icon:LoadSpriteAsync(skillCell.skill_icon)
    self.p_text_skill_title:SetLocalText(skillCell.name)
    self.p_text_skill_desc:SetLocalText(skillCell.desc)
  else
    self.p_content_skill:SetActive(false)
  end
  local hasMutex = not string.IsNullOrEmpty(cityTemplate.mutex_flag) and not string.IsNullOrEmpty(cityTemplate.flag)
  self.p_text_altar_limit:SetActive(hasMutex)
  if hasMutex then
    local mutexName = DataCenter.SeasonCityAltarManager:GetCityNameByFlag(cityTemplate.mutex_flag, LuaEntry.Player:GetSelfServerId())
    self.p_text_altar_limit:SetLocalText("season_s6_activity1200109_desc12", cityTemplate:GetFullName(), mutexName)
  end
end

function UILWSeasonCityAltarSkillComp:UpdateData()
  self.CurState, self.EndTime = self:GetOpenStateAndTime()
  self.TickAct = false
  self.p_content_city_time:SetActive(false)
  if self.CurState == self.OpenState.Finished then
    self.p_text_city_state:SetLocalText("season_s6_activity1200109_desc03")
  else
    self.TickAct = true
    self.p_content_city_time:SetActive(true)
    if self.CurState == self.OpenState.Opening then
      self.p_text_city_state:SetLocalText("season_s6_activity1200109_desc02")
    elseif self.CurState == self.OpenState.UnOpen then
      self.p_text_city_state:SetLocalText("season_s6_activity1200109_desc01")
    end
  end
  return true
end

function UILWSeasonCityAltarSkillComp:UpdateUi()
end

function UILWSeasonCityAltarSkillComp:Update1000MS()
  if self.TickAct then
    local leftTime = self.EndTime - UITimeManager:GetInstance():GetServerTime()
    if leftTime < 0 then
      self.TickAct = false
      if self:UpdateData() then
        self:UpdateUi()
      end
    else
      local day, hour, min, sec = UITimeManager:GetInstance():MilliSecondToFmtFormat(leftTime)
      self.p_text_day:SetTextFormat("%sd", day)
      self.p_text_hour:SetTextFormat("%02d", hour)
      self.p_text_min:SetTextFormat("%02d", min)
      self.p_text_sec:SetTextFormat("%02d", sec)
    end
  end
end

function UILWSeasonCityAltarSkillComp:GetOpenStateAndTime()
  local firstDay = checknumber(self.CityCell.first_open)
  local loopDay = checknumber(self.CityCell.loop_blank)
  local openTimes = checknumber(self.CityCell.loop_time)
  local offsetHour, durationMin = string.string2_ii(self.CityCell.open_para, "|")
  local openState = self.OpenState.Finished
  local seasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  for i = 1, openTimes do
    local day = firstDay + (i - 1) * loopDay
    local dayZeroTime = seasonStartTime + (day - 1) * OneDayTime * 1000
    local startTime = dayZeroTime + offsetHour * OneHourTime * 1000
    local endTime = startTime + durationMin * 60 * 1000
    if now < startTime then
      openState = self.OpenState.UnOpen
      return openState, startTime
    elseif now <= endTime then
      openState = self.OpenState.Opening
      return openState, endTime
    end
  end
  return self.OpenState.Finished, -1
end

function UILWSeasonCityAltarSkillComp:GetSkillCell()
  if self.CityCell ~= nil then
    return DataCenter.SeasonCityAltarManager:GetAltarSkillCell(self.CityCell.id)
  end
  return nil
end

function UILWSeasonCityAltarSkillComp:GotoCity()
  if self.CityCell ~= nil then
    self.CityCell:JumpTo()
  end
end

function UILWSeasonCityAltarSkillComp:OnGotoSkillClicked()
  local skillCell = self:GetSkillCell()
  if skillCell ~= nil then
    GoToUtil:GoToNewAllianceSkill(skillCell.id)
  end
end

return UILWSeasonCityAltarSkillComp
