local ReceiveRechargeRewardMessage = BaseClass("ReceiveRechargeRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, rechargeId, stageId)
  base.OnCreate(self)
  self.sfsObj:PutInt("rechargeId", rechargeId)
  self.sfsObj:PutInt("stageId", stageId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.CumulativeRechargeManager:SendRewardHandle(t)
end

ReceiveRechargeRewardMessage.OnCreate = OnCreate
ReceiveRechargeRewardMessage.HandleMessage = HandleMessage
return ReceiveRechargeRewardMessage
