local SeasonCampDestroyTimeInfo = BaseClass("SeasonCampDestroyTimeInfo")

function SeasonCampDestroyTimeInfo:__init(mgr)
  self.currentBattleStage = SeasonCampDestroyStage.None
  self.warTimes = nil
  self.warStart = 0
  self.warEnd = 0
  self.rangeIndex = 0
  self.rangeStart = 0
  self.rangeEnd = 0
  self.warTimeMgr = DataCenter.SeasonCampDestroyManager
  self.timeMgr = UITimeManager:GetInstance()
end

function SeasonCampDestroyTimeInfo:__delete()
  self.warTimes = nil
  self.timeMgr = nil
  self.warTimeMgr = nil
end

function SeasonCampDestroyTimeInfo:Refresh()
  if not self.warTimes then
    self.warTimes = self.warTimeMgr:GetWarTimeConfigs()
  end
  self.currentBattleStage = SeasonCampDestroyStage.None
  local isDeclareDay = self.warTimeMgr:IsDeclareDay()
  if isDeclareDay then
    self.warStart = self.timeMgr:GetTodayZero()
  else
    self.warStart = self.warTimeMgr:GetNextDeclareTime()
  end
  local duration = 86400000
  self.warEnd = self.warStart + duration
  self.rangeIndex = 0
  self.rangeStart = 0
  self.rangeEnd = 0
  local now = self.timeMgr:GetServerTime()
  if isDeclareDay then
    self.currentBattleStage = SeasonCampDestroyStage.Wait
    local elapsedMs = now - self.warStart
    local min = 1
    local max = 3
    for i = min, max do
      local data = self.warTimes[i - 1]
      if data then
        self.rangeStart = data.StartTimeMS or 0
        self.rangeEnd = data.EndTimeMS or 0
        if elapsedMs >= self.rangeStart then
          self.rangeIndex = i
          if elapsedMs <= self.rangeEnd then
            self.currentBattleStage = SeasonCampDestroyStage.Fight
            break
          elseif i == max then
            self.rangeIndex = 4
          end
        else
          break
        end
      end
    end
  else
    self.currentBattleStage = SeasonCampDestroyStage.Idle
  end
end

function SeasonCampDestroyTimeInfo:Description()
  local timeMgr = self.timeMgr or UITimeManager:GetInstance()
  return string.format("Stage:%s RangeIndex:%s WarStart:%s WarEnd:%s", self.currentBattleStage, self.rangeIndex, timeMgr:TimeStampToTimeForLocal(self.warStart or 0), timeMgr:TimeStampToTimeForLocal(self.warEnd or 0))
end

return SeasonCampDestroyTimeInfo
