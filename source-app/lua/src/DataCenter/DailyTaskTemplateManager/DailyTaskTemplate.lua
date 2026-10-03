local DailyTaskTemplate = BaseClass("DailyTaskTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.desc = ""
  self.gotype2 = QuestGoType.None
  self.gopara = {}
  self.para2 = 0
  self.order = 0
  self.point = 0
  self.icon = ""
  self.show = QuestShowType.No
  self.desctype = QuestDescType.Normal
  self.progressShow = 1
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.desc = nil
  self.gotype2 = nil
  self.gopara = nil
  self.para1 = nil
  self.para2 = nil
  self.order = nil
  self.point = nil
  self.icon = nil
  self.show = nil
  self.desctype = nil
  self.progressShow = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name", "")
  self.desc = row:getValue("desc", "")
  self.gotype2 = row:getValue("gotype2")
  self.gopara = row:getValue("gopara")
  local param = row:getValue("para1")
  if not table.IsNullOrEmpty(param) then
    self.para1 = tonumber(param[1])
  else
    self.para1 = 0
  end
  self.para2 = row:getValue("para2")
  self.order = row:getValue("order")
  self.point = row:getValue("point")
  self.icon = row:getValue("icon")
  self.show = row:getValue("show")
  self.desctype = row:getValue("desctype")
  self.progressShow = row:getValue("progressshow")
end

local function GetDesc(self)
  return QuestUtil.GetQuestDesc(self, false)
end

DailyTaskTemplate.__init = __init
DailyTaskTemplate.__delete = __delete
DailyTaskTemplate.InitData = InitData
DailyTaskTemplate.GetDesc = GetDesc
return DailyTaskTemplate
