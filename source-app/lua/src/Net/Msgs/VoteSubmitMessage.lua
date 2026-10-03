local VoteSubmitMessage = BaseClass("VoteSubmitMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, voteId, itemIds, uid)
  base.OnCreate(self)
  local ids
  if itemIds then
    for w, v in pairs(itemIds) do
      if not string.IsNullOrEmpty(v) then
        if not ids then
          ids = w
        else
          ids = ids .. "," .. w
        end
      end
    end
  end
  if ids then
    self.sfsObj:PutUtfString("itemId", ids)
  end
  if voteId then
    self.sfsObj:PutUtfString("voteId", voteId)
  end
  if uid then
    self.sfsObj:PutUtfString("uuid", uid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode == nil or t.errorCode == "" then
    DataCenter.AllianceNoticeManager:UpdateVote(t)
  end
end

VoteSubmitMessage.OnCreate = OnCreate
VoteSubmitMessage.HandleMessage = HandleMessage
return VoteSubmitMessage
