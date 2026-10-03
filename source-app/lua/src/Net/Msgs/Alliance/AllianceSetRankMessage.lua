local AllianceSetRankMessage = BaseClass("AllianceSetRankMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, playerId, rank, offical, fireOffical)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("playerId", playerId)
  self.sfsObj:PutInt("rank", rank)
  self.sfsObj:PutInt("offical", offical)
  if fireOffical == nil then
    fireOffical = 0
  end
  self.sfsObj:PutInt("fireOffical", fireOffical)
end

local function ChatShareChangeMessage(t)
  local AlMgr = DataCenter.AllianceMemberDataManager
  local playerId = t.playerId
  local member = AlMgr:GetAllianceMemberByUid(playerId)
  if member == nil then
    return
  end
  local param = {}
  param.uid = member.uid
  param.uname = member.name
  param.selfName = LuaEntry.Player.name
  param.selfRank = DataCenter.AllianceBaseDataManager:GetSelfRank()
  local share = {}
  share.roomId = ChatInterface.getAllianceRoomId()
  share.param = param
  if t.rank then
    share.post = PostType.Text_AllianceRankChange
    param.old = member.rank
    param.new = t.rank
  elseif t.officalType then
    share.post = PostType.Text_AllianceOfficialChange
    param.new = t.officalType
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    ChatShareChangeMessage(t)
    DataCenter.AllianceMemberDataManager:SetAllianceRank(t)
    EventManager:GetInstance():Broadcast(EventId.AllianceMember)
    if t.officalType == nil or t.officalType == 0 then
      UIUtil.ShowTipsId(120094)
    end
  end
end

AllianceSetRankMessage.OnCreate = OnCreate
AllianceSetRankMessage.HandleMessage = HandleMessage
return AllianceSetRankMessage
