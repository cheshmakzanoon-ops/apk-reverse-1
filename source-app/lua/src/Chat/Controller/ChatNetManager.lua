local ChatNetManager = BaseClass("ChatNetManager")
local rapidjson = require("rapidjson")
local ChatService = CS.ChatService.Instance
local Network = CS.GameEntry.Network
local AESHelper = CS.AESHelper
local CHAT_APP_ID = "100017"
local WS_SERVER_LIST_URL = "http://10.7.88.22:8082/server/links"
local WS_SERVER_LIST_URLLIST = {
  "http://10.7.88.22:8082/server/links"
}
local urlFormat = "https://%s/chatservice/status"
local testNewGetServerListLine = {}
local msgSginMsgList = {
  [ChatMsgDefines.ChatRoom] = true
}
local CONNECT_NONE = 0
local CONNECT_REQUEST = 1
local CONNECT_OPENING = 2
local CONNECT_OPENED = 3
local CONNECT_RUNNING = 4
local CONNECT_CLOSEING = 5
local CONNECT_CLOSED = 6
local ChatMsgMapType = {}

local function GetMsgType(cmd)
  local msgType = ChatMsgMapType[cmd]
  if type(msgType) ~= "table" then
    local msgTypePath = ChatMsgMap[cmd]
    if msgTypePath ~= nil then
      local loaded = require(msgTypePath)
      if type(loaded) == "table" then
        msgType = loaded
        ChatMsgMapType[cmd] = msgType
      else
        Logger.LogWarning("[\232\173\166\229\145\138] \230\168\161\229\157\151\229\138\160\232\189\189\229\164\177\232\180\165\233\157\158 table \231\177\187\229\158\139\239\188\129cmd = " .. tostring(cmd) .. "\239\188\140\231\177\187\229\158\139\228\184\186 " .. type(loaded))
        CS.GameEntry.DebugLuaFile(msgTypePath)
      end
    end
  end
  return msgType
end

local WebSocketCImpl = {}

function WebSocketCImpl:Connect(p, ip, port)
  if self.c then
    self.c:connect(p, ip, port)
  else
    ChatPrint("WebSocketCImpl:Connect not ready")
  end
end

function WebSocketCImpl:IsOpen()
  if self.c then
    return self.c:is_connect()
  else
    ChatPrint("WebSocketCImpl:IsOpen not ready")
    return false
  end
end

function WebSocketCImpl:SendLuaMessage(json)
  if self.c then
    self.c:send(json)
  else
    ChatPrint("WebSocketCImpl:SendLuaMessage not ready")
  end
end

function WebSocketCImpl:SendLuaTable(tbl)
  if self.c then
    self.c:sendtable(tbl)
  else
    ChatPrint("WebSocketCImpl:SendLuaTable not ready")
  end
end

function WebSocketCImpl:Disconnect()
  if self.c then
    self.c:close()
    self.c = nil
  end
end

function ChatNetManager:__onRequest(param)
  self:__setStatus(CONNECT_NONE)
  local respon
  if not string.IsNullOrEmpty(param) then
    respon = rapidjson.decode(param)
  end
  if respon == nil then
    ChatPrint("__onRequest but param is empty?")
    Logger.LogInfo(string.format("ChatGetServerListError decodeFail param=%s retry=%s url=%s requestIndex=%s", tostring(param), tostring(self.request_no), tostring(WS_SERVER_LIST_URL), tostring(self.requestIndex)))
    __ChatPostBI(ChatBIEnum.IM_GET_SERVER_LIST_ERROR, {
      error = param,
      times = self.request_no,
      url = WS_SERVER_LIST_URL
    })
    self:__doRetryRequest()
    return
  end
  self.requestList = respon
  if respon.code == 1 then
    __ChatPostBI(ChatBIEnum.IM_GET_SERVER_LIST_SUCCESS, {
      times = self.request_no,
      url = WS_SERVER_LIST_URL
    })
    self:Connect()
  else
    Logger.LogInfo(string.format("ChatGetServerListRefuse code=%s retry=%s url=%s requestIndex=%s response=%s", tostring(respon.code), tostring(self.request_no), tostring(WS_SERVER_LIST_URL), tostring(self.requestIndex), tostring(param)))
    __ChatPostBI(ChatBIEnum.IM_GET_SERVER_LIST_REFUSE, {
      code = respon.code,
      times = self.request_no,
      url = WS_SERVER_LIST_URL
    })
    self:__doRetryRequest()
  end
