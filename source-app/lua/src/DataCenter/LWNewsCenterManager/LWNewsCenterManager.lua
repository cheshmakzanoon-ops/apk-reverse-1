local LWNewsCenterManager = BaseClass("LWNewsCenterManager")
local NewsCenterData = require("DataCenter.LWNewsCenterManager.NewsCenterData")
local WikiTokenService = require("DataCenter.LWNewsCenterManager.WikiTokenService")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local StringUtils = CS.StringUtils
local onLinePattern = "^(https://wiki%.lastwar%.com/)([A-Za-z0-9_%-]+)/show/(.+)$"
local testPattern = "^(https://wiki%-test%.lastwar%.com/)([A-Za-z0-9_%-]+)/show/(.+)$"
local MsgReqMaxNum = 20

function LWNewsCenterManager:__init()
  self:AddListeners()
  self.pendingOpen = nil
  self.wikiTokenService = WikiTokenService.New()
  self.lateUpdateReqTimer = nil
end

function LWNewsCenterManager:AddListeners()
  EventManager:GetInstance():AddListener(EventId.WEBVIEW_FIRE_EVENT, self.OnWebViewFireEvent)
end

function LWNewsCenterManager:RemoveListeners()
  EventManager:GetInstance():RemoveListener(EventId.WEBVIEW_FIRE_EVENT, self.OnWebViewFireEvent)
end

function LWNewsCenterManager.OnWebViewFireEvent(eventJson)
  if string.IsNullOrEmpty(eventJson) then
    return
  end
  local eventData = rapidjson.decode(eventJson)
  if eventData and eventData.source and eventData.source == WebEventType.NewsCenter then
    if not eventData.data or not eventData.data.info then
      Logger.LogError(string.format("[NewsCenter] OnWebViewFireEvent: Missing data or info in eventJson = %s", tostring(eventJson)))
      return
    end
    local info = eventData.data.info
    if eventData.data.event_name == NewsCenterWebEventName.Like and info.newsUuid then
      local data = DataCenter.LWNewsCenterManager:GetNewsDataByUuid(tonumber(info.newsUuid))
      if data and info.newLikeCount then
        data:UpdateCountByWeb(info.newLikeCount)
        EventManager:GetInstance():Broadcast(EventId.CHAT_NEWSCENTER_UPLIKECOUNT, data)
      else
        Logger.LogWarning(string.format("[NewsCenter] LikeEvent: newsUuid=%s, newLikeCount=%s, data=%s", tostring(info.newsUuid), tostring(info.newLikeCount), tostring(data)))
      end
    elseif eventData.data.event_name == NewsCenterWebEventName.ImageDownload then
      if info.url and info.url ~= "" then
        CS.SDKManager.OpenURL(info.url)
      else
        Logger.LogError(string.format("[NewsCenter] ImageDownload: Missing or invalid URL in eventJson = %s", tostring(eventJson)))
      end
    elseif eventData.data.event_name == NewsCenterWebEventName.Share then
      local data = DataCenter.LWNewsCenterManager:GetNewsDataByUuid(tonumber(info.newsUuid))
      if data then
        local share_param = {}
        share_param.postType = PostType.NewsCenterLink
        share_param.uuid = data.uuid
        share_param.newsType = data.type
        local chatData = {}
        chatData.post = share_param.postType
        chatData.postType = share_param.postType
        chatData.param = share_param
        chatData.isShowWeb = true
        chatData.openType = DataCenter.LWNewsCenterManager.lastWebOpenType
        EventManager:GetInstance():Broadcast(EventId.CHAT_NEWSCENTER_SHARE, data.uuid)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
      end
    else
      Logger.LogWarning(string.format("[NewsCenter] Unknown event_name: %s, eventJson=%s", tostring(eventData.data.event_name), tostring(eventJson)))
    end
  else
    Logger.LogWarning(string.format("[NewsCenter] OnWebViewFireEvent: Not a NewsCenter source, eventJson=%s", tostring(eventJson)))
  end
end

