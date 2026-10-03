local SeasonBankReportManager = BaseClass("SeasonBankReportManager", CEventable)

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

function SeasonBankReportManager:__init()
  self:AddListener()
  self.mailType = MailType.SEASON_BANK
  self.newMailUidStack = {}
  self.uid2MailCountMap = {}
  self.time2MailUidMap = {}
  self.keepMailMaxTime = LuaEntry.DataConfig:TryGetNum("scout_cd", "k3", 3600)
  self._firstEnterWorld = false
end

function SeasonBankReportManager:__delete()
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

function SeasonBankReportManager:AddListener()
  self:RegisterEvent(EventId.MailPush, self.OnNewMailPush)
  self:RegisterEvent(EventId.OnEnterWorld, self.OnEnterWorld)
end

local function GetBankDataByMailUid(mailUid)
  local mailInfo = DataCenter.MailDataManager:GetMailInfoById(mailUid)
  return mailInfo
end

function SeasonBankReportManager:IsDataEmpty()
  return StackIsEmpty(self.newMailUidStack)
end

function SeasonBankReportManager:GetUnreadCountNoRepeat()
  return GetStackCountNoRepeat(self)
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
    local mailData = GetBankDataByMailUid(removeData.mailUid)
    if mailData then
      local uid = removeData.mailUid
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
    CommonUtil.PlayerPrefsSetTable(SettingKeys.SEASON_BANK_RED_DOT, self.time2MailUidMap)
    EventManager:GetInstance():Broadcast(EventId.BankReportDataUpdate, GetStackCountNoRepeat(self))
  end
end

function SeasonBankReportManager:OnEnterWorld()
  if not self._firstEnterWorld and SeasonUtil.InSeasonBigMapMode() and SeasonUtil.IsInSeasonNineNationMode() then
    self._firstEnterWorld = true
    local WorldBankScoutTipManager = require("DataCenter.SeasonManager.Bank.Tip.WorldBankScoutTipManager")
    WorldBankScoutTipManager:GetInstance()
    self.time2MailUidMap = CommonUtil.PlayerPrefsGetTable(SettingKeys.SEASON_BANK_RED_DOT, {})
    local timeList = table.keys(self.time2MailUidMap)
    table.sort(timeList, CompareTime)
    for _, v in ipairs(timeList) do
      local mailUid = self.time2MailUidMap[v]
      local mailData = GetBankDataByMailUid(mailUid)
      if mailData then
        local data = {
          mailUid = mailUid,
          time = mailData.createTime
        }
        StackPopIn(self.newMailUidStack, data)
        self.uid2MailCountMap[mailUid] = (self.uid2MailCountMap[mailUid] or 0) + 1
      end
    end
    EventManager:GetInstance():Broadcast(EventId.BankReportDataUpdate, GetStackCountNoRepeat(self))
    if self.timer == nil then
      self.timer = TimerManager:GetInstance():GetTimer(5, timer_action, self, false, false, true)
      self.timer:Start()
    end
    timer_action(self)
  end
end

function SeasonBankReportManager:OnNewMailPush(mailUid)
  if mailUid then
    local mailData = GetBankDataByMailUid(mailUid)
    if mailData and mailData.type == self.mailType then
      local data = {
        mailUid = mailUid,
        time = mailData.createTime
      }
      StackPopIn(self.newMailUidStack, data)
      local createTime = mailData.createTime
      self.time2MailUidMap[tostring(createTime)] = mailUid
      CommonUtil.PlayerPrefsSetTable(SettingKeys.SEASON_BANK_RED_DOT, self.time2MailUidMap)
      self.uid2MailCountMap[mailUid] = 1
      EventManager:GetInstance():Broadcast(EventId.BankReportDataUpdate, GetStackCountNoRepeat(self))
    end
  end
end

function SeasonBankReportManager:GetAllNewBankDataList()
  local ret = {}
  for _, v in ipairs(self.newMailUidStack) do
    if v.mailUid then
      local mailData = GetBankDataByMailUid(v.mailUid)
      if mailData then
        ret[v.mailUid] = mailData
      end
    end
  end
  ret = table.values(ret)
  table.sort(ret, function(a, b)
    return a.createTime > b.createTime
  end)
  return ret
end

function SeasonBankReportManager:ClearNewBankDataList(dataList)
  if table.IsNullOrEmpty(dataList) then
    return
  end
  for _, mailData in ipairs(dataList) do
    local uid = mailData.uid
    for i = #self.newMailUidStack, 1, -1 do
      if self.newMailUidStack[i].mailUid == mailData.uid then
        table.remove(self.newMailUidStack, i)
      end
    end
    if self.uid2MailCountMap[uid] then
      self.uid2MailCountMap[uid] = self.uid2MailCountMap[uid] - 1
      if self.uid2MailCountMap[uid] <= 0 then
        self.uid2MailCountMap[uid] = nil
      end
    end
    local removeTimeKey
    for k, v in pairs(self.time2MailUidMap) do
      if v == uid then
        removeTimeKey = k
        break
      end
    end
    if removeTimeKey then
      self.time2MailUidMap[removeTimeKey] = nil
    end
  end
  CommonUtil.PlayerPrefsSetTable(SettingKeys.SEASON_BANK_RED_DOT, self.time2MailUidMap)
  EventManager:GetInstance():Broadcast(EventId.BankReportDataUpdate, GetStackCountNoRepeat(self))
end

function SeasonBankReportManager:GetBankDataList(day)
  local list = DataCenter.MailDataManager:GetGroupMailList(MailTypeToInternalGroup[self.mailType])
  if table.IsNullOrEmpty(list) then
    return {}
  end
  day = day or 7
  local timeStampLimit = UITimeManager:GetInstance():GetServerTime() - day * 24 * 3600 * 1000
  local ret = {}
  for _, mailData in ipairs(list) do
    if timeStampLimit <= mailData.createTime and mailData.type == self.mailType then
      local ext = mailData:GetMailExt():GetExtData()
      if ext and ext.depositAmount then
        table.insert(ret, mailData)
      end
    end
  end
  table.sort(ret, function(a, b)
    return a.createTime > b.createTime
  end)
  return ret
end

return SeasonBankReportManager
