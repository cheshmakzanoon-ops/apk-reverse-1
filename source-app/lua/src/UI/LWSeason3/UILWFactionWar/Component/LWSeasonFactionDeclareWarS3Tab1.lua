local base = UIAsyncContainer
local LWSeasonFactionDeclareWarS3Tab1 = BaseClass("LWSeasonFactionDeclareWarS3Tab1", base)
local Localization = CS.GameEntry.Localization
local SeasonFactionWarTimeline = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarTimeline")
local title_path = "Bg/title"
local time_text_path = "Bg/TimeBg/TimeText"
local info_btn_path = "InfoBtn"
local content_path = "Content"
local rank_list_item1_path = "Content/RankListItem1"
local rank_list_item2_path = "Content/RankListItem2"
local rank_list_item3_path = "Content/RankListItem3"
local tab_item1_path = "Content/Tab/TabItem1"
local tab_item2_path = "Content/Tab/TabItem2"
local tab_item3_path = "Content/Tab/TabItem3"
local res_name_text_path = "Bg/Res/ResText"
local icon1_path = "Bg/icon1/icon1"
local icon2_path = "Bg/icon2/icon2"
local pos1_path = "Bg/icon1/pos1"
local pos2_path = "Bg/icon2/pos2"
local first_name_txt1_path = "Content/RankListItem1/Name/firstNameTxt1"
local server_txt1_path = "Content/RankListItem1/Name/serverTxt1"
local power_txt1_path = "Content/RankListItem1/powerTxt1"
local alliance_flag1_path = "Content/RankListItem1/allianceFlag1"
local button1_path = "Content/RankListItem1/Button1"
local first_name_txt2_path = "Content/RankListItem2/Name/firstNameTxt2"
local server_txt2_path = "Content/RankListItem2/Name/serverTxt2"
local power_txt2_path = "Content/RankListItem2/powerTxt2"
local alliance_flag2_path = "Content/RankListItem2/allianceFlag2"
local button2_path = "Content/RankListItem2/Button2"
local first_name_txt3_path = "Content/RankListItem3/Name/firstNameTxt3"
local server_txt3_path = "Content/RankListItem3/Name/serverTxt3"
local power_txt3_path = "Content/RankListItem3/powerTxt3"
local alliance_flag3_path = "Content/RankListItem3/allianceFlag3"
local button3_path = "Content/RankListItem3/Button3"
local group_title1_path = "Bg/icon1/GroupTitle1"
local group_title2_path = "Bg/icon2/GroupTitle2"
local act_title_path = "Bg/act_title"
local round_txt_path = "Bg/round_txt"
local bg_path = "Bg/bg"
local rank_icon_1_path = "Content/RankListItem1/rank_icon_1"
local rank_icon_2_path = "Content/RankListItem2/rank_icon_2"
local rank_icon_3_path = "Content/RankListItem3/rank_icon_3"
local explain_btn_path = "explainBtn"

