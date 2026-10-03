local ClaimStormEventAllianceRewardMessage = BaseClass("ClaimStormEventAllianceRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, configId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cfgId", configId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonSnowStormDataManager:GetTargetReward(t, false)
end

ClaimStormEventAllianceRewardMessage.OnCreate = OnCreate
ClaimStormEventAllianceRewardMessage.HandleMessage = HandleMessage
return ClaimStormEventAllianceRewardMessage