function LWNewsCenterManager:ShowNewsWeb(uid, showType, shareResult)
  local data = DataCenter.LWNewsCenterManager:GetNewsDataByUuid(uid)
  if not data then
    return
  end
  local url = DataCenter.LWNewsCenterManager:GetLanguageUrl(data.urlWiki)
  local openUrl = DataCenter.LWNewsCenterManager:GetNewsCenterUrl(url, data, showType, true)
  if not openUrl then
    return
  end
  local param = {
    source = WebEventType.NewsCenter,
    data = {
      event_name = NewsCenterWebEventName.Share,
      info = {shareStatus = shareResult}
    }
  }
  local json = rapidjson.encode(param)
  local safeJson = json:gsub("\\", "\\\\"):gsub("\"", "\\\"")
  local script = string.format("receiveMessageFromUnity(\"%s\")", safeJson)
  local eventParam = {openUrl = openUrl, eventJson = script}
  if showType == NewsCenterOpenType.News then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_OPEN_URL, eventParam)
  elseif showType == NewsCenterOpenType.Chat then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_CHATVIEW_OPENURL, eventParam)
  elseif showType == NewsCenterOpenType.NoticeDetail then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_NOTICE_DETAIL_VIEW_OPENURL, eventParam)
  elseif showType == NewsCenterOpenType.NoticeRecord then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_NOTICE_RECORD_VIEW_OPENURL, eventParam)
  end
end

function LWNewsCenterManager:ShowWebViewURl(param)
  if not (not IsNull(param.obj) and param.url) or not param.openType then
    return
  end
  self.lastWebOpenType = param.openType
  CS.ZendeskSupportView.Show(param.obj, param.url, nil, param.startJson)
end

function LWNewsCenterManager:__delete()
  CS.ZendeskSupportView.Close()
  self:RemoveRequestWikiChainUpdate()
  self:RemoveListeners()
end

function LWNewsCenterManager:InitData()
  self.infos = nil
  self.newsDataDic = {}
  self.newsAdd = {}
  self.maxNewsUidDic = {}
  self.cacheNewsInfo = {}
  self.cacheChainNewsSimpleDict = {}
  self.cacheChainNewsDataStateDict = {}
  self.newsChainDic = {}
  self.requestWikiChainList = {}
  self.wikiCountDic = {}
  self.reset = false
  SFSNetwork.SendMessage(MsgDefines.GetNewsInfo)
end

function LWNewsCenterManager:Startup()
end

function LWNewsCenterManager:OnGetNewsInfo(infos)
  if not infos or #infos == 0 then
    return
  end
  self.infos = {}
  for i, info in pairs(infos) do
    info.key = info.bigType .. "_" .. info.smallType .. "_" .. info.createTime
    info.prefKey = "NEWS_NEW_MARK_" .. info.uuid
    info.isNew = CommonUtil.PlayerPrefsGetInt(info.prefKey, 0) == 0
    
    function info:SetRead()
      if self.isNew then
        CommonUtil.PlayerPrefsSetInt(self.prefKey, 1)
        self.isNew = false
      end
    end
    
    table.insert(self.infos, info)
  end
end

function LWNewsCenterManager:OnPushNewNews(info)
  if not info then
    return
  end
  if not self.infos then
    self.infos = {}
  end
  local capacity = LuaEntry.DataConfig:TryGetNum("news_setting", "k1", 30)
  while capacity <= #self.infos do
    table.remove(self.infos, #self.infos)
  end
  info.key = info.bigType .. "_" .. info.smallType .. "_" .. info.createTime
  info.prefKey = "NEWS_NEW_MARK_" .. info.uuid
  info.isNew = CommonUtil.PlayerPrefsGetInt(info.prefKey, 0) == 0
  
  function info:SetRead()
    if self.isNew then
      CommonUtil.PlayerPrefsSetInt(self.prefKey, 1)
      self.isNew = false
    end
  end
  
  table.insert(self.infos, 1, info)
end

function LWNewsCenterManager:OnNewsLiked(newsUuid, likeNum)
  if not self.infos then
    return
  end
  for _, info in ipairs(self.infos) do
    if info.uuid == newsUuid then
      info.likeNum = likeNum
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_UPLIKECOUNT, info)
      break
    end
  end
end

local Tab = {Zone = 1, Alliance = 2}

function LWNewsCenterManager:GetFirstUnreadNews()
  local firstUnreadNews
  local infos = DataCenter.LWNewsCenterManager:FilterNews(Tab.Zone)
  if infos then
    for _, info in ipairs(infos) do
      if info.isNew then
        firstUnreadNews = info
        break
      end
    end
  end
  return firstUnreadNews
end

