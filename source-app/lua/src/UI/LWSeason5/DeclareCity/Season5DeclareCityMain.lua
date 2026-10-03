local p_text_act_title_path = "RightView/Top/p_text_act_title"
local p_text_act_time_path = "RightView/Top/content_time/bg_text_time/p_text_act_time"
local p_text_act_desc_path = "RightView/Top/p_text_act_desc"
local p_btn_info_path = "RightView/Top/p_btn_info"
local p_btn_record_path = "RightView/Top/p_btn_record"
local p_text_btn_record_path = "RightView/Top/p_btn_record/icon/p_text_btn_record"
local p_btn_war_time_path = "RightView/Top/p_btn_war_time"
local p_text_war_time_path = "RightView/Top/p_btn_war_time/icon/p_text_war_time"
local p_btn_reward_path = "RightView/Top/p_btn_reward"
local p_text_btn_reward_path = "RightView/Top/p_btn_reward/icon/p_text_btn_reward"
local p_btn_rank_path = "RightView/Bottom/p_btn_rank"
local p_text_btn_rank_path = "RightView/Bottom/p_btn_rank/LW_Btn_Common_New_Base/p_text_btn_rank"
local p_btn_city_list_path = "RightView/Bottom/p_btn_city_list"
local p_text_btn_city_list_path = "RightView/Bottom/p_btn_city_list/LW_Btn_Common_New_Base/p_text_btn_city_list"
local p_content_alliance_path = "RightView/p_content_alliance"
local p_text_no_alliance_path = "RightView/p_content_alliance/p_text_no_alliance"
local p_btn_join_alliance_path = "RightView/p_content_alliance/p_btn_join_alliance"
local p_text_btn_join_alliance_path = "RightView/p_content_alliance/p_btn_join_alliance/p_text_btn_join_alliance"
local p_content_out_war_day_path = "RightView/p_content_out_war_day"
local Season5DeclareOutWarDayComp = require("UI/LWSeason5/DeclareCity/Comp/Season5DeclareOutWarDayComp")
local p_content_out_war_time_path = "RightView/p_content_out_war_time"
local Season5DeclareOutWarTimeComp = require("UI/LWSeason5/DeclareCity/Comp/Season5DeclareOutWarTimeComp")
local p_content_in_war_time_path = "RightView/p_content_in_war_time"
local Season5DeclareInWarTimeComp = require("UI/LWSeason5/DeclareCity/Comp/Season5DeclareInWarTimeComp")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local Season5DeclareCityMain = BaseClass("Season5DeclareCityMain", base)

function Season5DeclareCityMain:ComponentDefine()
  self.p_text_act_title = self:AddComponent(UITextMeshProUGUIEx, p_text_act_title_path)
  self.p_text_act_time = self:AddComponent(UITextMeshProUGUIEx, p_text_act_time_path)
  self.p_text_act_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_act_desc_path)
  self.p_btn_info = self:AddComponent(UIButton, p_btn_info_path)
  self.p_btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClicked))
  self.p_btn_record = self:AddComponent(UIButton, p_btn_record_path)
  self.p_btn_record:SetOnClick(BindCallback(self, self.OnBtnRecordClicked))
  self.p_text_btn_record = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_record_path)
  self.p_btn_war_time = self:AddComponent(UIButton, p_btn_war_time_path)
  self.p_btn_war_time:SetOnClick(BindCallback(self, self.OnBtnWarTimeClicked))
  self.p_text_war_time = self:AddComponent(UITextMeshProUGUIEx, p_text_war_time_path)
  self.p_btn_reward = self:AddComponent(UIButton, p_btn_reward_path)
  self.p_btn_reward:SetOnClick(BindCallback(self, self.OnBtnRewardClicked))
  self.p_text_btn_reward = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_reward_path)
  self.p_btn_rank = self:AddComponent(UIButton, p_btn_rank_path)
  self.p_btn_rank:SetOnClick(BindCallback(self, self.OnRankClicked))
  self.p_text_btn_rank = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_rank_path)
  self.p_btn_city_list = self:AddComponent(UIButton, p_btn_city_list_path)
  self.p_btn_city_list:SetOnClick(BindCallback(self, self.OnCityListClicked))
  self.p_text_btn_city_list = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_city_list_path)
  self.p_content_alliance = self:AddComponent(UIBaseContainer, p_content_alliance_path)
  self.p_text_no_alliance = self:AddComponent(UITextMeshProUGUIEx, p_text_no_alliance_path)
  self.p_btn_join_alliance = self:AddComponent(UIButton, p_btn_join_alliance_path)
  self.p_btn_join_alliance:SetOnClick(BindCallback(self, self.OnBtnClickJoin))
  self.p_text_btn_join_alliance = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_join_alliance_path)
  self.p_content_out_war_day = self:AddComponent(Season5DeclareOutWarDayComp, p_content_out_war_day_path)
  self.p_content_out_war_time = self:AddComponent(Season5DeclareOutWarTimeComp, p_content_out_war_time_path)
  self.p_content_in_war_time = self:AddComponent(Season5DeclareInWarTimeComp, p_content_in_war_time_path)
