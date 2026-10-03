local ParkourAcceptInviteMessage = BaseClass("ParkourAcceptInviteMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function ParkourAcceptInviteMessage:OnCreate(target)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("target", target)
end

function ParkourAcceptInviteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = t.reward
    if reward then
      DataCenter.RewardManager:AddRewardsAndRes({reward = reward})
      local helpTimes = t.helpTimes or 0
      local max = t.maxHelpTimes or 0
      local text = Localization:GetString("parkour_transmitted_num", helpTimes, max)
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGiftPackageOnlyRewardGet) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGiftPackageOnlyRewardGet)
      end
      local desc = Localization:GetString("parkour_transmitted_desc")
      DataCenter.RewardManager:ShowCommonReward({reward = reward}, nil, nil, nil, nil, nil, nil, desc, nil, true, text)
    end
    local target = t.target
    if target then
      EventManager:GetInstance():Broadcast(EventId.SurfingInviteHelpSuccess, target)
    end
  end
end

return ParkourAcceptInviteMessage
