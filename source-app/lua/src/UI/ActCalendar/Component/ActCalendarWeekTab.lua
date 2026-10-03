local ActCalendarWeekTab = BaseClass("ActCalendarWeekTab", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function ActCalendarWeekTab:OnCreate()
  base.OnCreate(self)
  self.name = self:AddComponent(UITextMeshProUGUIEx, "weekName")
  self.date = self:AddComponent(UITextMeshProUGUIEx, "weekDate")
end

function ActCalendarWeekTab:OnDestroy()
  base.OnDestroy(self)
end

function ActCalendarWeekTab:OnEnable()
  base.OnEnable(self)
end

function ActCalendarWeekTab:OnDisable()
  base.OnDisable(self)
end

function ActCalendarWeekTab:ReInit(name, date)
  self.name:SetLocalText(name)
  local year, month, day = UITimeManager:GetInstance():TimeStampToServerTime(date)
  self.date:SetText(string.format("%02d/%02d", month, day))
end

return ActCalendarWeekTab
