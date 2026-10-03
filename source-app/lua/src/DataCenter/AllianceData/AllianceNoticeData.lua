local AllianceNoticeData = BaseClass("AllianceNoticeData")
local ChatPinAllianceNoticeItemCell = require("UI.UIChatNew.Component.ChatPinAllianceNoticeItemCell")
local rapidjson = require("rapidjson")

function AllianceNoticeData:__init()
  self:ClearData()
end

function AllianceNoticeData:__delete()
  self:ClearData()
end

function AllianceNoticeData:ClearData()
  self.uid = nil
  self.content = nil
  self.like = nil
  self.unlike = nil
  self.isAdv = nil
  self.comment = nil
  self.time = nil
  self.like_time = nil
  self.publisherUid = nil
  self.type = ChatPinMessageType.AllianceNotice
  self.transText = nil
  self.localLikeTime = 0
  self.noticeType = ChatNoticeType.NORMAL
  self.myLike = 0
  self.myDislike = 0
  self.isR4R5 = 0
  self.lastAdvNoticeTime = nil
  self.smallHeight = 0
  self.smallWidth = 0
  self.bigHeight = 0
  self.bigWidth = 0
  self.noticePicVer = 0
  self.picSenderUid = ""
  self.extraJson = nil
  self.extraJsonData = nil
  self.picJson = nil
  self.picJsonData = nil
  self.edited = 0
end

function AllianceNoticeData:UpdateInfo(message)
  if message.uuid then
    self.uid = message.uuid
  end
  if message.noticeType then
    self.noticeType = message.noticeType
  end
  if message.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    if not string.IsNullOrEmpty(message.notice) then
      self:GetVoteData(message)
    end
  elseif message.notice then
    self.content = message.notice
  end
  if message.like then
    self.like = message.like
  end
  if message.unlike then
    self.unlike = message.unlike
  end
  if message.adv then
    self.isAdv = message.adv > 0 or false
  end
  if message.comment then
    self.comment = message.comment
  end
  if message.create_time then
    self.time = message.create_time
  end
  if message.like_time then
    self.like_time = message.like_time
  end
  if message.room_id then
    self.roomId = message.room_id
  end
  if message.publisherUid then
    self.publisherUid = message.publisherUid
  end
  if message.pinnedTime then
    self.pinnedTime = message.pinnedTime
  end
  if message.isR4R5 then
    self.isR4R5 = message.isR4R5
  end
  if message.noticePicVer then
    self.noticePicVer = message.noticePicVer
  end
  if message.picSenderUid then
    self.picSenderUid = message.picSenderUid
  end
  if message.smallHeight then
    self.smallHeight = message.smallHeight
  end
  if message.smallWidth then
    self.smallWidth = message.smallWidth
  end
  if message.bigHeight then
    self.bigHeight = message.bigHeight
  end
  if message.bigWidth then
    self.bigWidth = message.bigWidth
  end
  if message.extraJson then
    self.extraJson = message.extraJson
    if not string.IsNullOrEmpty(self.extraJson) then
      self.extraJsonData = rapidjson.decode(self.extraJson)
    end
  end
  if message.picJson then
    self.picJson = message.picJson
    if not string.IsNullOrEmpty(self.picJson) then
      self.picJsonData = rapidjson.decode(self.picJson)
      for i = 1, #self.picJsonData do
        local data = self.picJsonData[i]
        if data[AlNoticePicDataType.SmallWidth] then
          data[AlNoticePicDataType.SmallWidth] = tonumber(data[AlNoticePicDataType.SmallWidth]) or 0
        end
        if data[AlNoticePicDataType.SmallHeight] then
          data[AlNoticePicDataType.SmallHeight] = tonumber(data[AlNoticePicDataType.SmallHeight]) or 0
        end
        if data[AlNoticePicDataType.BigWidth] then
          data[AlNoticePicDataType.BigWidth] = tonumber(data[AlNoticePicDataType.BigWidth]) or 0
        end
        if data[AlNoticePicDataType.BigHeight] then
          data[AlNoticePicDataType.BigHeight] = tonumber(data[AlNoticePicDataType.BigHeight]) or 0
        end
      end
    end
  end
  if message.edited then
    self.edited = message.edited
  end
end

function AllianceNoticeData:UpdateLikeAndDislikeInfo(message)
  self.myLike = message.myLike or 0
  if self.myLike == 1 then
    DataCenter.AllianceNoticeManager:SetIsNoticeClickedLike(self.uid)
  end
  self.myDislike = message.myDislike or 0
end

