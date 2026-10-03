local GaleArenaBattlePreViewMessage = BaseClass("GaleArenaBattlePreViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, otherUid)
  base.OnCreate(self)
  if otherUid then
    self.sfsObj:PutUtfString("otherUid", otherUid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      EventManager:GetInstance():Broadcast(EventId.NewGaleArenaGetBattlePreview, t)
    else
      EventManager:GetInstance():Broadcast(EventId.NewGaleArenaGetMessageError, t)
      UIUtil.ShowTipsId(t.errorCode)
      if "new_arena_tips_38" == t.errorCode then
        SFSNetwork.SendMessage(MsgDefines.GaleArenaRankList)
      end
    end
  end
end

GaleArenaBattlePreViewMessage.OnCreate = OnCreate
GaleArenaBattlePreViewMessage.HandleMessage = HandleMessage
return GaleArenaBattlePreViewMessage
