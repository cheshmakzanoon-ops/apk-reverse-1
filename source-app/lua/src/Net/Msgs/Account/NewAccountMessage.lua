local NewAccountMessage = BaseClass("NewAccountMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    if param.confirm == 2 then
      self.sfsObj:PutInt("confirm", 1)
    end
    if param.specify then
      self.sfsObj:PutInt("specify", 1)
      self.sfsObj:PutInt("targetServer", param.targetServer)
    end
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  Logger.LogInfo("[AT]ClearGUID&NetUid_NewAccount")
  CS.AccountCredentialManager.ClearAll()
  CS.AccountCredentialManager.SetLoginKey(message.loginKey)
  CS.ApplicationLaunch.Instance:ReloadGame()
end

NewAccountMessage.OnCreate = OnCreate
NewAccountMessage.HandleMessage = HandleMessage
return NewAccountMessage
