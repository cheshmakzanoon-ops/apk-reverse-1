local IndividualOrderGetReward = BaseClass("IndividualOrderGetReward", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, stage)
  base.OnCreate(self)
  self.sfsObj:PutInt("stage", stage)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil and message.errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.ActIndividualOrderManager:HandleMessageGetReward(message)
end

IndividualOrderGetReward.OnCreate = OnCreate
IndividualOrderGetReward.HandleMessage = HandleMessage
return IndividualOrderGetReward
