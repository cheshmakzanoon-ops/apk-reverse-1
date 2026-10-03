local ArmyInfo = BaseClass("ArmyInfo")

local function __init(self)
  self.id = 0
  self.free = 0
  self.train = 0
  self.level = 0
  self.upgrade = 0
  self.march = 0
end

local function __delete(self)
  self.id = nil
  self.free = nil
  self.train = nil
  self.level = nil
  self.upgrade = nil
  self.march = nil
end

local function UpdateInfo(self, message)
  if message == nil then
    return
  end
  self.id = message.id
  if message.free ~= nil then
    self.free = message.free
  else
    self.free = 0
  end
  if message.march ~= nil then
    self.march = message.march
  end
  if message.train ~= nil then
    self.train = message.train
  else
    self.train = 0
  end
  if message.upgrade ~= nil then
    self.upgrade = message.upgrade
  else
    self.upgrade = 0
  end
  local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.id)
  if template ~= nil then
    self.level = template.level
  end
end

ArmyInfo.__init = __init
ArmyInfo.__delete = __delete
ArmyInfo.UpdateInfo = UpdateInfo
return ArmyInfo
