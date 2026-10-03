local ZombieRushActInfoMessage = BaseClass("ZombieRushActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZombieRushActInfoMessage:OnCreate(templateId)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", templateId)
end

function ZombieRushActInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    EventManager:GetInstance():Broadcast(EventId.ZombieRushSearchFailed)
    if errCode == "zombierush_err_seasonWrong" then
      local errorMsg = message.errorMsg
      if errorMsg ~= nil and errorMsg ~= "" then
        local arr = string.split(errorMsg, "|")
        if arr and #arr == 2 then
          UIUtil.ShowTips(CS.GameEntry.Localization:GetString(errCode, arr[1], arr[2]))
          return
        end
      end
    end
    UIUtil.ShowTipsId(errCode)
  end
end

return ZombieRushActInfoMessage