function LWSeasonFactionDeclareWarS3Tab1:OnCreate()
  base.OnCreate(self)
  self.rectTransform:Set_offsetMin(7, 10)
  self.rectTransform:Set_offsetMax(-7, 0)
  self.explain_btn = self:AddComponent(UIButton, explain_btn_path)
  self.explain_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarRule, {anim = true}, "DeclareWarTime")
  end)
  self.stepEndTime = nil
  self.rank_data_1 = nil
  self.rank_data_2 = nil
  self.rank_data_3 = nil
  self.timeline = self:AddComponent(SeasonFactionWarTimeline, "TimeLine")
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.group_title1 = self:AddComponent(UITextMeshProUGUIEx, group_title1_path)
  self.group_title2 = self:AddComponent(UITextMeshProUGUIEx, group_title2_path)
  self.act_title = self:AddComponent(UITextMeshProUGUIEx, act_title_path)
  self.round_txt = self:AddComponent(UITextMeshProUGUIEx, round_txt_path)
  self.rankRoot = self:AddComponent(UIBaseContainer, content_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.pos1 = self:AddComponent(UITextMeshProUGUIEx, pos1_path)
  self.pos2 = self:AddComponent(UITextMeshProUGUIEx, pos2_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.rank_list_item1 = self:AddComponent(UIBaseContainer, rank_list_item1_path)
  self.rank_list_item2 = self:AddComponent(UIBaseContainer, rank_list_item2_path)
  self.rank_list_item3 = self:AddComponent(UIBaseContainer, rank_list_item3_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
  self.rank_icon_1 = self:AddComponent(UIImage, rank_icon_1_path)
  self.rank_icon_2 = self:AddComponent(UIImage, rank_icon_2_path)
  self.rank_icon_3 = self:AddComponent(UIImage, rank_icon_3_path)
  self.rank_icon_1:SetActive(false)
  self.rank_icon_2:SetActive(false)
  self.rank_icon_3:SetActive(false)
  self.res_name = self:AddComponent(UITextMeshProUGUIEx, res_name_text_path)
  self.info_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarRule, {anim = true}, "DeclareWar")
  end)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnRankChanged(6, true)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnRankChanged(7, true)
    end
  end)
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      self:OnRankChanged(8, true)
    end
  end)
  self.first_name_txt1 = self:AddComponent(UITextMeshProUGUIEx, first_name_txt1_path)
  self.server_txt1 = self:AddComponent(UITextMeshProUGUIEx, server_txt1_path)
  self.power_txt1 = self:AddComponent(UITextMeshProUGUIEx, power_txt1_path)
  self.alliance_flag1 = self:AddComponent(UIImage, alliance_flag1_path)
  self.button1 = self:AddComponent(UIButton, button1_path)
  self.first_name_txt2 = self:AddComponent(UITextMeshProUGUIEx, first_name_txt2_path)
  self.server_txt2 = self:AddComponent(UITextMeshProUGUIEx, server_txt2_path)
  self.power_txt2 = self:AddComponent(UITextMeshProUGUIEx, power_txt2_path)
  self.alliance_flag2 = self:AddComponent(UIImage, alliance_flag2_path)
  self.button2 = self:AddComponent(UIButton, button2_path)
  self.first_name_txt3 = self:AddComponent(UITextMeshProUGUIEx, first_name_txt3_path)
  self.server_txt3 = self:AddComponent(UITextMeshProUGUIEx, server_txt3_path)
  self.power_txt3 = self:AddComponent(UITextMeshProUGUIEx, power_txt3_path)
  self.alliance_flag3 = self:AddComponent(UIImage, alliance_flag3_path)
  self.button3 = self:AddComponent(UIButton, button3_path)
  self.button1:SetOnClick(function()
    if self.rank_data_1 then
      UIUtil.TryShowAllianceInfo(self.rank_data_1.serverId, self.rank_data_1.aid, self.rank_data_1.name)
    end
  end)
  self.button2:SetOnClick(function()
    if self.rank_data_2 then
      UIUtil.TryShowAllianceInfo(self.rank_data_2.serverId, self.rank_data_2.aid, self.rank_data_2.name)
    end
  end)
  self.button3:SetOnClick(function()
    if self.rank_data_3 then
      UIUtil.TryShowAllianceInfo(self.rank_data_3.serverId, self.rank_data_3.aid, self.rank_data_3.name)
    end
  end)
  self.pos1:SetLocalText("310164")
  self.pos2:SetLocalText("310164")
  self.time_text:SetText("00:00:00")
  self.title:SetLocalText("season_s3_trends_name19")
  self.pos1:SetActive(false)
  self.pos2:SetActive(false)
end

function LWSeasonFactionDeclareWarS3Tab1:OnDestroy()
  self.bg = nil
  self.score1 = nil
  self.status1 = nil
  self.score2 = nil
  self.status2 = nil
  self.title = nil
  self.time_text = nil
  self.info_btn = nil
  self.rank_list_item1 = nil
  self.rank_list_item2 = nil
  self.rank_list_item3 = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.tab_item3 = nil
  self.res_name = nil
  self.rank_icon_1 = nil
  self.rank_icon_2 = nil
  self.rank_icon_3 = nil
  base.OnDestroy(self)
end

function LWSeasonFactionDeclareWarS3Tab1:OnEnable()
  base.OnEnable(self)
end

function LWSeasonFactionDeclareWarS3Tab1:OnDisable()
  base.OnDisable(self)
end

function LWSeasonFactionDeclareWarS3Tab1:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionDeclareInfoUpdate, self.OnDeclareInfoUpdate)
  self:AddUIListener(EventId.SeasonRankUpdate, self.OnSeasonRankUpdate)
end

function LWSeasonFactionDeclareWarS3Tab1:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionDeclareInfoUpdate, self.OnDeclareInfoUpdate)
  self:RemoveUIListener(EventId.SeasonRankUpdate, self.OnSeasonRankUpdate)
  base.OnRemoveListener(self)
end

