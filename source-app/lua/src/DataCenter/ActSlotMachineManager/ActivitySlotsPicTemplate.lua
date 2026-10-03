local ActivitySlotsPicTemplate = BaseClass("ActivitySlotsPicTemplate")

local function __init(self)
  self.id = 0
  self.groupid = 0
  self.list_id = 0
  self.order = 0
  self.icon_id = 0
end

local function __delete(self)
  self.id = nil
  self.groupid = nil
  self.list_id = nil
  self.order = nil
  self.icon_id = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.groupid = tonumber(row:getValue("groupid")) or 0
  self.list_id = tonumber(row:getValue("list_id")) or 0
  self.order = tonumber(row:getValue("order")) or 0
  self.icon_id = tonumber(row:getValue("icon_id")) or 0
end

ActivitySlotsPicTemplate.__init = __init
ActivitySlotsPicTemplate.__delete = __delete
ActivitySlotsPicTemplate.InitData = InitData
return ActivitySlotsPicTemplate
