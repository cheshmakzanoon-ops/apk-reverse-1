local OfficialApplyItemTemplate = require("DataCenter.GovernmentManager.OfficialApply.OfficialApplyItemTemplate")
local OfficialAppointItemTemplate = require("DataCenter.GovernmentManager.OfficialApply.OfficialAppointItemTemplate")
local OfficialAppointmentItemTemplate = require("DataCenter.GovernmentManager.OfficialApply.OfficialAppointmentItemTemplate")
local string_IsNullOrEmpty = string.IsNullOrEmpty
local Localization = CS.GameEntry.Localization
local SFSNetwork = _ENV.SFSNetwork
local MsgDefines = _ENV.MsgDefines
local LuaEntry = _ENV.LuaEntry
local Vibrator = CS.Vibrator
local OfficialApplyManager = BaseClass("OfficialApplyManager", CEventable)

local function __init(self)
  self.applyList = {}
  self.appointsLogList = {}
  self.ownApplyPositionId = nil
  self.ownApplyTimeList = {}
  self.canApplyList = nil
  self.ownPostionId = nil
  self.canPop = false
  self.cacheHandler = nil
  self.appointmentList = {}
  self.maxApplyNum = nil
  self.isApplyListFull = nil
  self.isAppointmentListFull = nil
  self.viewPositionId = nil
  self:AddListener()
end

local function __delete(self)
  self.applyList = nil
  self.appointsLogList = nil
  self.ownApplyPositionId = nil
  self.ownApplyTimeList = nil
  self.canApplyList = nil
  self.ownPostionId = nil
  self.canPop = nil
  self.cacheHandler = nil
  self.appointmentList = nil
  self.maxApplyNum = nil
  self.isApplyListFull = nil
  self.isAppointmentListFull = nil
  self.viewPositionId = nil
  self:RemoveListener()
end

local function AddListener(self)
  self:RegisterEvent(EventId.SelfOfficialPositionChange, self.OnSelfOfficialPositionChange)
end

local function RemoveListener(self)
  self:UnregisterEvent(EventId.SelfOfficialPositionChange)
end

local function OnSelfOfficialPositionChange(self)
  local positionId = DataCenter.GovernmentManager:GetPositionId()
  self:CheckNeedGetAllPositionApplyList(positionId)
end

local function InitData(self, msg)
  if msg.positionInfo and msg.positionInfo.applyPosition then
    self:SetOwnApplyPositionId(msg.positionInfo.applyPosition)
  end
  self:CheckNeedGetAllPositionApplyList(msg.positionInfo.positionId)
end

local function CheckNeedGetAllPositionApplyList(self, positionId)
  if not string.IsNullOrEmpty(positionId) then
    positionId = tonumber(positionId)
    if positionId == 10001 or positionId == 10002 then
      local list = self:GetCanApplyGovernmentList()
      for index, value in ipairs(list) do
        SFSNetwork.SendMessage(MsgDefines.KingdomPositionApplyList, value)
      end
    end
  end
end

local function RefreshOwnApplyTime(self, msg)
  if msg and msg.positionId then
    self.ownApplyTimeList[msg.positionId] = msg.applyTime or 0
    EventManager:GetInstance():Broadcast(EventId.OfficialApplyDownRefresh, msg.positionId)
  end
end

local function InitApplyList(self, msg)
  if msg == nil then
    return
  end
  self.applyList[msg.positionId] = {}
  self.ownApplyTimeList[msg.positionId] = msg.applyTime or 0
  for index, value in ipairs(msg.applyArr) do
    local officialApplyItem = OfficialApplyItemTemplate.New()
    officialApplyItem:ParseData(value)
    table.insert(self.applyList[msg.positionId], officialApplyItem)
  end
  EventManager:GetInstance():Broadcast(EventId.OfficialApplyListInit, msg.positionId)
  self.isApplyListFull = #self.applyList[msg.positionId] >= OfficialApplyManager.GetMaxApplyNum(self)
  self:SetOwnApplyPositionId(msg.applyPosition)
end

