local TranslateManager = BaseClass("TranslateManager")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local TRANS_CHANNEL = "lastwar"
local timeOut = 10
local count = 3
local StringUtils = CS.StringUtils
local UrlList = {
  "https://lastwar-us-translate.lastwargame.com/",
  "https://lastwar-translate-cf.lastwarapp.net/",
  "https://translate-lastwar-trans-llkvwlcehu.us-east-1.fcapp.run/"
}
local blackDic = {}
local testSpeedList = {}
local testTingDic = {}
local perUrlList = {}

function TranslateManager:GetTransUrlIndex()
  if 0 < #testSpeedList then
    return self:PickNextTestUrl()
  end
  if 0 < #perUrlList then
    return perUrlList[1].url
  end
  if table.count(blackDic) == #UrlList then
    self:InitRunningData()
    return self:PickNextTestUrl()
  end
  return self.defaultUrl
end

function TranslateManager:PickNextTestUrl()
  local url = table.remove(testSpeedList, 1)
  if url then
    testTingDic[url] = true
    return url
  end
  return self.defaultUrl
end

function TranslateManager:InitRunningData()
  blackDic = {}
  testTingDic = {}
  perUrlList = {}
  testSpeedList = {}
  testSpeedList = DeepCopy(UrlList)
end

function TranslateManager:__init()
  self.version = ChatInterface.getVersionName()
  self:InitRunningData()
  self:RefreshCircuit()
end

function TranslateManager:GetDefaultUrl()
  local LanguageType = CS.GameFramework.Localization.Language
  if Localization.Language == LanguageType.Russian then
    return UrlList[3]
  else
    return UrlList[1]
  end
end

function TranslateManager:RefreshCircuit()
  self.defaultUrl = self:GetDefaultUrl()
  self.curUrl = self:GetDefaultUrl()
  self:ClearDatas()
end

function TranslateManager:ClearDatas()
  self.transResultCache = {}
  self.transDic = {}
  self.transId = 0
end

function TranslateManager:GetLangString(str)
  str = str or ""
  if str == "zh-CN" or str == "zh_CN" or str == "zh-Hans" or str == "zh-CHS" or str == "cn" then
    return "zh-Hans"
  elseif str == "zh-TW" or str == "zh_TW" or str == "zh-Hant" or str == "zh-CHT" or str == "tw" then
    return "zh-Hant"
  end
  return str
end

function TranslateManager:tag_private_use_chars(text)
  local result = {}
  for _, code in utf8.codes(text) do
    local char = utf8.char(code)
    if code >= lwEmojiScope.uncodeStart and code <= lwEmojiScope.uncodeEnd then
      table.insert(result, string.format("<span class=\"notranslate\">%s</span>", char))
    else
      table.insert(result, char)
    end
  end
  return table.concat(result)
end

function TranslateManager:RemoveEmojiCode(text)
  return text:gsub("\238[\128-\191][\128-\191]", "")
end

function TranslateManager:MakePostParam(srcLang, targetLang, content, userLang, transType, roomGroupType, oLang)
  local tarL = self:GetLangString(targetLang)
  if string.IsNullOrEmpty(tarL) then
    Logger.LogError("\231\191\187\232\175\145\231\155\174\230\160\135\232\175\173\232\168\128\228\184\186\231\169\186!" .. tostring(targetLang))
  end
  local oriL = srcLang
  local pUid = ChatInterface.getPlayerUid()
  local sid = ChatInterface.getSelfServerId()
  local ui = pUid .. "," .. sid .. "," .. self.version
  local translateKey = ChatInterface.getTranslateKey()
  local gs = "0"
  if CS.SDKManager.IS_UNITY_EDITOR() or CommonUtil.IsGrayServer() then
    gs = "1"
  end
  local channel = TRANS_CHANNEL
  local ul = ""
  if userLang ~= nil then
    ul = tostring(userLang)
  end
  local trans = ""
  if transType ~= nil then
    trans = tostring(transType)
  end
  local t = {}
  t.sc = tostring(content)
  t.sf = tostring(oriL)
  t.ol = tostring(oLang)
  t.tf = tostring(tarL)
  t.ch = tostring(channel)
  t.ui = tostring(ui)
  t.scene = tostring(channel)
  t.uid = tostring(pUid)
  t.tk = tostring(translateKey)
  t.gs = tostring(gs)
  t.ul = ul
  t.type = trans
  if roomGroupType ~= nil then
    t.roomGroupType = roomGroupType
  end
  return t
