local IndividualOrderGetInfo = BaseClass("IndividualOrderGetInfo", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil and message.errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.ActIndividualOrderManager:HandleMessageGetInfo(message)
end

IndividualOrderGetInfo.OnCreate = OnCreate
IndividualOrderGetInfo.HandleMessage = HandleMessage
return IndividualOrderGetInfo