function LWNewsCenterManager:ChangeMainBubbleState(isOn)
  if self.showBubble ~= isOn then
    self.showBubble = isOn
    EventManager:GetInstance():Broadcast(EventId.CHAT_NEWSCENTER_BUBBLESTATE_UPDATA)
  end
end

function LWNewsCenterManager:GetIsShowBubble()
  return self.showBubble
end

function LWNewsCenterManager:GetRedDontCount()
  local infos = DataCenter.LWNewsCenterManager:FilterNews(Tab.Zone)
  local count = 0
  if infos then
    for _, info in ipairs(infos) do
      if info.isNew then
        count = count + 1
      end
    end
  end
  return count
end

local function __CommonJudge(tab, inAlliance)
  if tab == Tab.Zone then
    return true
  elseif tab == Tab.Alliance then
    return inAlliance and not string.IsNullOrEmpty(LuaEntry.Player.allianceId)
  end
  return false
end

local function __FilterPersonalBattleNews(info, tab)
  local player = LuaEntry.Player
  local atkUser = info.dataObj.atk.user
  local defUser = info.dataObj.def.user
  local alId = player.allianceId
  local atkAl, defAl = atkUser.alId, defUser.alId
  local inAlliance = alId == atkAl or alId == defAl
  return __CommonJudge(tab, inAlliance)
end

local function __FilterAllianceBattleNews(info, tab)
  local player = LuaEntry.Player
  local s1, s2 = info.dataObj.side1, info.dataObj.side2
  local inAlliance = player.allianceId == s1.allianceId or player.allianceId == s2.allianceId
  return __CommonJudge(tab, inAlliance)
end

local function __FilterOccupyCityNews(info, tab)
  local player = LuaEntry.Player
  local atk, def = info.dataObj.atk, info.dataObj.def
  local inAlliance = player.allianceId == atk.alId or player.allianceId == def.alId
  return __CommonJudge(tab, inAlliance)
end

local function __FilterAppointOfficalNews(info, tab)
  local player = LuaEntry.Player
  local king = info.dataObj.king
  local target = info.dataObj.target
  local inAlliance = player.allianceId == king.allianceId or target and player.allianceId == target.allianceId
  return __CommonJudge(tab, inAlliance)
end

local function __FilterTrainRobNews(info, tab)
  local player = LuaEntry.Player
  local data = info.dataObj
  local inAlliance = player.allianceId == data.allianceId
  return __CommonJudge(tab, inAlliance)
end

local function __FilterArenaChampionNews(info, tab)
  local data = info.dataObj
  if not data.serverArr then
    data.allianceId = tonumber(data.allianceId) or 0
    data.serverArr = {
      tonumber(data.serverId) or 0
    }
    data.serverArrStr = "#" .. data.serverId
    local arr = string.split(data.otherServerId or "", "|")
    for _, otherServerId in ipairs(arr) do
      if not string.IsNullOrEmpty(otherServerId) then
        table.insert(data.serverArr, tonumber(otherServerId) or 0)
        data.serverArrStr = data.serverArrStr .. " #" .. otherServerId
      end
    end
  end
  local inAlliance = LuaEntry.Player.allianceId == data.allianceId
  return __CommonJudge(tab, inAlliance)
end

local __FilterFuncs = {
  [NewsSubType.PERSONAL_BATTLE] = __FilterPersonalBattleNews,
  [NewsSubType.ALLIANCE_BATTLE] = __FilterAllianceBattleNews,
  [NewsSubType.ALLIANCE_ATK_ALLIANCE_CITY] = __FilterOccupyCityNews,
  [NewsSubType.APPOINT_OFFICAL] = __FilterAppointOfficalNews,
  [NewsSubType.TRAIN_ROB] = __FilterTrainRobNews,
  [NewsSubType.ARENA_CHAMPION] = __FilterArenaChampionNews
}

function LWNewsCenterManager:FilterNews(tab)
  if self.infos == nil then
    return {}
  end
  local infos = {}
  for _, info in pairs(self.infos) do
    local filterFunc = __FilterFuncs[info.smallType]
    if filterFunc and filterFunc(info, tab) then
      table.insert(infos, info)
    end
  end
  return infos
end

function LWNewsCenterManager:InitNewsCenter(reset)
  self.reset = reset
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.NewsCenterInit)
end

local URL_QUERY_FORMAT = "?token=%s&avatarId=%s&newsUuid=%s&isLike=%s"

