local AllianceOrderGetReward = BaseClass("AllianceOrderGetReward", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, stage)
  base.OnCreate(self)
  self.sfsObj:PutInt("stage", stage)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    if message.errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
    return
  end
  DataCenter.ActAllianceOrderManager:HandleMessageGetReward(message)
end

AllianceOrderGetReward.OnCreate = OnCreate
AllianceOrderGetReward.HandleMessage = HandleMessage
return AllianceOrderGetReward
