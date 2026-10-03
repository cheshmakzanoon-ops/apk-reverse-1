local PushBloodyQueenS1RestActivityInfoUpdateMessage = BaseClass("PushBloodyQueenS1RestActivityInfoUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t then
    if not DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.OffSeason1QueenOfBlood.Type) then
      return
    end
    if t.updateType and t.updateType ~= QueenOfBloodUpdateType.NORMAL then
      if t.updateType == QueenOfBloodUpdateType.PEASONAL_RANK then
        SFSNetwork.SendMessage(MsgDefines.BloodyQueenPersonalRank, DataCenter.OffSeason1QueenOfBloodManager.activityCount, true)
      elseif t.updateType == QueenOfBloodUpdateType.SPACIAL_MONSTER_UPDATE then
        SFSNetwork.SendMessage(MsgDefines.BloodyQueenS1RestGainActivityInfo, t.updateType, t.extendInfo)
      elseif t.updateType == QueenOfBloodUpdateType.SPACIAL_MONSTER_SINGLE_UPDATE then
        EventManager:GetInstance():Broadcast(EventId.PushBloodyQueenS1RestActivityInfoUpdateInView, t)
      elseif t.updateType == QueenOfBloodUpdateType.TASK_INFO_UPDATE then
        SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskInfo, OffSeason1TaskGroup.QueenOfBlood)
      elseif t.updateType == QueenOfBloodUpdateType.RANK_UPDATE then
        EventManager:GetInstance():Broadcast(EventId.PushBloodyQueenS1RestRefreshRankPopInView, t.extendInfo)
      end
    else
      SFSNetwork.SendMessage(MsgDefines.BloodyQueenS1RestGainActivityInfo)
    end
  end
end

PushBloodyQueenS1RestActivityInfoUpdateMessage.OnCreate = OnCreate
PushBloodyQueenS1RestActivityInfoUpdateMessage.HandleMessage = HandleMessage
return PushBloodyQueenS1RestActivityInfoUpdateMessage
