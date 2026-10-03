local ActivityEventInfoGetMessage = BaseClass("ActivityEventInfoGetMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
  CommonUtil.ProtectCall(function()
    local valueType = type(activityId)
    if valueType ~= "string" and valueType ~= "number" then
      Logger.LogError("ActivityEventInfoGetMessage: activityId type error")
      return
    elseif valueType == "string" then
      local number_id = tonumber(activityId)
      if number_id == nil then
        Logger.LogError("ActivityEventInfoGetMessage: activityId type error")
        return
      end
    end
  end)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.success == nil then
    DataCenter.ActivityListDataManager:RetEventData(t)
    if t.type == EnumActivity.AllianceCompete.EventType then
      EventManager:GetInstance():Broadcast(EventId.RefreshAllianceArmsUI)
    end
    if t.activityType == EnumActivity.LuckyShop.Type then
      DataCenter.LuckyShopManager:RefreshShopHandler(t)
    elseif t.activityType == EnumActivity.ContinuePay.Type then
      DataCenter.ContinuePayActivityManager:UpdateActDetailInfo(t)
    elseif t.activityType == EnumActivity.BargainShop.Type then
      EventManager:GetInstance():Broadcast(EventId.RefreshBargainShop)
    end
    if t.activityType == EnumActivity.LimitedTimeFeast.Type then
      DataCenter.ActLimitedTimeFeastData:RefreshActDetailData(t)
    end
    if t.activityType == EnumActivity.ActMonopoly.Type then
      DataCenter.ActMonopolyDataManager:RefreshActDetailData(t)
      EventManager:GetInstance():Broadcast(EventId.ActMonopolyDetailData)
    end
    if t.activityType == EnumActivity.ActBingo.Type then
      DataCenter.ActBingoDataManager:RefreshActDetailData(t)
      EventManager:GetInstance():Broadcast(EventId.ActBingoDetailData)
    end
    if t.activityType == EnumActivity.ActSlotMachine.Type then
      DataCenter.ActSlotMachineDataManager:RefreshActDetailData(t)
      EventManager:GetInstance():Broadcast(EventId.ActSlotDetailData)
    end
    if t.activityType == EnumActivity.ActTask.Type then
      DataCenter.ActTaskManager:RefreshActDetailData(t)
    end
    if t.activityType == EnumActivity.TorchRelay.Type then
      DataCenter.ActivityTorchRelayTaskManager:ParseTaskUpdateByDayServerData(t)
    end
    if t.activityType == EnumActivity.RevivalPlan.Type then
      DataCenter.RevivalPlanManager:RefreshKeyReplaceState()
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

ActivityEventInfoGetMessage.OnCreate = OnCreate
ActivityEventInfoGetMessage.HandleMessage = HandleMessage
return ActivityEventInfoGetMessage
