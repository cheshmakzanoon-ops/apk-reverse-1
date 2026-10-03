local ClaimStormEventPersonRewardMesage = BaseClass("ClaimStormEventPersonRewardMesage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, cfgId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cfgId", cfgId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonSnowStormDataManager:GetTargetReward(t, true)
end

ClaimStormEventPersonRewardMesage.OnCreate = OnCreate
ClaimStormEventPersonRewardMesage.HandleMessage = HandleMessage
return ClaimStormEventPersonRewardMesage