end

function ChatNetManager:__onOpen(param)
  self:__setStatus(CONNECT_OPENED)
  local currentServer = self:GetCurLineInfo()
  Logger.LogInfo(string.format("ChatConnectOpen retry=%s wsLineIndex=%s protocol=%s ip=%s port=%s param=%s", tostring(self.connect_no), tostring(self.wsLineIndex), tostring(currentServer and currentServer.protocol), tostring(currentServer and currentServer.ip), tostring(currentServer and currentServer.port), tostring(param)))
  if currentServer then
    __ChatPostBI(ChatBIEnum.IM_CONNECT_AND_LOGIN_SUCCESS, {
      times = self.connect_no,
      protocol = currentServer.protocol,
      ip = currentServer.ip,
      port = currentServer.port
    })
  else
    __ChatPostBI(ChatBIEnum.IM_CONNECT_AND_LOGIN_SUCCESS, {
      times = self.connect_no
    })
  end
end

function ChatNetManager:__onClose(param)
  ChatPrint("onClose")
  if self.connect_status == CONNECT_RUNNING then
    local currentServer = self:GetCurLineInfo()
    Logger.LogInfo(string.format("ChatConnectClose status=%s retry=%s wsLineIndex=%s protocol=%s ip=%s port=%s reason=%s", tostring(self.connect_status), tostring(self.connect_no), tostring(self.wsLineIndex), tostring(currentServer and currentServer.protocol), tostring(currentServer and currentServer.ip), tostring(currentServer and currentServer.port), tostring(param)))
    ChatManager2:GetInstance():onErrorOrDisconnect(param)
  end
  self:__setStatus(CONNECT_CLOSED)
  self:__doRetryConnect()
end

function ChatNetManager:__onError(param)
  if self.connect_status == CONNECT_OPENING then
    local currentServer = self:GetCurLineInfo()
    Logger.LogInfo(string.format("ChatConnectError status=%s lastStatus=%s retry=%s wsLineIndex=%s protocol=%s ip=%s port=%s error=%s", tostring(self.connect_status), tostring(self.lastStatus), tostring(self.connect_no), tostring(self.wsLineIndex), tostring(currentServer and currentServer.protocol), tostring(currentServer and currentServer.ip), tostring(currentServer and currentServer.port), tostring(param)))
    __ChatPostBI(ChatBIEnum.IM_CONNECT_AND_LOGIN_ERROR, {
      times = self.connect_no,
      error = param,
      protocol = currentServer.protocol,
      ip = currentServer.ip,
      port = currentServer.port
    })
  elseif self.connect_status == CONNECT_RUNNING then
    ChatManager2:GetInstance():onErrorOrDisconnect()
  end
  self.lastStatus = self.connect_status
  self:__setStatus(CONNECT_CLOSED)
  self:__doRetryConnect()
end

function ChatNetManager:__onMessage(param)
  local data = rapidjson.decode(param)
  self:__onMessageTable(data)
end

function ChatNetManager:__onMessageTable(tbl)
  self:__setStatus(CONNECT_RUNNING)
  local cmd = tbl.cmd
  ChatPrint("websocket push : " .. cmd)
  if cmd ~= nil then
    local msgType = GetMsgType(cmd)
    if msgType ~= nil then
      local msg = msgType:NewEmpty()
      msg:HandleMessage(tbl)
    end
    if ChatBI_CmdWhiteList[cmd] then
      __ChatPostBI(ChatBIEnum.IM_COMMAND_BACK, {cmd = cmd})
    end
  end
end

function ChatNetManager:__doRetryRequest()
  if self.retryTimer ~= nil then
    ChatPrint("Already in retry!")
    return
  end
  self.retryTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.retryTimer = nil
    self:RequestServerList()
  end, 3)
end

function ChatNetManager:__doRetryConnect()
  if self.do_retry == false then
    ChatPrint("not do retry!")
    return
  end
  if self.retryTimer ~= nil then
    ChatPrint("Already in retry!")
    return
  end
  self.retryTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.retryTimer = nil
    if self.lastStatus ~= CONNECT_OPENED and self.lastStatus ~= CONNECT_RUNNING then
      self.wsLineIndex = self.wsLineIndex + 1
      if self.wsLineIndex > #self.requestList.data then
        self.wsLineIndex = 1
      end
    end
    self:Connect()
  end, 3)
end

