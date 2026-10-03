local DsbActGetRewardMessage = BaseClass("DsbActGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbActGetRewardMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("rewardId", param.rewardId)
  self.sfsObj:PutInt("rewardType", param.rewardType)
end

function DsbActGetRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetActGetRewardMsg(t)
  end
end

return DsbActGetRewardMessage