local function RefreshApplyList(self, msg)
  if msg == nil then
    return
  end
  local isChange = false
  local isOwnAdd = false
  if msg.delUid then
    local applyList = self.applyList[msg.positionId]
    if applyList then
      for i = #applyList, 1, -1 do
        if applyList[i].uid == msg.delUid then
          table.remove(applyList, i)
          isChange = true
          break
        end
      end
    end
    if msg.delUid == LuaEntry.Player.uid then
      self:SetOwnApplyPositionId(nil)
    end
  elseif msg.apply then
    local applyList = self.applyList[msg.positionId]
    if applyList then
      local officialApplyItem = OfficialApplyItemTemplate.New()
      officialApplyItem:ParseData(msg.apply)
      table.insert(applyList, officialApplyItem)
      isChange = true
      if msg.apply.uid == LuaEntry.Player.uid then
        self:SetOwnApplyPositionId(msg.positionId)
        isOwnAdd = true
      end
    end
  end
  if isChange then
    if isOwnAdd then
      EventManager:GetInstance():Broadcast(EventId.OfficialApplyListRefresh, {
        positionId = msg.positionId,
        moveIndex = #self.applyList[msg.positionId]
      })
    else
      EventManager:GetInstance():Broadcast(EventId.OfficialApplyListRefresh, {
        positionId = msg.positionId
      })
    end
    EventManager:GetInstance():Broadcast(EventId.OfficialApplyTipRefresh)
    self.isApplyListFull = #self.applyList[msg.positionId] >= OfficialApplyManager.GetMaxApplyNum(self)
  end
end

local function InitAppointsLogList(self, msg)
  if msg == nil then
    return
  end
  self.appointsLogList[msg.positionId] = {}
  for index, value in ipairs(msg.arr) do
    local officialAppointItem = OfficialAppointItemTemplate.New()
    officialAppointItem:ParseData(value)
    table.insert(self.appointsLogList[msg.positionId], officialAppointItem)
  end
  EventManager:GetInstance():Broadcast(EventId.OfficialAppointLogListInit, msg.positionId)
end

local function GetCanApplyGovernmentList(self)
  if self.canApplyList == nil then
    local cfg = LuaEntry.DataConfig:TryGetStr("auto_wonder_config", "k5")
    if cfg then
      self.canApplyList = string.split(cfg, ";")
    end
  end
  return self.canApplyList
end

local function GetApplyList(self, positionId)
  return self.applyList[positionId]
end

local function GetAppointmentList(self, positionId)
  return self.appointmentList[positionId]
end

local function GetAppointLogList(self, positionId)
  return self.appointsLogList[positionId]
end

local function GetApplyListOwnIndex(self, positionId)
  local index = #self.applyList[positionId]
  local uid = LuaEntry.Player.uid
  for i, v in ipairs(self.applyList[positionId]) do
    if v.uid == uid then
      index = i
      break
    end
  end
  return index
end

local function GetAppointmentListOwnIndex(self, positionId)
  local index = #self.appointmentList[positionId]
  local uid = LuaEntry.Player.uid
  for i, v in ipairs(self.appointmentList[positionId]) do
    if v.uid == uid then
      index = i
      break
    end
  end
  return index
end

local function GetOwnAppointIdName(self)
  local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByUID(LuaEntry.Player.uid)
  if positionInfo then
    local id = positionInfo.positionId
    local list = self:GetCanApplyGovernmentList()
    for _, value in ipairs(list) do
      if tostring(id) == value then
        local template = DataCenter.GovernmentTemplateManager:GetTemplate(id)
        return id, Localization:GetString(template.name)
      end
    end
    return id, ""
  end
  return nil
end

local function SetOwnApplyPositionId(self, applyPositionId)
  if self.ownApplyPositionId ~= applyPositionId then
    Logger.LogInfo("OldOwnApplyPositionId: " .. tostring(self.ownApplyPositionId))
    Logger.LogInfo("NewOwnApplyPositionId: " .. tostring(applyPositionId))
  end
  self.ownApplyPositionId = applyPositionId
  EventManager:GetInstance():Broadcast(EventId.OfficialApplyTipRefresh)
end

local function GetOwnApplyPositionId(self)
  return self.ownApplyPositionId
end

local function GetOwnApplyCD(self, positionId)
  if self.ownApplyTimeList and self.ownApplyTimeList[positionId] then
    local cfgCD = LuaEntry.DataConfig:TryGetNum("auto_wonder_config", "k7")
    return self.ownApplyTimeList[positionId] + cfgCD * 1000 - UITimeManager:GetInstance():GetServerTime()
  else
    return 0
  end
end

