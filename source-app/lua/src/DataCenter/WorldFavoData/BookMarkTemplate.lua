local BookMarkTemplate = BaseClass("BookMarkTemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.name = ""
  self.icon = ""
  self.prefab = ""
  self.mail_icon = nil
  self.dynamicIcon = ""
  self.sort = 0
  self.season = 0
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.name = nil
  self.icon = nil
  self.prefab = nil
  self.mail_icon = nil
  self.dynamicIcon = nil
  self.sort = nil
  self.season = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id")
  self.type = row:getIntValue("type")
  self.name = row:getValue("name")
  self.icon = row:getValue("icon")
  self.prefab = row:getValue("perfab") or row:getValue("prefab")
  self.friend_prefab = row:getValue("friend_prefab")
  self.text = row:getValue("text")
  self.mail_icon = row:getValue("mail_icon")
  self.dynamicIcon = row:getValue("dynamicIcon")
  self.sort = row:getIntValue("sort")
  self.season = row:getIntValue("season")
end

BookMarkTemplate.__init = __init
BookMarkTemplate.__delete = __delete
BookMarkTemplate.InitData = InitData
return BookMarkTemplate
