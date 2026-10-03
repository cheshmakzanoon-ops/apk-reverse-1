local ChatReportMessage = BaseClass("ChatReportMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function GetExtraChat(extra, chatData)
  local ret = extra == nil and SFSObject.New() or extra
  if not string.IsNullOrEmpty(chatData.roomId) then
    ret:PutUtfString("roomId", tostring(chatData.roomId))
  end
  if chatData.seqId then
    ret:PutInt("seqId", chatData.seqId)
  end
  return ret
end

local function GetExtraType(extra, extraData)
  local ret = extra == nil and SFSObject.New() or extra
  if extraData.extraType then
    ret:PutInt("type", tonumber(extraData.extraType))
  end
  return ret
end

local function GetExtraAllianceId(extra, extraData)
  local ret = extra == nil and SFSObject.New() or extra
  if extraData.allianceId then
    ret:PutUtfString("allianceId", tostring(extraData.allianceId))
  end
  return ret
end

local function GetExtraGroupMailId(extra, extraData)
  local ret = extra == nil and SFSObject.New() or extra
  if extraData.groupMailId then
    ret:PutUtfString("groupMailId", tostring(extraData.groupMailId))
  end
  return ret
end

local function GetExtraNoticeId(extra, extraData)
  local ret = extra == nil and SFSObject.New() or extra
  if extraData.noticeId then
    ret:PutUtfString("noticeId", tostring(extraData.noticeId))
  end
  return ret
end

local function GetExtraSeasonId(extra, extraData)
  local ret = extra == nil and SFSObject.New() or extra
  if extraData.season then
    ret:PutUtfString("season", tostring(extraData.season))
  end
  return ret
end

local function GetExtraUid(extra, extraData)
  local ret = extra == nil and SFSObject.New() or extra
  if extraData.uid then
    ret:PutUtfString("uid", tostring(extraData.uid))
  end
  return ret
end

local function OnCreate(self, reportUid, content, type, reportTypeList, extraData, msgCreateTime, extraNote)
  base.OnCreate(self)
  if reportTypeList then
    local array = SFSArray.New()
    table.walk(reportTypeList, function(k, v)
      if k then
        array:AddInt(tonumber(k))
      end
    end)
    self.sfsObj:PutSFSArray("reportTypes", array)
  end
  if reportUid then
    self.sfsObj:PutUtfString("reportUid", tostring(reportUid))
  end
  if content then
    self.sfsObj:PutUtfString("content", tostring(content))
  end
  if type then
    self.sfsObj:PutInt("type", tonumber(type))
  end
  if msgCreateTime then
    self.sfsObj:PutLong("msgCreateTime", tonumber(msgCreateTime))
  end
  if extraData ~= nil then
    local extra
    if not string.IsNullOrEmpty(extraData.roomId) and extraData.seqId then
      extra = GetExtraChat(extra, extraData)
    end
    extra = GetExtraType(extra, extraData)
    extra = GetExtraAllianceId(extra, extraData)
    extra = GetExtraGroupMailId(extra, extraData)
    extra = GetExtraNoticeId(extra, extraData)
    extra = GetExtraSeasonId(extra, extraData)
    extra = GetExtraUid(extra, extraData)
    if extra then
      self.sfsObj:PutSFSObject("extra", extra)
    end
  end
  if not string.IsNullOrEmpty(extraNote) then
    self.sfsObj:PutUtfString("custom", tostring(extraNote))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    ChatManager2:GetInstance():OnReportSucceed(t.reportUid)
  end
end

ChatReportMessage.OnCreate = OnCreate
ChatReportMessage.HandleMessage = HandleMessage
return ChatReportMessage
