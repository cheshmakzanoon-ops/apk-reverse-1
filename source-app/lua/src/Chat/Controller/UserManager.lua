local UserManager = BaseClass("UserManager")
local ChatUserInfo = require("Chat.Model.ChatUserInfo")
local rapidjson = require("rapidjson")

function UserManager:__init()
  self:resetData()
end

function UserManager:resetData()
  self.chatUserInfos = {}
  self.fetchingUids = {}
  self.reportedChatList = {}
  self.reportedUserHeadList = {}
  self.requestUser = true
  self.cacheRequestUids = {}
end

function UserManager:releaseData()
  self:resetData()
end

function UserManager:CreateUserInfo()
  return ChatUserInfo.New()
end

function UserManager:SetRequestUserInfo(requestUser)
  if self.requestUser == requestUser then
    return
  end
  ChatPrint("SetRequestUserInfo: " .. tostring(requestUser))
  self.requestUser = requestUser
  if self.requestUser == true then
    self:__processAllUserInfos()
  end
end

function UserManager:__processAllUserInfos()
  ChatPrint("processAllUserInfos all is ok!")
  local RoomMgr = ChatManager2:GetInstance().Room
  local allUsers = {}
  RoomMgr:GetAllUserInRooms(allUsers)
  if 0 < #allUsers then
    self:requestUserInfo(allUsers)
  end
end

function UserManager:getChatUserInfo(uid, req)
  if type(req) ~= "boolean" then
    req = true
  end
  if type(uid) ~= "string" or uid == "" then
    ChatPrint("uid error!!!")
    return nil
  end
  local userInfo = self.chatUserInfos[uid]
  if not userInfo then
    userInfo = self:CreateUserInfo()
    userInfo.uid = uid
    self.chatUserInfos[uid] = userInfo
    ChatPrint("This is new player uid : %s", uid)
    if req == true then
      self:requestSingleUserInfo(uid)
    end
  elseif not userInfo:GetIsBack() then
    userInfo:UpdateSendTime()
    userInfo:UpdateSendDelay()
    self:__removeFetchingUid()
    if req == true then
      self:requestSingleUserInfo(uid)
    end
  end
  return userInfo
end

function UserManager:requestUserInfo(idTable)
  if not idTable then
    return
  end
  if type(idTable) ~= "table" then
    ChatPrint("requestUserInfo but type error!!")
    return
  end
  ChatPrint("preCacheUserInfo :" .. #idTable)
  self:__removeExistUserInfo(idTable)
  if #idTable == 0 then
    return
  end
  self:__requestUserInfoFromNet(idTable)
end

function UserManager:requestSingleUserInfo(id, immediately)
  if not id then
    return
  end
  if immediately then
    self:requestUserInfo({id})
  end
  if not self.__combineRequestUserIdList then
    self.__combineRequestUserIdList = {id}
  elseif not table.indexof(self.__combineRequestUserIdList, id) then
    table.insert(self.__combineRequestUserIdList, id)
  end
  if self.__commitRequestUserInfoTimer then
    self.__commitRequestUserInfoTimer:Stop()
  end
  self.__commitRequestUserInfoTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:requestUserInfo(self.__combineRequestUserIdList)
    self.__combineRequestUserIdList = nil
    self.__commitRequestUserInfoTimer = nil
  end, 0.5)
end

function UserManager:__onDBCacheUserInfo(idTable, result)
  if result ~= nil then
    for _, userInfo in ipairs(result) do
      self:addChatUserInfo(userInfo)
    end
    self:__removeExistUserInfo(idTable)
  else
    ChatPrint("query user info error!")
  end
  if 0 < #idTable then
    self:__requestUserInfoFromNet(idTable)
  else
    EventManager:GetInstance():Broadcast(EventId.UPDATE_MSG_USERINFO)
  end
end

function UserManager:__removeExistUserInfo(idTable)
  if idTable == nil then
    return
  end
  table.removebyfunc(idTable, function(uid)
    if ChatInterface.isChatGM(uid) then
      return true
    end
    if uid == "system" then
      return true
    end
    local chatInfo = self.chatUserInfos[uid]
    if chatInfo and chatInfo.info_ok == true then
      return true
    end
  end)
end

function UserManager:ForcePullMyUserInfoFromNet()
  self:__requestUserInfoFromNet({
    LuaEntry.Player.uid
  })
end

function UserManager:__requestUserInfoFromNet(reqUserIds)
  if self.requestUser == false then
    ChatPrint("requestUserInfo but false!!!")
    return
  end
  ChatPrint("requestUserInfo to net.")
  local userIds = {}
  for _, uid in ipairs(reqUserIds) do
    if not self.fetchingUids[uid] then
      userIds[#userIds + 1] = uid
      self:__addFetchingUid(uid)
    end
  end
  if 0 < #userIds then
    ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.GetUserInfoMulti, userIds)
  end
end

