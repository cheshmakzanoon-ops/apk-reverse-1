local PushBatchEffectChangeMessage = BaseClass("PushBatchEffectChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if LuaEntry.Effect ~= nil then
    local preEarthOrderEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_UNLOCK)
    local preRadarCenterEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.DETECT_EVENT_FUNCTION_OPEN)
    local monopolyOpenEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MONOPOLY_FUNCTION_OPEN)
    local preVisitorEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.VISITOR_EVENT_FUNCTION_OPEN)
    local nowStageAddTime = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_STAGE_ADDTIME)
    local nowAlarmOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_ALARM_OPEN)
    local nowHospitalMaxStock = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_HOSPITAL_MAX_STOCK)
    LuaEntry.Effect:OnEffectChange(t)
    local nowEarthOrderEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_UNLOCK)
    local nowRadarCenterEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.DETECT_EVENT_FUNCTION_OPEN)
    local newMonopolyOpenEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MONOPOLY_FUNCTION_OPEN)
    local nowVisitorEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.VISITOR_EVENT_FUNCTION_OPEN)
    local newStageAddTime = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_STAGE_ADDTIME)
    local newAlarmOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_ALARM_OPEN)
    local newHospitalMaxStock = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_HOSPITAL_MAX_STOCK)
    if preRadarCenterEffect ~= nowRadarCenterEffect then
      DataCenter.RadarCenterDataManager:GetDetectEventData()
    end
    if preEarthOrderEffect ~= nowEarthOrderEffect then
      DataCenter.EarthOrderDataManager:SendGetEarthOrder()
    end
    if nowStageAddTime ~= newStageAddTime then
      DataCenter.StageManager:UpdateHangUpMaxTime()
    end
    if monopolyOpenEffect ~= newMonopolyOpenEffect then
      DataCenter.MonopolyManager:SendInitMessage()
      DataCenter.CityZoneMgr.cityZoneFog:UnLockTwo()
      DataCenter.MonopolyManager:TryUnlock()
    end
    if preVisitorEffect ~= nowVisitorEffect then
      DataCenter.CityVisitorManager:GetNewVisitorInfo()
    end
    if nowAlarmOpen ~= newAlarmOpen then
      EventManager:GetInstance():Broadcast(EventId.Alarm_Open)
    end
    if nowHospitalMaxStock ~= newHospitalMaxStock then
      EventManager:GetInstance():Broadcast(EventId.RefreshHospitalMaxEffect)
    end
    EventManager:GetInstance():Broadcast(EventId.EffectNumChange)
  end
end

PushBatchEffectChangeMessage.OnCreate = OnCreate
PushBatchEffectChangeMessage.HandleMessage = HandleMessage
return PushBatchEffectChangeMessage
