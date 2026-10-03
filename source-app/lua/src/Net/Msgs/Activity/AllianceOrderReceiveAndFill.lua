local AllianceOrderReceiveAndFill = BaseClass("AllianceOrderReceiveAndFill", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    if message.errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  DataCenter.ActAllianceOrderManager:HandleMessageReceiveAndFill(message)
end

AllianceOrderReceiveAndFill.OnCreate = OnCreate
AllianceOrderReceiveAndFill.HandleMessage = HandleMessage
return AllianceOrderReceiveAndFill
