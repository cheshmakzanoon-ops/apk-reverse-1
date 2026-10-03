local DetectResultDataManager = BaseClass("DetectResultDataManager", CEventable)
local Localization = CS.GameEntry.Localization

local function StackPopIn(t, v)
  if t and type(t) == "table" then
    table.insert(t, v)
  end
end

local function StackPopOut(t)
  if t and type(t) == "table" and not table.IsEmpty(t) then
    return table.remove(t, #t)
  end
end

local function StackIsEmpty(t)
  if t and type(t) == "table" then
    return table.IsEmpty(t)
  else
    return true
  end
end

local function GetStackCountNoRepeat(self)
  if self.uid2MailCountMap then
    return table.count(self.uid2MailCountMap)
  end
end

function DetectResultDataManager:__init()
  if LuaEntry.DataConfig:CheckSwitch("scout_beta") then
    self:AddListener()
  end
  self.newMailUidStack = {}
  self.uid2MailCountMap = {}
  self.time2MailUidMap = {}
  self.keepMailMaxTime = LuaEntry.DataConfig:TryGetNum("scout_cd", "k3", 3600)
  self._firstEnterWorld = false
end

function DetectResultDataManager:__delete()
  self.newMailUidStack = nil
  self.uid2MailCountMap = nil
  self.time2MailUidMap = nil
  self.keepMailMaxTime = nil
  self._firstEnterWorld = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function GetScoutDataByMailUid(mailUid)
  local mailInfo = DataCenter.MailDataManager:GetMailInfoById(mailUid)
  return mailInfo
end

local function CompareTime(a, b)
  return tonumber(a) < tonumber(b)
end

local function timer_action(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local removePosList = {}
  for i = 1, table.count(self.newMailUidStack) do
    if (curTime - tonumber(self.newMailUidStack[i].time)) / 1000 > self.keepMailMaxTime then
      table.insert(removePosList, i)
    else
      break
    end
  end
  for k, v in ipairs(removePosList) do
    local removeData = table.remove(self.newMailUidStack, v - k + 1)
    local mailData = GetScoutDataByMailUid(removeData.mailUid)
    if mailData then
      local mailExtData = mailData:GetMailExt():GetExtData()
      local uid = removeData.mailUid
      if mailExtData.targetType == ScoutMailTargetType.MAIN_BUILDING then
        uid = mailData:GetMailExt():GetExtData().targetUser.uid
      end
      if self.uid2MailCountMap[uid] then
        self.uid2MailCountMap[uid] = self.uid2MailCountMap[uid] - 1
        if self.uid2MailCountMap[uid] <= 0 then
          self.uid2MailCountMap[uid] = nil
        end
      end
      self.time2MailUidMap[tostring(removeData.time)] = nil
    end
  end
  if not table.IsEmpty(removePosList) then
    CommonUtil.PlayerPrefsSetTable(SettingKeys.WORLD_SCOUT_RED_DOT, self.time2MailUidMap)
    EventManager:GetInstance():Broadcast(EventId.DetectResultDataUpdate, GetStackCountNoRepeat(self))
  end
end

function DetectResultDataManager:OnEnterWorld()
  if LuaEntry.DataConfig:CheckSwitch("scout_beta") and not self._firstEnterWorld then
    self._firstEnterWorld = true
    self.time2MailUidMap = CommonUtil.PlayerPrefsGetTable(SettingKeys.WORLD_SCOUT_RED_DOT, {})
    local timeList = table.keys(self.time2MailUidMap)
    table.sort(timeList, CompareTime)
    for _, v in ipairs(timeList) do
      local mailUid = self.time2MailUidMap[v]
      local mailData = GetScoutDataByMailUid(mailUid)
      if mailData then
        local data = {
          mailUid = mailUid,
          time = mailData.createTime
        }
        StackPopIn(self.newMailUidStack, data)
        local mailExtData = mailData:GetMailExt():GetExtData()
        if mailExtData.targetType == ScoutMailTargetType.MAIN_BUILDING then
          local targetUser = mailExtData.targetUser.uid
          self.uid2MailCountMap[targetUser] = (self.uid2MailCountMap[targetUser] or 0) + 1
        else
          self.uid2MailCountMap[mailUid] = (self.uid2MailCountMap[mailUid] or 0) + 1
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.DetectResultDataUpdate, GetStackCountNoRepeat(self))
    if self.timer == nil then
      self.timer = TimerManager:GetInstance():GetTimer(5, timer_action, self, false, false, true)
      self.timer:Start()
    end
    timer_action(self)
  end
end

function DetectResultDataManager:AddListener()
  self:RegisterEvent(EventId.MailPush, self.OnNewMailPush)
  self:RegisterEvent(EventId.OnEnterWorld, self.OnEnterWorld)
end

function DetectResultDataManager:OnNewMailPush(mailUid)
  if mailUid then
    local mailData = GetScoutDataByMailUid(mailUid)
    if mailData and IsMailScoutType(mailData.type) then
      local data = {
        mailUid = mailUid,
        time = mailData.createTime
      }
      StackPopIn(self.newMailUidStack, data)
      local createTime = mailData.createTime
      self.time2MailUidMap[tostring(createTime)] = mailUid
      CommonUtil.PlayerPrefsSetTable(SettingKeys.WORLD_SCOUT_RED_DOT, self.time2MailUidMap)
      local mailExtData = mailData:GetMailExt():GetExtData()
      local targetUser = mailExtData.targetUser.uid
      if mailExtData.targetType == ScoutMailTargetType.MAIN_BUILDING then
        if not self.uid2MailCountMap[targetUser] then
          self.uid2MailCountMap[targetUser] = 1
          EventManager:GetInstance():Broadcast(EventId.DetectResultDataUpdate, GetStackCountNoRepeat(self))
        else
          self.uid2MailCountMap[targetUser] = self.uid2MailCountMap[targetUser] + 1
        end
      else
        self.uid2MailCountMap[mailUid] = 1
        EventManager:GetInstance():Broadcast(EventId.DetectResultDataUpdate, GetStackCountNoRepeat(self))
      end
    end
  end
end

function DetectResultDataManager:GetAllNewScoutDataList()
  local ret = {}
  local hashMap = {}
  while not StackIsEmpty(self.newMailUidStack) do
    local data = StackPopOut(self.newMailUidStack)
    if data.mailUid then
      local mailData = GetScoutDataByMailUid(data.mailUid)
      if mailData then
        local mailExtData = mailData:GetMailExt():GetExtData()
        if mailExtData.targetType == ScoutMailTargetType.MAIN_BUILDING then
          local targetUser = mailData:GetMailExt():GetExtData().targetUser.uid
          if not hashMap[targetUser] then
            table.insert(ret, mailData)
          end
          hashMap[targetUser] = true
        else
          table.insert(ret, mailData)
        end
      end
    end
  end
  self.uid2MailCountMap = {}
  self.time2MailUidMap = {}
  self:RefreshRedState()
  return ret
end

function DetectResultDataManager:ClearAllNewScoutData()
  self.time2MailUidMap = {}
  self.uid2MailCountMap = {}
  self.newMailUidStack = {}
  self:RefreshRedState()
end

function DetectResultDataManager:RefreshRedState()
  CommonUtil.PlayerPrefsSetTable(SettingKeys.WORLD_SCOUT_RED_DOT, self.time2MailUidMap)
  EventManager:GetInstance():Broadcast(EventId.DetectResultDataUpdate, GetStackCountNoRepeat(self))
end

function DetectResultDataManager:IsDataEmpty()
  return StackIsEmpty(self.newMailUidStack)
end

function DetectResultDataManager:IsDataEmptyOrUnavailable()
  if StackIsEmpty(self.newMailUidStack) then
    return true
  end
  local ret = true
  for k, v in pairs(self.newMailUidStack) do
    local mailData = GetScoutDataByMailUid(v.mailUid)
    if mailData then
      ret = false
      break
    end
  end
  return ret
end

function DetectResultDataManager:GetUnreadCountNoRepeat()
  return GetStackCountNoRepeat(self)
end

return DetectResultDataManager
