local PushLottoBaseRewardMessage = BaseClass("PushLottoBaseRewardMessage", SFSBaseMessage)
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
    if statueType2 == StatusType2.BuildingRewardBubble2 then
      UIUtil.ShowTipsId("thxgiv_MapGiftGet")
    end
  end
  DataCenter.ActGiftGivingDataManager:SetActivityStatusReceiveDictPushMsg(t)
  EventManager:GetInstance():Broadcast(EventId.WorldRewardBubbleGetMsg)
end

PushLottoBaseRewardMessage.OnCreate = OnCreate
PushLottoBaseRewardMessage.HandleMessage = HandleMessage
return PushLottoBaseRewardMessage
