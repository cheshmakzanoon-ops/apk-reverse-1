local VoteListMessage = BaseClass("VoteListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, voteId, uuid)
  base.OnCreate(self)
  if voteId then
    self.sfsObj:PutUtfString("voteId", voteId)
  end
  if uuid then
    self.sfsObj:PutUtfString("uuid", uuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode == nil or t.errorCode == "" then
    DataCenter.AllianceNoticeManager:UpdateVoteItemPlayerInfoList(t.uuid, t.list)
  end
end

VoteListMessage.OnCreate = OnCreate
VoteListMessage.HandleMessage = HandleMessage
return VoteListMessage
