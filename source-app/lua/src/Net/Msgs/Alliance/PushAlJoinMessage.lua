local PushAlJoinMessage = BaseClass("PushAlJoinMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.alliance ~= nil then
    DataCenter.AllianceBaseDataManager:UpdateAllianceBaseData(t)
    DataCenter.AllianceMemberDataManager:TryInitMemberList(true)
    DataCenter.AllianceNoticeManager:GetNoticeList()
    SFSNetwork.SendMessage(MsgDefines.GetAllianceRedPacket)
    DataCenter.WorldAllianceCityDataManager:InitAllCityDataRequest()
    SFSNetwork.SendMessage(MsgDefines.AllianceDeclareWarGet)
    if CS.SceneManager.World ~= nil then
      CS.SceneManager.World:CheckNeedRefreshRoad()
    end
    EventManager:GetInstance():Broadcast(EventId.AllianceApplySuccess)
    if t.lastUpdateTime then
      LuaEntry.Player:SetLastUpdateTime(t.lastUpdateTime)
    end
  end
end

PushAlJoinMessage.OnCreate = OnCreate
PushAlJoinMessage.HandleMessage = HandleMessage
return PushAlJoinMessage
