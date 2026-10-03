local base = UIAsyncContainer
local SeasonCampDestroyBattleWait = BaseClass("SeasonCampDestroyBattleWait", base)
local Localization = CS.GameEntry.Localization
local SeasonCampDestroyBattleTimeSlot = require("UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyBattleTimeSlot")

function SeasonCampDestroyBattleWait:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function SeasonCampDestroyBattleWait:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyBattleWait:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRect = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compPGoOutWarTimeArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compPOutWarTime2 = self.viewSkin:AddComponent(self, SeasonCampDestroyBattleTimeSlot, 3)
  self.compPOutWarTime1 = self.viewSkin:AddComponent(self, SeasonCampDestroyBattleTimeSlot, 4)
  self.compPOutWarTime0 = self.viewSkin:AddComponent(self, SeasonCampDestroyBattleTimeSlot, 5)
  self.textPOutWarTimeDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textPOutWarTimeTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self:SetOffsetMinXY(0, 0)
  self:SetOffsetMaxXY(0, 0)
  self:InitTimes()
end

function SeasonCampDestroyBattleWait:ComponentDestroy()
  self.viewSkin = nil
  self.compRect = nil
  self.compPGoOutWarTimeArrow = nil
  self.compPOutWarTime2 = nil
  self.compPOutWarTime1 = nil
  self.compPOutWarTime0 = nil
  self.textPOutWarTimeDesc = nil
  self.textPOutWarTimeTime = nil
end

function SeasonCampDestroyBattleWait:DataDefine()
  self.mgr = DataCenter.SeasonCampDestroyManager
  self.ZeroTime = UITimeManager:GetInstance():GetTodayZero()
end

function SeasonCampDestroyBattleWait:DataDestroy()
  self.mgr = nil
end

function SeasonCampDestroyBattleWait:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyBattleWait:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyBattleWait:InitTimes()
  if not self.mgr then
    return
  end
  self.WarTimeConfigs = DataCenter.SeasonCampDestroyManager:GetWarTimeConfigs()
  local data1 = {}
  data1.WarTimeConfigData = self.WarTimeConfigs[0]
  self.compPOutWarTime0:ReInit(data1)
  local data2 = {}
  data2.WarTimeConfigData = self.WarTimeConfigs[1]
  self.compPOutWarTime1:ReInit(data2)
  local data3 = {}
  data3.WarTimeConfigData = self.WarTimeConfigs[2]
  self.compPOutWarTime2:ReInit(data3)
  self.WarTimeConfigs = DataCenter.SeasonCampDestroyManager:GetWarTimeConfigs()
  self.ZeroTime = UITimeManager:GetInstance():GetTodayZero()
  self.HintKey = nil
  self.HintTime = nil
  local timeInfo = self.mgr:GetTimeInfo()
  local stage = timeInfo and timeInfo.currentBattleStage or SeasonCampDestroyStage.None
  if stage == SeasonCampDestroyStage.Fight then
    self.HintKey = "season_s5_activity_1200059_desc21"
    local now = UITimeManager:GetInstance():GetServerTime()
    local baseTime = UITimeManager:GetInstance():GetTodayZero()
    local found = false
    for _, warTimeConfig in pairs(self.WarTimeConfigs) do
      if warTimeConfig:IsNowInRange(now) then
        self.HintTime = baseTime + warTimeConfig.EndTimeMS
        found = true
        break
      end
    end
    if not found then
      self.HintTime = UITimeManager:GetInstance():GetTomorrowZero()
    end
  elseif stage == SeasonCampDestroyStage.Wait then
    local now = UITimeManager:GetInstance():GetServerTime()
    local baseTime = UITimeManager:GetInstance():GetTodayZero()
    local nextWarTime
    for _, warTimeConfig in pairs(self.WarTimeConfigs) do
      if now < baseTime + warTimeConfig.StartTimeMS and (not nextWarTime or nextWarTime > baseTime + warTimeConfig.StartTimeMS) then
        nextWarTime = baseTime + warTimeConfig.StartTimeMS
      end
    end
    if nextWarTime then
      self.HintKey = "season_s5_activity_1200059_desc16"
      self.HintTime = nextWarTime
    else
      self.HintKey = "season_s6_activity_1200116_desc25"
      self.HintTime = UITimeManager:GetInstance():GetTomorrowZero()
    end
  end
  self:RefreshDesc()