function ChatNetManager:__stopRetryTimer()
  if self.retryTimer then
    self.retryTimer:Stop()
    self.retryTimer = nil
  end
end

function ChatNetManager:__stopReqTimer()
  if self.req_timer then
    self.req_timer:Stop()
    self.req_timer = nil
  end
end

function ChatNetManager:__init()
  self.request_no = 0
  self.connect_no = 0
  self.requestIndex = 0
  self.wsLineIndex = 0
  self.requestList = nil
  self.cur_server = 1
  self.connect_status = CONNECT_NONE
  self.req_timer = nil
  self.retry_timer = nil
  self.do_retry = false
  self.WebSocketInst = ChatService
  self.token = ""
end

function ChatNetManager:InitWebSocketInst()
  if LuaEntry.WebSocket == nil then
    self.WebSocketInst = ChatService
    return
  end
  self.WebSocketInst = WebSocketCImpl
  if WebSocketCImpl.c then
    ChatPrint("WebSocketCImpl:Init already connect!!!")
    WebSocketCImpl.c:close()
  end
  local c = LuaEntry.WebSocket.create()
  if c == nil then
    return false
  end
  local time = ChatInterface.getServerTime()
  local uid = ChatInterface.getPlayerUid()
  local sign = cutils.CalcChatSign(CHAT_APP_ID, uid, time)
  c:addheader("APPID", CHAT_APP_ID)
  c:addheader("TIME", tostring(time))
  c:addheader("UID", uid)
  c:addheader("SIGN", sign)
  c:setdelegate(function(e, p, no)
    self:__onCallback(e, p, no)
  end)
  c:setrecvtable()
  c:enableping(20)
  c:autoclose(45)
  WebSocketCImpl.c = c
  return true
end

function ChatNetManager:SetToken(token)
  if token ~= nil and token ~= "" then
    self.token = token
  end
end

