local IndividualOrderReset = BaseClass("IndividualOrderReset", SFSBaseMessage)
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
  DataCenter.ActIndividualOrderManager:HandleMessageReset(message)
end

IndividualOrderReset.OnCreate = OnCreate
IndividualOrderReset.HandleMessage = HandleMessage
return IndividualOrderReset
