local AllianceTrainVipRewardSelectMessage = BaseClass("AllianceTrainVipRewardSelectMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceTrainVipRewardSelectMessage:OnCreate(vipReward, platform)
  base.OnCreate(self)
  self.sfsObj:PutIntLuaArray("vipReward", vipReward)
  self.sfsObj:PutInt("platform", platform)
end

function AllianceTrainVipRewardSelectMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWAllyStationDataManager:SetToggleNumSelect(true)
end

return AllianceTrainVipRewardSelectMessage
