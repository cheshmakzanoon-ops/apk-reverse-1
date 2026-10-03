local AssistancePlayerInfo = BaseClass("AssistancePlayerInfo")

local function __init(self)
end

local function __delete(self)
  self.uid = nil
  self.level = nil
  self.headSkinId = nil
  self.name = nil
  self.pic = nil
  self.picVer = nil
  self.marchEndTime = nil
end

local function Parse(self, message)
  self.uid = message.uid
  self.level = message.level
  self.headSkinId = message.headSkinId
  self.name = message.name
  self.pic = message.pic
  self.picVer = message.picVer
  self.marchEndTime = message.marchEndTime or 0
end

AssistancePlayerInfo.__init = __init
AssistancePlayerInfo.__delete = __delete
AssistancePlayerInfo.Parse = Parse
return AssistancePlayerInfo
