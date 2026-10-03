local PushData = BaseClass("PushData")

function PushData:__init()
  self.pushType = ""
  self.noticeTime = 0
  self.pushBody = ""
  self.pushTag = ""
  self.pushId = ""
end

function PushData:SetData(_pushId, _noticeTime, _pushBody, _pushTag, _pushType)
  self.pushId = _pushId
  self.noticeTime = _noticeTime
  self.pushBody = _pushBody
  self.pushTag = _pushTag
  self.pushType = _pushType
end

function PushData:GetPushType()
  return self.pushType or ""
end

function PushData:GetPushTime()
  return self.noticeTime or 0
end

function PushData:GetPushBody()
  return self.pushBody or ""
end

function PushData:GetPushTag()
  return self.pushTag or ""
end

function PushData:GetPushId()
  return self.pushId or ""
end

return PushData
