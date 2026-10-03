local ExplorerTreasureOpenMessage = BaseClass("ExplorerTreasureOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ExplorerTreasureOpenMessage:OnCreate(param)
  base.OnCreate(self)
end

function ExplorerTreasureOpenMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ExplorerTreasureManager:UpdateGuaranteedTimes(t.dispatch_explorer_treasure_guarantee)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIExplorerTreasureReward, {anim = true}, t)
    EventManager:GetInstance():Broadcast(EventId.OnGetExplorerTreasureSuccess)
  end
end

return ExplorerTreasureOpenMessage
