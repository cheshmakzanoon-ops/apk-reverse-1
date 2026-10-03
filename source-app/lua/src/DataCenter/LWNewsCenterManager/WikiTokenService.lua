local WikiTokenService = BaseClass("WikiTokenService")
local rapidjson = require("rapidjson")
local ChatService = CS.ChatService.Instance
local urlParam = {
  onlineHost = {
    "https://wiki-cf-api.lastwarapp.net/",
    "https://wiki-aws-api.lastwar.com/"
  },
  testHost = {
    "https://wiki-api-test.lastwar.com/"
  }
}
local wikiApi = {
  getListApi = "api/game/article/list",
  shareCountApi = "api/game/article/share"
}
local TOKEN_REFRESH_THRESHOLD = 8

function WikiTokenService:__init()
  self.wikiToken = nil
  self.tokenInfo = nil
  self.requestingToken = false
  self.curLineIndex = 1
  self._waitCallbacks = {}
  self.hostList = ChatInterface.isOnline() and urlParam.onlineHost or urlParam.testHost
  self.wikiHost = self.hostList[self.curLineIndex]
end

function WikiTokenService:WithToken(callback)
  if self:GetToken() then
    callback(self.wikiToken)
    return
  end
  table.insert(self._waitCallbacks, callback)
end

function WikiTokenService:_FlushWaitCallbacks()
  if not self._waitCallbacks or #self._waitCallbacks == 0 then
    return
  end
  local list = self._waitCallbacks
  self._waitCallbacks = {}
  for _, cb in ipairs(list) do
    cb(self.wikiToken)
  end
end

function WikiTokenService:SetToken(msg)
  self.requestingToken = false
  if msg.errorCode and msg.errorCode ~= 0 then
    UIUtil.ShowErrorCodeTips(msg)
    return
  end
  self.tokenInfo = msg
  self.wikiToken = msg.token
  self:_FlushWaitCallbacks()
  EventManager:GetInstance():Broadcast(EventId.WIKI_TOKEN_READY)
end

function WikiTokenService:GetToken(bypassCheck)
  if bypassCheck then
    return self.wikiToken
  end
  if not self.wikiToken then
    self:_RequestTokenIfNeeded("no token")
    return nil
  end
  if not self.tokenInfo or not self.tokenInfo.exp then
    self:_RequestTokenIfNeeded("missing exp")
    return nil
  end
  local now = UITimeManager:GetInstance():GetServerTime() / 1000
  local timeLeft = self.tokenInfo.exp - now
  if timeLeft < TOKEN_REFRESH_THRESHOLD then
    self:_RequestTokenIfNeeded("expiring")
    return nil
  end
  return self.wikiToken
end

function WikiTokenService:_RequestTokenIfNeeded(reason)
  if self.requestingToken then
    return
  end
  self.requestingToken = true
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.CreateWikiToken)
end

function WikiTokenService:Request(apiPath, paramTable, onResponse, retry, startIndex)
  retry = math.max(retry or 0, 0)
  local hostCount = #self.hostList
  if hostCount == 0 then
    if onResponse then
      onResponse(false, "no host")
    end
    return
  end
  startIndex = startIndex or self.curLineIndex or 1
  if startIndex < 1 or hostCount < startIndex then
    startIndex = 1
  end
  local index = (startIndex + retry - 1) % hostCount + 1
  local host = self.hostList[index]
  self:WithToken(function(token)
    if not token then
      if onResponse then
        onResponse(false, "no token")
      end
      return
    end
    local url = host .. apiPath
    local json = rapidjson.encode(paramTable or {})
    local headers = {Authorization = token}
    ChatService:RequestWiki(url, json, function(ok, jsonStr)
      local success = ok == true or ok == "true"
      if success then
        self.curLineIndex = index
        if onResponse then
          onResponse(true, jsonStr)
        end
        return
      end
      if retry + 1 < hostCount then
        self:Request(apiPath, paramTable, onResponse, retry + 1, startIndex)
      elseif onResponse then
        onResponse(false, jsonStr)
      end
    end, 15, headers)
  end)
end

function WikiTokenService:RequestLike(url, callback)
  self:Request(wikiApi.shareCountApi, {url = url}, callback)
end

function WikiTokenService:RequestArticleList(urls, callback)
  self:Request(wikiApi.getListApi, {urls = urls}, callback)
end

return WikiTokenService