local function GetOwnApplicantData(self, positionId, isServer)
  local str, cd
  local myCurOffice = false
  local cfgLvl = LuaEntry.DataConfig:TryGetNum("auto_wonder_config", "k1")
  local cfgMax = LuaEntry.DataConfig:TryGetNum("auto_wonder_config", "k3")
  local cfgCD = LuaEntry.DataConfig:TryGetNum("auto_wonder_config", "k7")
  local officialId, nowOfficialName = self:GetOwnAppointIdName()
  local curPresident = DataCenter.GovernmentManager:GetCurPresident(LuaEntry.Player:GetSourceServerId())
  if curPresident == nil then
    str = Localization:GetString("officer_apply_020")
  elseif cfgLvl > DataCenter.BuildManager.MainLv then
    str = Localization:GetString("officer_apply_008", cfgLvl)
  elseif self.viewPositionId == positionId and OfficialApplyManager.GetMoveIndexInAppointmentList(self, positionId) > -1 then
    local info = OfficialApplyManager.GetAppointmentInfo(self, positionId)
    if info then
      local time
      if isServer then
        time = UITimeManager:GetInstance():TimeStampToTimeForServer(tonumber(info.appointTime))
      else
        time = UITimeManager:GetInstance():TimeStampToTimeForLocal(tonumber(info.appointTime))
      end
      str = Localization:GetString("officer_apply_033", time)
    end
  elseif self.applyList[positionId] and cfgMax <= #self.applyList[positionId] and self:GetOwnApplyPositionId() ~= positionId then
    str = Localization:GetString("officer_apply_004")
  elseif officialId and nowOfficialName then
    if officialId == positionId then
      str = Localization:GetString("officer_apply_051", nowOfficialName)
      myCurOffice = true
    else
      str = Localization:GetString("officer_apply_006", nowOfficialName)
    end
  else
    local ownApplyPositionId = self:GetOwnApplyPositionId()
    if ownApplyPositionId then
      if ownApplyPositionId == positionId then
        str = Localization:GetString("officer_apply_003")
      else
        local template = DataCenter.GovernmentTemplateManager:GetTemplate(ownApplyPositionId)
        str = Localization:GetString("officer_apply_005", Localization:GetString(template.name))
      end
    elseif self.ownApplyTimeList[positionId] and cfgCD * 1000 >= UITimeManager:GetInstance():GetServerTime() - self.ownApplyTimeList[positionId] then
      str = "officer_apply_007"
      cd = self:GetOwnApplyCD(positionId)
    else
      str = nil
    end
  end
  return str, cd, myCurOffice
end

local function SendGetFirstKingdomPositionApplyList(self)
  local list = self:GetCanApplyGovernmentList()
  local positionId = list[1]
  if self.ownApplyPositionId then
    positionId = self.ownApplyPositionId
  end
  SFSNetwork.SendMessage(MsgDefines.KingdomPositionApplyList, positionId)
end

local function IsManager(self, serverId)
  return LuaEntry.Player:IsPresident(serverId) or LuaEntry.Player:IsFirstLady(serverId)
end

local function GetOwnPositionId(self)
  if self.ownPostionId == nil then
    self.ownPostionId = CommonUtil.PlayerPrefsGetString(SettingKeys.GOVERMENT_OWN_POSITIONID, "")
  end
  return self.ownPostionId
end

local function SaveOwnPositionId(self, positionId)
  if positionId == nil then
    positionId = ""
  end
  local oldPositionId = self:GetOwnPositionId()
  if oldPositionId ~= positionId then
    Vibrator.ContinuousHaptic(0.25, 0.25, 0.25, 2)
  end
  if self.canPop then
    self:ShowOwnOfficialChangeMessage(oldPositionId, positionId)
  else
    function self.cacheHandler()
      self:ShowOwnOfficialChangeMessage(oldPositionId, positionId)
    end
  end
  self.ownPostionId = positionId
  CommonUtil.PlayerPrefsSetString(SettingKeys.GOVERMENT_OWN_POSITIONID, positionId)
  EventManager:GetInstance():Broadcast(EventId.SaveOwnPositionId, positionId)
end

