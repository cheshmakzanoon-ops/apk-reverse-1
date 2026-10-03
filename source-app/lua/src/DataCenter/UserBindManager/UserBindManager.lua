local UserBindManager = BaseClass("UserBindManager")
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function __init(self)
  self.param = {}
end

local function __delete(self)
  self.param = nil
end

local function SetParam(self, param)
  self.param = param
end

local function UserBindHandle(self, message)
  if message.errorCode == nil then
    local gameUid = message.gameUid
    if gameUid ~= nil and gameUid ~= "" then
      if self.param.optType == AccountBindType.Bind and not self.param.auto_bind then
        UIUtil.ShowMessage(Localization:GetString("280080"))
      end
    else
      local status = message.status
      if status == nil then
        if self.param.optType == AccountBindType.Bind then
          if not string.IsNullOrEmpty(self.param.pgs_id) then
            DataCenter.AccountManager.PlayGamesAccount.userId = self.param.pgs_id
            DataCenter.AccountManager.PlayGamesAccount.userName = self.param.pgs_name
          end
          if not string.IsNullOrEmpty(self.param.googlePlay) then
            if CS.SDKManager.IS_Android() then
              DataCenter.AccountManager.GoogleSignAccount.userId = self.param.googlePlay
              DataCenter.AccountManager.GoogleSignAccount.userName = self.param.googlePlayName
            end
            if CS.SDKManager.IS_IPhonePlayer() then
              DataCenter.AccountManager.GameCenterAccount.userId = self.param.googlePlay
              DataCenter.AccountManager.GameCenterAccount.userName = self.param.googlePlayName
            end
          end
          EventManager:GetInstance():Broadcast(EventId.MSG_USER_BIND_OK)
          if not self.param.auto_bind then
            UIUtil.ShowTipsId(280053)
          end
        else
          UIUtil.ShowMessage(Localization:GetString("280061"))
        end
      elseif status == 1 then
        UIUtil.ShowTipsId("email not confirm!")
        EventManager:GetInstance():Broadcast(EventId.MSG_USER_BIND_OK)
      elseif status == 2 then
        UIUtil.ShowTipsId("passsword error!")
        EventManager:GetInstance():Broadcast(EventId.MSG_USER_BIND_OK)
      end
    end
  else
    local temp = message.errorCode
    if temp == "E100200" then
      local userName = ""
      local userServerId = ""
      local reason = ""
      local bantime = 0
      if message.gameUserName ~= nil then
        userName = message.gameUserName
      end
      if message.serverId ~= nil then
        userServerId = message.serverId
      end
      if message.banMsgId ~= nil then
        reason = message.banMsgId
      end
      if message.banTime ~= nil then
        bantime = message.banTime
      end
    elseif self.param.optType == AccountBindType.Bind and not self.param.auto_bind then
      UIUtil.ShowTipsId(280054)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent)
end

UserBindManager.__init = __init
UserBindManager.__delete = __delete
UserBindManager.UserBindHandle = UserBindHandle
UserBindManager.SetParam = SetParam
return UserBindManager
