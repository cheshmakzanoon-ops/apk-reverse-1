local SeasonWeatherManager = BaseClass("SeasonWeatherManager")
local SeasonWeatherTemplate = require("DataCenter.SeasonWeather.SeasonWeatherTemplate")
local SeasonWeatherData = require("DataCenter.SeasonWeather.SeasonWeatherData")
local SeasonWeatherTypeTemplate = require("DataCenter.SeasonWeather.SeasonWeatherTypeTemplate")
local Localization = CS.GameEntry.Localization

function SeasonWeatherManager:__init()
  self.data = nil
  self.configMapType = nil
  self.configMapEvent = nil
  self._requestDelayTimer = nil
  self._pendingForce = false
  self:AddListener()
end

function SeasonWeatherManager:__delete()
  self.data = nil
  self:RemoveListener()
  self:DeleteTimer()
  self:DeleteRequestDelayTimer()
end

function SeasonWeatherManager:Startup()
end

function SeasonWeatherManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterCrossServer, self.RequestData, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnQuitCrossServer, self.RequestData, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.SpecialServerSeasonInfoUpdate, self.OnSpecialServerSeasonInfoUpdate, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.OnSetCrossID, self.OnCrossIDChanged, self)
end

function SeasonWeatherManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterCrossServer, self.RequestData, self)
  EventManager:GetInstance():RemoveListener2(EventId.OnQuitCrossServer, self.RequestData, self)
  EventManager:GetInstance():RemoveListener2(EventId.SpecialServerSeasonInfoUpdate, self.OnSpecialServerSeasonInfoUpdate, self)
  EventManager:GetInstance():RemoveListener2(EventId.OnSetCrossID, self.OnCrossIDChanged, self)
end

function SeasonWeatherManager:OnSpecialServerSeasonInfoUpdate(serverId)
  if serverId ~= LuaEntry.Player:GetCurServerId() then
    return
  end
  self:TryRequestData(false)
end

function SeasonWeatherManager:OnCrossIDChanged()
  self:TryRequestData(true)
end

function SeasonWeatherManager:InitData(netData, isChange)
  if self.whenInitData == true then
    return
  end
  if GMUtils.GetBool(GMConst.DisableSeasonWeather, false) then
    netData = nil
    isChange = nil
  end
  self.whenInitData = true
  if netData and netData.curWeather then
    local data = self.data or {}
    self.data = data
    data.serverId = netData.serverId
    if data.curWeather then
      data.curWeather:UpdateData(netData.curWeather)
    else
      data.curWeather = SeasonWeatherData.New(netData.curWeather)
    end
    data.curWeather:UpdateAMBSound()
    data.curWeather:PlaySound()
    if not netData.lastWeather then
      netData.lastWeather = data.curWeather:GetLastDefaultData()
    end
    if data.lastWeather then
      data.lastWeather:UpdateData(netData.lastWeather)
    else
      data.lastWeather = SeasonWeatherData.New(netData.lastWeather)
    end
    self:AddTimer()
  else
    self:DeleteTimer()
    local curWeather = self.data and self.data.curWeather
    self.data = nil
    if curWeather then
      curWeather:UpdateAMBSound()
    end
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonWeatherInfoUpdate, isChange)
  self.whenInitData = false
  if isChange and self.data and self.data.curWeather and not table.IsNullOrEmpty(self.data.curWeather.summonUserInfo) and not self:IsCloseUI() then
    local canShow = not BattleFieldUtil.InBattleField() and (SceneUtils.GetIsInCity() or SceneUtils.GetIsInWorld())
    if canShow and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSeasonWeather) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonWeather, {anim = true})
    end
  end
end

function SeasonWeatherManager:GetConfigData(configId)
  if self.configMapEvent == nil then
    self.configMapEvent = {}
  end
  if self.configMapEvent[configId] == nil then
    local config = LocalController:instance():getLine(TableName.SeasonWeatherEvent, configId)
    if not config then
      return nil
    end
    if config then
      self.configMapEvent[configId] = SeasonWeatherTemplate.New(config)
    else
      self.configMapEvent[configId] = false
      return nil
    end
  end
  return self.configMapEvent[configId]
end

function SeasonWeatherManager:GetWeatherTypeInfo(weatherType)
  if not weatherType or weatherType < 0 then
    return
  end
  self:GetWeatherTypeInfoAll()
  return self.configMapType[weatherType]
end

