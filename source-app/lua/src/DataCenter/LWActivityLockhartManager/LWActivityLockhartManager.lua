local LWActivityLockhartManager = BaseClass("LWActivityLockhartManager")

function LWActivityLockhartManager:__init()
  self.recordActivityPlot = {}
  self.monsterSpecialId2Plot = {}
  self.maxLockHartUnlockLevel = 0
  self.lockHartHasFirstKillLevel = 0
end

function LWActivityLockhartManager:__delete()
  self.recordActivityPlot = nil
  self.monsterSpecialId2Plot = nil
  self.maxLockHartUnlockLevel = nil
  self.lockHartHasFirstKillLevel = nil
end

function LWActivityLockhartManager:GetPlotBySpecialId(specialId)
  if table.IsNullOrEmpty(self.monsterSpecialId2Plot) then
    local str = LuaEntry.DataConfig:TryGetStr("specialmonster_plot", "k1")
    if not string.IsNullOrEmpty(str) then
      local strArr = string.split(str, "|")
      if not table.IsNullOrEmpty(strArr) then
        for i = 1, #strArr do
          local value = string.split(strArr[i], ";")
          if table.length(value) == 2 then
            local id = tonumber(value[1])
            local plot = tonumber(value[2])
            if self.monsterSpecialId2Plot[id] == nil then
              self.monsterSpecialId2Plot[id] = plot
            end
          end
        end
      end
    end
  end
  if self.monsterSpecialId2Plot[specialId] then
    return self.monsterSpecialId2Plot[specialId]
  end
  return 0
end

function LWActivityLockhartManager:IsRecordPlot(specialId)
  self.recordActivityPlot = CommonUtil.PlayerPrefsGetTable(SettingKeys.SpecialMonsterPlot, {})
  for i = 1, #self.recordActivityPlot do
    if self.recordActivityPlot[i] == specialId then
      return true
    end
  end
  return false
end

function LWActivityLockhartManager:SaveRecordPlot(specialId)
  table.insert(self.recordActivityPlot, specialId)
  CommonUtil.PlayerPrefsSetTable(SettingKeys.SpecialMonsterPlot, self.recordActivityPlot)
end

function LWActivityLockhartManager:TryOpenMonsterSpecialIdPlot(specialId)
  local plot = self:GetPlotBySpecialId(specialId)
  if plot ~= 0 and not self:IsRecordPlot(specialId) then
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plot, hideMainUI = true})
    self:SaveRecordPlot(specialId)
  end
end

function LWActivityLockhartManager:IsShowLockHartMain()
  if not LuaEntry.Player:IsInAlliance() then
    return false
  end
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.LockhartActivity.Type)
  if activityData == nil then
    return false
  end
  if not self:IsShowLockHartEntry() then
    return false
  end
  return true
end

function LWActivityLockhartManager:IsShowLockHartEntry()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local showEntryTime = CommonUtil.PlayerPrefsGetLong("LockhartActivity_ShowEntryTime", 0)
  if curTime > showEntryTime or showEntryTime == 0 then
    CommonUtil.PlayerPrefsSetBool("LockhartActivity_ShowEntry", true)
    return true
  end
  return CommonUtil.PlayerPrefsGetBool("LockhartActivity_ShowEntry", true)
end

function LWActivityLockhartManager:SetMaxLockHartUnlockLevel(level, hasFirstKill)
  if not level or level <= 0 then
    return
  end
  self.maxLockHartUnlockLevel = level
  if hasFirstKill then
    self.lockHartHasFirstKillLevel = level
  end
end

function LWActivityLockhartManager:GetMaxLockHartUnlockLevel()
  return self.maxLockHartUnlockLevel
end

function LWActivityLockhartManager:IsLockHartFirstKill(level)
  if not level or level <= 0 then
    return false
  end
  if 0 >= self.maxLockHartUnlockLevel then
    return false
  end
  if level < self.maxLockHartUnlockLevel then
    return false
  end
  if level == self.lockHartHasFirstKillLevel then
    return true
  else
    return false
  end
end

function LWActivityLockhartManager:IsLockHartBoss(specialId)
  if not specialId then
    return false
  end
  if specialId == WorldMonsterSpecialType.LockHartOldS0 or specialId == WorldMonsterSpecialType.LockHartNewS0 or specialId == WorldMonsterSpecialType.LockHartS1 or specialId == WorldMonsterSpecialType.LockHartS2 or specialId == WorldMonsterSpecialType.LockHartS3 or specialId == WorldMonsterSpecialType.LockHartS4 or specialId == WorldMonsterSpecialType.LockHartS5 or specialId == WorldMonsterSpecialType.LockHartS6 then
    return true
  end
  return false
end

return LWActivityLockhartManager
