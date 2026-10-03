local FireworkInfo = BaseClass("FireworkInfo")

function FireworkInfo:__init()
  self.sendUid = ""
  self.pic = ""
  self.picVer = 0
  self.countryFlag = ""
  self.headSkinId = 0
  self.headSkinET = 0
  self.startTime = 0
  self.endTime = 0
  self.configId = 0
end

function FireworkInfo:SetData(data)
  if not data then
    return
  end
  self.sendUid = data.sendUid or ""
  self.pic = data.pic or ""
  self.picVer = data.picVer or 0
  self.countryFlag = data.countryFlag or ""
  self.headSkinId = data.headSkinId or 0
  self.headSkinET = data.headSkinET or 0
  self.startTime = data.startTime or 0
  self.endTime = data.endTime or 0
  self.configId = data.configId or 0
end

function FireworkInfo:SetCsData(data)
  if not data then
    return
  end
  self.sendUid = data.SendUid or ""
  self.pic = data.Pic or ""
  self.picVer = data.PicVer or 0
  self.countryFlag = data.CountryFlag or ""
  self.headSkinId = data.HeadSkinId or 0
  self.headSkinET = data.HeadSkinET or 0
  self.startTime = data.StartTime or 0
  self.endTime = data.EndTime or 0
  self.configId = data.ConfigId or 0
end

function FireworkInfo:GetSendUid()
  return self.sendUid
end

function FireworkInfo:GetPic()
  return self.pic
end

function FireworkInfo:GetPicVer()
  return self.picVer
end

function FireworkInfo:GetCountryFlag()
  return self.countryFlag
end

function FireworkInfo:GetHeadSkinId()
  return self.headSkinId
end

function FireworkInfo:GetHeadSkinET()
  return self.headSkinET
end

function FireworkInfo:GetStartTime()
  return self.startTime
end

function FireworkInfo:GetEndTime()
  return self.endTime
end

function FireworkInfo:GetConfigId()
  return self.configId
end

function FireworkInfo:GetRemainTime()
  if self.endTime <= 0 then
    return 0
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return math.max(0, self.endTime - serverTime)
end

function FireworkInfo:IsFinished()
  return self:GetRemainTime() <= 0
end

return FireworkInfo
