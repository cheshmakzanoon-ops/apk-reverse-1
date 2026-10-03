local HospitalInfo = BaseClass("HospitalInfo")

local function __init(self)
  self.armyId = 0
  self.heal = 0
  self.dead = 0
end

local function __delete(self)
  self.armyId = nil
  self.heal = nil
  self.dead = nil
end

local function UpdateInfo(self, message)
  if message == nil then
    return
  end
  if message.armyId ~= nil then
    self.armyId = tonumber(message.armyId)
  end
  if message.heal ~= nil then
    self.heal = message.heal
  end
  if message.dead ~= nil then
    self.dead = message.dead
  end
end

HospitalInfo.__init = __init
HospitalInfo.__delete = __delete
HospitalInfo.UpdateInfo = UpdateInfo
return HospitalInfo
