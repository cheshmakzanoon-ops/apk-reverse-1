local AllianceNoticeRecordData = BaseClass("AllianceNoticeRecordData")
local rapidjson = require("rapidjson")

function AllianceNoticeRecordData:__init()
  self:ClearData()
end

function AllianceNoticeRecordData:__delete()
  self:ClearData()
end

function AllianceNoticeRecordData:ClearData()
  self.playerUid = nil
  self.playerName = nil
  self.operateType = nil
  self.time = nil
  self.uuid = nil
  self.noticeData = nil
  self.noticeDataDecode = nil
  self.voteData = nil
end

function AllianceNoticeRecordData:UpdateInfo(message)
  if message == nil then
    return
  end
  if message.playerUid then
    self.playerUid = message.playerUid
  end
  if message.playerName then
    self.playerName = message.playerName
  end
  if message.operateType then
    self.operateType = message.operateType
  end
  if message.time then
    self.time = message.time
  end
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.noticeData then
    self.noticeData = message.noticeData
    self.noticeDataDecode = rapidjson.decode(self.noticeData)
    if self.noticeDataDecode and self.noticeDataDecode.notice then
      if self.noticeDataDecode.noticeType == ChatNoticeType.ALLIANCE_VOTE then
        self.voteData = rapidjson.decode(self.noticeDataDecode.notice)
      else
        if self.noticeDataDecode.extraJson then
          self.noticeDataDecode.extraJsonData = rapidjson.decode(self.noticeDataDecode.extraJson)
        end
        if self.noticeDataDecode.picJson then
          self.noticeDataDecode.picJsonData = rapidjson.decode(self.noticeDataDecode.picJson)
        end
      end
    end
  end
end

function AllianceNoticeRecordData:IsHaveNoticePicVer()
  local haveOldPicData = self.noticeDataDecode.noticePicVer and self.noticeDataDecode.noticePicVer > 0 and not string.IsNullOrEmpty(self.noticeDataDecode.picSenderUid)
  local havePicData = self.noticeDataDecode.picJsonData ~= nil
  return haveOldPicData or havePicData
end

function AllianceNoticeRecordData:GetNoticePicListData()
  local dataList
  if self.noticeDataDecode.picJsonData then
    dataList = self.noticeDataDecode.picJsonData
  elseif self.noticeDataDecode.noticePicVer and self.noticeDataDecode.noticePicVer > 0 then
    local data = {
      [AlNoticePicDataType.SenderUid] = self.noticeDataDecode.picSenderUid,
      [AlNoticePicDataType.PicVer] = self.noticeDataDecode.noticePicVer,
      [AlNoticePicDataType.SmallWidth] = self.noticeDataDecode.smallWidth,
      [AlNoticePicDataType.SmallHeight] = self.noticeDataDecode.smallHeight,
      [AlNoticePicDataType.BigWidth] = self.noticeDataDecode.bigWidth,
      [AlNoticePicDataType.BigHeight] = self.noticeDataDecode.bigHeight
    }
    dataList = {
      [1] = data
    }
  end
  return dataList
end

return AllianceNoticeRecordData
