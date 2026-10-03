local NewBuildQueueTemplate = BaseClass("NewBuildQueueTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.order = 0
  self.giftId = 0
  self.rent_price = 0
  self.rent_time = 0
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.order = nil
  self.giftId = nil
  self.rent_price = nil
  self.rent_time = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.order = row:getValue("order")
  self.giftId = row:getValue("gift")
  self.rent_price = row:getValue("rent_price")
  self.rent_time = row:getValue("rent_time")
end

local function GetUnlockMethods(self)
  local methods = {}
  if self.giftId ~= 0 then
    table.insert(methods, BuildQueueUnlockType.GiftPack)
  end
  if self.rent_price ~= 0 then
    table.insert(methods, BuildQueueUnlockType.Rent)
  end
  return methods
end

NewBuildQueueTemplate.__init = __init
NewBuildQueueTemplate.__delete = __delete
NewBuildQueueTemplate.InitData = InitData
NewBuildQueueTemplate.GetUnlockMethods = GetUnlockMethods
return NewBuildQueueTemplate
