local ChatVieweDataManager = BaseClass("ChatVieweDataManager")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization

function ChatVieweDataManager:__init()
  self.alNoticeShowType = ChatAlNoticeShowType.Normal
  self.alNoticeSelectDelUuidDict = {}
  self.alNoticeSelectDelRoomId = ""
  self.curSelectRoomGroup = nil
end

function ChatVieweDataManager:__delete()
  self.alNoticeShowType = nil
  self.alNoticeSelectDelUuidDict = nil
  self.alNoticeSelectDelRoomId = nil
  self.curSelectRoomGroup = nil
end

function ChatVieweDataManager:OnSelectRoom(roomData)
  local curRoomGroup = roomData.group
  if self.curSelectRoomGroup == curRoomGroup then
    return
  end
  self.curSelectRoomGroup = curRoomGroup
  self:SetAlNoticeNormalData()
  EventManager:GetInstance():Broadcast(ChatEventEnum.OnChatViewRoomChange, roomData)
end

function ChatVieweDataManager:OnShowPrivateList()
  self.curSelectRoomGroup = nil
  self:SetAlNoticeNormalData()
  EventManager:GetInstance():Broadcast(ChatEventEnum.OnChatViewShowPrivateList)
end

function ChatVieweDataManager:OnExitChatView()
  self.curSelectRoomGroup = nil
  self:SetAlNoticeNormalData()
end

function ChatVieweDataManager:SetAlNoticeNormalData()
  self.alNoticeShowType = ChatAlNoticeShowType.Normal
  self.alNoticeSelectDelUuidDict = {}
  self.alNoticeSelectDelRoomId = ""
end

function ChatVieweDataManager:GetAlNoticeShowType()
  return self.alNoticeShowType
end

function ChatVieweDataManager:GetAlNoticeBatchDelDict()
  return self.alNoticeSelectDelUuidDict
end

function ChatVieweDataManager:StartAlNoticeSelectDel(roomId)
  self.alNoticeShowType = ChatAlNoticeShowType.BatchDel
  self.alNoticeSelectDelUuidDict = {}
  self.alNoticeSelectDelRoomId = roomId
end

function ChatVieweDataManager:CheckNoticeInBatchDel(noticeUuid)
  local isSelect = false
  if self.alNoticeSelectDelUuidDict[noticeUuid] then
    isSelect = true
  end
  return isSelect
end

function ChatVieweDataManager:SetNoticeInBatchDel(noticeUuid, isSelect)
  if isSelect then
    self.alNoticeSelectDelUuidDict[noticeUuid] = true
  else
    self.alNoticeSelectDelUuidDict[noticeUuid] = nil
  end
end

return ChatVieweDataManager
