local RolesInfo = BaseClass("RolesInfo")

local function __init(self)
  self.pic = ""
  self.picVer = 0
  self.gameUserName = ""
  self.recommend = ""
  self.gameUserLevel = ""
  self.power = ""
  self.gameUid = ""
  self.alAbbr = ""
  self.id = ""
  self.uuid = ""
  self.port = ""
  self.zone = ""
  self.ip = ""
  self.headSkinId = nil
  self.headSkinET = nil
  self.loginKey = nil
end

local function __delete(self)
  self.pic = nil
  self.picVer = nil
  self.gameUserName = nil
  self.recommend = nil
  self.gameUserLevel = nil
  self.power = nil
  self.gameUid = nil
  self.alAbbr = nil
  self.id = nil
  self.uuid = nil
  self.port = nil
  self.zone = nil
  self.ip = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.loginKey = nil
end

local function Parse(self, message)
  if message == nil then
    return
  end
  if message.pic ~= nil then
    self.pic = message.pic
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  end
  if message.gameUserName ~= nil then
    self.gameUserName = message.gameUserName
  end
  if message.recommend ~= nil then
    self.recommend = message.recommend
  end
  if message.gameUserLevel ~= nil then
    self.gameUserLevel = message.gameUserLevel
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.gameUid ~= nil then
    self.gameUid = message.gameUid
  end
  if message.alAbbr ~= nil then
    self.alAbbr = message.alAbbr
  end
  if message.id ~= nil then
    self.id = message.id
  end
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.port then
    self.port = message.port
  end
  if message.zone then
    self.zone = message.zone
  end
  if message.ip then
    self.ip = message.ip
  end
  if message.headSkinId then
    self.headSkinId = message.headSkinId
  end
  if message.headSkinET then
    self.headSkinET = message.headSkinET
  end
end

RolesInfo.__init = __init
RolesInfo.__delete = __delete
RolesInfo.Parse = Parse
return RolesInfo
