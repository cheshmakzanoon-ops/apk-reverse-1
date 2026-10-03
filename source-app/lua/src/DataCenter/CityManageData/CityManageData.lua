local CityManageData = BaseClass("CityManageData")

local function __init(self)
  self.id = 0
  self.name1 = 0
  self.name2 = 0
  self.des = 0
  self.icon = ""
  self.type = 0
  self.type2 = 0
  self.group = 0
  self.status = nil
end

local function __delete(self)
  self.id = nil
  self.name1 = nil
  self.name2 = nil
  self.des = nil
  self.icon = nil
  self.type = nil
  self.type2 = nil
  self.group = nil
  self.status = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name1 = row:getValue("name1")
  self.name2 = row:getValue("name2")
  self.des = row:getValue("desc")
  self.icon = row:getValue("icon")
  self.type = row:getValue("type")
  self.type2 = row:getValue("type2")
  self.group = row:getValue("group")
  self.status = row:getValue("status")
end

CityManageData.__init = __init
CityManageData.__delete = __delete
CityManageData.InitData = InitData
return CityManageData
