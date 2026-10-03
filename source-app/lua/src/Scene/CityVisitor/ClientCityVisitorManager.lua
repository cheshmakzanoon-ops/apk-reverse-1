local ClientCityVisitorManager = BaseClass("ClientCityVisitorManager")

local function AddListeners(self)
  self.RefreshAllianceListCallback = BindCallback(self, self.RefreshAllianceList)
  EventManager:GetInstance():AddListener(EventId.SearchAllianceSuccess, self.RefreshAllianceListCallback)
  self.AllianceBossActDataCallback = BindCallback(self, self.OnS0AllianceBossActDataRefresh)
  EventManager:GetInstance():AddListener(EventId.OnS0AllianceBossOnActInfoGot, self.AllianceBossActDataCallback)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.SearchAllianceSuccess, self.RefreshAllianceListCallback)
  self.RefreshAllianceListCallback = nil
  EventManager:GetInstance():RemoveListener(EventId.OnS0AllianceBossOnActInfoGot, self.AllianceBossActDataCallback)
  self.AllianceBossActDataCallback = nil
end

local function __init(self)
  AddListeners(self)
  self.allianceUid = nil
  self.isEnterGame = nil
end

local function __delete(self)
  RemoveListener(self)
  self.allianceUid = nil
  self.isEnterGame = nil
end

local function ShowAllianceInviteVisitor(self)
  self:CheckShowS0AllianceBossVisitor()
  local openServerDay = UITimeManager:GetInstance():GetOpenServerDay()
  local configDays = LuaEntry.DataConfig:TryGetNum("alliance_invite_config", "k1", 0)
  if openServerDay > configDays then
    return
  end
  if not DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.LW_BUILD_ALLIANCE_CENTER, 1) then
    return
  end
  if LuaEntry.Player:IsInAlliance() then
    return
  end
  if not self:GetTodayCanShowSecond(TodayNoSecondConfirmType.AllianceInviteVisitor) then
    return
  end
  self.isEnterGame = true
  SFSNetwork.SendMessage(MsgDefines.AlSearch, 1, 1, "", 0, true)
end

function ClientCityVisitorManager:RefreshAllianceList()
  if self.isEnterGame and SceneUtils.GetIsInCity() then
    self.isEnterGame = false
    local search_al_id_list = DataCenter.AllianceTempListManager:GetSearchAllianceIdList()
    local hasList = table.count(search_al_id_list) > 0
    if hasList then
      local allianceUid, tmpInfo, playerPower, playerMainLv
      playerPower = LuaEntry.Player.power
      playerMainLv = DataCenter.BuildManager.MainLv
      for i = 1, table.count(search_al_id_list) do
        tmpInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(search_al_id_list[i])
        if tmpInfo and next(tmpInfo) ~= nil and tmpInfo.curMember < tmpInfo.maxMember and tmpInfo.recruitTotal == 0 and playerPower >= tmpInfo.applyPowerLimit and playerMainLv >= tmpInfo.applyLevelLimit then
          allianceUid = tmpInfo.uid
          break
        end
      end
      self.allianceUid = allianceUid
      if string.IsNullOrEmpty(allianceUid) then
        return
      end
      self:CreateAllianceInviteVisitor()
      self:SetTodayNoShowSecond(TodayNoSecondConfirmType.AllianceInviteVisitor)
    end
  end
end

local function GetAllianceInviteVisitorData(self)
  return DataCenter.CityVisitorManager:CreateOneFakeVisitorDataByEventId(12001, 100012001)
end

local function CreateAllianceInviteVisitor(self)
  local visitor = self:GetAllianceInviteVisitorData()
  if visitor then
    visitor.allianceUid = self.allianceUid
    DataCenter.CityVisitorManager:TryAddVisitor(visitor, false)
  end
end

local function GetTodayCanShowSecond(self, showType)
  local time = Setting:GetPrivateString(showType, "")
  if time ~= "" then
    return not UITimeManager:GetInstance():IsSameDayForServer(tonumber(time), UITimeManager:GetInstance():GetServerSeconds())
  end
  return true
end

local function SetTodayNoShowSecond(self, showType)
  Setting:SetPrivateString(showType, tostring(UITimeManager:GetInstance():GetServerSeconds()))
end

local function OpenAllianceInvitePanel(self)
  local info
  if self.allianceUid then
    info = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceUid)
    local rebuildAlliance = DataCenter.CityRebuildDataManager:GetAllianceInfoInfo()
    if rebuildAlliance and rebuildAlliance.uid then
      info = rebuildAlliance
    end
  end
  if info then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceInvite, self.allianceUid)
  else
    UIUtil.ShowTipsId("alliance_invite_tips_err1")
  end
end

local function GMSetEnterGameTarget(self, state)
  self.isEnterGame = state
end

local function CheckShowS0AllianceBossVisitor(self)
  DataCenter.S0AllianceBossDataManager:CheckShowS0AllianceBossVisitor()
end

local function OnS0AllianceBossActDataRefresh(self, t)
  if t and t.type == 2 and SceneUtils.GetIsInCity() then
    local show = DataCenter.S0AllianceBossDataManager:CheckVisitorStatus()
    if show then
      self:CreateS0AllianceBossVisitor()
    end
  end
end

local function CreateS0AllianceBossVisitor(self)
  local visitor = self:GetS0AllianceBossVisitorData()
  if visitor then
    visitor.allianceUid = self.allianceUid
    DataCenter.CityVisitorManager:TryAddVisitor(visitor, false)
  end
end

local function GetS0AllianceBossVisitorData(self)
  return DataCenter.CityVisitorManager:CreateOneFakeVisitorDataByEventId(2091, 100002092)
end

ClientCityVisitorManager.__init = __init
ClientCityVisitorManager.__delete = __delete
ClientCityVisitorManager.GetAllianceInviteVisitorData = GetAllianceInviteVisitorData
ClientCityVisitorManager.CreateAllianceInviteVisitor = CreateAllianceInviteVisitor
ClientCityVisitorManager.GetTodayCanShowSecond = GetTodayCanShowSecond
ClientCityVisitorManager.SetTodayNoShowSecond = SetTodayNoShowSecond
ClientCityVisitorManager.ShowAllianceInviteVisitor = ShowAllianceInviteVisitor
ClientCityVisitorManager.OpenAllianceInvitePanel = OpenAllianceInvitePanel
ClientCityVisitorManager.GMSetEnterGameTarget = GMSetEnterGameTarget
ClientCityVisitorManager.GetS0AllianceBossVisitorData = GetS0AllianceBossVisitorData
ClientCityVisitorManager.CheckShowS0AllianceBossVisitor = CheckShowS0AllianceBossVisitor
ClientCityVisitorManager.OnS0AllianceBossActDataRefresh = OnS0AllianceBossActDataRefresh
ClientCityVisitorManager.CreateS0AllianceBossVisitor = CreateS0AllianceBossVisitor
return ClientCityVisitorManager
