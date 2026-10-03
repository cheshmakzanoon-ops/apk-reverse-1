local CityRebuildDataManager = BaseClass("CityRebuildDataManager")
local POP_DELAY_TIME = 4

local function __init(self)
  self.reward = nil
  self.allianceInfo = {}
  self.march = {}
  self.rewardCfg = {}
  self:AddListener()
end

local function __delete(self)
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  self.reward = nil
  self.allianceInfo = nil
  self.march = nil
  self.create = nil
  self.hasCure = nil
  self.rewardCfg = nil
  self:RemoveListener()
end

local function StartUp(self)
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function SetAllianceAndMarchInfo(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if message.alliance then
      self.allianceInfo = message.alliance
      local alliance = AllianceBaseInfo.New()
      alliance:ParseData(message.alliance, false)
      if alliance.uid ~= nil and alliance.uid ~= "" then
        self.allianceInfo = alliance
      end
    end
    if message.march then
      self.march = message.march
    end
  end
  if self.create then
    self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICityRebuildNewView, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    end, POP_DELAY_TIME)
  end
end

local function SetRebuildRewardInfo(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if message.reward then
      self.reward = message.reward
      DataCenter.RewardManager:AddRewardsAndRes(message)
    end
    if message.hasCure then
      self.hasCure = message.hasCure
    end
  end
end

local function GetAllianceInfoInfo(self)
  return self.allianceInfo
end

local function ReleaseAllianceInfoInfo(self)
  self.allianceInfo = nil
end

local function GetRebuildRewardInfo(self)
  return DataCenter.RewardManager:ReturnRewardParamForMessage(self.reward)
end

local function CheckCanPopRebuildUI(self)
  if self.reward and #self.reward > 0 then
    return true
  end
  return false
end

local function SetRebuildRewardInfoNull(self)
  self.reward = nil
end

local function GetMarchInfo(self)
  return self.march
end

local function GetCureState(self)
  if self.hasCure then
    return self.hasCure
  else
    return false
  end
end

local function SetFlyRewardData(self, cfg)
  self.rewardCfg = cfg
end

local function FlyReward(self)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if window and window.Ctrl:IsVisible() and self.rewardCfg then
    EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, self.rewardCfg)
  end
end

local function SendMarchMessage(self, create)
  self.create = create
  SFSNetwork.SendMessage(MsgDefines.AllianceRescueCreateMarch, create)
end

local function SendStopCityFireMessage(self)
  SFSNetwork.SendMessage(MsgDefines.AllianceRescueStopCityFire)
end

CityRebuildDataManager.__init = __init
CityRebuildDataManager.__delete = __delete
CityRebuildDataManager.StartUp = StartUp
CityRebuildDataManager.AddListener = AddListener
CityRebuildDataManager.RemoveListener = RemoveListener
CityRebuildDataManager.SetRebuildRewardInfo = SetRebuildRewardInfo
CityRebuildDataManager.GetRebuildRewardInfo = GetRebuildRewardInfo
CityRebuildDataManager.SendMarchMessage = SendMarchMessage
CityRebuildDataManager.SetAllianceAndMarchInfo = SetAllianceAndMarchInfo
CityRebuildDataManager.SendStopCityFireMessage = SendStopCityFireMessage
CityRebuildDataManager.GetAllianceInfoInfo = GetAllianceInfoInfo
CityRebuildDataManager.GetMarchInfo = GetMarchInfo
CityRebuildDataManager.SetRebuildRewardInfoNull = SetRebuildRewardInfoNull
CityRebuildDataManager.CheckCanPopRebuildUI = CheckCanPopRebuildUI
CityRebuildDataManager.ReleaseAllianceInfoInfo = ReleaseAllianceInfoInfo
CityRebuildDataManager.GetCureState = GetCureState
CityRebuildDataManager.SetFlyRewardData = SetFlyRewardData
CityRebuildDataManager.FlyReward = FlyReward
return CityRebuildDataManager
