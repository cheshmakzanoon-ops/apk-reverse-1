local UserGetDefendWallCompensateMessage = BaseClass("UserGetDefendWallCompensateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  else
    DataCenter.WoundedCompensateData:ReceiveRewardHandle(t)
  end
end

UserGetDefendWallCompensateMessage.OnCreate = OnCreate
UserGetDefendWallCompensateMessage.HandleMessage = HandleMessage
return UserGetDefendWallCompensateMessage