function LWNewsCenterManager:GetLanguageUrl(url)
  local gameLanguage = Localization:GetLanguage()
  local language = self:GetConfigLanguage(gameLanguage)
  if string.find(url, "{0}", 1, true) then
    url = string.gsub(url, "{0}", language, 1)
  end
  return url
end

function LWNewsCenterManager:ShareNewsWiki(uid)
  local data = self:GetNewsDataByUuid(uid)
  if not data or not self:GetPostHttpIsOn() then
    return
  end
  self.wikiTokenService:RequestLike(data.urlWiki)
end

function LWNewsCenterManager:GetPostHttpIsOn()
  local isOn = LuaEntry.DataConfig:TryGetNum("wiki_data_control", "k1")
  if isOn == 0 then
    return false
  end
  return true
end

function LWNewsCenterManager:PostWiki()
  if not self.newsDataDic then
    return
  end
  if not self:GetPostHttpIsOn() then
    return
  end
  local urls = {}
  for _, dic in pairs(self.newsDataDic) do
    for _, data in pairs(dic) do
      table.insert(urls, data.urlWiki)
    end
  end
  if #urls == 0 then
    return
  end
  self.wikiTokenService:RequestArticleList(urls, function(ok, jsonStr)
    if not ok then
      return
    end
    local jsonObj = rapidjson.decode(jsonStr)
    if not jsonObj or not jsonObj.data then
      return
    end
    for _, info in pairs(jsonObj.data) do
      local newsData = self.newsChainDic[info.wikiChain]
      if newsData then
        newsData:UpdateWikiInfo(info)
        self.wikiCountDic[info.wikiChain] = info
      end
    end
  end)
end

function LWNewsCenterManager:GetNewsDataByWiki()
  self:PostWiki()
end

function LWNewsCenterManager:SetToken(msg)
  self.wikiTokenService:SetToken(msg)
  self:_ProcessPendingOpen()
end

function LWNewsCenterManager:_ProcessPendingOpen()
  if not self.pendingOpen then
    return
  end
  local pending = self.pendingOpen
  local resolvedUrl = self:GetNewsCenterUrl(pending.baseUrl, pending.newsData, pending.openType, false, true)
  if resolvedUrl then
    if pending.openType == NewsCenterOpenType.News then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_OPEN_URL, {openUrl = resolvedUrl})
    elseif pending.openType == NewsCenterOpenType.Chat then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_CHATVIEW_OPENURL, {openUrl = resolvedUrl})
    elseif pending.openType == NewsCenterOpenType.NoticeDetail then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_NOTICE_DETAIL_OPENURL, {openUrl = resolvedUrl})
    elseif pending.openType == NewsCenterOpenType.NoticeRecord then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_NOTICE_RECORD_OPENURL, {openUrl = resolvedUrl})
    end
    Logger.Log(string.format("[NewsCenter] Processed pending open url: %s", resolvedUrl))
  end
  self.pendingOpen = nil
end

function LWNewsCenterManager:GetNewsCenterUrl(baseUrl, newsData, openType, allowDelayOpen, bypassTokenCheck)
  local isLiked = newsData and newsData.isLike and true or false
  local avatarAssetKey = CS.UploadImageManager.Instance:GenAssetKey(LuaEntry.Player.uid, LuaEntry.Player.picVer, true)
  local wikiToken = self.wikiTokenService:GetToken(bypassTokenCheck)
  if wikiToken then
    local fullUrl = baseUrl .. string.format(URL_QUERY_FORMAT, wikiToken, avatarAssetKey, newsData and newsData.uuid or "", tostring(isLiked))
    self.pendingOpen = nil
    return fullUrl
  end
  if allowDelayOpen then
    self.pendingOpen = {
      baseUrl = baseUrl,
      newsData = newsData,
      openType = openType
    }
  end
  return nil
end

function LWNewsCenterManager:UpdateNewsCenterLike(data)
  if data.type and data.uuid then
    local newsData = self:GetNewsData(data.type, data.uuid)
    if newsData then
      local info = self.wikiCountDic[newsData.wikiChain]
      if newsData.wikiChain and info and info.likeCount then
        info.likeCount = info.likeCount + 1
        info.isLike = true
      end
      newsData:UpLikeCount()
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_UPLIKECOUNT, newsData)
    end
  end
