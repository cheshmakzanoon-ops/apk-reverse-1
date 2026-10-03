local p_comp_out_war_time_0_path = "content_out_war_time/img_circle/content_war_time/p_comp_out_war_time_0"
local p_comp_out_war_time_1_path = "content_out_war_time/img_circle/content_war_time/p_comp_out_war_time_1"
local p_comp_out_war_time_2_path = "content_out_war_time/img_circle/content_war_time/p_comp_out_war_time_2"
local p_go_out_war_time_arrow_path = "content_out_war_time/img_circle/p_go_out_war_time_arrow"
local p_text_out_war_time_desc_path = "p_text_out_war_time_desc"
local p_text_out_war_time_time_path = "p_text_out_war_time_time"
local Season5DeclareOutWarTimeSlot = require("UI/LWSeason5/DeclareCity/Comp/Season5DeclareOutWarTimeSlot")
local base = UIBaseContainer
local Season5DeclareOutWarTimeComp = BaseClass("Season5DeclareOutWarTimeComp", UIBaseContainer)

function Season5DeclareOutWarTimeComp:ComponentDefine()
  self.p_comp_out_war_time_0 = self:AddComponent(Season5DeclareOutWarTimeSlot, p_comp_out_war_time_0_path)
  self.p_comp_out_war_time_1 = self:AddComponent(Season5DeclareOutWarTimeSlot, p_comp_out_war_time_1_path)
  self.p_comp_out_war_time_2 = self:AddComponent(Season5DeclareOutWarTimeSlot, p_comp_out_war_time_2_path)
  self.p_go_out_war_time_arrow = self:AddComponent(UIBaseContainer, p_go_out_war_time_arrow_path)
  self.p_text_out_war_time_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_out_war_time_desc_path)
  self.p_text_out_war_time_time = self:AddComponent(UITextMeshProUGUIEx, p_text_out_war_time_time_path)
end

function Season5DeclareOutWarTimeComp:ComponentDestroy()
  self.p_comp_out_war_time_0 = nil
  self.p_comp_out_war_time_1 = nil
  self.p_comp_out_war_time_2 = nil
  self.p_go_out_war_time_arrow = nil
  self.p_text_out_war_time_desc = nil
  self.p_text_out_war_time_time = nil
end

function Season5DeclareOutWarTimeComp:DataDefine()
end

function Season5DeclareOutWarTimeComp:DataDestroy()
end

function Season5DeclareOutWarTimeComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Season5DeclareOutWarTimeComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareOutWarTimeComp:OnAddListener()
  base.OnAddListener(self)
end

function Season5DeclareOutWarTimeComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function Season5DeclareOutWarTimeComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function Season5DeclareOutWarTimeComp:InitData(data)
  self.WarTimeConfigs = DataCenter.UILWSeasonAllianceWarTimeManager:GetWarTimeConfigs()
  self.ZeroTime = UITimeManager:GetInstance():GetTodayZero()
  self.HintKey = "season_s5_activity_1200059_desc21"
  self.HintTime = UITimeManager:GetInstance():GetTomorrowZero()
  local now = UITimeManager:GetInstance():GetServerTime()
  local baseTime = UITimeManager:GetInstance():GetTodayZero()
  for _, warTimeConfig in pairs(self.WarTimeConfigs) do
    if now < baseTime + warTimeConfig.StartTimeMS then
      self.HintKey = "season_s5_activity_1200059_desc16"
      self.HintTime = math.min(self.HintTime, baseTime + warTimeConfig.StartTimeMS)
    end
  end
  return table.count(self.WarTimeConfigs) == 3
end

function Season5DeclareOutWarTimeComp:InitUi()
  local data1 = {}
  data1.WarTimeConfigData = self.WarTimeConfigs[0]
  self.p_comp_out_war_time_0:ReInit(data1)
  local data2 = {}
  data2.WarTimeConfigData = self.WarTimeConfigs[1]
  self.p_comp_out_war_time_1:ReInit(data2)
  local data3 = {}
  data3.WarTimeConfigData = self.WarTimeConfigs[2]
  self.p_comp_out_war_time_2:ReInit(data3)
  self.p_text_out_war_time_desc:SetLocalText(self.HintKey)
  self:Update1000MS()
end

function Season5DeclareOutWarTimeComp:UpdateData()
end

function Season5DeclareOutWarTimeComp:UpdateUi()
end

function Season5DeclareOutWarTimeComp:Update1000MS()
  if IsNotNull(self.p_go_out_war_time_arrow) then
    local past = UITimeManager:GetInstance():GetServerTime() - self.ZeroTime
    self.p_go_out_war_time_arrow:SetEulerAnglesXYZ(0, 0, -(past / (OneDayTime * 1000)) * 360)
  end
  local leftTime = math.max(0, checknumber(self.HintTime) - UITimeManager:GetInstance():GetServerTime())
  self.p_text_out_war_time_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
end

return Season5DeclareOutWarTimeComp
