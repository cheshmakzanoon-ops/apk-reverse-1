local PushReceiveBaseRewardMessage = BaseClass("PushReceiveBaseRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local isInCrossServer = false
  local player = LuaEntry.Player
  if not player:IsInSourceServer() or player:GetCurServerId() ~= player:GetSelfServerId() then
    isInCrossServer = true
  end
  local curScene = CS.SceneManager.CurrSceneID
  if not isInCrossServer and (curScene == SceneManagerSceneID.World or curScene == SceneManagerSceneID.City) then
    local id = t.statusId
    local statueType2 = DataCenter.StatusManager:GetStatusType2(id)
    if statueType2 == StatusType2.BuildingRewardBubble3 then
      UIUtil.ShowTipsId("thxgiv_MapGiftGet")
    end
  end
  DataCenter.ActivityReceiveDataManager:SetActivityStatusReceiveDictPushMsg(t)
  EventManager:GetInstance():Broadcast(EventId.WorldGetRewardBubbleGetMsg)
  if t.aid then
    local activityId = toInt(t.aid)
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    if actInfo and actInfo.type == EnumActivity.ActValentineReceiveGift.Type then
      DataCenter.ValentineDataManager:PopGetKingOfLoveRewardCountInfoStr(activityId)
    end
  end
end

PushReceiveBaseRewardMessage.OnCreate = OnCreate
PushReceiveBaseRewardMessage.HandleMessage = HandleMessage
return PushReceiveBaseRewardMessage