end

function LWNewsCenterManager:GetNewsDataByUuid(uuid)
  if not uuid then
    return
  end
  for i, dic in pairs(self.newsDataDic) do
    if dic[uuid] then
      return dic[uuid]
    end
  end
end

function LWNewsCenterManager:GetServerNews(type)
  local newsDataList = self:GetNewsCenterInfoListByType(type)
  local priority = 0
  if newsDataList and 0 < #newsDataList then
    priority = newsDataList[#newsDataList].priority
  end
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.GetNewCenter, type, priority)
end

function LWNewsCenterManager:InitNewsCenterDatas(serverData)
  if not serverData then
    return
  end
  for i, data in pairs(serverData) do
    self:UpdateNewsCenter(data)
  end
  if not self.reset then
    local isNew = self:GetNewsRed() and true or false
    self:ChangeMainBubbleState(isNew)
  else
    self:PostWiki()
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_INIT)
end

function LWNewsCenterManager:UpdateNewsCenter(serverData)
  local newsType = serverData.type
  if not self.newsDataDic[newsType] then
    self.newsDataDic[newsType] = {}
  end
  local newsData
  local dataList = serverData.news
  local wikiInfo
  for i = 1, #dataList do
    wikiInfo = nil
    newsData = NewsCenterData.New(self)
    newsData:onParseServerData(dataList[i])
    wikiInfo = self.wikiCountDic[dataList[i].wikiChain]
    if wikiInfo then
      newsData:UpdateWikiInfo(wikiInfo)
    end
    if newsData.uuid then
      self.newsDataDic[newsType][newsData.uuid] = newsData
      if newsData.wikiChain then
        self.newsChainDic[newsData.wikiChain] = newsData
        self:SetCacheChainNewsDict(newsData.wikiChain, newsData)
      end
      if not self.maxNewsUidDic[newsType] then
        self.maxNewsUidDic[newsType] = newsData.uuid
      elseif newsData.uuid > self.maxNewsUidDic[newsType] then
        self.maxNewsUidDic[newsType] = newsData.uuid
      end
    end
  end
  if 0 < #dataList then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_UPDATA, newsType)
  end
end

function LWNewsCenterManager:SortListByDic(dic)
  local dataList = {}
  for uid, data in pairs(dic) do
    if data:IsCanShow() then
      table.insert(dataList, data)
    end
  end
  table.sort(dataList, function(a, b)
    if a.priority > b.priority then
      return true
    end
  end)
  return dataList
end

function LWNewsCenterManager:GetNewsData(tabType, uid)
  if not (tabType and uid) or not self.newsDataDic[tabType] then
    return
  end
  return self.newsDataDic[tabType][uid]
end

function LWNewsCenterManager:GetNewsCenterInfoListByType(newsType)
  if self.newsDataDic[newsType] then
    return self:SortListByDic(self.newsDataDic[newsType]) or {}
  end
end

function LWNewsCenterManager:GetNewsCount(newsType)
  local list = self:GetNewsCenterInfoListByType(newsType)
  local count = 0
  for i, data in pairs(list) do
    if data.isNew then
      count = count + 1
    end
  end
  return count
end

function LWNewsCenterManager:UpdateRed(tabTypeList)
  self.newsAdd = self.newsAdd or {}
  if tabTypeList and 0 < #tabTypeList then
    self:ChangeMainBubbleState(true)
    for i, tabType in pairs(tabTypeList) do
      self.newsAdd[tabType] = true
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_ADDPUSH)
    end
  end
end

function LWNewsCenterManager:GetRed(tabTyp)
  return self.newsAdd and self.newsAdd[tabTyp]
end

function LWNewsCenterManager:SetRedDotId(tabType)
  if tabType and self.maxNewsUidDic[tabType] then
    CommonUtil.PlayerPrefsSetLong("newsCenterRed" .. tabType, self.maxNewsUidDic[tabType])
    self.newsAdd[tabType] = nil
  end
end

function LWNewsCenterManager:GetRedDotId(tabType)
  return CommonUtil.PlayerPrefsGetLong("newsCenterRed" .. tabType, 0)
end

function LWNewsCenterManager:GetRedNew(tabType)
  local dataList = self:GetNewsCenterInfoListByType(tabType)
  if not dataList then
    return
  end
  for i = 1, #dataList do
    if dataList[i].isNew then
      return true
    end
  end
  return self.newsAdd[tabType]