end

function TranslateManager:SetTestIsOn()
  self.test = not self.test
  if self.test then
    Logger.LogError("\231\186\191\232\183\175\229\133\168\233\131\168\229\164\177\232\180\165\229\183\178\229\188\128\229\144\175")
    return
  end
  Logger.LogError("\231\186\191\232\183\175\229\133\168\233\131\168\229\164\177\232\180\165\229\183\178\229\133\179\233\151\173")
end

function TranslateManager:Translate(srcText, srcLang, tarlang, callback, userLang, transType, roomGroupType, oLang)
  local srcLang = srcLang or ""
  local oLang = oLang or ""
  local tarLang = self:GetSettingTransLanguage()
  local transText = self:RemoveEmojiCode(srcText)
  local notEmojiText = StringUtils.GetNotEmojiText(transText)
  if string.IsNullOrEmpty(notEmojiText) then
    callback("ok", {
      translateMsg = srcText,
      targetLang = self:GetLangString(tarLang),
      disableRefresh = 1,
      code = 0
    })
    return
  else
    srcText = transText
  end
  local urlParams = self:MakePostParam(srcLang, tarLang, srcText, userLang, transType, roomGroupType, oLang)
  self.transId = self.transId + 1
  self.transDic[self.transId] = {
    count = 1,
    params = urlParams,
    url = self.curUrl
  }
  self:GoTranslate(urlParams, callback, self.transId)
end

function TranslateManager:Contains(list, value)
  for index, v in ipairs(list) do
    if v.url == value then
      return index
    end
  end
  return false
end

function TranslateManager:GoTranslate(urlParams, callback, transId)
  local startTime = UITimeManager:GetInstance():GetServerTime()
  transId = tonumber(transId)
  if string.IsNullOrEmpty(urlParams.tf) then
    Logger.LogError("\231\191\187\232\175\145\231\155\174\230\160\135\232\175\173\232\168\128\228\184\186\231\169\186!")
    if callback then
      callback(false, nil)
    end
    return
  end
  self.curUrl = self:GetTransUrlIndex()
  local url = self.curUrl
  local transData = self.transDic[transId]
  if transData then
    transData.url = url
  end
  CS.ChatService.Instance:RequestTranslate(url, urlParams, function(ok, jsonStr, backTransId)
    local endTime = UITimeManager:GetInstance():GetServerTime()
    local time = math.floor(endTime - startTime)
    local backId = tonumber(backTransId)
    local data = self.transDic[backId]
    if ok == "false" then
      if data and data.url then
        blackDic[data.url] = true
        testTingDic[data.url] = nil
        local idx = self:Contains(perUrlList, data.url)
        if idx then
          table.remove(perUrlList, idx)
        end
        if data.count and data.count < count then
          data.count = data.count + 1
          self:GoTranslate(data.params, callback, backId)
        elseif callback then
          callback(false, nil)
        end
      elseif callback then
        callback(false, nil)
      end
      return
    end
    self.transDic[backId] = nil
    local rtnTbl
    if not string.IsNullOrEmpty(jsonStr) then
      rtnTbl = rapidjson.decode(jsonStr)
      if rtnTbl and rtnTbl.translateMsg then
        rtnTbl.translateMsg = string.gsub(rtnTbl.translateMsg, "&#39;", "'")
      end
    end
    if data and data.url and testTingDic[data.url] then
      testTingDic[data.url] = nil
      if not self:Contains(perUrlList, data.url) then
        table.insert(perUrlList, {
          url = data.url,
          speed = time
        })
        table.sort(perUrlList, function(a, b)
          return a.speed < b.speed
        end)
      end
    end
    if callback then
      callback(true, rtnTbl)
    end
    if data and data.url then
      PostEventLog.Track(PostEventLog.Defines.TranslationUrl, {
        succeed = ok,
        url = data.url
      })
      if startTime and endTime then
        PostEventLog.Track(PostEventLog.Defines.TranslationSpeed, {
          milliscond = time,
          url = data.url
        })
      end
    end
  end, timeOut, tostring(transId))
