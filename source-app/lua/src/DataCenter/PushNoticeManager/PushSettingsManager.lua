local PushSettingsManager = BaseClass("PushSettingsManager")
local jumpCd = 604800
local START_TIP_SHOW_COUNT = 18

function PushSettingsManager:InitData(msg)
  self.settingsDatas = {}
  self.settingsMap = {}
  self.pushUserChatDatas = {}
  self.pushGroupChatDatas = {}
  local showCount = 0
  local tbl = LocalController:instance():getTable(TableName.APS_PUSH_SETTINGS)
  for id, _ in pairs(tbl.data) do
    local data = LocalController:instance():getLine(TableName.APS_PUSH_SETTINGS, id)
    self.settingsDatas[id] = data
    self.settingsDatas[id].isOn = 0 < data.default
    for _, pushId in ipairs(data.push_ids) do
      self.settingsMap[pushId] = data
    end
    if self:CheckSettingShow(data) then
      showCount = showCount + 1
    end
  end
  self:InitPushSettingUserList(msg)
  self:InitPushSettingGroupChatList(msg)
  local settingsMsg = msg.lwPushSettings
  self.settingsMsg = settingsMsg
  if settingsMsg then
    for i, id in ipairs(settingsMsg.idList) do
      if self.settingsDatas[id] then
        self.settingsDatas[id].isOn = 0 < settingsMsg.stateList[i]
      end
    end
    self.isShowRedPoint = showCount > #settingsMsg.idList and showCount > START_TIP_SHOW_COUNT
  else
    self.isShowRedPoint = false
    self:SaveSettings()
  end
end

function PushSettingsManager:InitPushSettingGroupChatList(msg)
  self.pushGroupChatDatas = {}
  local pushChatMsg = msg.lwPushGroupChat
  if pushChatMsg then
    for i, id in pairs(pushChatMsg) do
      self.pushGroupChatDatas[id] = true
    end
  end
end

function PushSettingsManager:InitPushSettingUserList(msg)
  self.pushUserChatDatas = {}
  local pushChatMsg = msg.lwPushChat
  if pushChatMsg then
    for i, id in pairs(pushChatMsg) do
      self.pushUserChatDatas[id] = true
    end
  end
end

function PushSettingsManager:GetDisplayDatas()
  local datas = {}
  if not CS.GameEntry.Sdk:GetIsNotifyOpen() then
    datas[1] = {order = -1}
  end
  for _, data in pairs(self.settingsDatas) do
    if self:CheckSettingShow(data) then
      table.insert(datas, data)
    end
  end
  table.sort(datas, function(a, b)
    return a.order < b.order
  end)
  return datas
end

function PushSettingsManager:IsPushOn(pushId)
  return self.settingsMap and self.settingsMap[pushId] and self.settingsMap[pushId].isOn
end

function PushSettingsManager:GetUserPushSetting(uid)
  return self.pushUserChatDatas[uid]
end

function PushSettingsManager:SetGroupChatSetting(roomId, state)
  if state == 1 then
    self.pushGroupChatDatas[roomId] = true
  else
    self.pushGroupChatDatas[roomId] = nil
  end
end

function PushSettingsManager:GetGroupChatPushSetting(roomId)
  return self.pushGroupChatDatas[roomId]
end

function PushSettingsManager:GetIsPushJump()
  local time = self:GetLastPushOpenTime()
  local curTime = UITimeManager:GetInstance():GetServerTime() / 1000
  if time == 0 or curTime - time >= jumpCd then
    return true
  end
end

function PushSettingsManager:GetLastPushOpenTime()
  return CommonUtil.PlayerPrefsGetInt("PushOpenTime", 0)
end

function PushSettingsManager:SetLastPushOpenTime()
  local curTime = math.floor(UITimeManager:GetInstance():GetServerTime() / 1000)
  return CommonUtil.PlayerPrefsSetInt("PushOpenTime", curTime)
end

function PushSettingsManager:CheckSettingShow(data)
  local show = true
  local open_type = data.open_type
  if not string.IsNullOrEmpty(open_type) then
    local split = string.split(open_type, ";")
    if 0 < #split then
      if tonumber(split[1]) == 1 then
        local nowSeason = DataCenter.SeasonDataManager:GetSeason()
        local day = UITimeManager:GetInstance():GetServerOpenDays()
        if nowSeason ~= 0 then
          day = DataCenter.SeasonDataManager:GetSeasonDurationDay() + 1
        end
        if nowSeason < tonumber(split[2]) or nowSeason == tonumber(split[2]) and day < tonumber(split[3]) then
          show = false
        end
      elseif tonumber(split[1]) == 2 then
        show = false
      end
    end
  end
  if data.id == 25 and not ChatInterface.IsAtOpen() then
    show = false
  end
  return show
end

function PushSettingsManager:HasNewPushUnread()
  return self.isShowRedPoint
end

function PushSettingsManager:UpdateSettingsMsg(idList, stateList)
  self.settingsMsg = self.settingsMsg or {}
  self.settingsMsg.idList = idList
  self.settingsMsg.stateList = stateList
  local showCount = 0
  for _, data in ipairs(self.settingsDatas) do
    if self:CheckSettingShow(data) then
      showCount = showCount + 1
    end
  end
  self.isShowRedPoint = showCount > #idList and showCount > START_TIP_SHOW_COUNT
end

function PushSettingsManager:IsPushUnread(id)
  if self.settingsMsg == nil then
    return false
  end
  if tonumber(id) <= START_TIP_SHOW_COUNT then
    return
  end
  for i, v in ipairs(self.settingsMsg.idList) do
    if id == v then
      return false
    end
  end
  return true
end

function PushSettingsManager:SaveSettings()
  if not self.settingsDatas then
    return
  end
  local idList = {}
  local stateList = {}
  for _, data in ipairs(self:GetDisplayDatas()) do
    if data.id then
      table.insert(idList, data.id)
      table.insert(stateList, data.isOn and 1 or 0)
    end
  end
  SFSNetwork.SendMessage(MsgDefines.LWSaveUserPushSettings, idList, stateList)
end

return PushSettingsManager