end

function LWNewsCenterManager:GetNewsRed()
  local guid = self:GetRedNew(ChatNewsCenterTabType.StrategyGuide)
  local cement = self:GetRedNew(ChatNewsCenterTabType.Announcement)
  return guid or cement
end

function LWNewsCenterManager:SetUpdateTime()
end

function LWNewsCenterManager:HasAdd()
  return self.newsAdd[ChatNewsCenterTabType.StrategyGuide] or self.newsAdd[ChatNewsCenterTabType.Announcement]
end

function LWNewsCenterManager:GetNewsWikiUp()
end

function LWNewsCenterManager:OnShareNewsMd5(serverData)
  if serverData and serverData.newsInfo and serverData.newsInfo.uuid then
    local roomId = serverData.roomId
    local newsData = serverData.newsInfo
    self:UpdateCacheData(newsData.uuid, newsData)
    if self.md5Url == serverData.md5Url then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UINewsShareView, {anim = true}, {
        newsUid = newsData.uuid,
        roomId = roomId
      })
    end
  end
end

function LWNewsCenterManager:OpenShareView(url, roomId)
  if not url or not roomId then
    return
  end
  self.md5Url = StringUtils.GetMD5(url)
  local language = Localization:GetLanguage()
  local abbr = "en"
  for k, v in pairs(SuportedServerLanguagesLocalName) do
    if v == language then
      abbr = k
    end
  end
  local param = {
    md5Url = self.md5Url,
    lang = abbr,
    roomId = roomId
  }
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ShareNewsCenter, param)
end

function LWNewsCenterManager:ReplaceWikiLink(str)
  local pattern = ChatInterface.isDebug() and testPattern or onLinePattern
  local prefix, lang, tail = str:match(pattern)
  if prefix then
    return prefix .. "{0}/show/" .. tail
  end
  return nil
end

function LWNewsCenterManager:UpdateCacheData(uuid, info)
  if uuid and not self.cacheNewsInfo[uuid] then
    if info then
      local newsData = NewsCenterData.New(self)
      newsData:onParseServerData(info)
      self.cacheNewsInfo[info.uuid] = newsData
      if newsData.wikiChain then
        self:SetCacheChainNewsDict(newsData.wikiChain, newsData)
      end
    else
      self.cacheNewsInfo[uuid] = false
    end
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_CACHEUPDATE, uuid)
  end
end

function LWNewsCenterManager:GetCacheInfo(uuid, type)
  if self.cacheNewsInfo[uuid] ~= nil then
    return self.cacheNewsInfo[uuid]
  else
    if not type then
      return nil
    end
    local language = Localization:GetLanguage()
    local abbr = "en"
    for k, v in pairs(SuportedServerLanguagesLocalName) do
      if v == language then
        abbr = k
      end
    end
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.UserNewsCenter, uuid, type, abbr)
  end
  return nil
end

function LWNewsCenterManager:GetCacheInfoByWikiChain(wikiChain)
  local state = NewsChainDataState.None
  local data
  if self.cacheChainNewsDataStateDict[wikiChain] then
    state = self.cacheChainNewsDataStateDict[wikiChain]
    if state == NewsChainDataState.HaveData then
      data = self.cacheChainNewsSimpleDict[wikiChain]
    end
  end
  if state == NewsChainDataState.None then
    self:TryRequestNewsInfosBywikiChain(wikiChain)
  end
  return state, data
end

function LWNewsCenterManager:GetCacheInfoByUrlWiki(urlWiki)
  if string.IsNullOrEmpty(urlWiki) then
    return NewsChainDataState.None, nil
  end
  local wikiChain = StringUtils.GetMD5(urlWiki)
  return self:GetCacheInfoByWikiChain(wikiChain)
end

function LWNewsCenterManager:OnGetNewsInfosMsg(msgData)
  if msgData == nil or msgData.data == nil or msgData.data.newsInfo == nil then
    return
  end
  local newsInfo = msgData.data.newsInfo
  for i = 1, #newsInfo do
    local data = newsInfo[i]
    local wikiChain = data.wikiChain
    local uuid = data.uuid
    if wikiChain then
      if uuid == nil then
        self.cacheChainNewsDataStateDict[wikiChain] = NewsChainDataState.NoData
      else
        self.cacheChainNewsDataStateDict[wikiChain] = NewsChainDataState.HaveData
        local newsData = NewsCenterData.New(self)
        newsData:onParseServerData(data)
        self:SetCacheChainNewsDict(newsData.wikiChain, newsData)
      end
    end
  end
