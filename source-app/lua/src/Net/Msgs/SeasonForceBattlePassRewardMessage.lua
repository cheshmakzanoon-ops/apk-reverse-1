local SeasonForceBattlePassRewardMessage = BaseClass("SeasonForceBattlePassRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonPassManager:OnRecvExtraRewardsResp(message)
  end
end

SeasonForceBattlePassRewardMessage.OnCreate = OnCreate
SeasonForceBattlePassRewardMessage.HandleMessage = HandleMessage
return SeasonForceBattlePassRewardMessage
