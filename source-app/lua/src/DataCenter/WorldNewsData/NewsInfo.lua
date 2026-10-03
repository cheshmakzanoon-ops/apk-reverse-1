local NewsInfo = BaseClass("NewsInfo")

local function __init(self)
  self.newsType = -1
  self.content = 0
  self.time = 0
  self.atkAbbr = ""
  self.defAbbr = ""
  self.atkColor = -1
  self.defColor = -1
end

local function __delete(self)
  self.newsType = nil
  self.content = nil
  self.time = nil
  self.atkAbbr = nil
  self.defAbbr = nil
  self.atkColor = nil
  self.defColor = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.type ~= nil then
    self.newsType = message.type
  end
  if message.time ~= nil then
    self.time = message.time
  end
  if message.content ~= nil then
    self.content = message.content
  end
  if message.atkAbbr ~= nil then
    self.atkAbbr = message.atkAbbr
  end
  if message.defAbbr ~= nil then
    self.defAbbr = message.defAbbr
  end
  if message.atkColor ~= nil then
    self.atkColor = message.atkColor
  end
  if message.defColor ~= nil then
    self.defColor = message.defColor
  end
end

NewsInfo.__init = __init
NewsInfo.__delete = __delete
NewsInfo.ParseData = ParseData
return NewsInfo