end

function LWNewsCenterManager:TryRequestNewsInfosBywikiChain(wikiChain)
  if self.cacheChainNewsDataStateDict[wikiChain] then
    return
  end
  self.cacheChainNewsDataStateDict[wikiChain] = NewsChainDataState.Requesting
  self:AddRequestWikiChain(wikiChain)
end

function LWNewsCenterManager:AddRequestWikiChain(wikiChain)
  table.insert(self.requestWikiChainList, wikiChain)
  self:TryAddRequestWikiChainUpdate()
end

function LWNewsCenterManager:TryAddRequestWikiChainUpdate()
  if self.lateUpdateReqTimer == nil then
    function self.lateUpdateReqTimer()
      self:RequestWikiChainUpdateFunc()
    end
    
    UpdateManager:GetInstance():AddLateUpdate(self.lateUpdateReqTimer)
  end
end

function LWNewsCenterManager:RemoveRequestWikiChainUpdate()
  if self.lateUpdateReqTimer then
    UpdateManager:GetInstance():RemoveLateUpdate(self.lateUpdateReqTimer)
    self.lateUpdateReqTimer = nil
  end
end

function LWNewsCenterManager:RequestWikiChainUpdateFunc()
  if #self.requestWikiChainList <= 0 then
    self:RemoveRequestWikiChainUpdate()
    return
  end
  local language = Localization:GetLanguage()
  local abbr = "en"
  for k, v in pairs(SuportedServerLanguagesLocalName) do
    if v == language then
      abbr = k
    end
  end
  local curListLen = #self.requestWikiChainList
  local md5Arry = {}
  local reqNum = math.min(curListLen, MsgReqMaxNum)
  for i = 1, reqNum do
    local md5Url = self.requestWikiChainList[i]
    table.insert(md5Arry, md5Url)
  end
  for i = 1, curListLen do
    local targetIndex = i + reqNum
    if curListLen < targetIndex then
      self.requestWikiChainList[i] = nil
    else
      self.requestWikiChainList[i] = self.requestWikiChainList[targetIndex]
    end
  end
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.UserQueryMultipleNews, md5Arry, abbr)
end

function LWNewsCenterManager:SetCacheChainNewsDict(wikiChain, newsData)
  self.cacheChainNewsSimpleDict[wikiChain] = newsData
  self.cacheChainNewsDataStateDict[wikiChain] = NewsChainDataState.HaveData
end

function LWNewsCenterManager:ResetData()
  self.newsDataDic = {}
  self.newsChainDic = {}
  self.newsAdd = {}
  self.maxNewsUidDic = {}
  self:InitNewsCenter(true)
end

function LWNewsCenterManager:GetConfigLanguage(lanKey)
  local language = Localization:GetLanguageName()
  return language
end

function LWNewsCenterManager:GetRedDotKey(tabType)
  return "NewsRedDotSetting" .. tabType
end

function LWNewsCenterManager:GetNotRedSetting(tabType)
  return CommonUtil.PlayerPrefsGetBool(self:GetRedDotKey(tabType), true)
end

function LWNewsCenterManager:GetCacheNewsType()
  return self.cacheNewsType
end

function LWNewsCenterManager:SetCacheNewsType(newsType)
  self.cacheNewsType = newsType
end

function LWNewsCenterManager:SetNotRedSetting(tabType, isOn)
  local curSetting = self:GetNotRedSetting(tabType)
  if curSetting ~= isOn then
    CommonUtil.PlayerPrefsSetBool(self:GetRedDotKey(tabType), isOn)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_REDDOTSETTING_UPDATA)
  end
end

function LWNewsCenterManager:OnOpenNewsCenterURL(data, openType)
  if openType == NewsCenterOpenType.Chat then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_CHATVIEW_OPENURL, data)
  elseif openType == NewsCenterOpenType.NoticeDetail then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_NOTICE_DETAIL_VIEW_OPENURL, data)
  elseif openType == NewsCenterOpenType.NoticeRecord then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_NOTICE_RECORD_VIEW_OPENURL, data)
  end
end

return LWNewsCenterManager
