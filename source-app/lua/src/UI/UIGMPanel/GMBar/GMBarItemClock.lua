local base = UIAsyncContainer
local socket = require("socket")
local GMBarItemClock = BaseClass("GMBarItemClock", base)
local Localization = CS.GameEntry.Localization

function GMBarItemClock:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GMBarItemClock:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GMBarItemClock:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnAddDay = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnAddDay:SetOnClick(function()
    self:OnBtnAddDayClick()
  end)
  self.btnAddHour = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnAddHour:SetOnClick(function()
    self:OnBtnAddHourClick()
  end)
  self.btnAddMin = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnAddMin:SetOnClick(function()
    self:OnBtnAddMinClick()
  end)
  self.btnRdcDay = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnRdcDay:SetOnClick(function()
    self:OnBtnRdcDayClick()
  end)
  self.btnRdcHour = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnRdcHour:SetOnClick(function()
    self:OnBtnRdcHourClick()
  end)
  self.btnRdcMin = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnRdcMin:SetOnClick(function()
    self:OnBtnRdcMinClick()
  end)
  self.btnChangeTimeRange = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnChangeTimeRange:SetOnClick(function()
    self:OnBtnChangeTimeRangeClick()
  end)
  self.textTmpTimeRangeType = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textTmpTimeReal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textTmpTimeChanged = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnReset = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnReset:SetOnClick(function()
    self:OnBtnResetClick()
  end)
  self.btnAdd10Min = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnAdd10Min:SetOnClick(function()
    self:OnBtnAdd10MinClick()
  end)
  self.btnRdc10Min = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnRdc10Min:SetOnClick(function()
    self:OnBtnRdc10MinClick()
  end)
end

function GMBarItemClock:ComponentDestroy()
  self.viewSkin = nil
  self.btnAddDay = nil
  self.btnAddHour = nil
  self.btnAddMin = nil
  self.btnRdcDay = nil
  self.btnRdcHour = nil
  self.btnRdcMin = nil
  self.btnChangeTimeRange = nil
  self.textTmpTimeRangeType = nil
  self.textTmpTimeReal = nil
  self.textTmpTimeChanged = nil
  self.btnReset = nil
  self.btnAdd10Min = nil
  self.btnRdc10Min = nil
end

function GMBarItemClock:DataDefine()
  self.isLocalMode = true
end

function GMBarItemClock:DataDestroy()
end

function GMBarItemClock:OnAddListener()
  base.OnAddListener(self)
end

function GMBarItemClock:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GMBarItemClock:Update1000MS()
  self:RefreshDisplay()
end

function GMBarItemClock:RefreshDisplay()
  local timeMgr = UITimeManager:GetInstance()
  local realSec = 0
  local changedSec = 0
  local offset = timeMgr:GetDebugOffsetSec()
  local offsetStr = self:FormatOffset(offset)
  if self.isLocalMode then
    realSec = math.modf(socket.gettime())
    changedSec = realSec + offset
    self.textTmpTimeRangeType:SetText("\230\156\172\229\156\176" .. offsetStr)
  else
    realSec = math.modf((timeMgr:GetServerTime() - offset * 1000) / 1000)
    changedSec = timeMgr:GetServerSeconds()
    self.textTmpTimeRangeType:SetText("\230\156\141\229\138\161\229\153\168" .. offsetStr)
  end
  local format = "%Y-%m-%d %H:%M:%S"
  if self.isLocalMode then
    self.textTmpTimeReal:SetText(os.date(format, realSec))
    self.textTmpTimeChanged:SetText(os.date(format, changedSec))
  else
    local serverFormat = "!" .. format
    local serverOffset = timeMgr:GetTimezoneOffset() / 1000
    self.textTmpTimeReal:SetText(os.date(serverFormat, realSec + serverOffset))
    self.textTmpTimeChanged:SetText(os.date(serverFormat, changedSec + serverOffset))
  end
end

function GMBarItemClock:FormatOffset(offsetSec)
  if offsetSec == 0 then
    return ""
  end
  local absOffset = math.abs(offsetSec)
  local sign = 0 < offsetSec and "+" or "-"
  local d = absOffset // 86400
  local h = absOffset % 86400 // 3600
  local m = absOffset % 3600 // 60
  local parts = {}
  if 0 < d then
    table.insert(parts, sign .. d .. "D")
  end
  if 0 < h then
    table.insert(parts, sign .. h .. "H")
  end
  if 0 < m then
    table.insert(parts, sign .. m .. "M")
  end
  if #parts == 0 then
    return ""
  end
  return "(" .. table.concat(parts, " ") .. ")"
end

function GMBarItemClock:OnBtnResetClick()
  if not GMUtils.IsGM() then
    return
  end
  UITimeManager:GetInstance():SetDebugOffsetSec(0, false)
  self:RefreshDisplay()
end

function GMBarItemClock:OnBtnAddDayClick()
  if not GMUtils.IsGM() then
    return
  end
  UITimeManager:GetInstance():SetDebugOffsetSec(86400, true)
  self:RefreshDisplay()
end

function GMBarItemClock:OnBtnAddHourClick()
  if not GMUtils.IsGM() then
    return
  end
  UITimeManager:GetInstance():SetDebugOffsetSec(3600, true)
  self:RefreshDisplay()
end

function GMBarItemClock:OnBtnAddMinClick()
  if not GMUtils.IsGM() then
    return
  end
  UITimeManager:GetInstance():SetDebugOffsetSec(60, true)
  self:RefreshDisplay()
end

function GMBarItemClock:OnBtnRdcDayClick()
  if not GMUtils.IsGM() then
    return
  end
  UITimeManager:GetInstance():SetDebugOffsetSec(-86400, true)
  self:RefreshDisplay()
end

function GMBarItemClock:OnBtnRdcHourClick()
  if not GMUtils.IsGM() then
    return
  end
  UITimeManager:GetInstance():SetDebugOffsetSec(-3600, true)
  self:RefreshDisplay()
end

function GMBarItemClock:OnBtnRdcMinClick()
  if not GMUtils.IsGM() then
    return
  end
  UITimeManager:GetInstance():SetDebugOffsetSec(-60, true)
  self:RefreshDisplay()
end

function GMBarItemClock:OnBtnAdd10MinClick()
  if not GMUtils.IsGM() then
    return
  end
  UITimeManager:GetInstance():SetDebugOffsetSec(600, true)
  self:RefreshDisplay()
end

function GMBarItemClock:OnBtnRdc10MinClick()
  if not GMUtils.IsGM() then
    return
  end
  UITimeManager:GetInstance():SetDebugOffsetSec(-600, true)
  self:RefreshDisplay()
end

function GMBarItemClock:OnBtnChangeTimeRangeClick()
  self.isLocalMode = not self.isLocalMode
  self:RefreshDisplay()
end

return GMBarItemClock
