local UserGuideSaveMessage = BaseClass("UserGuideSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function UserGuideSaveMessage:OnCreate(userGuideType, value)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", userGuideType)
  self.sfsObj:PutUtfString("value", value)
end

function UserGuideSaveMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local userGuideType = 0
  local value = ""
  if message.type then
    userGuideType = message.type
  end
  if message.value then
    value = message.value
  end
  if userGuideType ~= 0 and not string.IsNullOrEmpty(value) then
    DataCenter.LWUserGuideManager:UpdateData(userGuideType, value)
  end
end

return UserGuideSaveMessage
