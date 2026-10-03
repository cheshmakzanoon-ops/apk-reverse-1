local MailTranslationRating = BaseClass("MailTranslationRating")
local Localization = CS.GameEntry.Localization

function MailTranslationRating:__init()
  self.dialogId = ""
end

function MailTranslationRating:ParseContent(mailHeader)
  if table.IsNullOrEmpty(mailHeader) then
    return
  end
  if mailHeader.h ~= nil then
    local message = mailHeader.h.title
    if message.dialog ~= nil then
      local dialog = message.dialog
      self.dialogId = dialog.id
    end
  else
    return ""
  end
end

function MailTranslationRating:GetTitle()
  local name = ""
  if string.IsNullOrEmpty(self.dialogId) then
    return name
  end
  local languageName = SuportedLanguagesLocalName[Localization:GetLanguage()]
  if string.IsNullOrEmpty(languageName) then
    languageName = SuportedLanguagesLocalName[Language.English]
  end
  name = Localization:GetString(self.dialogId, Localization:GetString(languageName))
  return name
end

return MailTranslationRating
