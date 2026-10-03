local ThanksgivingGiveMessage = BaseClass("ThanksgivingGiveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, otherUid, num, returnGiftUuid, leavingMessage)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("otherUid", otherUid)
  self.sfsObj:PutInt("num", num)
  self.sfsObj:PutLong("returnGiftUuid", returnGiftUuid)
  self.sfsObj:PutUtfString("leavingMessage", leavingMessage)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  local sendNum = t.num or 0
  if 0 < sendNum then
    UIUtil.ShowTips(Localization:GetString("thxgiv_LikeTurkey", sendNum))
  end
  EventManager:GetInstance():Broadcast(EventId.ActGiftGivingGive, t)
end

ThanksgivingGiveMessage.OnCreate = OnCreate
ThanksgivingGiveMessage.HandleMessage = HandleMessage
return ThanksgivingGiveMessage
