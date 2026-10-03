local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_SeasonTrendsShare = BaseClass("SeasonTrendsShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local _cp_ShareTitle = "ShareTitle"
local _cp_shareMsg = "ShareIconNode/ShareMsg/ShareMsg"
local _cp_shareNode = ""
local _cp_prog = "ShareIconNode/Progress"
local _cp_progTxt = "ShareIconNode/Progress/Txt_Progress"
local start_time_path = "ShareIconNode/startTime"

function ChatItemPost_SeasonTrendsShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_SeasonTrendsShare:ComponentDefine()
  self._shareTitle = self:AddComponent(UIText, _cp_ShareTitle)
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self._shareProg = self:AddComponent(UISlider, _cp_prog)
  self._shareProgTxt = self:AddComponent(UIText, _cp_progTxt)
  self.countDownTxt = self:AddComponent(UIText, start_time_path)
  self._shareMsg:SetLocalText(310000)
end

function ChatItemPost_SeasonTrendsShare:OnClickBg()
  local trendConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, self.attachInfo.config_id)
  if trendConfig and trendConfig.off_seaon and trendConfig.off_seaon == "1" then
    DataCenter.ActTrendsDataManager:Jump(self.attachInfo)
  else
    DataCenter.LWSeasonTrendsManager:Jump(self.attachInfo)
  end
end

function ChatItemPost_SeasonTrendsShare:OnLoaded()
  local chatData = self:ChatData()
  if not chatData then
    self:FallBack()
    return
  end
  local senderUid = chatData.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout and _userInfo then
    self._chatNameLayout:UpdateName(_userInfo, chatData)
  end
  local attachInfo = chatData:getMessageParam(false)
  if not attachInfo or not attachInfo.config_id then
    self:FallBack()
    return
  end
  self.attachInfo = attachInfo
  local trendConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, attachInfo.config_id)
  local trendData
  if trendConfig and trendConfig.off_seaon and trendConfig.off_seaon == "1" then
    trendData = DataCenter.ActTrendsDataManager:GetTrendsConfigData(attachInfo.groupIndex, attachInfo.config_id)
  else
    trendData = DataCenter.LWSeasonTrendsManager:GetTrendsConfigData(attachInfo.groupIndex, attachInfo.config_id)
  end
  if trendConfig == nil or trendData == nil then
    self:FallBack()
    return
  end
  self._shareTitle:SetLocalText(trendConfig.stage_name)
  self.targetCount = trendConfig.para2
  self._shareProg:SetValue(attachInfo.cur_count / self.targetCount)
  self._shareProgTxt:SetText(string.format("%s/%s", attachInfo.cur_count, self.targetCount))
  self:RefreshState()
end

function ChatItemPost_SeasonTrendsShare:OnRecycle()
  self:DelTimer()
end

function ChatItemPost_SeasonTrendsShare:RefreshState()
  local state = DataCenter.LWSeasonTrendsManager:GetTrendsState(self.attachInfo)
  if not state or state == SeasonTrendState.Expire then
    self.countDownTxt:SetLocalText("season_trend_event_over")
    self:DelTimer()
    return
  end
  if state == SeasonTrendState.NotOpen then
    self.countDownTxt:SetLocalText("season_trend_event_coming")
    self:DelTimer()
    return
  end
  if self.attachInfo.end_time and self.attachInfo.end_time > UITimeManager:GetInstance():GetServerTime() then
    self.endTime = self.attachInfo.end_time
    self:SetRemainTime()
    self:AddTimer()
  else
    self.countDownTxt:SetLocalText("390980")
    self:DelTimer()
  end
end

function ChatItemPost_SeasonTrendsShare:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.SetRemainTime, self, false, false, false)
  end
  self.timer:Start()
end

function ChatItemPost_SeasonTrendsShare:SetRemainTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime - curTime
  if 0 < remainTime then
    self.countDownTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:DelTimer()
    self.countDownTxt:SetLocalText("390980")
  end
end

function ChatItemPost_SeasonTrendsShare:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatItemPost_SeasonTrendsShare:FallBack()
  self.countDownTxt:SetLocalText("season_trend_event_over")
  self._shareTitle:SetLocalText("")
  self._shareProg:SetValue(0)
  self._shareProgTxt:SetText("")
  self:DelTimer()
end

return ChatItemPost_SeasonTrendsShare