local function ShowOwnOfficialChangeMessage(self, oldPositionId, positionId)
  if oldPositionId ~= positionId then
    local newMsg
    local showTime = 2
    if string.IsNullOrEmpty(positionId) then
      if not string.IsNullOrEmpty(oldPositionId) then
        local configData = DataCenter.GovernmentTemplateManager:GetTemplate(oldPositionId)
        newMsg = {
          msg = Localization:GetString("officer_apply_022", Localization:GetString(configData.name))
        }
      end
    else
      local configData = DataCenter.GovernmentTemplateManager:GetTemplate(positionId)
      newMsg = {
        msg = Localization:GetString("officer_apply_021", Localization:GetString(configData.name)),
        iconPath = configData.icon
      }
    end
    if self.canPop then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIOfficialMessageBar, {anim = true, playEffect = false}, newMsg, showTime)
    else
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIOfficialMessageBar, {anim = true, playEffect = false}, newMsg, showTime)
    end
  end
end

local function ShowLoginPop(self)
  if self.cacheHandler then
    self.cacheHandler()
    self.cacheHandler = nil
  end
  self.canPop = true
end

local function CheckCanApply(self, positionId)
  local list = self:GetCanApplyGovernmentList()
  local canApply = false
  for index, value in ipairs(list) do
    if value == positionId then
      canApply = true
      break
    end
  end
  return canApply
end

local function HaveApplyRed(self, positionId)
  local red = false
  local autoAgreeInfo = DataCenter.GovernmentManager:GetKingdomPositionAutoAgreeInfo()
  local autoAgree = autoAgreeInfo and autoAgreeInfo.autoAgree
  for key, value in pairs(self.applyList) do
    if (positionId == nil or key == positionId) and 0 < #value and (not autoAgree or tonumber(key) == 10002) then
      red = true
      break
    end
  end
  red = red and self:IsManager(LuaEntry.Player:GetSourceServerId())
  return red
end

local function InitAppointmentList(self, msg)
  if msg == nil then
    return
  end
  self.appointsLogList[msg.positionId] = {}
  for index, value in ipairs(msg.arr) do
    local officialAppointItem = OfficialAppointItemTemplate.New()
    officialAppointItem:ParseData(value)
    table.insert(self.appointsLogList[msg.positionId], officialAppointItem)
  end
  EventManager:GetInstance():Broadcast(EventId.OfficialAppointLogListInit, msg.positionId)
end

local function GetMaxApplyNum(self)
  if self.maxApplyNum == nil then
    self.maxApplyNum = LuaEntry.DataConfig:TryGetNum("auto_wonder_config", "k2")
  end
  return self.maxApplyNum
end

local function GetMaxAppointmentNum(self)
  if self.maxAppointmentNum == nil then
    self.maxAppointmentNum = LuaEntry.DataConfig:TryGetNum("auto_wonder_config", "k3")
  end
  return self.maxAppointmentNum
end

local function GetApplyListFull(self)
  return self.isApplyListFull
end

local function GetAppointmentListFull(self)
  return self.isAppointmentListFull
end

local function UpdateAppointmentList(self, msg)
  if msg == nil then
    return
  end
  local positionId = msg.positionId
  if self.appointmentList[positionId] ~= nil then
    table.clear(self.appointmentList[positionId])
  else
    self.appointmentList[positionId] = {}
  end
  local isInList = false
  local uid = LuaEntry.Player.uid
  for _, v in ipairs(msg.applyArr) do
    local officialAppointmentItem = OfficialAppointmentItemTemplate.New()
    officialAppointmentItem:ParseData(v)
    table.insert(self.appointmentList[positionId], officialAppointmentItem)
    if v.uid == uid then
      isInList = true
    end
  end
  self:SetOwnApplyPositionId(msg.applyPosition)
  EventManager:GetInstance():Broadcast(EventId.OfficialAppointmentListRefresh, positionId)
  self.isAppointmentListFull = #self.appointmentList[positionId] >= OfficialApplyManager.GetMaxAppointmentNum(self)
end

local function SendKingdomPositionAppointmentList(self, positionId, update)
  if string_IsNullOrEmpty(positionId) then
    return
  end
  if update then
    self.viewPositionId = positionId
  elseif string_IsNullOrEmpty(self.viewPositionId) or positionId ~= self.viewPositionId then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.KingdomPositionAppointmentList, positionId)
end

local function SetViewPositionId(self, positionId)
  self.viewPositionId = positionId
end

local function GetAppointmentInfo(self, positionId)
  if self.appointmentList and self.appointmentList[positionId] then
    local uid = LuaEntry.Player.uid
    for _, v in ipairs(self.appointmentList[positionId]) do
      if v and v.uid == uid then
        return v
      end
    end
  end
end

