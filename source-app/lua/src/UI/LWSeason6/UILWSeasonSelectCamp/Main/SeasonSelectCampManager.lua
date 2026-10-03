local SeasonSelectCamp_InfoData = require("UI.LWSeason6.UILWSeasonSelectCamp.Main.SeasonSelectCamp_InfoData")
local SeasonSelectCampManager = BaseClass("SeasonSelectCampManager")

function SeasonSelectCampManager:__init()
  self:InitVars()
end

function SeasonSelectCampManager:__delete()
end

function SeasonSelectCampManager:InitVars()
  self.InfoData = nil
  self.ActState = {Select = 1, EndShow = 2}
  self.Icons = {
    [0] = "Assets/Main/SeasonRes/S6/Sprites/SelectCamp/ljq_s6_jinbi_03.png",
    [1] = "Assets/Main/SeasonRes/S6/Sprites/SelectCamp/ljq_s6_jinbi_01.png",
    [2] = "Assets/Main/SeasonRes/S6/Sprites/SelectCamp/ljq_s6_jinbi_02.png"
  }
end

function SeasonSelectCampManager:SetActId(actId)
  self.ActId = actId
end

function SeasonSelectCampManager:GetActData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.ActId)
end

function SeasonSelectCampManager:GetCurActState()
  local selectEndTime = self:GetSelectEndTime()
  if selectEndTime > UITimeManager:GetInstance():GetServerTime() then
    return self.ActState.Select, selectEndTime
  end
  local actData = self:GetActData()
  if actData ~= nil then
    local endTime = actData:GetShowEndTime()
    if 0 < endTime then
      return self.ActState.EndShow, endTime
    end
  end
  return self.ActState.EndShow, 0
end

function SeasonSelectCampManager:GetCurServerCamp()
  if self.InfoData == nil then
    return nil
  end
  return self.InfoData.ServerCamp
end

function SeasonSelectCampManager:GetCurServerZone()
  if self.InfoData == nil then
    return nil
  end
  return self.InfoData.ServerZone
end

function SeasonSelectCampManager:GetMyCampId()
  if self.InfoData == nil then
    return 0
  end
  local serverCamp = self.InfoData.ServerCamp
  if serverCamp then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    for serverId, campId in pairs(serverCamp) do
      if mySourceServerId == checknumber(serverId) then
        return campId
      end
    end
  end
  return 0
end

function SeasonSelectCampManager:GetSelectEndTime()
  local actData = self:GetActData()
  if actData ~= nil then
    local startTime = actData:GetShowStartTime()
    local actCell = self:GetActCell()
    if actCell ~= nil then
      local normalDay = checknumber(actCell.para_1)
      return startTime + normalDay * 24 * 3600 * 1000
    end
  end
  return 0
end

function SeasonSelectCampManager:IsSelectState()
  return self:GetCurActState() == self.ActState.Select
end

function SeasonSelectCampManager:IsEndShowState()
  return self:GetCurActState() == self.ActState.EndShow
end

function SeasonSelectCampManager:GetActCell()
  if checknumber(self.ActId) > 0 then
    return LocalController:instance():getLine(TableName.Activity, checknumber(self.ActId))
  end
  return nil
end

function SeasonSelectCampManager:GetCd()
  local actData = self:GetActData()
  if actData ~= nil then
    return checknumber(actData.para_2) * 1000
  end
  return 0
end

function SeasonSelectCampManager:IsCdValid()
  if self.InfoData == nil then
    return false, 0
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local nextSetTime = self.InfoData:GetLastSetTime() + self:GetCd()
  if curTime < nextSetTime then
    return false, nextSetTime - curTime
  end
  return true, 0
end

function SeasonSelectCampManager:GetCurSelectId()
  if self.InfoData == nil then
    return 0
  end
  local myCampData = self.InfoData:GetMyCampData()
  if myCampData ~= nil then
    return checknumber(myCampData.SelectId)
  end
  return 0
end

function SeasonSelectCampManager:ClearInfoData()
  self.InfoData = nil
end

function SeasonSelectCampManager:SendGetInfo()
  SFSNetwork.SendMessage(MsgDefines.ActivitySelectcampInfo)
end

function SeasonSelectCampManager:OnGetInfoCallback(payload)
  if self.InfoData == nil then
    self.InfoData = SeasonSelectCamp_InfoData.New()
  end
  self.InfoData:SetData(payload)
  EventManager:GetInstance():Broadcast(EventId.SeasonSelectCampInfoUpdate)
end

function SeasonSelectCampManager:CheckSelectCondition(toastReason)
  local valid = true
  local msg = ""
  if self:GetCurActState() ~= self.ActState.Select then
    valid = false
  end
  if self.InfoData == nil then
    valid = false
    return false, ""
  end
  local campData = self.InfoData:GetMyCampData()
  if campData == nil or not campData.ImLeaderServerKing then
    valid = false
    msg = CS.GameEntry.Localization:GetString("season_s6_activity_1200080_desc13")
  end
  local isCdValid, waitTime = self:IsCdValid()
  if not isCdValid then
    valid = false
    if 0 < waitTime then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(waitTime)
      msg = CS.GameEntry.Localization:GetString("season_s6_activity_1200080_desc14", timeStr)
    end
  end
  if not valid and toastReason and not string.IsNullOrEmpty(msg) then
    UIUtil.ShowTips(msg)
  end
  return valid, msg
end

function SeasonSelectCampManager:SendSelect(selectId, toastReason)
  local valid, _ = self:CheckSelectCondition(toastReason)
  if valid then
    selectId = Mathf.Clamp(checknumber(selectId), 0, 2)
    local param = {}
    param.value = selectId
    SFSNetwork.SendMessage(MsgDefines.ActivitySelectcampSelect, param)
    return true
  end
  return false
end

function SeasonSelectCampManager:OnSelectCallback(payload)
  if payload ~= nil and self.InfoData ~= nil then
    self.InfoData:HandleSelect(payload)
    EventManager:GetInstance():Broadcast(EventId.SeasonSelectCampSelectIdUpdate)
  end
end

return SeasonSelectCampManager