end

function TranslateManager:GetSettingTransLanguage()
  local language = self:GetChatTranslateLanguage()
  language = LanageAbbr[language]
  if string.IsNullOrEmpty(language) then
    language = LanageAbbr[Language.English]
  end
  return language
end

function TranslateManager:TranslateLang(chatData)
  local userLang = ""
  local sender = chatData:getSenderInfo()
  if sender then
    userLang = sender.lang
  end
  local hasAt, msg, map = self:FilterAtChatMessage(chatData)
  local roomGreoupType = chatData.group
  if chatData.post == PostType.Text_AllianceNotice then
    roomGreoupType = FakeChatGroupType.Fake_GROUP_ALLIANCE_NOTICE
  end
  local oLang
  if chatData.extra then
    oLang = chatData.extra.srcLang
  end
  self:Translate(msg, chatData.originalLang, "", function(ok, data)
    if hasAt and data and data.translateMsg then
      data.translateMsg = self:FixAtChatMessgae(data.translateMsg, map)
    end
    self:onTranslateCallback(chatData, ok, data)
  end, userLang, chatData:GetTranslateType(), roomGreoupType, oLang)
end

function TranslateManager:FilterAtChatMessage(chatData)
  local map = {}
  local msg = chatData:GetNeedTranslateText()
  local code = lwAtTranslateScope.uncodeStart
  if chatData.extra and not table.IsNullOrEmpty(chatData.extra.atPlayers) then
    for _, v in ipairs(chatData.extra.atPlayers) do
      local char = utf8.char(code)
      msg = string.gsub(msg, v.name, char, 1)
      map[char] = v.name
      code = code + 1
    end
  end
  return next(map) ~= nil, msg, map
end

function TranslateManager:FixAtChatMessgae(msg, map)
  for k, v in pairs(map) do
    msg = string.gsub(msg, k, v, 1)
  end
  return msg
end

function TranslateManager:onTranslateCallback(chatData, ok, data)
  local ret = false
  if not data or data.code ~= 0 then
  else
    chatData.translateMsg = data.translateMsg
    chatData.translatedLang = data.targetLang
    chatData:SetCanRefreshTranslate(data.disableRefresh or 0)
    local roomId = chatData.roomId
    local msgSeqId = chatData.seqId
    local roomData = self.transResultCache[roomId]
    if roomData == nil then
      roomData = {}
      self.transResultCache[roomId] = roomData
    end
    roomData[msgSeqId] = {
      msg = data.translateMsg,
      lang = data.targetLang,
      canRefreshTrans = chatData:GetCanRefreshTranslate(),
      transJson = data
    }
    ret = true
  end
  local transState = -1
  if ret == true then
    transState = 2
    chatData:setTranslationMsg(chatData.translateMsg)
  else
    transState = -1
  end
  chatData:setTranslateState(transState)
  chatData:UpdateTransJson(data)
  local roomData = self.transResultCache[chatData.roomId]
  if roomData and roomData[chatData.seqId] then
    roomData[chatData.seqId].transState = transState
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UPDATE_ROOM_MSG, chatData)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ON_TRANSLATION_FINISH, chatData)
end