function LWSeasonFactionDeclareWarS3Tab1:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  self:OnDeclareInfoUpdate()
  if self.isEnd and self.currStep == SeasonFactionDeclareWarStep.battle_after then
    self.rankRoot:SetActive(true)
    self.timeline:SetActive(false)
    if self.rank_type == nil or self.rank_type == 0 then
      self.tab_item1:SetIsOn(true)
      self:OnRankChanged(6, true)
    else
      local rank_type = toInt(self.rank_type)
      if rank_type == 0 then
        self.tab_item1:SetIsOn(true)
        self:OnRankChanged(6, true)
      else
        self.rank_data_1 = DataCenter.SeasonDataManager:GetSeasonRankDataCacheByRank(rank_type, 1)
        if self.rank_data_1 == nil then
          SFSNetwork.SendMessage(MsgDefines.GetSeasonRankInfo, rank_type, 3)
        end
      end
    end
  else
    self.rank_type = nil
    self.rankRoot:SetActive(false)
    self.timeline:SetActive(true)
    self.timeline:UpdateData()
  end
end

function LWSeasonFactionDeclareWarS3Tab1:OnDeclareInfoUpdate()
  local mgr = DataCenter.SeasonFactionWarDataManager
  local actInfo = mgr:GetDeclareWarActInfo()
  if actInfo then
    local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    self.currStep = actInfo.currStep
    self.stepEndTime = actInfo.stepEndTime
    self.round = actInfo.round
    self.isEnd = actInfo.isEnd or self.round == 8
    if mgr:CampIsAttacker(1) then
      self.bg:SetFlipX(false)
      self.icon1:LoadSprite(mgr:GetCampIcon(2, true))
      self.icon2:LoadSprite(mgr:GetCampIcon(1, true))
      self.group_title1:SetText(mgr:GetCampName(2))
      self.group_title2:SetText(mgr:GetCampName(1))
      self.pos1:SetActive(myCampId == 2)
      self.pos2:SetActive(myCampId == 1)
    else
      self.bg:SetFlipX(true)
      self.icon1:LoadSprite(mgr:GetCampIcon(1, true))
      self.icon2:LoadSprite(mgr:GetCampIcon(2, true))
      self.group_title1:SetText(mgr:GetCampName(1))
      self.group_title2:SetText(mgr:GetCampName(2))
      self.pos1:SetActive(myCampId == 1)
      self.pos2:SetActive(myCampId == 2)
    end
    local round = Localization:GetString("312094", actInfo.round or 1)
    local title = Localization:GetString(mgr.StepText[self.currStep + 1] or "season_s2_faction_war_01")
    self.title:SetText(title)
    self.act_title:SetText(Localization:GetString("season_s2_faction_war_01"))
    self.round_txt:SetText(string.format("<size=50>%s</size>", round))
    self:Update1000MS()
  end
end

function LWSeasonFactionDeclareWarS3Tab1:OnSeasonRankUpdate()
  if self.rank_type then
    self:OnRankChanged(self.rank_type, false)
  end
end

function LWSeasonFactionDeclareWarS3Tab1:OnRankChanged(rank_type, needRefresh)
  if needRefresh then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonRankInfo, rank_type, 3)
  end
  self.rank_type = rank_type
  self.rank_data_1 = DataCenter.SeasonDataManager:GetSeasonRankDataCacheByRank(rank_type, 1)
  self.rank_data_2 = DataCenter.SeasonDataManager:GetSeasonRankDataCacheByRank(rank_type, 2)
  self.rank_data_3 = DataCenter.SeasonDataManager:GetSeasonRankDataCacheByRank(rank_type, 3)
  for rank = 1, 3 do
    local data = self["rank_data_" .. rank] or {}
    local icon = self["rank_icon_" .. rank]
    if icon then
      local compId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(data.serverId)
      if compId == 1 or compId == 2 then
        icon:SetActive(true)
        icon:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(compId))
      else
        icon:SetActive(false)
      end
    end
    if data and (data.rank == 1 or data.rank == 2 or data.rank == 3) then
      self["first_name_txt" .. rank]:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
      self["server_txt" .. rank]:SetText("#" .. data.serverId)
      self["power_txt" .. rank]:SetText(string.GetFormattedSeparatorNum(toInt(data.score)))
      self["alliance_flag" .. rank]:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(data.icon)))
    else
      self["first_name_txt" .. rank]:SetText("-")
      self["server_txt" .. rank]:SetText("-")
      self["power_txt" .. rank]:SetText("-")
      self["alliance_flag" .. rank]:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, "0"))
    end
  end
end

function LWSeasonFactionDeclareWarS3Tab1:Update1000MS()
  if self.stepEndTime then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    deltaTime = self.stepEndTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.time_text:SetText(showTime)
    else
      self.time_text:SetText("")
      if self.currStep == SeasonFactionDeclareWarStep.battle then
        self.title:SetLocalText("season_s2_faction_war_12")
      end
      if self.lastRequest == nil or curTime - self.lastRequest > 3456 then
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarInfo)
        self.lastRequest = curTime
      end
    end
  end
end

return LWSeasonFactionDeclareWarS3Tab1
