local KingdomPositionInfo = BaseClass("DecorationTemplate")

function KingdomPositionInfo:__init()
  self.positionId = ""
  self.appointTime = 0
  self.uid = ""
  self.serverId = 0
  self.pic = ""
  self.picVer = 0
  self.name = ""
  self.headSkinId = 0
  self.headSkinET = 0
  self.abbr = ""
  self.endTime = 0
  self.template = nil
end

function KingdomPositionInfo:__delete()
  self.positionId = ""
  self.appointTime = 0
  self.uid = ""
  self.serverId = 0
  self.pic = ""
  self.picVer = 0
  self.name = ""
  self.headSkinId = 0
  self.headSkinET = 0
  self.abbr = ""
  self.endTime = 0
  self.template = nil
  self.declaration = nil
end

function KingdomPositionInfo:Deposition()
  self.uid = ""
  self.serverId = 0
  self.pic = ""
  self.picVer = 0
  self.name = ""
  self.headSkinId = 0
  self.headSkinET = 0
  self.abbr = ""
  self.endTime = 0
  self.declaration = nil
end

function KingdomPositionInfo:ParseData(message)
  if message == nil then
    return
  end
  self.positionId = message.positionId
  self.appointTime = message.appointTime or 0
  self.appointRight = not not message.appointRight
  self.uid = message.uid or ""
  self.serverId = message.serverId or 0
  self.pic = message.pic or ""
  self.picVer = message.picver or 0
  self.name = message.name or ""
  self.headSkinId = message.headSkinId or 0
  self.headSkinET = message.headSkinET or 0
  self.abbr = message.abbr or ""
  self.endTime = message.endTime or 0
  self.declaration = message.declaration or ""
  self.template = DataCenter.GovernmentTemplateManager:GetTemplate(self.positionId)
end

function KingdomPositionInfo:ParseBuildingOfficialData(message)
  if message == nil then
    return
  end
  self.positionId = message.positionId
  self.appointTime = message.time or 0
  self.uid = message.uid or ""
  self.endTime = message.endTime or 0
  self.declaration = message.declaration or ""
  self.template = DataCenter.GovernmentTemplateManager:GetTemplate(self.positionId)
  if message.user then
    local user = message.user
    self.name = user.name or ""
    self.abbr = user.abbr or ""
    self.gender = user.gender or 1
    self.pic = user.pic or ""
    self.picVer = user.picver or 0
    self.serverId = user.srcServer or 0
    self.headSkinId = user.headSkinId or 0
    self.headSkinET = user.headSkinET or 0
    self.power = user.power or 0
  end
end

function KingdomPositionInfo:IsInAppointTimeCD()
  local k9 = LuaEntry.DataConfig:TryGetNum("wonder", "k9", 240) * 1000
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > self.appointTime + k9 then
    return false
  end
  return true
end

function KingdomPositionInfo:GetAppointTimeCD()
  return self.appointTime + LuaEntry.DataConfig:TryGetNum("wonder", "k9", 240) * 1000
end

function KingdomPositionInfo:GetFullName(isConqueror, uid)
  local ret = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, self.name)
  if self.abbr ~= nil and self.abbr ~= "" then
    ret = "[" .. self.abbr .. "] " .. ret
  end
  if isConqueror and self.serverId > 0 then
    ret = "#" .. self.serverId .. " " .. ret
  end
  return ret
end

function KingdomPositionInfo:HasAppointRight()
  if self.positionId == 10001 or self.positionId == "10001" then
    return true
  end
  return self.appointRight or false
end

function KingdomPositionInfo:GetHeadBgImg()
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

function KingdomPositionInfo:SetDeclaration(declaration)
  self.declaration = declaration
end

return KingdomPositionInfo
