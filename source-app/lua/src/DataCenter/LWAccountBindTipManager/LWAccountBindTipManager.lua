local LWAccountBindTipManager = BaseClass("LWAccountBindTipManager", CEventable)
local Setting = CS.GameEntry.Setting
local SDKManager = CS.SDKManager
local AccountBindTipLastShowTime = "AccountBindTipLastShowTime"
local AccountBindTipShowTimes = "AccountBindTipShowTimes"
local CountryAll = "all"
local HourMilliSeconds = 3600000

function LWAccountBindTipManager:__init()
  self.baseCondition = false
  self.bindState = false
  self.bubbleShow = true
  self:AddListener()
end

function LWAccountBindTipManager:__delete()
  self.baseCondition = false
  self.bubbleShow = false
  self.bindState = false
  self:RemoveListener()
end

function LWAccountBindTipManager:InitData()
  self.bubbleShow = true
  self.conditionMap = {}
  local condition = LuaEntry.DataConfig:TryGetStr("bind_email_alert_config", "k4")
  if not string.IsNullOrEmpty(condition) then
    local strs = string.split(condition, ";")
    for _, v in ipairs(strs) do
      if not string.IsNullOrEmpty(v) then
        local array = string.split(v, "|")
        if #array == 2 then
          local type = tonumber(array[1]) or 0
          local value = tonumber(array[2]) or 0
          self.conditionMap[type] = value
        end
      end
    end
  end
  self.countryPlatMap = {}
  local countryPlat = LuaEntry.DataConfig:TryGetStr("bind_email_alert_config", "k8")
  if not string.IsNullOrEmpty(countryPlat) then
    local strs = string.split(countryPlat, ";")
    for _, v in pairs(strs) do
      if not string.IsNullOrEmpty(v) then
        local array = string.split(v, "|")
        if #array == 2 then
          local plat = tonumber(array[1]) or 0
          local country = array[2]
          if 0 < plat and not string.IsNullOrEmpty(country) then
            self.countryPlatMap[country] = plat
          end
        elseif #array == 1 then
          local plat = tonumber(array[1]) or 0
          if 0 < plat then
            self.countryPlatMap[CountryAll] = plat
            break
          end
        end
      end
    end
  end
  self.baseCondition = self:CheckCondition()
  self.bindState = self:CheckBindState()
end

function LWAccountBindTipManager:CheckCondition()
  if self.conditionMap then
    for type, value in pairs(self.conditionMap) do
      if type == 1 then
        local mainLv = DataCenter.BuildManager.MainLv
        if value > mainLv then
          return false
        end
      elseif type == 2 then
        if DataCenter.MonopolyManager.player == nil then
          return false
        end
        local currStageId = DataCenter.MonopolyManager.player.curId
        if value > currStageId then
          return false
        end
      elseif type == 3 then
        local regTime = tonumber(LuaEntry.Player.regTime) or 0
        if regTime <= 0 then
          return false
        end
        local time = UITimeManager:GetInstance():GetServerTime()
        local diff = time - regTime
        local diffHour = Mathf.Floor(diff / HourMilliSeconds)
        if value > diffHour then
          return false
        end
      end
    end
  end
  return true
end

function LWAccountBindTipManager:CheckBindState()
  if DataCenter.AccountManager.firstBindAccountRewardFlag then
    return true
  end
  local account = DataCenter.AccountManager.MailAccount.gameAccount
  if account ~= "" then
    local status = DataCenter.AccountManager.MailAccount.accountStatus or AccountBandState.UnBand
    if status == AccountBandState.Band then
      return true
    end
  end
  return false
end

function LWAccountBindTipManager:AddListener()
  if self.inited then
    return
  end
  self.inited = true
  self:RegisterEvent(EventId.MainLvUp, self.OnMainLevelUp)
  self:RegisterEvent(EventId.GF_monopoly_new_grid_arrived, self.OnMonopolyChanged)
  self:RegisterEvent(EventId.AccountBindOKEvent, self.OnAccountBind)
end

