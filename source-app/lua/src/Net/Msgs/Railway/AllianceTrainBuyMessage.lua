local AllianceTrainBuyMessage = BaseClass("AllianceTrainBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.sfsObj:PutInt("trainPlatformId", 1)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWAllyStationDataManager:OnAllianceTrainBuySuccess(message)
end

AllianceTrainBuyMessage.OnCreate = OnCreate
AllianceTrainBuyMessage.HandleMessage = HandleMessage
return AllianceTrainBuyMessage
