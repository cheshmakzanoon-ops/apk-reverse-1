local BloodyNightData = BaseClass("BloodyNightData")

function BloodyNightData:__init(serverId)
  self.serverIds = {}
  self.serverIds[1] = serverId
  self.state = BloodyNightState.None
  self.fetchReady = 0
  self.FETCH_CD = 1
  self:FetchActivityData()
end

function BloodyNightData:__delete()
  self:Destroy()
end

function BloodyNightData:Destroy()
  self:RemoveUpdateTimer()
  self.state = BloodyNightState.None
  self.bnTemplate = nil
  self.startTime = nil
  self.endTime = nil
  self.nightStalker = nil
  self.stageTemplateList = nil
  self.curStageTemplate = nil
  self.serverIds = nil
  self.serverDataEndTime = nil
  self.serverData = nil
end

function BloodyNightData:AddUpdateTimer()
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function BloodyNightData:RemoveUpdateTimer()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function BloodyNightData:OnUpdateSec()
  if self.endTime or self.serverDataEndTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.serverDataEndTime and now > self.serverDataEndTime + 1000 then
      self:FetchActivityData()
    elseif self.endTime and now > self.endTime then
      self:ParseServerData(false)
    elseif self.state == BloodyNightState.Bloody and now > self.endTime - 10000 and now < self.endTime - 9000 then
      local selfServerId = LuaEntry.Player:GetSelfServerId()
      for _, v in pairs(self.serverIds) do
        if v == selfServerId then
          UIUtil.ShowCountdownTimeUI(self.endTime)
        end
      end
    elseif self.state == BloodyNightState.Silent and now > self.endTime - 21000 and now < self.endTime - 20000 then
      local selfServerId = LuaEntry.Player:GetSelfServerId()
      for _, v in pairs(self.serverIds) do
        if v == selfServerId then
          local startTime = 21000 - (self.endTime - now)
          DataCenter.LWSoundManager:PlayBloodyNightTransitionBGM(startTime)
        end
      end
    end
  end
end

function BloodyNightData:AddServer(serverId)
  for _, v in pairs(self.serverIds) do
    if v == serverId then
      return
    end
  end
  table.insert(self.serverIds, serverId)
end

function BloodyNightData:FetchActivityData(force)
  if BattleFieldUtil.InBattleField() and LuaEntry.Player:GetCurServerId() == self.serverIds[1] then
    return
  end
  if not force and UITimeManager:GetInstance():GetServerSeconds() < self.fetchReady then
    return
  end
  self.fetchReady = UITimeManager:GetInstance():GetServerSeconds() + self.FETCH_CD
  SFSNetwork.SendMessage(MsgDefines.ViewBloodNightAct, self.serverIds[1])
end

function BloodyNightData:FindCurBloodyNightState(bloodNightDayActArr, now)
  if not bloodNightDayActArr then
    return false
  end
  for _, v in ipairs(bloodNightDayActArr) do
    for _, night in ipairs(v.bloodNightArr) do
      if now > night.createTime and now < night.startOpenTime then
        self.state = BloodyNightState.Silent
        self.startTime = night.createTime
        self.endTime = night.startOpenTime
        self.bnTemplate = DataCenter.BloodyNightDataManager:GetTemplate(night.configId)
        return true
      elseif now > night.startOpenTime and now < night.settleTime then
        self.state = BloodyNightState.Bloody
        self.startTime = night.startOpenTime
        self.endTime = night.settleTime
        self.bnTemplate = DataCenter.BloodyNightDataManager:GetTemplate(night.configId)
        return true
      end
    end
  end
end