function SeasonWeatherManager:GetWeatherTypeInfoAll()
  if self.configMapType == nil then
    self.configMapType = {}
    LocalController:instance():visitTable(TableName.SeasonWeatherConfig, function(id, lineData)
      self.configMapType[id] = SeasonWeatherTypeTemplate.New(lineData)
    end)
  end
end

function SeasonWeatherManager:GetWeatherType(weatherId)
  if not weatherId or weatherId < 0 then
    return SeasonWeatherType.Unknown
  end
  local typeInfo = self:GetWeatherTypeInfo(weatherId)
  if not typeInfo then
    return SeasonWeatherType.Unknown
  end
  return typeInfo.type
end

function SeasonWeatherManager:IsOpen()
  local endTime = self.data and self.data.curWeather and self.data.curWeather.endTime
  return endTime and endTime > UITimeManager:GetInstance():GetServerTime()
end

function SeasonWeatherManager:CanShowUI()
  if not self:IsOpen() then
    return false
  end
  if self:IsCloseUI() then
    return false
  end
  if CrossServerUtil:GetIsCrossServer() then
    local isBigMap, curSameGroup = SeasonUtil.InSeasonBigMapMode()
    if not isBigMap or not curSameGroup then
      return false
    end
  end
  local serverOpenDay = SeasonUtil.GetSeasonDay()
  if not serverOpenDay or serverOpenDay <= 2 then
    return false
  end
  return true
end

function SeasonWeatherManager:IsCloseUI()
  local info = self:GetWeatherInfo()
  if info then
    local typeInfo = self:GetWeatherTypeInfo(info.weatherId)
    if typeInfo and typeInfo.is_close_ui then
      return true
    end
  end
  return false
end

function SeasonWeatherManager:GetWeatherInfo()
  return self.data and self.data.curWeather
end

function SeasonWeatherManager:GetWeatherLastInfo()
  return self.data and self.data.lastWeather
end

function SeasonWeatherManager:GetConfigDataByAdd(add_)
  local info = self:GetWeatherInfo()
  if not info then
    return nil
  end
  local template = self:GetConfigData(info.configId)
  if not template then
    return nil
  end
  add_ = add_ or 0
  local addData = self:GetConfigData(info.configId + add_)
  if not addData or template.season_group ~= addData.season_group then
    return nil
  end
  return addData
end

function SeasonWeatherManager:GetNextWeatherConfig()
  local info = self:GetWeatherInfo()
  if not info then
    return nil
  end
  local nextTemplate = self:GetConfigDataByAdd(1)
  return nextTemplate
end

function SeasonWeatherManager:GetWeatherTypeList()
  if not self.typeList then
    self:GetWeatherTypeInfoAll()
    self.typeList = {}
    local index = 1
    for k, v in pairs(self.configMapType) do
      if v and v.id and not v.is_close_ui then
        self.typeList[index] = v
        index = index + 1
      end
    end
    table.sort(self.typeList, function(a, b)
      if a.order == b.order then
        return a.id < b.id
      end
      return a.order < b.order
    end)
  end
  return self.typeList
end

function SeasonWeatherManager:CanShowWeather()
  local curServerConfig = SeasonUtil.GetCurServerConfig()
  if not curServerConfig or not curServerConfig:InNormalMode() then
    return false
  end
  return true
end

function SeasonWeatherManager:GetAMBSoundId()
  if self.data and self.data.curWeather then
    return self.data.curWeather:GetAMBSoundId()
  end
  return 0
end

function SeasonWeatherManager:GetWeatherGuiderPlot(curWeather, nextWeather)
  if not self.guiderPlots then
    self.guiderPlots = {}
    LocalController:instance():visitTable(TableName.SeasonWeatherGuider, function(id, lineData)
      if lineData and lineData.permutation then
        local permutation = string.split(lineData.permutation, "|")
        if #permutation == 2 then
          local curWeatherId = tonumber(permutation[1])
          local nextWeatherId = tonumber(permutation[2])
          if curWeatherId and nextWeatherId then
            self.guiderPlots[curWeatherId] = self.guiderPlots[curWeatherId] or {}
            self.guiderPlots[curWeatherId][nextWeatherId] = tonumber(lineData.plot)
          end
        end
      end
    end)
  end
  if not self.guiderPlots or not self.guiderPlots[curWeather] then
    return nil
  end
  return self.guiderPlots[curWeather][nextWeather] or nil
end

