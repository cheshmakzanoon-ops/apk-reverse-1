local ChatPrivateDataManager = BaseClass("ChatPrivateDataManager")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization

function ChatPrivateDataManager:__init()
  self.curShowType = ChatPrivateListShowType.Normal
  self.batchDelDict = {}
  self.batchDelSelectMaxNum = 20
end

function ChatPrivateDataManager:__delete()
  self.curShowType = nil
  self.batchDelDict = nil
  self.batchDelSelectMaxNum = nil
end

function ChatPrivateDataManager:CheckCanSelectRoomInBatchDel(roomId)
  local isCanAdd = true
  local tableNum = table.count(self.batchDelDict)
  if tableNum >= self.batchDelSelectMaxNum then
    isCanAdd = false
  end
  return isCanAdd
end

function ChatPrivateDataManager:SelectRoomInBatchDel(roomId)
  self.batchDelDict[roomId] = true
end

function ChatPrivateDataManager:UnSelectRoomInBatchDel(roomId)
  self.batchDelDict[roomId] = nil
end

function ChatPrivateDataManager:CheckRoomInBatchDel(roomId)
  return self.batchDelDict[roomId] == true
end

function ChatPrivateDataManager:GetBatchDelDict()
  return self.batchDelDict or {}
end

function ChatPrivateDataManager:ChangeShowType(showType)
  self.curShowType = showType
end

function ChatPrivateDataManager:SetToNormalData()
  self.curShowType = ChatPrivateListShowType.Normal
  DataCenter.ChatPrivateSearchDataManager:SetToNormalData()
  self.batchDelDict = {}
end

function ChatPrivateDataManager:GetShowType()
  return self.curShowType
end

function ChatPrivateDataManager:OnTabSelectPrivate()
  self:SetToNormalData()
end

function ChatPrivateDataManager:OnExitChatView()
  self:SetToNormalData()
end

function ChatPrivateDataManager:OnToSearchType()
  self:SetToNormalData()
  self.curShowType = ChatPrivateListShowType.Search
end

function ChatPrivateDataManager:OnToBatchDelType()
  self:SetToNormalData()
  self.curShowType = ChatPrivateListShowType.BatchDel
end

function ChatPrivateDataManager:OnToNormalType()
  self:SetToNormalData()
end

function ChatPrivateDataManager:ResetForReInit()
  DataCenter.ChatPrivateSearchDataManager:ResetForReInit()
end

return ChatPrivateDataManager
