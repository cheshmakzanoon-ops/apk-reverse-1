local SeasonCampDestroyWarTimeData = BaseClass("SeasonCampDestroyWarTimeData")

function SeasonCampDestroyWarTimeData:__init()
  self.SetTime = 0
  self.TimeIndex = -1
  self.AllianceId = ""
  self.Logs = {}
end

function SeasonCampDestroyWarTimeData:__delete()
  self.Logs = nil
end

function SeasonCampDestroyWarTimeData:SetData(res)
  if res == nil then
    return
  end
  self.SetTime = checknumber(res.settime)
  self.TimeIndex = checknumber(res.wartimeindex)
  self.AllianceId = res.aid
  self.Logs = res.sethistory
end

function SeasonCampDestroyWarTimeData:Description()
  local timeStr = ""
  if self.SetTime and self.SetTime > 0 then
    timeStr = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.SetTime * 1000)
  end
  return string.format("Aid:%s Index:%s SetTime:%s (%s) Logs:%s", self.AllianceId, self.TimeIndex, self.SetTime, timeStr, table.count(self.Logs or {}))
end

return SeasonCampDestroyWarTimeData
