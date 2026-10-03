local LWSeasonWeekInfo = BaseClass("LWSeasonWeekInfo", UIBaseContainer)
local base = UIBaseContainer
local WeekPos = {
  44,
  85,
  127,
  170,
  212,
  253,
  295,
  338,
  381,
  422,
  465,
  507,
  549,
  590,
  634,
  710
}

function LWSeasonWeekInfo:OnCreate()
  base.OnCreate(self)
  self.mask = self:AddComponent(UIBaseContainer, "bg/mask")
  for i = 1, 8 do
    self["w" .. i] = self:AddComponent(UIText, "txtAct/w" .. i)
  end
  local seasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local seasonWeek = 1
  local seasonWeekDot = 0
  if 0 < seasonStartTime and seasonStartTime < curTime then
    local elapsedTime = curTime - seasonStartTime
    if 0 <= elapsedTime then
      seasonWeek, seasonWeekDot = math.modf(elapsedTime / (7 * OneDayTime * 1000))
      seasonWeek = seasonWeek + 1
    end
  end
  seasonWeek = math.min(seasonWeek, 8)
  for week = 1, 8 do
    self["w" .. week]:SetActive(week <= seasonWeek)
  end
  local posStart = WeekPos[seasonWeek * 2 - 1]
  local posEnd = WeekPos[seasonWeek * 2]
  self.mask:SetSizeDeltaXY(posStart + (posEnd - posStart) * seasonWeekDot, 52)
end

function LWSeasonWeekInfo:OnDestroy()
  base.OnDestroy(self)
end

function LWSeasonWeekInfo:OnEnable()
  base.OnEnable(self)
end

function LWSeasonWeekInfo:OnDisable()
  base.OnDisable(self)
end

function LWSeasonWeekInfo:GetDayTrans(index)
  if self["w" .. index] then
    return self["w" .. index].transform
  end
  return nil
end

return LWSeasonWeekInfo
