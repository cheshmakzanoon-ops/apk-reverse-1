local BookMark = BaseClass("BookMark")

local function __init(self)
  self.pos = 0
  self.server = -1
  self.worldId = 0
  self.name = ""
  self.type = 0
  self.createTime = 0
  self.topFlag = 0
end

local function __delete(self)
  self.pos = nil
  self.server = nil
  self.name = nil
  self.type = nil
  self.createTime = nil
  self.topFlag = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.point ~= nil then
    self.pos = message.point
  end
  if message.server ~= nil then
    self.server = message.server
  end
  if message.worldId ~= nil then
    self.worldId = message.worldId
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.createTime ~= nil then
    self.createTime = message.createTime
  end
  if message.topFlag ~= nil then
    self.topFlag = message.topFlag
  end
  if message.pointInfo then
    self.pointInfo = message.pointInfo
  end
end

BookMark.__init = __init
BookMark.__delete = __delete
BookMark.ParseData = ParseData
return BookMark