function SeasonWeatherManager:RequestData()
  self:TryRequestData(true)
end

function SeasonWeatherManager:TryRequestData(force)
  if self.whenInitData then
    return
  end
  if not self:CanShowWeather() then
    self:DeleteRequestDelayTimer()
    self._pendingForce = false
    self:InitData(nil)
    return
  end
  if force then
    self._pendingForce = true
  else
    local info = self:GetWeatherInfo()
    if info and info.endTime and UITimeManager:GetInstance():GetServerTime() > info.endTime then
      return
    end
  end
  self:DeleteRequestDelayTimer()
  self._requestDelayTimer = TimerManager:GetInstance():GetTimer(0.2, self.DoRequestData, self, true, false, true)
  self._requestDelayTimer:Start()
end

function SeasonWeatherManager:DoRequestData()
  self._requestDelayTimer = nil
  local force = self._pendingForce
  self._pendingForce = false
  if not self:CanShowWeather() then
    self:InitData(nil)
    return
  end
  if force or not self.data then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonWeatherInfo)
    return
  end
  local info = self:GetWeatherInfo()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if self:IsOpen() and info and serverTime >= info.endTime then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonWeatherInfo)
  end
end

function SeasonWeatherManager:DeleteRequestDelayTimer()
  if self._requestDelayTimer ~= nil then
    self._requestDelayTimer:Stop()
    self._requestDelayTimer = nil
  end
end

function SeasonWeatherManager:GetBuffValue(seasonWeatherType)
  if not self.data or not self.data.curWeather then
    return 0
  end
  if seasonWeatherType ~= self:GetWeatherType(self.data.curWeather.weatherId) then
    return 0
  end
  local typeInfo = self:GetWeatherTypeInfo(self.data.curWeather.weatherId)
  return typeInfo and typeInfo.buff_para and typeInfo.buff_para[1] or 0
end

function SeasonWeatherManager:GetWeatherVirus()
  return self:GetBuffValue(SeasonWeatherType.Fog)
end

function SeasonWeatherManager:CanSummonWeather(skillTemp)
  local targetWeatherId = tonumber(skillTemp.value1) or -1
  if not skillTemp or skillTemp.type ~= MasterySkill.SummonWeather or targetWeatherId < 0 then
    return false, Localization:GetString("season_s1_weather_tips_1")
  end
  local info = self:GetWeatherInfo()
  local curWeatherId = info and info.weatherId
  if not curWeatherId or not self:IsOpen() then
    return false, Localization:GetString("season_s1_weather_tips_1")
  end
  local curWeatherType = self:GetWeatherType(curWeatherId)
  if targetWeatherId == curWeatherType then
    return false, Localization:GetString("season_s1_weather_tips_3")
  end
  local limitWeathers = not string.IsNullOrEmpty(skillTemp.value2) and string.split(skillTemp.value2, "|")
  if not table.IsNullOrEmpty(limitWeathers) then
    local canUse, str = false, ""
    for _, v in ipairs(limitWeathers) do
      local weatherId = tonumber(v)
      if weatherId == curWeatherType then
        canUse = true
        break
      else
        local weatherTemplate = self:GetWeatherTypeInfo(weatherId)
        if weatherTemplate then
          str = string.format("%s %s ", str, Localization:GetString(weatherTemplate.name))
        end
      end
    end
    if not canUse then
      return false, Localization:GetString("s1_title_skill_tips03", str)
    end
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = math.floor((info.endTime - serverTime) / 60000)
  local limitTime = tonumber(skillTemp.value3) or -1
  if 0 < limitTime and remainTime >= limitTime then
    return false, Localization:GetString("s1_title_skill_tips04", limitTime)
  end
  local limitEndTime = LuaEntry.DataConfig:TryGetNum("season1_activeskill_config", "k1", 0)
  if 0 < limitEndTime and remainTime < limitEndTime then
    return false, Localization:GetString("s1_title_skill_tips02", limitEndTime)
  end
  return true
end

function SeasonWeatherManager:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function SeasonWeatherManager:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(10, self.OnTimer, self, false, false, false)
  end
  self.timer:Start()
end

function SeasonWeatherManager:OnTimer()
  local info = self:GetWeatherInfo()
  if info and info.endTime + 10000 < UITimeManager:GetInstance():GetServerTime() then
    self:TryRequestData(true)
    self:DeleteTimer()
  end
end

return SeasonWeatherManager