end

function Season5DeclareCityMain:OnBtnInfoClicked()
  if self.ActData ~= nil and self.ActData.story ~= nil then
    local msg = CS.GameEntry.Localization:GetString(self.ActData.story)
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end
end

function Season5DeclareCityMain:OnBtnRecordClicked()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString(390851))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.Season5DeclareCityHistory)
end

function Season5DeclareCityMain:OnBtnWarTimeClicked()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString(390851))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.Season5DeclareWarTimeView, {anim = true})
end

function Season5DeclareCityMain:OnBtnRewardClicked()
  UIManager:GetInstance():OpenWindow(UIWindowNames.Season5DeclareCityDetail)
end

function Season5DeclareCityMain:OnRankClicked()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank)
end

function Season5DeclareCityMain:OnCityListClicked()
  SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
  UIManager:GetInstance():OpenWindow(UIWindowNames.Season5DeclareCityList)
end

function Season5DeclareCityMain:ComponentDestroy()
  self.p_text_act_title = nil
  self.p_text_act_time = nil
  self.p_text_act_desc = nil
  self.p_btn_info = nil
  self.p_btn_record = nil
  self.p_text_btn_record = nil
  self.p_btn_war_time = nil
  self.p_text_war_time = nil
  self.p_btn_reward = nil
  self.p_text_btn_reward = nil
  self.p_btn_rank = nil
  self.p_text_btn_rank = nil
  self.p_btn_city_list = nil
  self.p_text_btn_city_list = nil
  self.p_content_alliance = nil
  self.p_text_no_alliance = nil
  self.p_btn_join_alliance = nil
  self.p_text_btn_join_alliance = nil
  self.p_content_out_war_day = nil
  self.p_content_out_war_time = nil
  self.p_content_in_war_time = nil
end

function Season5DeclareCityMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  DataCenter.AllianceDeclareWarManager:SetWarCityParam(nil)
end

function Season5DeclareCityMain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareCityMain:OnEnable()
  base.OnEnable(self)
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo)
  end
end

function Season5DeclareCityMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceDataUpdated)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnCrossDeclareWarInfo)
  self:AddUIListener(EventId.SeasonAllianceWarTimeGetInfoUpdate, self.OnSeasonAllianceWarTimeGetInfoUpdate)
end

function Season5DeclareCityMain:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceDataUpdated)
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnCrossDeclareWarInfo)
  self:RemoveUIListener(EventId.SeasonAllianceWarTimeGetInfoUpdate, self.OnSeasonAllianceWarTimeGetInfoUpdate)
  base.OnRemoveListener(self)
end

function Season5DeclareCityMain:SetData(activityId)
  base.SetData(self, activityId)
  if self:InitData(activityId) then
    self:InitUi()
    self:ResetUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
  end
end

function Season5DeclareCityMain:InitData(data)
  if data ~= nil then
    self.ActId = data
    self.ActData = DataCenter.ActivityListDataManager:GetActivityDataById(self.ActId)
    local para4 = self.ActData.para4
    local startTime = self.ActData.startTime
    local endTime = self.ActData.endTime
    self.FightStartTime = startTime + toInt(para4) * OneHourTime * 1000
    self.FightEndTime = endTime
    self.activityData = self.ActData
    DataCenter.SeasonDataManager.CrossDeclareWarStartTime = self.FightStartTime
    return true
  end
  return false
end

function Season5DeclareCityMain:InitUi()
  if self.ActData ~= nil then
    self.p_text_act_title:SetLocalText(self.ActData.name)
  end
  self.p_text_act_desc:SetLocalText("season_s5_activity_1200063_desc04")
  self.p_text_btn_record:SetLocalText("season_s5_activity_1200059_desc04")
  self.p_text_war_time:SetLocalText("season_s5_activity_1200059_desc05")
  self.p_text_btn_reward:SetLocalText("season_s5_activity_1200059_desc03")
  self.p_text_btn_rank:SetLocalText("season_s5_activity_1200059_desc07")
  self.p_text_btn_city_list:SetLocalText("season_s5_activity_1200059_desc06")
end

