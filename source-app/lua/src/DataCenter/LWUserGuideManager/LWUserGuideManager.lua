local LWUserGuideManager = BaseClass("LWUserGuideManager")

function LWUserGuideManager:__init()
  self.data = {}
end

function LWUserGuideManager:__delete()
  self.data = nil
end

function LWUserGuideManager:InitData(msg)
  local list = msg.userGuide
  if list ~= nil then
    for k, v in pairs(list) do
      self.data[tonumber(k)] = v
    end
  end
end

function LWUserGuideManager:UpdateData(type, value)
  self.data[type] = value
end

function LWUserGuideManager:SendMsg(type, value)
  SFSNetwork.SendMessage(MsgDefines.UserGuideSave, type, value)
end

function LWUserGuideManager:GetValue(userGuideType)
  if self.data[userGuideType] then
    return self.data[userGuideType]
  end
  return ""
end

return LWUserGuideManager
