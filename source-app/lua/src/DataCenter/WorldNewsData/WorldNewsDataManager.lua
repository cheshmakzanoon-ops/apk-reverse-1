local WorldNewsDataManager = BaseClass("WorldNewsDataManager")
local AreaInfo = require("DataCenter.WorldNewsData.AreaInfo")
local NewsInfo = require("DataCenter.WorldNewsData.NewsInfo")

local function __init(self)
  self.areaInfoList = {}
  self.newsInfoList = {}
  self.cacheRefreshAreaId = {}
  self.lastAreaNewsTime = CS.GameEntry.Setting:GetPrivateInt("LAST_GET_AREA_NEWS_TIME", 0)
  self.latestAreaNewsTime = 0
  self.lastAlCityNewsTime = CS.GameEntry.Setting:GetPrivateInt("LAST_GET_AL_CITY_NEWS_TIME", 0)
  self.latestAlCityNewsTime = 0
  self.lastRequestTime = 0
  self.timer = nil
  
  function self.timer_action(temp)
    self:CheckRefresh()
  end
  
  self:AddListener()
  self:CheckAddTimer()
end

local function __delete(self)
  self.cacheRefreshAreaId = nil
  self.areaInfoList = nil
  self.newsInfoList = nil
  self.timer_action = nil
  self:DeleteTimer()
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
end

local function OnEnterWorld(data)
  DataCenter.WorldNewsDataManager:CheckAddTimer()
end

local function OnEnterCity(data)
  DataCenter.WorldNewsDataManager:CheckAddTimer()
end

local function CheckAddTimer(self)
  if SceneUtils.GetIsInWorld() then
    self:AddTimer()
  else
    self:DeleteTimer()
  end
end

local function SendRequest(self)
  self.lastRequestTime = UITimeManager:GetInstance():GetServerSeconds()
  SFSNetwork.SendMessage(MsgDefines.GetWorldNewInfo)
end

local function CheckRefresh(self)
  local timeDelta = LuaEntry.DataConfig:TryGetNum("world_news_info", "k4")
  if timeDelta < 300 then
    timeDelta = 300
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local deltaTime = curTime - timeDelta
  local needSendMessage = false
  for k, v in pairs(self.areaInfoList) do
    if (self.cacheRefreshAreaId[k] == nil or self.cacheRefreshAreaId[k] == 0) and 0 < v.time and deltaTime > v.time then
      needSendMessage = true
      self.cacheRefreshAreaId[k] = 1
    end
  end
  if needSendMessage == false then
    local requestDelta = LuaEntry.DataConfig:TryGetNum("world_news_info", "k5")
    if requestDelta < 300 then
      requestDelta = 300
    end
    if curTime > self.lastRequestTime + requestDelta then
      needSendMessage = true
    end
  end
  if needSendMessage == true then
    self:SendRequest()
  end
end

local function UpdateWorldNewsData(self, message)
  self.areaInfoList = {}
  self.newsInfoList = {}
  self.latestAreaNewsTime = 0
  self.latestAlCityNewsTime = 0
  if message.areaInfo ~= nil then
    local newsInfo = message.areaInfo
    if newsInfo.infos ~= nil then
      local arr = newsInfo.infos
      for k, v in pairs(arr) do
        local oneData = AreaInfo.New()
        oneData:ParseData(v)
        if oneData.id ~= nil and 0 < oneData.id then
          self.areaInfoList[oneData.id] = oneData
          if oneData.time > self.latestAreaNewsTime then
            self.latestAreaNewsTime = oneData.time
          end
        end
      end
      for k, v in pairs(self.cacheRefreshAreaId) do
        if self.areaInfoList[k] == nil then
          v = 0
        end
      end
      EventManager:GetInstance():Broadcast(EventId.UpdateWorldZoneNews)
    end
    EventManager:GetInstance():Broadcast(EventId.WorldAreaNewsRedDot)
  end
  if message.newsInfo ~= nil then
    local newsInfo = message.newsInfo
    if newsInfo.infos ~= nil then
      local arr = newsInfo.infos
      for k, v in pairs(arr) do
        local oneData = NewsInfo.New()
        oneData:ParseData(v)
        table.insert(self.newsInfoList, oneData)
        if oneData.time > self.latestAlCityNewsTime then
          self.latestAlCityNewsTime = oneData.time
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.WorldAlCityNewsRedDot)
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateWorldNewsData)
end

local function GetAreaInfoList(self)
  return self.areaInfoList
end

local function GetAreaInfoByPointId(self, pointId)
  return self.areaInfoList[pointId]
end

local function GetNewsInfoList(self)
  return self.newsInfoList
end

local function SetLastGetAreaNewsTime(self, getNewsTime)
  if getNewsTime > self.lastAreaNewsTime then
    self.lastAreaNewsTime = getNewsTime
    CS.GameEntry.Setting:SetPrivateInt("LAST_GET_AREA_NEWS_TIME", getNewsTime)
    EventManager:GetInstance():Broadcast(EventId.WorldAreaNewsRedDot)
  end
end

local function SetLastGetAlCityNewsTime(self, getNewsTime)
  if getNewsTime > self.lastAlCityNewsTime then
    self.lastAlCityNewsTime = getNewsTime
    CS.GameEntry.Setting:SetPrivateInt("LAST_GET_AL_CITY_NEWS_TIME", getNewsTime)
    EventManager:GetInstance():Broadcast(EventId.WorldAlCityNewsRedDot)
  end
end

local function CheckShowAreaNews(self)
  if self.latestAreaNewsTime > self.lastAreaNewsTime then
    return true
  end
  return false
end

local function CheckShowAlCityNews(self)
  if self.latestAlCityNewsTime > self.lastAlCityNewsTime then
    return true
  end
  return false
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(30, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function CheckShowByCityLv(self)
  local showLevel = LuaEntry.DataConfig:TryGetNum("world_news_info", "k8")
  if showLevel <= DataCenter.BuildManager.MainLv then
    return true
  end
  return false
end

WorldNewsDataManager.__init = __init
WorldNewsDataManager.__delete = __delete
WorldNewsDataManager.SendRequest = SendRequest
WorldNewsDataManager.UpdateWorldNewsData = UpdateWorldNewsData
WorldNewsDataManager.GetAreaInfoList = GetAreaInfoList
WorldNewsDataManager.GetNewsInfoList = GetNewsInfoList
WorldNewsDataManager.AddTimer = AddTimer
WorldNewsDataManager.DeleteTimer = DeleteTimer
WorldNewsDataManager.SetLastGetAreaNewsTime = SetLastGetAreaNewsTime
WorldNewsDataManager.CheckShowAreaNews = CheckShowAreaNews
WorldNewsDataManager.SetLastGetAlCityNewsTime = SetLastGetAlCityNewsTime
WorldNewsDataManager.CheckShowAlCityNews = CheckShowAlCityNews
WorldNewsDataManager.GetAreaInfoByPointId = GetAreaInfoByPointId
WorldNewsDataManager.CheckRefresh = CheckRefresh
WorldNewsDataManager.CheckShowByCityLv = CheckShowByCityLv
WorldNewsDataManager.CheckAddTimer = CheckAddTimer
WorldNewsDataManager.AddListener = AddListener
WorldNewsDataManager.RemoveListener = RemoveListener
WorldNewsDataManager.OnEnterWorld = OnEnterWorld
WorldNewsDataManager.OnEnterCity = OnEnterCity
return WorldNewsDataManager
