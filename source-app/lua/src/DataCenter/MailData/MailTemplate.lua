local MailTemplate = BaseClass("MailTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.title = ""
  self.subtitle = ""
  self.message = ""
  self.reward = ""
  self.type = 0
  self.titleText = ""
  self.subtitleText = ""
  self.messageText = ""
  self.group = -1
end

local function __delete(self)
  self.id = 0
  self.title = ""
  self.subtitle = ""
  self.message = ""
  self.reward = ""
  self.type = 0
  self.titleText = ""
  self.subtitleText = ""
  self.messageText = ""
  self.group = -1
end

local function InitData(self, lineData)
  if lineData == nil then
    return
  end
  self.id = lineData.id
  self.title = lineData.title
  self.subtitle = lineData.subtitle
  self.message = lineData.message
  self.reward = lineData.reward
  self.type = lineData.type
  self.group = MailTypeToInternalGroup[self.type] or -1
end

local function DoLocalization(self)
  if string.IsNullOrEmpty(self.titleText) then
    self.titleText = Localization:GetString(self.title)
  end
  if string.IsNullOrEmpty(self.subtitleText) then
    self.subtitleText = Localization:GetString(self.subtitle)
  end
  if string.IsNullOrEmpty(self.messageText) then
    self.messageText = Localization:GetString(self.message)
  end
end

local function ContainKeywords(self, keywords)
  local s1, _ = string.find(self.titleText, keywords, 0, true)
  if s1 then
    return true, self.title
  end
  local s2, _ = string.find(self.subtitle, keywords, 0, true)
  if s2 then
    return true, self.subtitle
  end
  local s3, _ = string.find(self.message, keywords, 0, true)
  if s3 then
    return true, self.message
  end
  return false
end

MailTemplate.__init = __init
MailTemplate.__delete = __delete
MailTemplate.InitData = InitData
MailTemplate.ContainKeywords = ContainKeywords
MailTemplate.DoLocalization = DoLocalization
return MailTemplate
