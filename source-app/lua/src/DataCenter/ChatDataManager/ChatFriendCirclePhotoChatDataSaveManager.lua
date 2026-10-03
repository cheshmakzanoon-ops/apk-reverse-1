local ChatFriendCirclePhotoChatDataSaveManager = BaseClass("ChatFriendCirclePhotoChatDataSaveManager")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local ChatMessage = require("Chat.Model.ChatMessage")

function ChatFriendCirclePhotoChatDataSaveManager:__init()
  self.curRoomId = nil
  self.roomPhotoChatDataList = {}
  self.createPhotoChatDataDict = {}
  self.isPhotoDataHaveGetAll = false
  self.isPhotoDataWaiting = false
end

function ChatFriendCirclePhotoChatDataSaveManager:__delete()
  self.curRoomId = nil
  self.roomPhotoChatDataList = nil
  self.createPhotoChatDataDict = nil
  self.isPhotoDataHaveGetAll = nil
  self.isPhotoDataWaiting = nil
end

function ChatFriendCirclePhotoChatDataSaveManager:InitRoomPhotoChatData(roomId)
  local isNeedInitAllData = false
  if self.curRoomId ~= roomId then
    isNeedInitAllData = true
  else
    local roomMinSeqId = 0
    local roomMaxSeqId = 0
    local saveMinSeqId = 0
    local saveMaxSeqId = 0
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
    if roomData then
      roomMinSeqId = roomData:getFirstSeqId()
      roomMaxSeqId = roomData:GetLastMsgSeqId()
    end
    if self.roomPhotoChatDataList and 0 < #self.roomPhotoChatDataList then
      saveMaxSeqId = self.roomPhotoChatDataList[1].seqId
      saveMinSeqId = self.roomPhotoChatDataList[#self.roomPhotoChatDataList].seqId
    end
    if roomMinSeqId <= 0 or roomMaxSeqId <= 0 or saveMinSeqId <= 0 or saveMaxSeqId <= 0 then
      isNeedInitAllData = true
    else
      local IsIntersect = roomMinSeqId <= saveMaxSeqId and roomMaxSeqId >= saveMinSeqId
      if IsIntersect == false then
        isNeedInitAllData = true
      end
    end
  end
  if isNeedInitAllData == true then
    self.curRoomId = roomId
    self.roomPhotoChatDataList = {}
    self.createPhotoChatDataDict = {}
    self.isPhotoDataHaveGetAll = false
  end
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(self.curRoomId)
  if roomData then
    local msgList = roomData:GetMsgs()
    if msgList and 0 < #msgList then
      local saveMinSeqId = 0
      local saveMaxSeqId = 0
      if self.roomPhotoChatDataList and 0 < #self.roomPhotoChatDataList then
        saveMaxSeqId = self.roomPhotoChatDataList[1].seqId
        saveMinSeqId = self.roomPhotoChatDataList[#self.roomPhotoChatDataList].seqId
      end
      local isSaveEmpty = saveMinSeqId == 0 and saveMaxSeqId == 0
      local addForwardNum = 1
      for i = #msgList, 1, -1 do
        local msg = msgList[i]
        local seqId = msg.seqId
        if isSaveEmpty == true or saveMaxSeqId < seqId or saveMinSeqId > seqId then
          local post = msg.post
          if post and post == PostType.FriendsCirleBodyHasIcon then
            if isSaveEmpty or saveMinSeqId > seqId then
              table.insert(self.roomPhotoChatDataList, msg)
            elseif saveMaxSeqId < seqId then
              table.insert(self.roomPhotoChatDataList, addForwardNum, msg)
              addForwardNum = addForwardNum + 1
            end
          elseif post and post == PostType.FriendsCirleBody and msg.extra.picVer ~= -1 then
            if isSaveEmpty or saveMinSeqId > seqId then
              table.insert(self.roomPhotoChatDataList, msg)
            elseif saveMaxSeqId < seqId then
              table.insert(self.roomPhotoChatDataList, addForwardNum, msg)
              addForwardNum = addForwardNum + 1
            end
          end
        end
      end
    end
  end
end

function ChatFriendCirclePhotoChatDataSaveManager:AddPhotoChatDataByMsg(handle)
  self.isPhotoDataWaiting = false
  local isHaveNewAdd = false
  if handle.result and not table.IsNullOrEmpty(handle.result.msg) then
    local msgs = handle.result.msg
    local first = msgs[1]
    if first then
      local roomId = first.roomId
      if roomId == self.curRoomId then
        table.sort(msgs, function(a, b)
          return a.seqId > b.seqId
        end)
        for i = 1, #msgs do
          local newchatData = ChatMessage.New()
          newchatData:onParseServerData(msgs[i])
          local seqId = newchatData.seqId
          if seqId < self.roomPhotoChatDataList[#self.roomPhotoChatDataList].seqId then
            table.insert(self.roomPhotoChatDataList, newchatData)
            self.createPhotoChatDataDict[seqId] = newchatData
            isHaveNewAdd = true
          end
        end
      end
    end
  end
  if isHaveNewAdd == false then
    self.isPhotoDataHaveGetAll = true
  end
end

function ChatFriendCirclePhotoChatDataSaveManager:GetPhotoChatDataList()
  return self.roomPhotoChatDataList
end

function ChatFriendCirclePhotoChatDataSaveManager:TryGetMoreData()
  if self.isPhotoDataWaiting == true then
    return
  end
  if self.isPhotoDataHaveGetAll == true then
    return
  end
  local endTime = 0
  local startSeqId = 0
  local endSeqId = 0
  if self.roomPhotoChatDataList and 0 < #self.roomPhotoChatDataList then
    endSeqId = self.roomPhotoChatDataList[1].seqId
    startSeqId = self.roomPhotoChatDataList[#self.roomPhotoChatDataList].seqId
    endTime = self.roomPhotoChatDataList[#self.roomPhotoChatDataList]:getServerTime()
  end
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryBrowsing_pictures, self.curRoomId, startSeqId)
  self.isPhotoDataWaiting = true
end

function ChatFriendCirclePhotoChatDataSaveManager:OnGetNewChatData(tabData)
  local roomId = tabData.roomId
  local group = tabData.group
  local seqId = tabData.seqId
  if roomId ~= self.curRoomId then
    return
  end
  if self.createPhotoChatDataDict[seqId] == nil then
    return
  end
  self.createPhotoChatDataDict[seqId]:onParseServerData(tabData)
end

function ChatFriendCirclePhotoChatDataSaveManager:ClearSaveData()
  self.curRoomId = nil
  self.roomPhotoChatDataList = {}
  self.createPhotoChatDataDict = {}
  self.isPhotoDataHaveGetAll = false
  self.isPhotoDataWaiting = false
end

return ChatFriendCirclePhotoChatDataSaveManager
