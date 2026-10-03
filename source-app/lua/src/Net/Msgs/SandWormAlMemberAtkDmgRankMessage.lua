local SandWormAlMemberAtkDmgRankMessage = BaseClass("SandWormAlMemberAtkDmgRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.SandWormHuntDataManager:RecMsgPersonRank(t)
  end
end

SandWormAlMemberAtkDmgRankMessage.OnCreate = OnCreate
SandWormAlMemberAtkDmgRankMessage.HandleMessage = HandleMessage
return SandWormAlMemberAtkDmgRankMessage
