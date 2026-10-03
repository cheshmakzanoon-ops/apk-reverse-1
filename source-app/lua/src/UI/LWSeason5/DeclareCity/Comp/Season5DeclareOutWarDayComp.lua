local p_text_out_war_day_desc_path = "shield/p_text_out_war_day_desc"
local p_text_out_war_day_time_path = "shield/p_text_out_war_day_time"
local base = UIBaseContainer
local Season5DeclareOutWarDayComp = BaseClass("Season5DeclareOutWarDayComp", UIBaseContainer)

function Season5DeclareOutWarDayComp:ComponentDefine()
  self.p_text_out_war_day_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_out_war_day_desc_path)
  self.p_text_out_war_day_time = self:AddComponent(UITextMeshProUGUIEx, p_text_out_war_day_time_path)
end

function Season5DeclareOutWarDayComp:ComponentDestroy()
  self.p_text_out_war_day_desc = nil
  self.p_text_out_war_day_time = nil
end

function Season5DeclareOutWarDayComp:DataDefine()
end

function Season5DeclareOutWarDayComp:DataDestroy()
end

function Season5DeclareOutWarDayComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Season5DeclareOutWarDayComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareOutWarDayComp:OnAddListener()
  base.OnAddListener(self)
end

function Season5DeclareOutWarDayComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function Season5DeclareOutWarDayComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    self:Update1000MS()
  end
end

function Season5DeclareOutWarDayComp:InitData(data)
  self.NextWarTime = self:GetNextWarTime(0)
  return true
end

function Season5DeclareOutWarDayComp:InitUi()
  self.p_text_out_war_day_desc:SetLocalText("season_s5_activity_1200059_desc02")
end

function Season5DeclareOutWarDayComp:Update1000MS()
  local leftTime = math.max(0, checknumber(self.NextWarTime) - UITimeManager:GetInstance():GetServerTime())
  self.p_text_out_war_day_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
end

function Season5DeclareOutWarDayComp:GetNextWarTime(week)
  local now = UITimeManager:GetInstance():GetServerTime()
  local thisWeekZero = UITimeManager:GetInstance():WeekZero()
  local baseTime = thisWeekZero + week * OneWeekTime * 1000
  local weekPairs = DataCenter.UILWSeasonAllianceWarTimeManager:GetValidWeeks()
  for _, weekIndex in pairs(weekPairs) do
    local startTime = baseTime + (checknumber(weekIndex) - 1) * OneDayTime * 1000
    if now <= startTime then
      return startTime
    end
  end
  return self:GetNextWarTime(week + 1)
end

return Season5DeclareOutWarDayComp
