local LWMainWinterStormNoticeItem = BaseClass("LWMainWinterStormNoticeItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local text_tip_path = "Bg/TipText"
local text_circle_time_path = "Bg/Circle_bg/CircleTimeText"
local bg2_path = "Bg2"
local text_m_path = "Bg2/MText"
local text_num_path = "Bg2/NumBg/NumText"

function LWMainWinterStormNoticeItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.text_tip = self:AddComponent(UIText, text_tip_path)
  self.text_circle_time = self:AddComponent(UIText, text_circle_time_path)
  self.bg2 = self:AddComponent(UIBaseContainer, bg2_path)
  self.text_m = self:AddComponent(UIText, text_m_path)
  self.text_m:SetLocalText("winter_battlefield_interface_tips1074")
  self.text_num = self:AddComponent(UIText, text_num_path)
  local max = LuaEntry.DataConfig:TryGetStr("winter_battlefield", "k23", "1")
  self.text_num:SetText(max)
  local mr = DataCenter.ActWinterStormManager:GetMarchResult()
  local startTime = 0
  local endTime = 0
  if mr ~= nil then
    startTime = mr.battleBeginTime
    endTime = mr.battleEndTime
  end
  self.startTime = startTime
  self.endTime = endTime
  self.alert_time = 10
end

function LWMainWinterStormNoticeItem:OnDestroy()
  self.bg = nil
  self.text_tip = nil
  self.text_circle_time = nil
  self.bg2 = nil
  self.text_m = nil
  self.text_num = nil
  self.startTime = 0
  self.endTime = 0
  base.OnDestroy(self)
end

function LWMainWinterStormNoticeItem:Update1000MS()
  if self.bg == nil then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if curSec < self.startTime - 5 then
    self.bg:SetActive(false)
    self.bg2:SetActive(true)
  elseif curSec < self.startTime then
    self.bg:SetActive(true)
    self.bg2:SetActive(false)
    self.text_tip:SetLocalText("winter_battlefield_interface_tips1022")
    self.text_circle_time:SetText(self.startTime - curSec .. "s")
  elseif curSec >= self.endTime - self.alert_time and curSec <= self.endTime then
    self.bg:SetActive(true)
    self.bg2:SetActive(false)
    self.text_tip:SetLocalText("winter_battlefield_interface_tips1023")
    self.text_circle_time:SetText(self.endTime - curSec .. "s")
  else
    self.bg:SetActive(false)
    self.bg2:SetActive(false)
  end
end

return LWMainWinterStormNoticeItem
