local CommonRedPointManager = BaseClass("CommonRedPointManager", CEventable)
local Setting = CS.GameEntry.Setting
local Key = "CommonRedPointLogin"
local ignoreHideInterval = 900

function CommonRedPointManager:__init()
  self:RegisterEvent(EventId.LOAD_COMPLETE, self.OnLoadComplete)
  self:RegisterEvent(EventId.OnUnDelayPassDay, self.OnPassDay)
  self.hideMap = {}
end

function CommonRedPointManager:__delete()
  self.FirstLogin = nil
  self.ignoreTime = nil
  self.hideMap = {}
  self.rewardPointIcon = nil
  self.isFunctionOn = nil
end

function CommonRedPointManager:Startup()
end

function CommonRedPointManager:InitData()
  self:InitDataImp()
end

function CommonRedPointManager:OnLoadComplete()
  self:InitDataImp()
end

function CommonRedPointManager:OnPassDay()
  if not self:IsFunctionOn() then
    return
  end
  local serverTime = UITimeManager:GetInstance():GetServerSeconds()
  Setting:SetPrivateInt(Key, serverTime)
  self.hideMap = {}
  EventManager:GetInstance():Broadcast(EventId.RefreshCommonRedPoint)
end

function CommonRedPointManager:IsFunctionOn()
  if self.isFunctionOn == nil then
    local openServerDay = UITimeManager:GetInstance():GetOpenServerDay()
    local daysOpen = LuaEntry.DataConfig:TryGetNum("redpoint_config", "k3", 15)
    self.isFunctionOn = LuaEntry.DataConfig:CheckSwitch("new_redpoint_config") and openServerDay >= daysOpen
  end
  return self.isFunctionOn
end

function CommonRedPointManager:InitDataImp()
  if self.FirstLogin == nil then
    if not self:IsFunctionOn() then
      self.FirstLogin = false
      return
    end
    local lastLoginTimeS = Setting:GetPrivateInt(Key, 0)
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local sameDay = UITimeManager:GetInstance():IsSameDayForServer(lastLoginTimeS, serverTime)
    self.FirstLogin = not sameDay
    self.FirstLogin = false
    Setting:SetPrivateInt(Key, serverTime)
  end
end

function CommonRedPointManager:CheckHide(redPointId)
  if redPointId == nil then
    return false
  end
  if not self:IsFunctionOn() then
    return false
  end
  if self.ignoreTime and Time.realtimeSinceStartup >= self.ignoreTime then
    self.hideMap = {}
    self.ignoreTime = nil
    self.FirstLogin = false
    EventManager:GetInstance():Broadcast(EventId.RefreshCommonRedPoint)
    return true
  end
  return self.hideMap[redPointId]
end

function CommonRedPointManager:Hide(redPointId)
  if not self:IsFunctionOn() then
    return false
  end
  self.hideMap[redPointId] = true
  return true
end

function CommonRedPointManager:GetRewardPointIcon()
  if self.rewardPointIcon == nil then
    local icon
    if self:IsFunctionOn() then
      icon = LuaEntry.DataConfig:TryGetStr("redpoint_config", "k2", "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_hongdian_liwu.png")
    else
      icon = LuaEntry.DataConfig:TryGetStr("redpoint_config", "k4", "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_hongdian_xiao.png")
    end
    self.rewardPointIcon = icon
  end
  return self.rewardPointIcon
end

return CommonRedPointManager