local function LogServerData(msg, isError)
  if not isError and not CS.CommonUtils.IsDebug() then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local todayZero = UITimeManager:GetInstance():GetTodayZero()
  local time = UITimeManager:GetInstance()
  local sb = StringBuilder.New()
  if isError then
    sb:AppendLine("BloodyNightDataManagerError:")
  else
    sb:AppendLine("BloodyNightDataManagerLog:")
  end
  if msg then
    sb:AppendLine("now:" .. time:TimeStampToTimeForServer(now) .. "todayZero:" .. time:TimeStampToTimeForServer(todayZero) .. (msg.isCloseBloodNight and "isCloseBloodNight" or ""))
    if msg.bloodNightDayActArr then
      for i, v in ipairs(msg.bloodNightDayActArr) do
        sb:AppendLine("\231\172\172" .. i .. "\229\164\169dayTime=" .. time:TimeStampToTimeForServer(v.dayTime))
        for j, night in ipairs(v.bloodNightArr) do
          sb:AppendLine("\231\172\172" .. j .. "\229\156\186\239\188\154" .. time:TimeStampToTimeForServer(night.createTime) .. "~" .. time:TimeStampToTimeForServer(night.startOpenTime) .. "~" .. time:TimeStampToTimeForServer(night.endTime))
        end
      end
    end
    if msg.extraNight then
      sb:AppendLine("\229\164\156\233\173\148\229\188\128\229\164\167\239\188\154" .. time:TimeStampToTimeForServer(msg.extraNight.startOpenTime) .. "~" .. time:TimeStampToTimeForServer(msg.extraNight.endTime))
    end
  else
    sb:AppendLine("now:" .. time:TimeStampToTimeForServer(now) .. "todayZero:" .. time:TimeStampToTimeForServer(todayZero))
  end
  if isError then
    Logger.LogError(sb:ToString())
  else
    Logger.LogCustom(sb:ToString())
  end
end

function BloodyNightData:HandleActivityData(msg)
  self.serverData = msg.bloodNightPlanActDataInfo
  if self.serverData then
    self.serverData.extraNight = msg.extraNight
    self.serverData.isCloseBloodNight = msg.isCloseBloodNight
    if self.serverData.bloodNightDayActArr then
      table.sort(self.serverData.bloodNightDayActArr, function(a, b)
        return a.dayTime < b.dayTime
      end)
    end
  end
  LogServerData(self.serverData, false)
  self:ParseServerData(true)
end

function BloodyNightData:HandleNightStalkerUltimate(msg)
  if self.serverData then
    self.serverData.extraNight = msg.extraNight
  end
  self:ParseServerData(true)
end

