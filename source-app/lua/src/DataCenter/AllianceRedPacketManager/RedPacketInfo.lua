local RedPacketInfo = BaseClass("RedPacketInfo")

local function __init(self)
  self.uuid = ""
  self.uid = ""
  self.name = ""
  self.pic = ""
  self.picV = 0
  self.total = 0
  self.cost = 0
  self.totalPeople = 0
  self.curPeople = 0
  self.time = 0
  self.resType = 0
  self.reasonId = 0
  self.needSend = false
  self.mCardET = 0
  self.record = {}
  self.status = nil
end

local function __delete(self)
  self.uuid = nil
  self.uid = nil
  self.name = nil
  self.pic = nil
  self.picV = nil
  self.total = nil
  self.cost = nil
  self.totalPeople = nil
  self.curPeople = nil
  self.time = nil
  self.resType = nil
  self.reasonId = nil
  self.needSend = nil
  self.status = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.uid ~= nil then
    local uidTab = string.split(message.uid, "|")
    self.uid = uidTab[1]
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.pic ~= nil then
    self.pic = message.pic
  end
  if message.picV ~= nil then
    self.picV = message.picV
  end
  if message.total ~= nil then
    self.total = message.total
  end
  if message.cost ~= nil then
    self.cost = message.cost
  end
  if message.totalPeople ~= nil then
    self.totalPeople = message.totalPeople
  end
  if message.curPeople ~= nil then
    self.curPeople = message.curPeople
  end
  if message.time ~= nil then
    self.time = message.time
  end
  if message.resType ~= nil then
    self.resType = message.resType
  end
  if message.reasonId ~= nil then
    self.reasonId = message.reasonId
  end
  if message.needSend ~= nil then
    self.needSend = message.needSend
  end
  if message.mCardET ~= nil then
    self.mCardET = message.mCardET
  end
  if message.status ~= nil then
    self.status = message.status
  end
end

local function UpdateData(self, message)
  self:ParseData(message)
end

local function UpdateRecord(self, message)
  self.record = message
end

local function UpdateStatus(self, status)
  self.status = status
end

RedPacketInfo.__init = __init
RedPacketInfo.__delete = __delete
RedPacketInfo.ParseData = ParseData
RedPacketInfo.UpdateData = UpdateData
RedPacketInfo.UpdateRecord = UpdateRecord
RedPacketInfo.UpdateStatus = UpdateStatus
return RedPacketInfo