function Season5DeclareCityMain:UpdateData()
  self.NextUpdateTime = UITimeManager:GetInstance():GetTomorrowZero()
  if not LuaEntry.Player:IsInAlliance() then
    return true
  end
  local weekPairs = DataCenter.UILWSeasonAllianceWarTimeManager:GetValidWeeks()
  local weekIndex = UITimeManager:GetInstance():GetNowWeekdayIndex()
  self.InWarDay = table.hasvalue(weekPairs, checkstring(weekIndex))
  if self.InWarDay then
    self.InWarTime = false
    local nextStartTime = 0
    local todayZero = UITimeManager:GetInstance():GetTodayZero()
    self.WarTimeData = DataCenter.UILWSeasonAllianceWarTimeManager:GetMyAllianceWarTimeData()
    if self.WarTimeData then
      local warTimeConfigs = DataCenter.UILWSeasonAllianceWarTimeManager:GetWarTimeConfigs()
      for _, warTimeConfig in pairs(warTimeConfigs) do
        nextStartTime = Mathf.Max(nextStartTime, todayZero + warTimeConfig.StartTime * 1000)
        if warTimeConfig:IsNowInRange() then
          self.InWarTime = self.InWarDay
          self.NextUpdateTime = todayZero + warTimeConfig.EndTime * 1000
          break
        end
      end
      if not self.InWarTime then
        local now = UITimeManager:GetInstance():GetServerTime()
        if nextStartTime > now then
          self.NextUpdateTime = Mathf.Min(self.NextUpdateTime, nextStartTime)
        end
      end
      return true
    else
      DataCenter.UILWSeasonAllianceWarTimeManager:SendGetInfo()
      return false
    end
  end
  return true
end

function Season5DeclareCityMain:ResetUi()
  self.p_content_alliance:SetActive(false)
  self.p_content_out_war_day:SetActive(false)
  self.p_content_out_war_time:SetActive(false)
  self.p_content_in_war_time:SetActive(false)
end

function Season5DeclareCityMain:UpdateUi()
  self:ResetUi()
  if not LuaEntry.Player:IsInAlliance() then
    self.p_content_alliance:SetActive(true)
    self.p_text_no_alliance:SetLocalText(390851)
    self.p_text_btn_join_alliance:SetLocalText(390079)
    return
  end
  if not self.InWarDay then
    self.p_content_out_war_day:SetActive(true)
    self.p_content_out_war_day:ReInit()
  elseif not self.InWarTime then
    self.p_content_out_war_time:SetActive(true)
    self.p_content_out_war_time:ReInit()
  else
    self.p_content_in_war_time:SetActive(true)
    self.p_content_in_war_time:ReInit()
  end
end

function Season5DeclareCityMain:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  local leftTime = math.max(0, checknumber(self.FightEndTime) - now)
  self.p_text_act_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  if now >= self.NextUpdateTime and self:UpdateData() then
    self:UpdateUi()
  end
end

function Season5DeclareCityMain:OnBtnClickJoin()
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
  end
end

function Season5DeclareCityMain:OnBtnClickGotoCity()
  if self.tab_item1:GetIsOn() then
    self.declareOther:OnBtnClickGotoCity()
  else
    self.declareByOther:OnBtnClickGotoCity()
  end
end

function Season5DeclareCityMain:OnBtnClickCityList()
  SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
  UIManager:GetInstance():OpenWindow(UIWindowNames.Season5DeclareCityList)
end

function Season5DeclareCityMain:OnBtnClickRecord()
  UIManager:GetInstance():OpenWindow(UIWindowNames.Season5DeclareCityHistory)
end

function Season5DeclareCityMain:OnBtnClickRank()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true}, {
    rank = 5,
    title = "season_trends_rank_name015",
    nameTxt = "390288",
    scoreTxt = "season_trends_rank_score_name005"
  })
end

function Season5DeclareCityMain:OnBtnClickGift()
  UIManager:GetInstance():OpenWindow(UIWindowNames.Season5DeclareCityDetail)
end

function Season5DeclareCityMain:OnBtnClickInfo()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local msg = Localization:GetString(self.activityData.story)
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end
end

function Season5DeclareCityMain:OnSeasonAllianceWarTimeGetInfoUpdate(evtData)
  if evtData.AllianceId == LuaEntry.Player.allianceId then
    self:ResetUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function Season5DeclareCityMain:OnAllianceDataUpdated()
  if LuaEntry.Player:IsInAlliance() and self.p_content_alliance:GetActive() then
    self:ResetUi()
    SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo)
  end
end

function Season5DeclareCityMain:OnCrossDeclareWarInfo()
  self:ResetUi()
  if self:UpdateData() then
    self:UpdateUi()
  end
end

return Season5DeclareCityMain
