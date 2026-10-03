local LWSoundMaxInstancesTemplate = BaseClass("LWSoundMaxInstancesTemplate")

local function __init(self)
  self.id = 0
  self.group = ""
  self.instanceLimit = 0
  self.whenPriorityEqual = 0
end

local function __delete(self)
  self.id = nil
  self.group = nil
  self.instanceLimit = nil
  self.whenPriorityEqual = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.group = row:getValue("audiomixer_group") or ""
  self.instanceLimit = tonumber(row:getValue("sound_instance_limit")) or 1
  self.whenPriorityEqual = tonumber(row:getValue("when_priority_equal")) or 1
end

LWSoundMaxInstancesTemplate.__init = __init
LWSoundMaxInstancesTemplate.__delete = __delete
LWSoundMaxInstancesTemplate.InitData = InitData
return LWSoundMaxInstancesTemplate
