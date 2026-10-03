local AccountScoreManager = BaseClass("AccountScoreManager")
local AccountScoreData = require("DataCenter.AccountScore.AccountScoreData")

function AccountScoreManager:__init()
  self.accountScoreData = nil
end

function AccountScoreManager:__delete()
  self.accountScoreData = nil
end

function AccountScoreManager:UpdateAccountScoreData(data)
  self.accountScoreData = nil
  self.accountScoreData = AccountScoreData.New()
  self.accountScoreData:ParseData(data)
  EventManager:GetInstance():Broadcast(EventId.AccountWebLogInfoUpdate)
end

function AccountScoreManager:CheckAccountIDOpen()
  return LuaEntry.DataConfig:CheckSwitch("LastWarID_open")
end

function AccountScoreManager:GetIfOpenGoToWebRemind()
  return LuaEntry.DataConfig:CheckSwitch("LastWarID_goto")
end

function AccountScoreManager:GoToLogInAccountScoreWeb(logInWebType)
  if self:GetIfOpenGoToWebRemind() then
    self:PostEventLogScoreWeb(logInWebType)
    SFSNetwork.SendMessage(MsgDefines.WebGenerateRedirectUrl, WebGenerateUrlType.AccountScore)
  else
    UIUtil.ShowTipsId("id_gotoswitch_tips")
  end
end

function AccountScoreManager:OnRecUrl(message)
  if not (message and message.data) or string.IsNullOrEmpty(message.data.url) then
    Logger.LogError("AccountScoreManager:OnRecUrl message is invalid")
    return
  end
  local url = message.data.url
  Logger.Log("AccountScoreManager:OnRecUrl url = " .. url)
  CS.SDKManager.OpenURL(url)
end

function AccountScoreManager:PostEventLogScoreWeb(logInWebType)
  PostEventLog.Track(PostEventLog.Defines.AccountScore_LogInScoreWeb, {logInWebType = logInWebType})
end

return AccountScoreManager