function UserManager:__onReceiveUserInfos(userTbls)
  ChatPrint("onReceiveUserInfos")
  if type(userTbls) ~= "table" then
    ChatPrint("UserManager:onReceiveUserInfos error")
    return
  end
  for _, userTbl in ipairs(userTbls) do
    local uid = userTbl.uid
    self:__removeFetchingUid(uid)
    local tempUserInfo = self.chatUserInfos[uid]
    if tempUserInfo == nil then
      tempUserInfo = self:CreateUserInfo()
    end
    tempUserInfo:onParseServerData(userTbl)
    tempUserInfo:SetInfoOK()
    self:addChatUserInfo(tempUserInfo)
    EventManager:GetInstance():Broadcast(EventId.PlayerMessageInfo, uid)
  end
  EventManager:GetInstance():Broadcast(EventId.UPDATE_MSG_USERINFO)
end

function UserManager:__onReceiveUserGender(uid, gender)
  local tempUserInfo = self.chatUserInfos[uid]
  if tempUserInfo then
    tempUserInfo.gender = gender
    EventManager:GetInstance():Broadcast(EventId.UPDATE_MSG_USERINFO)
  end
end

function UserManager:__onSearchUserInfos(userTbls)
  ChatPrint("__onSearchUserInfos")
  if type(userTbls) ~= "table" then
    ChatPrint("UserManager:__onSearchUserInfos error")
    return
  end
  for _, userTbl in ipairs(userTbls) do
    local uid = userTbl.uid
    local tempUserInfo = self.chatUserInfos[uid]
    if tempUserInfo == nil then
      tempUserInfo = self:CreateUserInfo()
    end
    tempUserInfo:onParseServerData(userTbl)
    self:addChatUserInfo(tempUserInfo)
  end
end

function UserManager:ChangeUserInfo(message)
  local userInfo = self:getChatUserInfo(message.uid)
  if userInfo then
    userInfo:onParseServerData(message)
  else
    local tempUserInfo = self:CreateUserInfo()
    tempUserInfo:onParseServerData(message)
    self:addChatUserInfo(tempUserInfo)
  end
  if message.uid ~= LuaEntry.Player.uid then
    EventManager:GetInstance():Broadcast(EventId.ChatUserInfoUpdate, message.uid)
  end
end

function UserManager:ChangeUserTitle(uid, title)
  local userInfo = self:getChatUserInfo(uid)
  if userInfo then
    userInfo.title = title
    EventManager:GetInstance():Broadcast(EventId.ChatUserInfoUpdate, uid)
  end
end

function UserManager:CheckUserNameAndPicVer(uid, abbr, name, picVer, pic, gender)
  abbr = abbr or ""
  name = name or ""
  picVer = picVer or 0
  pic = pic or ""
  gender = gender or 0
  local userInfo = self:getChatUserInfo(uid)
  if userInfo then
    if userInfo.userName == name and userInfo.allianceSimpleName == abbr and userInfo.headPicVer == picVer and userInfo.pic == pic and userInfo.gender == gender then
      return
    end
    userInfo.info_ok = false
  end
  ChatPrint("CheckLastUpdate request userinfo: " .. uid)
  self:requestSingleUserInfo(uid)
  return
end

function UserManager:__addFetchingUid(uid)
  self.fetchingUids[uid] = true
end

function UserManager:__removeFetchingUid(uid)
  if self.fetchingUids[uid] then
    self.fetchingUids[uid] = nil
  end
end

function UserManager:getUIDWithUserName(userName)
  local uid = ""
  if userName then
    local userArr = self.chatUserInfos
    if userArr then
      for key, value in pairs(userArr) do
        if value.userName == userName then
          uid = key
          break
        end
      end
    end
  end
  return uid
end

function UserManager:__processSenderInfo(uid, senderInfo)
  if senderInfo == nil then
    return
  end
  local req = false
  local uinfo = self.chatUserInfos[uid]
  if uinfo then
    if senderInfo.lastUpdateTime ~= uinfo.lastUpdateTime and toInt(senderInfo.lastUpdateTime) > toInt(uinfo.lastUpdateTime) then
      req = true
    end
  else
    uinfo = self:CreateUserInfo()
    uinfo.uid = uid
    uinfo.userName = senderInfo.userName
    uinfo.lastUpdateTime = senderInfo.lastUpdateTime
    uinfo.lang = senderInfo.lang
    uinfo.allianceSimpleName = senderInfo.abbr
    self:addChatUserInfo(uinfo)
    req = true
  end
  if req == true then
    uinfo.info_ok = false
    self:requestSingleUserInfo(uid)
  end
end

function UserManager:addChatUserInfo(chatUserInfo)
  if not chatUserInfo then
    return
  end
  self.chatUserInfos[chatUserInfo.uid] = chatUserInfo
end

function UserManager:isExistUserInfoByUid(uid)
  return self:getChatUserInfo(uid) ~= nil
end

function UserManager:recordChatMsg(uid)
  if not table.hasvalue(self.reportedChatList, uid) then
    table.insert(self.reportedChatList, uid)
  else
  end
end

function UserManager:isReportedChatMsg(uid)
  return table.hasvalue(self.reportedChatList, uid)
end

function UserManager:recordUserHead(uid)
  if not table.hasvalue(self.reportedUserHeadList, uid) then
    table.insert(self.reportedUserHeadList, uid)
  end
end

function UserManager:isReportedUserHead(uid)
  return table.hasvalue(self.reportedUserHeadList, uid)
end

function UserManager:updateBanTime(uid, banTime)
end

return UserManager
