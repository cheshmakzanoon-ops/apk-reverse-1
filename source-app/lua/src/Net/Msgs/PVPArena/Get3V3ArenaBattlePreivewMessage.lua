local Get3V3ArenaBattlePreivewMessage = BaseClass("Get3V3ArenaBattlePreivewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, otherUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", 2)
  if otherUid then
    self.sfsObj:PutUtfString("otherUid", tostring(otherUid))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.Arena3V3GetMessageError)
  else
    DataCenter.LW3V3ArenaManager:ParseDefenseTeams(t)
    DataCenter.LW3V3Manager:ParseWeaponInfo(t.ownerInfo)
    local ownerInfo = t.ownerInfo
    if ownerInfo == nil then
      EventManager:GetInstance():Broadcast(EventId.Arena3V3GetMessageError)
      return
    end
    local uuid = ownerInfo.playerInfo.uid
    if uuid == nil then
      EventManager:GetInstance():Broadcast(EventId.Arena3V3GetMessageError)
      return
    end
    EventManager:GetInstance():Broadcast(EventId.Arena3V3GetDenfenseTeam, uuid)
  end
end

Get3V3ArenaBattlePreivewMessage.OnCreate = OnCreate
Get3V3ArenaBattlePreivewMessage.HandleMessage = HandleMessage
return Get3V3ArenaBattlePreivewMessage
