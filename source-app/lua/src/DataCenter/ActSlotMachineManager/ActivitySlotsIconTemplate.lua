local ActivitySlotsIconTemplate = BaseClass("ActivitySlotsIconTemplate")

local function __init(self)
  self.id = 0
  self.pic_type = 0
  self.icon = ""
  self.icon_bg = ""
  self.name = ""
  self.icon_blur = ""
  self.icon_bg_blur = ""
end

local function __delete(self)
  self.id = nil
  self.pic_type = nil
  self.icon = nil
  self.icon_bg = nil
  self.name = nil
  self.icon_blur = nil
  self.icon_bg_blur = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.pic_type = tonumber(row:getValue("pic_type")) or 0
  self.icon = row:getValue("icon")
  self.icon_bg = row:getValue("icon_bg")
  self.name = row:getValue("name")
  self.icon_blur = row:getValue("icon_blur")
  self.icon_bg_blur = row:getValue("icon_bg_blur")
end

ActivitySlotsIconTemplate.__init = __init
ActivitySlotsIconTemplate.__delete = __delete
ActivitySlotsIconTemplate.InitData = InitData
return ActivitySlotsIconTemplate