function TranslateManager:EasterEggDoTranslate(transData)
  if string.IsNullOrEmpty(transData:GetTranslateMsg()) or transData:GetTranslateType() ~= nil or transData:GetTranslatedLang() ~= ChatInterface.GetChatTranslateLanguageAbbr() then
    self:Translate(transData:GetSourceMsg(), "", "", function(ok, data)
      self:OnEasterEggTranslateCallback(transData, ok, data)
    end, transData:GetSourceLang(), transData:GetTranslateType())
  end
end

function TranslateManager:NewsCenterTranslate(newsData)
  if string.IsNullOrEmpty(newsData:GetTranslateMsg()) or newsData:GetTranslateType() ~= nil or newsData:GetTranslatedLang() ~= ChatInterface.GetChatTranslateLanguageAbbr() then
    self:Translate(newsData.title, "", "", function(ok, data)
      self:OnNewsCenterCallBack(newsData, ok, data)
    end, "", newsData:GetTranslateType())
  end
end

function TranslateManager:OnNewsCenterCallBack(newsData, ok, data)
  local ret
  if not data or data.code ~= 0 then
  else
    newsData:SetTranslateMsg(data.translateMsg)
    newsData:SetTranslatedLang(data.targetLang)
    newsData:SetCanRefreshTranslate(data.disableRefresh or 0)
    ret = true
  end
  local transState = -1
  if ret == true then
    transState = 2
    newsData:SetTranslateMsg(data.translateMsg)
  else
    transState = -1
  end
  newsData:SetTranslateState(transState)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_FINISHED, newsData)
end

function TranslateManager:OnEasterEggTranslateCallback(transData, ok, data)
  local ret = false
  if not data or data.code ~= 0 then
  else
    transData:SetTranslateMsg(data.translateMsg)
    transData:SetTranslatedLang(data.targetLang)
    transData:SetCanRefreshTranslate(data.disableRefresh or 0)
    ret = true
  end
  local transState = -1
  if ret == true then
    transState = 2
    transData:SetTranslateMsg(data.translateMsg)
  else
    transState = -1
  end
  transData:SetTranslateState(transState)
  EventManager:GetInstance():Broadcast(ChatEventEnum.EasterEggChatTranslateFinished, transData)
end

function TranslateManager:DoTranslate(chatData)
  if string.IsNullOrEmpty(chatData.translateMsg) or chatData:GetTranslateType() ~= nil or chatData.translatedLang ~= ChatInterface.GetChatTranslateLanguageAbbr() then
    ChatPrint("\229\142\187\230\156\141\229\138\161\229\153\168\231\191\187\232\175\145")
    self:TranslateLang(chatData)
  end
end

function TranslateManager:UpdateTranslateInfo(chatData)
  local roomId = chatData.roomId
  local msgSeqId = chatData.seqId
  local roomData = self.transResultCache[roomId]
  if roomData ~= nil then
    local data = roomData[msgSeqId]
    if data ~= nil then
      chatData.translateMsg = data.msg
      chatData.translatedLang = data.lang
      chatData:setTranslateState(data.transState)
      chatData:SetCanRefreshTranslate(data.canRefreshTrans)
      chatData:UpdateTransJson(data.transJson)
    end
  end
end

function TranslateManager:SetChatTranslateLanguage(language)
  if self.chatTranslateLanguage ~= language then
    CommonUtil.PlayerPrefsSetInt("chatTranslateLanguage", language)
    self.chatTranslateLanguage = language
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TRANSLATE_SETTING)
  end
end

function TranslateManager:GetChatTranslateLanguage()
  if not self.chatTranslateLanguage then
    self.chatTranslateLanguage = CommonUtil.PlayerPrefsGetInt("chatTranslateLanguage", -1)
  end
  if self.chatTranslateLanguage < 0 then
    self.chatTranslateLanguage = Localization:GetLanguage()
  end
  return self.chatTranslateLanguage
end

return TranslateManager
