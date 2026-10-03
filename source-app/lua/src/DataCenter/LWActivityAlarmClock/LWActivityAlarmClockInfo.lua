local LWActivityAlarmClockInfo = BaseClass("LWActivityAlarmClockInfo")
local Localization = CS.GameEntry.Localization

function LWActivityAlarmClockInfo:__init()
  self.id = 0
  self.status = 0
  self.startTime = 0
  self.endTime = 0
  self.param = 0
  self.showMainUITopStartTime = 0
  self.showMainUITopEndTime = 0
  self.markData = nil
  self.viewRank = 0
end

function LWActivityAlarmClockInfo:__delete()
  self.id = nil
  self.status = nil
  self.startTime = nil
  self.endTime = nil
  self.param = nil
  self.template = nil
  self.showMainUITopStartTime = nil
  self.showMainUITopEndTime = nil
  self.markData = nil
  self.viewRank = nil
end

function LWActivityAlarmClockInfo:InitData(message)
  if message.id then
    self.id = message.id
  end
  if message.status then
    self.status = message.status
  end
  if message.startTime then
    self.startTime = message.startTime
  end
  if message.endTime then
    self.endTime = message.endTime
  end
  if message.param then
    self.param = message.param
  end
  if message.positionId then
    self.positionId = message.positionId
  end
  if message.viewRank then
    self.viewRank = message.viewRank
  end
  if not self.template then
    self.template = DataCenter.LWActivityAlarmClockTemplateManager:GetTemplate(self.id)
  end
  if self.template then
    if self.template.top_timer ~= -1 then
      self.showMainUITopStartTime, self.showMainUITopEndTime = DataCenter.LWActivityAlarmClockManager:CalcShowMainUITopStartTimeAndEndTime(self.startTime, self.template)
    end
    self.param = DataCenter.LWActivityAlarmClockManager:SplitActivityAlarmClockParamData(self.template.type, self.param)
  end
end

function LWActivityAlarmClockInfo:GetActivityAlarmClockState()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.status == 0 then
    if curTime < self.startTime then
      return ActivityAlarmClockState.NoOpen
    elseif curTime >= self.startTime and curTime < self.endTime then
      return ActivityAlarmClockState.Doing
    elseif curTime >= self.endTime then
      return ActivityAlarmClockState.End
    end
  elseif self.status == 1 then
    if curTime < self.startTime then
      return ActivityAlarmClockState.NoOpen
    elseif curTime >= self.startTime then
      return ActivityAlarmClockState.End
    end
  end
  return ActivityAlarmClockState.End
end

function LWActivityAlarmClockInfo:GetName()
  if self.template then
    if self.template.type == ActivityAlarmClockType.AllianceMark then
      local allianceMarkData = DataCenter.WorldFavoDataManager:GetAllianceBookmarkByType(self.param, LuaEntry.Player:GetSourceServerId())
      if allianceMarkData and allianceMarkData.IsSelfAlliance and allianceMarkData:IsSelfAlliance() then
        self.markData = allianceMarkData
        return allianceMarkData.name
      end
    elseif self.template.type == ActivityAlarmClockType.KingdomPosition then
      local tGovernmentCfg = DataCenter.GovernmentTemplateManager:GetTemplate(self.positionId)
      local sName = Localization:GetString(tGovernmentCfg.name)
      return Localization:GetString(self.template.title, sName)
    else
      return Localization:GetString(self.template.title)
    end
  end
  return ""
end

function LWActivityAlarmClockInfo:GetIconPath()
  if self.template then
    if self.template.type == ActivityAlarmClockType.AllianceMark then
      local iconName = DataCenter.WorldFavoDataManager:GetBookMarkIconName(self.param)
      return string.format(LoadPath.AllianceMark, iconName)
    elseif self.template.type == ActivityAlarmClockType.KingdomPosition then
      local tGovernmentCfg = DataCenter.GovernmentTemplateManager:GetTemplate(self.positionId)
      return tGovernmentCfg.icon
    elseif self.template.type == ActivityAlarmClockType.AllyDrill or self.template.type == ActivityAlarmClockType.AllyDrillBooking then
      local bossType = DataCenter.AllyDrillDataManager:GetBossType()
      if bossType == AllyDrillBoss.HugeSandWorm then
        return string.format(LoadPath.ActivityIconPath, "lrb_shachongjunyan_yeqian")
      elseif bossType == AllyDrillBoss.RoadHog then
        return "Assets/Main/SeasonRes/Shared/Sprites/UI/MadCow/wxy_S5_tongmengjunyan_yeqian.png"
      else
        return self.template.icon
      end
    else
      return self.template.icon
    end
  end
  return ""
end

function LWActivityAlarmClockInfo:NeedShow()
  local needShow = true
  if self.template and self.template.type == ActivityAlarmClockType.AllyDrillBooking and not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    needShow = false
  end
  if self.viewRank and self.viewRank > 0 then
    local player_rank = DataCenter.AllianceBaseDataManager:GetSelfRank()
    if player_rank < self.viewRank then
      needShow = false
    end
  end
  return needShow
end

return LWActivityAlarmClockInfo