function ChatNetManager:ConnectWS(urlIndex)
  self.wsLineIndex = urlIndex
  local currentServer = self.requestList.data[self.wsLineIndex]
  if currentServer == nil then
    Logger.LogWarning("ChatNetManager : currentServer \228\184\186 nil, urlIndex=" .. tostring(urlIndex))
    if self.requestList.data then
      Logger.LogWarning("ChatNetManager : \229\176\157\232\175\149 fallback \229\136\176\231\172\172\228\184\128\228\184\170 server, data \233\149\191\229\186\166 = " .. tostring(#self.requestList.data) .. "  select urlIndex  = " .. tostring(urlIndex))
    end
    currentServer = self.requestList.data[1]
  end
  if currentServer == nil then
    Logger.LogError("ChatNetManager : currentServer \228\190\157\231\132\182\230\152\175 nil, \230\151\160\230\179\149\232\191\158\230\142\165")
    return
  end
  self.WebSocketInst:Connect(currentServer.protocol, currentServer.ip, currentServer.port, self.token)
  __ChatPostBI(ChatBIEnum.IM_CONNECT_AND_LOGIN_REQUEST, {
    times = self.connect_no,
    protocol = currentServer.protocol,
    ip = currentServer.ip,
    port = currentServer.port
  })
end

function ChatNetManager:OnRequestComplete(i, url, request, hasErr)
  if not request.isDone then
    return
  end
  local urlList = self.requestList.data
  if hasErr or request.responseCode ~= 200 then
    self.chooseCount = self.chooseCount + 1
    if self.chooseCount == #urlList and self.wsLineIndex == 0 then
      self:ConnectWS(1)
    end
    return
  end
  if self.wsLineIndex == 0 then
    self.wsLineIndex = i
    self:ConnectWS(i)
  end
end

function ChatNetManager:ChooseLine()
  local urlList = self.requestList.data
  self.chooseCount = 0
  self.wsLineIndex = 0
  for i = 1, #urlList do
    local ip = urlList[i].ip
    local url = string.format(urlFormat, ip)
    CS.GameKit.Base.WebRequestManager.Instance:Get(url, function(request, hasErr)
      self:OnRequestComplete(i, url, request, hasErr)
    end, 0, 5, nil)
  end
end

function ChatNetManager:Connect()
  if self.connect_status == CONNECT_OPENING then
    ChatPrint("already in connect!")
    Logger.LogError("ChatServer connection fail ! already in connect!")
    return
  end
  if self.requestList == nil or self.requestList.data == nil or #self.requestList.data == 0 then
    ChatPrint("no connect data!")
    Logger.LogError("ChatServer connection fail ! no connect data!")
    return
  end
  self:InitWebSocketInst()
  self:__setStatus(CONNECT_OPENING)
  self.do_retry = true
  self.connect_no = self.connect_no + 1
  if 0 < self.wsLineIndex then
    self:ConnectWS(self.wsLineIndex)
  else
    self:ChooseLine()
  end
end

function ChatNetManager:IsRunning()
  return self.connect_status == CONNECT_RUNNING
end

function ChatNetManager:IsConnect()
  return self.WebSocketInst:IsOpen()
end

function ChatNetManager:__setStatus(status)
  self.connect_status = status
  ChatPrint("set status : %d", status)
end

function ChatNetManager:Init(gameuid)
  ChatPrint("ChatNetManager:Init %s", tostring(gameuid))
  if ChatInterface.IsPressureTest() then
    CHAT_APP_ID = "100017"
    WS_SERVER_LIST_URL = "https://yace-lastwar-serverlist-va-ali.lastwargame.com/gameservice/chat_server_links.php"
    WS_SERVER_LIST_URLLIST = {
      "https://yace-lastwar-serverlist-va-ali.lastwargame.com/gameservice/chat_server_links.php"
    }
    urlFormat = "https://%s/chatservice/status"
  elseif ChatInterface.isAwsURL() then
    CHAT_APP_ID = "100017"
    WS_SERVER_LIST_URL = "https://yace-lastwar-serverlist-va-ali.lastwargame.com/gameservice/chat_server_links.php"
    WS_SERVER_LIST_URLLIST = {
      "https://yace-lastwar-serverlist-va-ali.lastwargame.com/gameservice/chat_server_links.php"
    }
    urlFormat = "https://%s/chatservice/status"
  elseif ChatInterface.isDebug() then
    CHAT_APP_ID = "100017"
    WS_SERVER_LIST_URL = "http://lw-local-gm.gamespark.net:8988/gameservice/chat_server_links.php"
    WS_SERVER_LIST_URLLIST = {}
    local server = ChatInterface.getPlayerServerId()
    if server == 296 then
      table.insert(WS_SERVER_LIST_URLLIST, "http://lw-gaonannan.gamespark.net:8082/server/links")
    elseif server == 107 then
      table.insert(WS_SERVER_LIST_URLLIST, "http://lw-antaihong.gamespark.net:8082/server/links")
    else
      table.insert(WS_SERVER_LIST_URLLIST, "http://lw-local-gm.gamespark.net:8988/gameservice/chat_server_links.php")
    end
    urlFormat = "http://%s:8020/chatservice/status"
  elseif CS.GameEntry.GlobalData:isChina() then
    CHAT_APP_ID = "100017"
    WS_SERVER_LIST_URL = "http://lw-local-chat.gamespark.net:8082/server/links"
    WS_SERVER_LIST_URLLIST = {
      "http://lw-local-chat.gamespark.net:8082/server/links"
    }
  else
    CHAT_APP_ID = "100017"
    if LuaEntry.DataConfig:CheckSwitch("CheckChatNewLine") then
      WS_SERVER_LIST_URL = "https://lastwar-serverlist-cf.lastwarapp.net/gameservice/chat_server_links.php"
      WS_SERVER_LIST_URLLIST = {
        "https://lastwar-serverlist-cf.lastwarapp.net/gameservice/chat_server_links.php",
        "https://lastwar-serverlist-us-aws-ali.lastwargame.com/gameservice/chat_server_links.php",
        "https://lastwar-serverlist-us-gcp-ali.lastwargame.com/gameservice/chat_server_links.php"
      }
    else
      WS_SERVER_LIST_URL = "https://lastwar-chat-cf.lastwarapp.net/server/links"
      WS_SERVER_LIST_URLLIST = {
        "https://lastwar-chat-cf.lastwarapp.net/server/links",
        "https://lastwar-chat-us-aws-ali.lastwargame.com/server/links",
        "https://lastwar-chat-us-gcp-ali.lastwargame.com/server/links"
      }
    end
    urlFormat = "https://%s/chatservice/status"
  end
  ChatService:Init(CHAT_APP_ID, gameuid, function(e, p, no)
    self:__onCallback(e, p, no)
  end)
  self:RequestServerList()
end

function ChatNetManager:Uninit()
  ChatPrint("ChatNetManager:Uninit")
  self:CloseWebSocket()
  ChatService:Uninit()
end

function ChatNetManager:__onCallback(e, p, no)
  ChatPrint("[callback] (%d) - %s", no or 0, e)
  if e == "onMessage" then
    self:__onMessage(p)
  elseif e == "onMessageTable" then
    self:__onMessageTable(p)
  elseif e == "onRequest" then
    self:__onRequest(p)
  elseif e == "onOpen" then
    self:__onOpen(p)
  elseif e == "onClose" then
    self:__onClose(p)
  elseif e == "onError" then
    self:__onError(p)
  elseif e == "OnNewServerLineRequest" then
    self:OnNewServerLineRequest(p)
  else
    ChatPrint("ChatManager2:Init ???" .. e)
  end
end

function ChatNetManager:areServerListsEqual(list1, list2)
  if not list1 or not list2 then
    return false
  end
  if #list1 ~= #list2 then
    return false
  end
  
  local function makeKey(item)
    return tostring(item.ip) .. ":" .. tostring(item.port) .. ":" .. tostring(item.protocol)
  end
  
  local set1 = {}
  for _, v in ipairs(list1) do
    local key = makeKey(v)
    set1[key] = (set1[key] or 0) + 1
  end
  for _, v in ipairs(list2) do
    local key = makeKey(v)
    if not set1[key] then
      return false
    end
    set1[key] = set1[key] - 1
    if set1[key] == 0 then
      set1[key] = nil
    end
  end
  return true
end

function ChatNetManager:OnNewServerLineRequest(param)
  if param == nil or param == "" then
    return
  end
  local success, respon = pcall(rapidjson.decode, param)
  if not success or not respon then
    Logger.LogWarning(string.format("ChatServerListTestDecodeFail testUrl=%s param=%s", tostring(testNewGetServerListLine and testNewGetServerListLine[self.requestIndex]), tostring(param)))
    return
  end
  if respon.code == 1 then
    local testRequestListData = respon.data or {}
    local requestListData = self.requestList and self.requestList.data or {}
    local isFull = self:areServerListsEqual(testRequestListData, requestListData)
    if not isFull then
      local originJson = ""
      local successEncode, encoded = pcall(rapidjson.encode, self.requestList)
      if successEncode then
        originJson = encoded
      end
      Logger.LogWarning(string.format("ChatServerListDiff requestIndex=%s  testUrl=%s  - >  originUrl=%s  ||  testParam=%s  ->  originParam=%s", tostring(self.requestIndex), tostring(testNewGetServerListLine and testNewGetServerListLine[self.requestIndex]), tostring(WS_SERVER_LIST_URL), tostring(param), tostring(originJson)))
    end
  end
end

function ChatNetManager:GetUrlIndex(type)
  if not string.IsNullOrEmpty(type) then
    local urlType
    for i = 1, #WS_SERVER_LIST_URLLIST do
      urlType = ChatInterface.GetUrlType(WS_SERVER_LIST_URLLIST[i])
      if urlType == type then
        return i
      end
    end
  end
end

function ChatNetManager:RequestServerList()
  if self.connect_status ~= CONNECT_NONE and self.connect_status ~= CONNECT_CLOSED then
    ChatPrint("RequestServerList status error? stauts = %s", tostring(self.connect_status))
  end
  self.do_retry = true
  self:__setStatus(CONNECT_REQUEST)
  self.request_no = self.request_no + 1
  self.requestIndex = self.requestIndex + 1
  if self.requestIndex == 1 then
    local line = Network:getCurLine()
    local type = ChatInterface.GetUrlType(line)
    if type then
      local index = self:GetUrlIndex(type)
      if index then
        self.requestIndex = index
      end
    end
  end
  if self.requestIndex > #WS_SERVER_LIST_URLLIST then
    self.requestIndex = 1
  end
  WS_SERVER_LIST_URL = WS_SERVER_LIST_URLLIST[self.requestIndex]
  ChatService:RequestServerList(WS_SERVER_LIST_URL, self.request_no)
  __ChatPostBI(ChatBIEnum.IM_GET_SERVER_LIST_REQUEST, {
    times = self.request_no,
    url = WS_SERVER_LIST_URL
  })
end

function ChatNetManager:SendSFSMessage(cmd, ...)
  local msgType = GetMsgType(cmd)
  local msg = msgType:NewMessage(...)
  Network:SendLuaMessage(cmd, msg:ToBinary())
end

function ChatNetManager:SendMessage(cmd, ...)
  local msgType = GetMsgType(cmd)
  local msg = msgType:NewMessage(...)
  local dataTbl = {}
  dataTbl.cmd = cmd
  dataTbl.params = msg.tableData
  if msg.tableData and msg.tableData.seqId then
    local seqId = msg.tableData.seqId
    if seqId % 1 ~= 0 then
      Logger.LogWarning("seqId has fraction, need check! seqId = " .. tostring(seqId))
      msg.tableData.seqId = math.floor(seqId)
    end
  end
  if msg.tableData.sendTime then
    dataTbl.sendTime = msg.tableData.sendTime
  else
    dataTbl.sendTime = math.modf(UITimeManager:GetInstance():GetServerTime())
  end
  self:WriteSign(dataTbl, cmd)
  self:SendTableMessage(dataTbl)
end

local function serialize_sorted(tbl)
  if not tbl then
    return
  end
  
  local function sort_table(t)
    local keys = {}
    for key in pairs(t) do
      table.insert(keys, key)
    end
    table.sort(keys)
    local sorted_tbl = {}
    for _, key in ipairs(keys) do
      local value = t[key]
      if type(value) == "table" then
        value = sort_table(value)
      end
      sorted_tbl[key] = value
    end
    return sorted_tbl
  end
  
  local sorted_tbl = sort_table(tbl)
  return sorted_tbl
end

function ChatNetManager:WriteSign(dataTbl, cmd)
  if not dataTbl.params then
    return
  end
  local logInSign = self.WebSocketInst:GetSign()
  if dataTbl.params and dataTbl.sendTime and not string.IsNullOrEmpty(logInSign) then
    local table = serialize_sorted(dataTbl.params)
    if table then
      dataTbl.params = table
      local extra = rapidjson.encode(table)
      local str = LuaEntry.Player.uid .. extra .. dataTbl.sendTime .. logInSign
      local _pwd = AESHelper.GetMd5Hash(str)
      dataTbl.sign = _pwd
    else
      Logger.LogError("chatSignError ----------- > not table")
    end
  else
    if not dataTbl.params then
      Logger.LogError("chatSignError ----------- > not dataTbl.params")
    end
    if not dataTbl.sendTime then
      Logger.LogError("chatSignError ----------- > not dataTbl.sendTime")
    end
    if string.IsNullOrEmpty(logInSign) then
      Logger.LogError("chatSignError ----------- > not logInSign")
    end
  end
end

function ChatNetManager:SendTableMessage(dataTbl)
  local WS = self.WebSocketInst
  if WS == WebSocketCImpl then
    WS:SendLuaTable(dataTbl)
  else
    local jsonData = rapidjson.encode(dataTbl)
    WS:SendLuaMessage(jsonData)
    if ChatBI_CmdWhiteList[dataTbl.cmd] then
      __ChatPostBI(ChatBIEnum.IM_COMMAND_SEND, {
        cmd = dataTbl.cmd
      })
    end
  end
end

function ChatNetManager:GetCurLineInfo()
  if self.requestList and self.requestList.data and self.wsLineIndex then
    return self.requestList.data[self.wsLineIndex]
  end
end

function ChatNetManager:CloseWebSocket()
  ChatPrint("CloseWebSocket!!!")
  local currentServer = self:GetCurLineInfo()
  Logger.LogInfo(string.format("ChatConnectManualClose status=%s retry=%s wsLineIndex=%s protocol=%s ip=%s port=%s", tostring(self.connect_status), tostring(self.connect_no), tostring(self.wsLineIndex), tostring(currentServer and currentServer.protocol), tostring(currentServer and currentServer.ip), tostring(currentServer and currentServer.port)))
  self.do_retry = false
  if self.connect_status == CONNECT_RUNNING then
    ChatManager2:GetInstance():onErrorOrDisconnect()
  end
  self:__setStatus(CONNECT_CLOSEING)
  self:__stopRetryTimer()
  self:__stopReqTimer()
  self.WebSocketInst:Disconnect()
  self:__setStatus(CONNECT_CLOSED)
end

function ChatNetManager:OnHandleMessage(cmd, t)
  if t ~= nil and t.errorCode ~= nil and t.errorCode == "120775" then
    UIUtil.ShowTipsId("alert_tips_1001")
  else
  end
  local msgType = GetMsgType(cmd)
  if msgType ~= nil then
    local msg = msgType:NewEmpty()
    msg:HandleMessage(t)
    return true
  end
  return false
end

return ChatNetManager
