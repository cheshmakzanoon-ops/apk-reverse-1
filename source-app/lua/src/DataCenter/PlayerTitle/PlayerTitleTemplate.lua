local PlayerTitleTemplate = BaseClass("PlayerTitleTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.description = ""
  self.source = ""
  self.message_show_icon = ""
  self.order = 0
  self.show_frame = ""
  self.limit_time = 0
  self.show_background = ""
  self.show_background_small = ""
  self.title_show_icon = ""
  self.extraPara = nil
  self.status = nil
  self.linkSkill = nil
  self.nextCfgId = nil
end

local function __delete(self)
  self.id = 0
  self.name = ""
  self.description = ""
  self.source = ""
  self.message_show_icon = ""
  self.order = 0
  self.show_frame = ""
  self.limit_time = 0
  self.show_background = ""
  self.show_background_small = ""
  self.title_show_icon = ""
  self.extraPara = nil
  self.status = nil
  self.linkSkill = nil
  self.nextCfgId = nil
end

local function InitData(self, lineData)
  if lineData == nil then
    return
  end
  self.id = lineData.id
  self.name = lineData.name
  self.description = lineData.description
  self.source = lineData.source
  self.message_show_icon = lineData.message_show_icon
  self.order = lineData.order
  self.show_frame = lineData.show_frame
  self.limit_time = lineData.limit_time
  self.show_background = lineData.show_background
  self.show_background_small = lineData.show_background_small
  self.title_show_icon = lineData.title_show_icon
  self.extraPara = not string.IsNullOrEmpty(lineData.extraPara) and lineData.extraPara or nil
  self.status = not string.IsNullOrEmpty(lineData.status) and lineData.status or nil
  self.linkSkill = not string.IsNullOrEmpty(lineData.linkSkill) and tonumber(lineData.linkSkill) or nil
  local special_access = not string.IsNullOrEmpty(lineData.special_access) and lineData.special_access or nil
  if special_access then
    local params = string.split(special_access, "|")
    if 2 <= #params then
      self.nextCfgId = tonumber(params[2]) or 0
    end
  end
  self.keyColor = lineData.key_new
end

PlayerTitleTemplate.__init = __init
PlayerTitleTemplate.__delete = __delete
PlayerTitleTemplate.InitData = InitData
return PlayerTitleTemplate
