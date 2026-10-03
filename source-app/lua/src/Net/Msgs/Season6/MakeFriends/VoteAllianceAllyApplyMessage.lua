local VoteAllianceAllyApplyMessage = BaseClass("VoteAllianceAllyApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function VoteAllianceAllyApplyMessage:OnCreate(applyId, likeType)
  base.OnCreate(self)
  self.sfsObj:PutInt("likeType", likeType)
  self.sfsObj:PutLong("applyId", applyId)
end

function VoteAllianceAllyApplyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.applyId then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyApplyDetail, t.applyId)
  end
end

return VoteAllianceAllyApplyMessage