local function SendKingdomPositionApplyAgree(self, positionId, uid, t)
  if string_IsNullOrEmpty(positionId) or string_IsNullOrEmpty(uid) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.KingdomPositionApplyAgree, {
    positionId = positionId,
    uid = uid,
    t = t
  })
end

local function SendKingdomPositionApplyList(self, positionId)
  SFSNetwork.SendMessage(MsgDefines.KingdomPositionApplyList, positionId)
end

local function GetMoveIndexInAppointmentList(self, positionId)
  if positionId and self.viewPositionId and self.viewPositionId == positionId then
    local list = self.appointmentList[positionId]
    if list then
      local uid = LuaEntry.Player.uid
      for i, v in ipairs(list) do
        if v.uid == uid then
          return i - 1
        end
      end
    end
  end
  return -1
end

local function GetResignOfficeTime(self)
  local cfgCD = LuaEntry.DataConfig:TryGetNum("auto_wonder_config", "k12")
  return cfgCD
end

OfficialApplyManager.__init = __init
OfficialApplyManager.__delete = __delete
OfficialApplyManager.AddListener = AddListener
OfficialApplyManager.RemoveListener = RemoveListener
OfficialApplyManager.InitData = InitData
OfficialApplyManager.RefreshOwnApplyTime = RefreshOwnApplyTime
OfficialApplyManager.InitApplyList = InitApplyList
OfficialApplyManager.RefreshApplyList = RefreshApplyList
OfficialApplyManager.InitAppointsLogList = InitAppointsLogList
OfficialApplyManager.GetCanApplyGovernmentList = GetCanApplyGovernmentList
OfficialApplyManager.OfficialApplyManager = OfficialApplyManager
OfficialApplyManager.GetApplyList = GetApplyList
OfficialApplyManager.GetAppointLogList = GetAppointLogList
OfficialApplyManager.GetApplyListOwnIndex = GetApplyListOwnIndex
OfficialApplyManager.GetOwnAppointIdName = GetOwnAppointIdName
OfficialApplyManager.SetOwnApplyPositionId = SetOwnApplyPositionId
OfficialApplyManager.GetOwnApplyPositionId = GetOwnApplyPositionId
OfficialApplyManager.GetOwnApplyCD = GetOwnApplyCD
OfficialApplyManager.GetOwnApplicantData = GetOwnApplicantData
OfficialApplyManager.SendGetFirstKingdomPositionApplyList = SendGetFirstKingdomPositionApplyList
OfficialApplyManager.IsManager = IsManager
OfficialApplyManager.GetOwnPositionId = GetOwnPositionId
OfficialApplyManager.SaveOwnPositionId = SaveOwnPositionId
OfficialApplyManager.ShowOwnOfficialChangeMessage = ShowOwnOfficialChangeMessage
OfficialApplyManager.ShowLoginPop = ShowLoginPop
OfficialApplyManager.CheckCanApply = CheckCanApply
OfficialApplyManager.HaveApplyRed = HaveApplyRed
OfficialApplyManager.InitAppointmentList = InitAppointmentList
OfficialApplyManager.GetMaxApplyNum = GetMaxApplyNum
OfficialApplyManager.GetMaxAppointmentNum = GetMaxAppointmentNum
OfficialApplyManager.GetApplyListFull = GetApplyListFull
OfficialApplyManager.GetAppointmentListFull = GetAppointmentListFull
OfficialApplyManager.UpdateAppointmentList = UpdateAppointmentList
OfficialApplyManager.SendKingdomPositionAppointmentList = SendKingdomPositionAppointmentList
OfficialApplyManager.SetViewPositionId = SetViewPositionId
OfficialApplyManager.GetAppointmentInfo = GetAppointmentInfo
OfficialApplyManager.GetAppointmentListOwnIndex = GetAppointmentListOwnIndex
OfficialApplyManager.GetAppointmentList = GetAppointmentList
OfficialApplyManager.SendKingdomPositionApplyAgree = SendKingdomPositionApplyAgree
OfficialApplyManager.SendKingdomPositionApplyList = SendKingdomPositionApplyList
OfficialApplyManager.GetMoveIndexInAppointmentList = GetMoveIndexInAppointmentList
OfficialApplyManager.OnSelfOfficialPositionChange = OnSelfOfficialPositionChange
OfficialApplyManager.CheckNeedGetAllPositionApplyList = CheckNeedGetAllPositionApplyList
OfficialApplyManager.GetResignOfficeTime = GetResignOfficeTime
return OfficialApplyManager
