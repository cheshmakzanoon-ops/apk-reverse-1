local ChatPrivateSearchDataManager = BaseClass("ChatPrivateSearchDataManager")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local RoomCreateOnceNum = 20

function ChatPrivateSearchDataManager:__init()
  self.curSearchTxt = ""
  self.curPageNum = -1
  self.curReqPageNum = -1
  self.curPageResultNum = 0
  self.searchResult = {}
  self.searchCDTime = 10000
  self.searchTweenMinTime = 200
  self.nextCanSearchTime = 0
  self.searchTweenMinStopTime = 0
  self.sendSearchTxt = ""
  self.searchResultRoomsData = {}
end

function ChatPrivateSearchDataManager:__delete()
end

function ChatPrivateSearchDataManager:GetCanSearchTime()
  return self.nextCanSearchTime
end

function ChatPrivateSearchDataManager:GetWaitTweenMinTime()
  return self.searchTweenMinStopTime
end

function ChatPrivateSearchDataManager:SetNextSearchTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local waitTime = LuaEntry.DataConfig:TryGetNum("search_cd_time", "k1")
  self.nextCanSearchTime = curTime + (waitTime + 1) * 1000
  self.searchTweenMinStopTime = curTime + self.searchTweenMinTime
end

function ChatPrivateSearchDataManager:SetNextCanSearchTime(time)
  if time > self.nextCanSearchTime then
    self.nextCanSearchTime = time
  end
end

function ChatPrivateSearchDataManager:GetCurSearchTxt()
  return self.curSearchTxt
end

function ChatPrivateSearchDataManager:SetCurSearchTxt(txt)
  self.curSearchTxt = txt
end

function ChatPrivateSearchDataManager:GetSearchResult()
  return self.searchResult
end

function ChatPrivateSearchDataManager:SetSearchResult(result)
  self.searchResult = result
end

function ChatPrivateSearchDataManager:SetToNormalData()
  self:SetCurSearchTxt("")
  self:ClearResultData()
end

function ChatPrivateSearchDataManager:OnEnterSearch()
  self:SetCurSearchTxt("")
  self:ClearResultData()
end

function ChatPrivateSearchDataManager:OnExitSearch()
  self:SetCurSearchTxt("")
  self:ClearResultData()
end

function ChatPrivateSearchDataManager:ClearResultData()
  self.curPageNum = -1
  self.curReqPageNum = -1
  self.curPageResultNum = 0
  self.searchResult = {}
  self.searchResultRoomsData = {}
end

function ChatPrivateSearchDataManager:OnSearchStart(txt)
  self:ClearResultData()
  self.sendSearchTxt = txt
  self.curReqPageNum = 0
  self.curPageNum = -1
  self.curPageResultNum = 0
  self:SetNextSearchTime()
end

function ChatPrivateSearchDataManager:GetSearchResultRoomsData()
  return self.searchResultRoomsData
end

function ChatPrivateSearchDataManager:TrySetSearchResult(txt, page, roomIds)
  if txt ~= self.sendSearchTxt then
    return
  end
  if page ~= self.curReqPageNum then
    return
  end
  self.curPageNum = page
  self.curPageResultNum = #roomIds
  local roomIdsData = roomIds or {}
  for _, roomId in ipairs(roomIdsData) do
    table.insert(self.searchResult, roomId)
  end
  local needCreateRoomds = {}
  for i = 1, #roomIdsData do
    table.insert(needCreateRoomds, roomIdsData[i])
  end
  if 0 < #needCreateRoomds then
    local roomDatas = ChatInterface.CreatePriveChatDataByRoomIds(needCreateRoomds)
    for _, roomData in ipairs(roomDatas) do
      table.insert(self.searchResultRoomsData, roomData)
    end
  end
end

function ChatPrivateSearchDataManager:TrySetSearchResultV3(txt, page, roomInfos)
  if txt ~= self.sendSearchTxt then
    return
  end
  if page ~= self.curReqPageNum then
    return
  end
  self.curPageNum = page
  self.curPageResultNum = #roomInfos
  local roomIdsData = {}
  for _, roomInfo in ipairs(roomInfos) do
    table.insert(roomIdsData, roomInfo.roomId)
  end
  for _, roomId in ipairs(roomIdsData) do
    table.insert(self.searchResult, roomId)
  end
  if 0 < #roomInfos then
    local roomDatas = ChatInterface.CreateRoomDataByRoomInfos(roomInfos)
    for _, roomData in ipairs(roomDatas) do
      table.insert(self.searchResultRoomsData, roomData)
    end
  end
end

function ChatPrivateSearchDataManager:TryCreateMoreRoomData()
  if self.curPageNum ~= self.curReqPageNum then
    return
  end
  if self.curPageResultNum <= 0 then
    return
  end
  self.curReqPageNum = self.curReqPageNum + 1
  SFSNetwork.SendMessage(MsgDefines.SearchChatRoomV3, self.sendSearchTxt, self.curReqPageNum)
end

function ChatPrivateSearchDataManager:RemoveRoomData(roomId)
  local removeIndex
  for i, roomId in ipairs(self.searchResult) do
    if roomId == roomId then
      removeIndex = i
      break
    end
  end
  if removeIndex then
    table.remove(self.searchResult, removeIndex)
    table.remove(self.searchResultRoomsData, removeIndex)
  end
  if #self.searchResultRoomsData < RoomCreateOnceNum then
    self:TryCreateMoreRoomData()
  end
end

function ChatPrivateSearchDataManager:RemoveBlockedRoomData(msg)
  local playerId
  if not table.IsNullOrEmpty(msg.chatShield) and #msg.chatShield > 0 then
    playerId = msg.chatShield[1].other
  end
  if string.IsNullOrEmpty(playerId) then
    return
  end
  local removeIndex
  for i, roomData in ipairs(self.searchResultRoomsData) do
    local otherUser = roomData:getPrivateOtherMember()
    if otherUser and otherUser.uid == playerId then
      removeIndex = i
      break
    end
  end
  if removeIndex then
    table.remove(self.searchResult, removeIndex)
    table.remove(self.searchResultRoomsData, removeIndex)
  end
  if #self.searchResultRoomsData < RoomCreateOnceNum then
    self:TryCreateMoreRoomData()
  end
end

function ChatPrivateSearchDataManager:ResetForReInit()
  self.searchResultRoomsData = {}
end

function ChatPrivateSearchDataManager:TryReGetRoomDataForReInit()
  local isReset = false
  if #self.searchResultRoomsData == 0 and 0 < #self.searchResult then
    isReset = true
  end
  return isReset
end

return ChatPrivateSearchDataManager