end

function SeasonCampDestroyBattleWait:RotateTime(comp, elapsedMs)
  if not comp then
    return
  end
  comp:SetEulerAnglesXYZ(0, 0, -(elapsedMs / (OneDayTime * 1000)) * 360)
end

function SeasonCampDestroyBattleWait:Refresh()
  if not self.mgr then
    return
  end
  local timeInfo = self.mgr:GetTimeInfo()
  local stage = timeInfo and timeInfo.currentBattleStage or SeasonCampDestroyStage.None
  if stage ~= SeasonCampDestroyStage.Wait and stage ~= SeasonCampDestroyStage.Fight then
    self.compRect:SetActive(false)
    return
  end
  self.compRect:SetActive(true)
  local leftTime = math.max(0, checknumber(self.HintTime) - UITimeManager:GetInstance():GetServerTime())
  if leftTime <= 0 then
    self:RefreshHintTime(stage)
    leftTime = math.max(0, checknumber(self.HintTime) - UITimeManager:GetInstance():GetServerTime())
  end
  if self.compPGoOutWarTimeArrow then
    local elapsed = UITimeManager:GetInstance():GetServerTime() - self.ZeroTime
    self:RotateTime(self.compPGoOutWarTimeArrow, elapsed)
  end
  self.textPOutWarTimeTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
end

function SeasonCampDestroyBattleWait:RefreshHintTime(stage)
  if stage == SeasonCampDestroyStage.Fight then
    self.HintKey = "season_s5_activity_1200059_desc21"
    local now = UITimeManager:GetInstance():GetServerTime()
    local baseTime = UITimeManager:GetInstance():GetTodayZero()
    local found = false
    for _, warTimeConfig in pairs(self.WarTimeConfigs) do
      if warTimeConfig:IsNowInRange(now) then
        self.HintTime = baseTime + warTimeConfig.EndTimeMS
        found = true
        break
      end
    end
    if not found then
      self.HintTime = UITimeManager:GetInstance():GetTomorrowZero()
    end
  elseif stage == SeasonCampDestroyStage.Wait then
    local now = UITimeManager:GetInstance():GetServerTime()
    local baseTime = UITimeManager:GetInstance():GetTodayZero()
    local nextWarTime
    for _, warTimeConfig in pairs(self.WarTimeConfigs) do
      if now < baseTime + warTimeConfig.StartTimeMS and (not nextWarTime or nextWarTime > baseTime + warTimeConfig.StartTimeMS) then
        nextWarTime = baseTime + warTimeConfig.StartTimeMS
      end
    end
    if nextWarTime then
      self.HintKey = "season_s5_activity_1200059_desc16"
      self.HintTime = nextWarTime
    else
      self.HintKey = "temp_key_001"
      self.HintTime = UITimeManager:GetInstance():GetTomorrowZero()
    end
  end
end

function SeasonCampDestroyBattleWait:RefreshDesc()
  if not self.mgr then
    return
  end
  local hintKey = self.HintKey
  self.textPOutWarTimeDesc:SetActive(not string.IsNullOrEmpty(hintKey))
  if not string.IsNullOrEmpty(hintKey) then
    self.textPOutWarTimeDesc:SetLocalText(hintKey)
  end
end

function SeasonCampDestroyBattleWait:OnEnable()
  base.OnEnable(self)
  self:Refresh()
  self:RefreshDesc()
end

function SeasonCampDestroyBattleWait:OnDisable()
  base.OnDisable(self)
end

function SeasonCampDestroyBattleWait:Update1000MS()
  self:Refresh()
  self:RefreshDesc()
end

return SeasonCampDestroyBattleWait