function AllianceNoticeData:GetVoteData(message)
  local voteData = rapidjson.decode(message.notice)
  voteData.voteInfo = rapidjson.decode(voteData.voteInfo)
  if voteData.voteInfo.isCryptonym == nil then
    voteData.voteInfo.isCryptonym = false
  end
  voteData.voteResult = rapidjson.decode(voteData.voteResult)
  self.content = voteData.voteInfo.title
  if not string.IsNullOrEmpty(voteData.itemId) then
    voteData.totalIdList = string.split(voteData.itemId, ",")
  end
  local optionItem
  if self.voteData and self.voteData.titleTrans then
    voteData.titleTrans = self.voteData.titleTrans
  end
  for i, v in pairs(voteData.voteResult.options) do
    for k, f in pairs(voteData.voteInfo.options) do
      if v.itemId == f.itemId then
        f.count = v.total
      end
      if self.voteData then
        optionItem = self.voteData.voteInfo.options[k]
        if optionItem and optionItem.transText then
          f.transText = optionItem.transText
        end
      end
      f.maxTotal = tonumber(voteData.total)
    end
  end
  if voteData.totalIdList then
    for i = 1, #voteData.totalIdList do
      for k, v in pairs(voteData.voteInfo.options) do
        if voteData.totalIdList[i] == v.itemId then
          v.isTotal = true
        end
      end
    end
  end
  self.voteData = voteData
end

function AllianceNoticeData:UpdateVote(vote)
  if vote.itemId then
    self.voteData.totalIdList = string.split(vote.itemId, ",")
  end
  if self.voteData.totalIdList then
    for i = 1, #self.voteData.totalIdList do
      for k, v in pairs(self.voteData.voteInfo.options) do
        if self.voteData.totalIdList[i] == v.itemId then
          v.isTotal = true
          v.count = v.count and v.count + 1 or 1
          DataCenter.AllianceNoticeManager:AddPlayerUidToPlayerInfoList(self.uid, v.itemId, LuaEntry.Player:GetUid())
        end
      end
    end
    self.voteData.voteResult.count = self.voteData.voteResult.count + 1
  end
end

function AllianceNoticeData:UpdateVoteDataByPlayerList(playerList)
  for k1, v1 in pairs(self.voteData.voteInfo.options) do
    for k2, v2 in pairs(playerList) do
      if v1.itemId == k2 then
        local voteItemplayInfos = v2
        v1.count = #voteItemplayInfos
      end
    end
  end
  local playerUidDic = {}
  for k, v in pairs(playerList) do
    local voteItemplayInfos = v
    for i = 1, #voteItemplayInfos do
      local playerUid = voteItemplayInfos[i].uid
      playerUidDic[playerUid] = 1
    end
  end
  self.voteData.voteResult.count = table.count(playerUidDic)
end

function AllianceNoticeData:IsOptionsTrans()
  local isTrans = true
  if self.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    local options = self.voteData.voteInfo.options
    for i = 1, #options do
      if not options[i].transText then
        isTrans = false
      end
    end
  end
  return isTrans
end

function AllianceNoticeData:SaveTransText(text, index)
  if self.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    if index then
      self.voteData.voteInfo.options[index].transText = text
    else
      self.voteData.titleTrans = text
    end
  else
    self.transText = text
  end
end

function AllianceNoticeData:IsTrans()
  if self.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    if self.voteData.titleTrans and self:IsOptionsTrans() then
      return true
    end
  else
    return self.transText
  end
end

function AllianceNoticeData:GetPrefabPath()
  return "Assets/Main/Prefabs/UI/ChatNew/ChatPinNoticeItem.prefab"
end

function AllianceNoticeData:GetChatPinName()
  return "notice"
end

function AllianceNoticeData:GetPrefabClass()
  return ChatPinAllianceNoticeItemCell
end

function AllianceNoticeData:GetMyLike()
  return self.myLike
end

function AllianceNoticeData:GetMyDislike()
  return self.myDislike
end

function AllianceNoticeData:SetMyLike(myLike)
  self.myLike = myLike
end

function AllianceNoticeData:SetMyDislike(myDislike)
  self.myDislike = myDislike
end

function AllianceNoticeData:GetIsR4R5()
  return self.isR4R5 == 1
end

function AllianceNoticeData:GetIsAdv()
  return self.isAdv
end

function AllianceNoticeData:GetTime()
  return self.time
end

function AllianceNoticeData:GetLastAdvNoticeTime()
  return self.lastAdvNoticeTime
end

function AllianceNoticeData:SetLastAdvNoticeTime(lastAdvNoticeTime)
  self.lastAdvNoticeTime = lastAdvNoticeTime
end

function AllianceNoticeData:IsHaveNoticePicVer()
  local haveOldPicData = self.noticePicVer > 0 and not string.IsNullOrEmpty(self.picSenderUid)
  local havePicData = self.picJsonData ~= nil
  return haveOldPicData or havePicData
end

function AllianceNoticeData:GetNoticePicData()
  return self.noticePicVer, self.picSenderUid, self.smallHeight, self.smallWidth, self.bigHeight, self.bigWidth
end

function AllianceNoticeData:GetNoticePicListData()
  local dataList
  if self.picJsonData then
    dataList = self.picJsonData
  elseif self.noticePicVer and self.noticePicVer > 0 then
    local data = {
      [AlNoticePicDataType.SenderUid] = self.picSenderUid,
      [AlNoticePicDataType.PicVer] = self.noticePicVer,
      [AlNoticePicDataType.SmallWidth] = self.smallWidth,
      [AlNoticePicDataType.SmallHeight] = self.smallHeight,
      [AlNoticePicDataType.BigWidth] = self.bigWidth,
      [AlNoticePicDataType.BigHeight] = self.bigHeight
    }
    dataList = {
      [1] = data
    }
  end
  return dataList
end

return AllianceNoticeData