function BloodyNightData:ParseServerData(isNewData)
  local msg = self.serverData
  local oldState = self.state
  self.state = BloodyNightState.None
  self.bnTemplate = nil
  self.startTime = nil
  self.endTime = nil
  self.nightStalker = nil
  self.stageTemplateList = nil
  self.curStageTemplate = nil
  local oldServerDataEndTime = self.serverDataEndTime
  self.serverDataEndTime = nil
  self:RemoveUpdateTimer()
  if not msg then
    return
  end
  local flag = msg.bloodNightPlanInfo.groupId
  self.stageTemplateList = DataCenter.BloodyNightDataManager:GetStageTemplateListByFlag(flag)
  local planId = msg.planId
  for _, v in pairs(self.stageTemplateList) do
    if v.id == planId then
      self.curStageTemplate = v
      break
    end
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local extraNight = msg.extraNight
  if extraNight and now > extraNight.startOpenTime and now < extraNight.settleTime then
    self.state = BloodyNightState.Bloody
    self.startTime = extraNight.startOpenTime
    self.endTime = extraNight.settleTime
    self.bnTemplate = DataCenter.BloodyNightDataManager:GetTemplate(extraNight.configId)
    self.nightStalker = extraNight.ownerInfo
  else
    local success = self:FindCurBloodyNightState(msg.bloodNightDayActArr, now)
    local finalDay = msg.bloodNightDayActArr and msg.bloodNightDayActArr[#msg.bloodNightDayActArr]
    if finalDay == nil then
      self.state = BloodyNightState.None
      self.FETCH_CD = 9999999
    else
      local finalNight = finalDay.bloodNightArr[#finalDay.bloodNightArr]
      self.serverDataEndTime = finalNight.endTime
      if not success and not msg.isCloseBloodNight then
        local nextNightTemplate = DataCenter.BloodyNightDataManager:GetTemplate(finalNight.configId + 1)
        if nextNightTemplate and nextNightTemplate.timeType == 200 then
          self.state = BloodyNightState.Silent
          self.startTime = finalNight.settleTime
          self.endTime = finalNight.endTime + nextNightTemplate.para3 * 1000
          self.bnTemplate = nextNightTemplate
        end
      end
    end
  end
  if msg.isCloseBloodNight then
    if self.state == BloodyNightState.Bloody then
      self.serverDataEndTime = self.endTime
    elseif self.state == BloodyNightState.Silent then
      self.serverDataEndTime = self.startTime
    elseif self.state == BloodyNightState.None then
      self.serverDataEndTime = nil
    end
  end
  if isNewData then
    if self.serverDataEndTime == oldServerDataEndTime then
      self.FETCH_CD = self.FETCH_CD * 2
    else
      self.FETCH_CD = 1
    end
  end
  if self.endTime then
    self:AddUpdateTimer()
  end
  local selfServerId = LuaEntry.Player:GetSelfServerId()
  for _, v in pairs(self.serverIds) do
    if v == selfServerId then
      local loginServerInit = DataCenter.BloodyNightDataManager:GetLoginServerInitMark()
      DataCenter.BloodyNightDataManager:SetLoginSeverInitMark(true)
      if self.state == BloodyNightState.Bloody then
        local cd = CommonUtil.PlayerPrefsGetLong("BloodyNightPopupCoolDown", 0)
        if now > cd then
          DataCenter.UIPopWindowManager:Push(UIWindowNames.UIBloodyNightPopup, {anim = true})
        end
      elseif self.state == BloodyNightState.None then
        if SeasonUtil.IsInSeasonDarknessMode() and Setting:GetPrivateBool("NightOverDawnStartPopup", true) then
          if loginServerInit then
            DataCenter.UIPopWindowManager:Push(UIWindowNames.UIDawnPopup, {anim = true})
          else
            local isFunctionOn = DataCenter.LWPopupManager:IsFunctionOnNewPopupStyle()
            if not isFunctionOn then
              DataCenter.UIPopWindowManager:Push(UIWindowNames.UIDawnPopup, {anim = true})
            else
              DataCenter.LWPopupManager:TryAddPopupNotification(PopupNotificationType.DawnPopup)
            end
          end
        end
        if oldState ~= BloodyNightState.None then
          EventManager:GetInstance():Broadcast(EventId.NightOverDawnStart)
        end
      end
      EventManager:GetInstance():Broadcast(EventId.BloodyNightSelfRefresh)
    end
    EventManager:GetInstance():Broadcast(EventId.BloodyNightActivityRefresh, v)
  end
end

function BloodyNightData:GetStageTemplate()
  return self.curStageTemplate, self.stageTemplateList
end

function BloodyNightData:GetStageEndTime()
  if self.serverData and self.serverData.bloodNightPlanInfo and self.serverData.bloodNightPlanInfo.endTime then
    return self.serverData.bloodNightPlanInfo.endTime
  end
  return 0
end

function BloodyNightData:IsBloodyNight()
  return self.state == BloodyNightState.Bloody
end

function BloodyNightData:GetBloodyNightState()
  return self.state, self.bnTemplate, self.startTime, self.endTime, self.nightStalker
end

function BloodyNightData:HandlePushBloodNightClose()
  self:FetchActivityData(true)
end

function BloodyNightData:HandleSaintMountainProgress(progress)
  self.progress = progress
  EventManager:GetInstance():Broadcast(EventId.SaintMountainProgressRefresh)
end

function BloodyNightData:GetSaintMountainProgress()
  local cur = self.progress or 0
  local max = LuaEntry.DataConfig:TryGetNum("s4_blood_night_switch", "k1", 1440)
  return cur, max
end

return BloodyNightData
