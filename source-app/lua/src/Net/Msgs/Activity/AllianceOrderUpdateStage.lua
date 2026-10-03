local AllianceOrderUpdateStage = BaseClass("AllianceOrderUpdateStage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    if message.errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  DataCenter.ActAllianceOrderManager:HandleMessageUpdateStage(message)
end

AllianceOrderUpdateStage.OnCreate = OnCreate
AllianceOrderUpdateStage.HandleMessage = HandleMessage
return AllianceOrderUpdateStage
