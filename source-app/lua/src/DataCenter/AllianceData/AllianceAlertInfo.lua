local AllianceAlertInfo = BaseClass("AllianceAlertInfo")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.alAbbr = ""
  self.headFrame = 0
  self.key = ""
  self.name = ""
  self.pic = ""
  self.picVer = 0
  self.point = 0
  self.targetUid = ""
  self.type = nil
  self.content = 0
  self.num = 0
  self.atkUid = ""
  self.atkName = ""
  self.atkAlAbbr = ""
  self.atkPic = ""
  self.atkPicVer = 1
  self.atkHeadFrame = 0
  self.marchInfo = {}
end

local function __delete(self)
  self.alAbbr = nil
  self.headFrame = nil
  self.key = nil
  self.name = nil
  self.pic = nil
  self.picVer = nil
  self.point = nil
  self.targetUid = nil
  self.type = nil
  self.content = nil
  self.num = nil
  self.atkUid = nil
  self.atkName = nil
  self.atkAlAbbr = nil
  self.atkPic = nil
  self.atkPicVer = nil
  self.atkHeadFrame = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.alAbbr ~= nil then
    self.alAbbr = message.alAbbr
  end
  if message.headFrame ~= nil then
    self.headFrame = message.headFrame
  end
  if message.key ~= nil then
    self.key = message.key
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.pic ~= nil then
    self.pic = message.pic
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  end
  if message.point ~= nil then
    self.point = message.point
  end
  if message.targetUid ~= nil then
    self.targetUid = message.targetUid
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.content ~= nil then
    self.content = message.content
  end
  if message.num then
    self.num = message.num
  end
  if message.atkUid ~= nil then
    self.atkUid = message.atkUid
  end
  if message.atkName then
    self.atkName = message.atkName
  end
  if message.atkAlAbbr ~= nil then
    self.atkAlAbbr = message.atkAlAbbr
  end
  if message.atkPic then
    self.atkPic = message.atkPic
  end
  if message.atkPicVer ~= nil then
    self.atkPicVer = message.atkPicVer
  end
  if message.atkHeadFrame then
    self.atkHeadFrame = message.atkHeadFrame
  end
  self.marchInfo = {}
end

AllianceAlertInfo.__init = __init
AllianceAlertInfo.__delete = __delete
AllianceAlertInfo.ParseData = ParseData
return AllianceAlertInfo