function LWAccountBindTipManager:RemoveListener()
  if not self.inited then
    return
  end
  self.inited = false
end

function LWAccountBindTipManager:OnMainLevelUp()
  if self.baseCondition then
    return
  end
  self.baseCondition = self:CheckCondition()
  if not self:CheckPlatform() then
    return false
  end
  if self.baseCondition and not self.bindState then
    EventManager:GetInstance():Broadcast(EventId.AccountBindTipChanged)
    self:TryPopTip()
  end
end

function LWAccountBindTipManager:OnMonopolyChanged()
  if self.baseCondition then
    return
  end
  self.baseCondition = self:CheckCondition()
  if not self:CheckPlatform() then
    return false
  end
  if self.baseCondition and not self.bindState then
    EventManager:GetInstance():Broadcast(EventId.AccountBindTipChanged)
    self:TryPopTip()
  end
end

function LWAccountBindTipManager:OnAccountBind()
  if self.bindState then
    return
  end
  self.bindState = self:CheckBindState()
  EventManager:GetInstance():Broadcast(EventId.AccountBindTipChanged)
end

function LWAccountBindTipManager:CheckTipShow()
  if not self:CheckPlatform() then
    return false
  end
  if not self.baseCondition then
    return false
  end
  if self.bindState then
    return false
  end
  return true
end

function LWAccountBindTipManager:CheckPlatform()
  if self.countryPlatMap == nil or table.count(self.countryPlatMap) == 0 then
    return false
  end
  if string.IsNullOrEmpty(LuaEntry.Player.country) then
    return false
  end
  local plat = tonumber(self.countryPlatMap[LuaEntry.Player.country]) or 0
  if plat == 0 then
    plat = tonumber(self.countryPlatMap[CountryAll]) or 0
    if plat == 0 then
      return false
    end
  end
  local platform = RuntimePlatform.Android
  if SDKManager.IS_Android() then
    platform = RuntimePlatform.Android
  elseif SDKManager.IS_IPhonePlayer() then
    platform = RuntimePlatform.IPhonePlayer
  end
  if plat == 1 then
    if platform == RuntimePlatform.Android then
      return true
    end
  elseif plat == 2 then
    if platform == RuntimePlatform.IPhonePlayer then
      return true
    end
  elseif plat == 3 and (platform == RuntimePlatform.Android or platform == RuntimePlatform.IPhonePlayer) then
    return true
  end
  return false
end

function LWAccountBindTipManager:CheckTipBubbleShow()
  if not self:CheckTipShow() then
    return false
  end
  return self.bubbleShow
end

function LWAccountBindTipManager:SetTipBubbleShow()
  self.bubbleShow = false
end

function LWAccountBindTipManager:GuideToAccountBind()
  if DataCenter.AccountScoreManager:CheckAccountIDOpen() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountManage, {anim = true, hideTop = true}, nil, nil, true)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAccount, {anim = true, hideTop = true}, nil, nil, true)
  end
end

function LWAccountBindTipManager:TryPopTip()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local lastTime = Setting:GetPrivateString(AccountBindTipLastShowTime, "")
  if string.IsNullOrEmpty(lastTime) then
    Setting:SetPrivateInt(AccountBindTipShowTimes, 1)
  else
    local sameDay = UITimeManager:GetInstance():IsSameDayForServer(tonumber(lastTime), curTime)
    if not sameDay then
      Setting:SetPrivateInt(AccountBindTipShowTimes, 1)
    else
      local curTimes = Setting:GetPrivateInt(AccountBindTipShowTimes, 0)
      local max = LuaEntry.DataConfig:TryGetNum("bind_email_alert_config", "k7", 0)
      if curTimes < max then
        Setting:SetPrivateInt(AccountBindTipShowTimes, curTimes + 1)
      else
        return
      end
    end
  end
  Setting:SetPrivateString(AccountBindTipLastShowTime, tostring(curTime))
  DataCenter.UIPopWindowManager:Push(UIWindowNames.LWAccountBindTip, {anim = false})
end

return LWAccountBindTipManager
