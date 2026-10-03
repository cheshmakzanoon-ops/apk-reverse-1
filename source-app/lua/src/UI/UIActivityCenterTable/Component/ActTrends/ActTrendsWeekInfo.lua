local ActTrendsWeekInfo = BaseClass("ActTrendsWeekInfo", UIBaseContainer)
local base = UIBaseContainer
local WeekPos = {
  47,
  200,
  247,
  404,
  450,
  606,
  658,
  660
}
local weekNum = 4

function ActTrendsWeekInfo:OnCreate()
  base.OnCreate(self)
  self.mask = self:AddComponent(UIBaseContainer, "bg/mask")
  for i = 1, weekNum do
    self["w" .. i] = self:AddComponent(UIText, "txtAct/w" .. i)
  end
  local ActStartTime = DataCenter.ActTrendsDataManager:GetTrendsStartTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local ActWeek = 1
  local ActWeekDot = 0
  if 0 < ActStartTime and ActStartTime < curTime then
    local elapsedTime = curTime - ActStartTime
    if 0 <= elapsedTime then
      ActWeek, ActWeekDot = math.modf(elapsedTime / (7 * OneDayTime * 1000))
      ActWeek = ActWeek + 1
    end
  end
  ActWeek = math.min(ActWeek, weekNum)
  for week = 1, weekNum do
    self["w" .. week]:SetActive(week <= ActWeek)
  end
  local posStart = WeekPos[ActWeek * 2 - 1]
  local posEnd = WeekPos[ActWeek * 2]
  self.mask:SetSizeDeltaXY(posStart + (posEnd - posStart) * ActWeekDot, 52)
end

function ActTrendsWeekInfo:OnDestroy()
  base.OnDestroy(self)
end

function ActTrendsWeekInfo:OnEnable()
  base.OnEnable(self)
end

function ActTrendsWeekInfo:OnDisable()
  base.OnDisable(self)
end

function ActTrendsWeekInfo:GetDayTrans(index)
  if self["w" .. index] then
    return self["w" .. index].transform
  end
  return nil
end

return ActTrendsWeekInfo
