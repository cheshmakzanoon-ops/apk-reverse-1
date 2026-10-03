local GroupChatSetTemplate = BaseClass("GroupChatSetTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.dots_type = 0
  self.limit_lv = 0
  self.groupTypeKey = ""
  self.groupKey = ""
  self.help_bubble = 0
  self.sort = 0
  self.groupType = ""
  self.group = ""
  self.param = 0
  self.group2 = 0
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.dots_type = nil
  self.limit_lv = nil
  self.groupTypeKey = nil
  self.groupKey = nil
  self.help_bubble = nil
  self.param = nil
  self.group2 = nil
  self.groupType = nil
  self.group = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id") or 0
  self.name = row:getValue("name") or ""
  self.dots_type = row:getValue("dots_type") or 0
  self.limit_lv = toInt(row:getValue("limit_lv")) or 0
  self.groupTypeKey = row:getValue("groupType") or ""
  self.groupKey = row:getValue("group") or ""
  self.help_bubble = toInt(row:getValue("help_bubble")) or 0
  self.sort = toInt(row:getValue("sort"))
  self.isShare = row:getValue("share") == 1
  self.param = row:getIntValue("param")
  self.group2 = row:getIntValue("group2")
  if not string.IsNullOrEmpty(self.groupTypeKey) then
    self.groupType = ChatGroupType[self.groupTypeKey]
  end
  if not string.IsNullOrEmpty(self.groupKey) then
    self.group = ChatRoomCategory[self.groupKey]
  end
end

GroupChatSetTemplate.__init = __init
GroupChatSetTemplate.__delete = __delete
GroupChatSetTemplate.InitData = InitData
return GroupChatSetTemplate
