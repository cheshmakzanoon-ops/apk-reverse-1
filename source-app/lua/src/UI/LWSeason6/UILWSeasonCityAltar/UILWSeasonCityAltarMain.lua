local UILWSeasonCityAltarSkillComp = require("UI.LWSeason6.UILWSeasonCityAltar.Comp.UILWSeasonCityAltarSkillComp")
local base = UIBaseContainer
local UILWSeasonCityAltarMain = BaseClass("UILWSeasonCityAltarMain", UIBaseContainer)

function UILWSeasonCityAltarMain:ComponentDefine()
  local p_comp_city_altar_path = "Root/mid/p_comp_city_altar"
  local p_btn_left_path = "Root/mid/p_btn_left"
  local p_btn_right_path = "Root/mid/p_btn_right"
  local p_btn_info_path = "Root/top/content_title/title/p_btn_info"
  local p_act_name_path = "Root/top/content_title/title/p_act_name"
  local p_text_time_path = "Root/top/content_title/time/bg/p_text_time"
  local p_text_desc_path = "Root/top/content_title/p_text_desc"
  local p_btn_rule_path = "Root/top/content_btn/p_btn_rule"
  local p_btn_rank_path = "Root/top/content_btn/p_btn_rank"
  local p_btn_list_path = "Root/top/content_btn/p_btn_list"
  self.p_comp_city_altar = self:AddComponent(UILWSeasonCityAltarSkillComp, p_comp_city_altar_path)
  self.p_btn_left = self:AddComponent(UIButton, p_btn_left_path)
  self.p_btn_left:SetOnClick(BindCallback(self, self.OnBtnLeftClicked))
  self.p_btn_right = self:AddComponent(UIButton, p_btn_right_path)
  self.p_btn_right:SetOnClick(BindCallback(self, self.OnBtnRightClicked))
  self.p_btn_info = self:AddComponent(UIButton, p_btn_info_path)
  self.p_btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClicked))
  self.p_btn_rule = self:AddComponent(UIButton, p_btn_rule_path)
  self.p_btn_rule:SetOnClick(BindCallback(self, self.OnBtnRuleClicked))
  self.p_btn_rank = self:AddComponent(UIButton, p_btn_rank_path)
  self.p_btn_rank:SetOnClick(BindCallback(self, self.OnBtnRankClicked))
  self.p_btn_list = self:AddComponent(UIButton, p_btn_list_path)
  self.p_btn_list:SetOnClick(BindCallback(self, self.OnBtnListClicked))
  self.p_act_name = self:AddComponent(UITextMeshProUGUIEx, p_act_name_path)
  self.p_text_time = self:AddComponent(UITextMeshProUGUIEx, p_text_time_path)
  self.p_text_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_desc_path)
end

function UILWSeasonCityAltarMain:ComponentDestroy()
  self.p_comp_city_altar = nil
  self.p_btn_left = nil
  self.p_btn_right = nil
  self.p_btn_info = nil
  self.p_btn_rule = nil
  self.p_btn_rank = nil
  self.p_btn_list = nil
  self.p_act_name = nil
  self.p_text_time = nil
  self.p_text_desc = nil
end

function UILWSeasonCityAltarMain:DataDefine()
  self.TickAct = false
end

function UILWSeasonCityAltarMain:DataDestroy()
  self.TickAct = false
end

function UILWSeasonCityAltarMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonCityAltarMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityAltarMain:SetData(actId, actData)
  self:ReInit()
end

function UILWSeasonCityAltarMain:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonCityAltarMain:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonCityAltarMain:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
  else
    self:ResetUi()
  end
end

function UILWSeasonCityAltarMain:InitData()
  CommonUtil.PlayerPrefsSetBool(SettingKeys.S6_MILITARY_ALTAR_ACTIVITY_SHOW, true)
  EventManager:GetInstance():Broadcast(EventId.SeasonCityAltarRedUpdate)
  self.ActData = DataCenter.SeasonCityAltarManager.ActData
  if self.ActData ~= nil then
    self.EndTime = self.ActData:GetShowEndTime()
    self.TickAct = true
    self.CityCells = DataCenter.SeasonCityAltarManager:GetCityAltarCells(LuaEntry.Player:GetSourceServerId())
    self.CurIndex = -1
    return table.count(self.CityCells) > 0
  end
  return false
end

function UILWSeasonCityAltarMain:InitUi()
  if self.ActData ~= nil then
    self.p_act_name:SetLocalText(self.ActData.name)
  end
  self.p_text_desc:SetActive(false)
  self:UpdateCityAltar(1)
end

function UILWSeasonCityAltarMain:ResetUi()
  self.p_comp_city_altar:SetActive(false)
  self.p_btn_left:SetActive(false)
  self.p_btn_right:SetActive(false)
end

function UILWSeasonCityAltarMain:UpdateData()
end

function UILWSeasonCityAltarMain:UpdateUi()
end

function UILWSeasonCityAltarMain:UpdateCityAltar(index)
  self.p_btn_left:SetActive(1 < index)
  self.p_btn_right:SetActive(index < table.count(self.CityCells))
  index = Mathf.Clamp(index, 1, table.count(self.CityCells))
  self.CurIndex = index
  local cityCell = self.CityCells[index]
  local data = {}
  data.CityCell = cityCell
  self.p_comp_city_altar:SetActive(true)
  self.p_comp_city_altar:ReInit(data)
end

function UILWSeasonCityAltarMain:Update1000MS()
  if self.TickAct then
    local timeLeft = Mathf.Max(0, checknumber(self.EndTime - UITimeManager:GetInstance():GetServerTime()))
    self.p_text_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft))
  end
end

function UILWSeasonCityAltarMain:OnBtnLeftClicked()
  self:UpdateCityAltar(self.CurIndex - 1)
end

function UILWSeasonCityAltarMain:OnBtnRightClicked()
  self:UpdateCityAltar(self.CurIndex + 1)
end

function UILWSeasonCityAltarMain:OnBtnInfoClicked()
  if self.ActData ~= nil and self.ActData.story ~= nil then
    local param = {}
    param.activityId = self.ActData.id
    param.activityRulesStr = CS.GameEntry.Localization:GetString(self.ActData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UILWSeasonCityAltarMain:OnBtnRuleClicked()
  if self.ActData == nil or table.IsNullOrEmpty(self.ActData.howtoplay) then
    return
  end
  local param = {}
  param.howToPlayList = self.ActData.howtoplay
  param.story = self.ActData.story
  param.defaultTitle = self.ActData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function UILWSeasonCityAltarMain:OnBtnRankClicked()
  local param = {}
  param.DefaultDropDownIndex = DataCenter.SeasonCityAltarManager.PeriodType.Day + 1
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWS6CityAltarSkillRank, {anim = true}, param)
end

function UILWSeasonCityAltarMain:OnBtnListClicked()
  GoToUtil.GoToSeasonCityList(6)
end

return UILWSeasonCityAltarMain
