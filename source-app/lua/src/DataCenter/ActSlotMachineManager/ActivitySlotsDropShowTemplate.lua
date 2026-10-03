local ActivitySlotsDropShowTemplate = BaseClass("ActivitySlotsDropShowTemplate")

local function __init(self)
  self.id = 0
  self.groupid = 0
  self.type_para = 0
  self.drop_show = 0
end

local function __delete(self)
  self.id = nil
  self.groupid = nil
  self.type_para = nil
  self.drop_show = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.groupid = tonumber(row:getValue("groupid")) or 0
  self.type_para = tonumber(row:getValue("type_para")) or 0
  self.drop_show = tonumber(row:getValue("drop_show")) or 0
end

ActivitySlotsDropShowTemplate.__init = __init
ActivitySlotsDropShowTemplate.__delete = __delete
ActivitySlotsDropShowTemplate.InitData = InitData
return ActivitySlotsDropShowTemplate
