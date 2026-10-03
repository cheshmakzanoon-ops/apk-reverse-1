local UIMainCityEvent = BaseClass("UIMainCityEvent", UIBaseContainer)
local base = UIBaseContainer
local mainBtn_path = "Main"
local bg_path = "Main/bg"
local bg_add_path = "Main/bg/bg_add"
local tip_path = "Main/tip"
local time_path = "Main/time"
local red_dot_path = "Main/redDot"
local city_event_avator = "Main/cityEventAvator"
local city_event_arrow = "Main/cityEventArrow"
local bg_UAVPair_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_jiesuowurenji01.png"
local avtor_UAVPair_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_jiesuowurenji02.png"
local arrow_UAVPair_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_jiesuowurenji03.png"
local bg_ZombieSea_bigZombie_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_sangshilaixi_rukou01.png"
local avtor_ZombieSea_bigZombie_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_sangshilaixi_rukou03.png"
local bg_ZombieSea_smallZombie_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_sangshilaixi_rukou04.png"
local avtor_ZombieSea_smallZombie_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_sangshilaixi_rukou05.png"
local arrow_ZombieSea_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_sangshilaixi_rukou02.png"
local bg_KillZombie_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_qinlisangshi1.png"
local avtor_KillZombie_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_qinlisangshi2.png"
local arrow_KillZombie_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_qinlisangshi3.png"
local bg_CityFight_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_gongcheng_01.png"
local avtor_CityFight_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_gongcheng_03.png"
local arrow_CityFight_sprite = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_gongcheng_02.png"

function UIMainCityEvent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:AddUIListener(EventId.CityEventRefresh, self.ReInit)
  self:AddUIListener(EventId.CityEventTaskUpdate, self.ReInit)
  self:AddUIListener(EventId.CityEventPageUpdate, self.ReInit)
end

function UIMainCityEvent:OnDestroy()
  self:RemoveUIListener(EventId.CityEventRefresh, self.ReInit)
  self:RemoveUIListener(EventId.CityEventTaskUpdate, self.ReInit)
  self:RemoveUIListener(EventId.CityEventPageUpdate, self.ReInit)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainCityEvent:ComponentDefine()
  self.mainBtn = self:AddComponent(UIButton, mainBtn_path)
  self.mainAnimator = self:AddComponent(UIAnimator, mainBtn_path)
  self.bgImg = self:AddComponent(UIImage, bg_path)
  self.bgAddImg = self:AddComponent(UIImage, bg_add_path)
  self.tip = self:AddComponent(UITextMeshProUGUIEx, tip_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.red_dot = self:AddComponent(UIImage, red_dot_path)
  self.avtor_Img = self:AddComponent(UIImage, city_event_avator)
  self.arrow_Img = self:AddComponent(UIImage, city_event_arrow)
  self.mainBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.valid = false
  self:SetActive(false)
end

function UIMainCityEvent:ComponentDestroy()
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  self.mainBtn = nil
  self.mainAnimator = nil
  self.bgImg = nil
  self.bgAddImg = nil
  self.tip = nil
  self.time = nil
  self.red_dot = nil
  self.avtor_Img = nil
end

function UIMainCityEvent:OnEnable()
  base.OnEnable(self)
end

function UIMainCityEvent:OnDisable()
  base.OnDisable(self)
end

function UIMainCityEvent:OnAddListener()
  base.OnAddListener(self)
end

function UIMainCityEvent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMainCityEvent:CloseWithAnim()
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  if self.mainAnimator then
    local success, time = self.mainAnimator:PlayAnimationReturnTime("CityEventOut")
    if success then
      self.closeAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:SetActive(false)
      end, time)
    else
      self:SetActive(false)
    end
  end
end

function UIMainCityEvent:ReInit()
  local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  if cityEventId == -1 then
    if self.valid then
      self:CloseWithAnim()
    end
    self.valid = false
    return
  end
  if SceneUtils.GetIsInWorld() and (cityEventId == BeginnerDirectorEvent.UAV_Repaire or cityEventId == BeginnerDirectorEvent.ZombieSeaFirstStage or cityEventId == BeginnerDirectorEvent.ZombieSeaSecondStage) then
    if self.valid then
      self:CloseWithAnim()
    end
    self.valid = false
    return
  end
  if DataCenter.LWBeginnerDirectorManager:IsCurCityEventAllTaskReceived() then
    if self.valid then
      self:CloseWithAnim()
    end
    self.valid = false
    return
  end
  local endTime = DataCenter.LWBeginnerDirectorManager:GetCurCityEventEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if endTime < curTime then
    if self.valid then
      self:CloseWithAnim()
    end
    self.valid = false
    return
  end
  local cityEventName = DataCenter.LWBeginnerDirectorManager:GetCurCityEventName()
  self.tip:SetLocalText(cityEventName)
  local bgPath, avatorPath, arrowPath = self:GetEventRelatedSpritePath()
  if bgPath then
    self.bgImg:LoadSprite(bgPath)
    self.bgAddImg:LoadSprite(bgPath)
  end
  if avatorPath then
    self.avtor_Img:LoadSprite(avatorPath)
    self.avtor_Img:SetNativeSize()
  end
  if arrowPath then
    self.arrow_Img:LoadSprite(arrowPath)
  end
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  self:SetActive(true)
  self.mainAnimator:Play("CityEventIn", 0, 0)
  self.valid = true
  self.endTime = endTime
  self:UpdateTime()
  self:RefreshRed()
end

function UIMainCityEvent:RefreshRed()
  local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  local hasRed = false
  if cityEventId == BeginnerDirectorEvent.ZombieSeaFirstStage then
    local pageStates = DataCenter.LWBeginnerDirectorManager:GetCurCityEventPages()
    local pageTasks = DataCenter.LWBeginnerDirectorManager:GetCurCityEventPageTasks()
    local showFirstStagePageIndex = 1
    local goalCount = #pageTasks
    for goalIndex = 1, goalCount do
      local goalPageState = pageStates[goalIndex]
      if goalPageState and goalPageState == 1 then
        showFirstStagePageIndex = math.min(goalIndex + 1, goalCount)
      else
        local pageTask = pageTasks[goalIndex]
        local allTaskComplete = true
        for i, task in ipairs(pageTask) do
          if task.state == TaskState.NoComplete then
            allTaskComplete = false
            break
          end
        end
        if allTaskComplete and showFirstStagePageIndex == goalIndex then
          hasRed = true
          break
        end
      end
    end
  else
    local allTaskArr = DataCenter.LWBeginnerDirectorManager:GetCurCityEventTaskArr()
    for i, task in ipairs(allTaskArr) do
      if task.state == TaskState.CanReceive then
        hasRed = true
        break
      end
    end
  end
  self.red_dot:SetActive(hasRed)
end

function UIMainCityEvent:Update1000MS()
  if self.valid then
    self:UpdateTime()
  end
end

function UIMainCityEvent:UpdateTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = self.endTime - curTime
  self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
  if diff <= 0 then
    self.valid = false
    self:SetActive(false)
  end
end

function UIMainCityEvent:GetEventRelatedSpritePath()
  local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  if cityEventId ~= -1 then
    if cityEventId == BeginnerDirectorEvent.UAV_Repaire then
      return bg_UAVPair_sprite, avtor_UAVPair_sprite, arrow_UAVPair_sprite
    elseif cityEventId == BeginnerDirectorEvent.ZombieSeaFirstStage then
      return bg_ZombieSea_smallZombie_sprite, avtor_ZombieSea_smallZombie_sprite, arrow_ZombieSea_sprite
    elseif cityEventId == BeginnerDirectorEvent.ZombieSeaSecondStage then
      return bg_ZombieSea_bigZombie_sprite, avtor_ZombieSea_bigZombie_sprite, arrow_ZombieSea_sprite
    elseif cityEventId == BeginnerDirectorEvent.BigWorldKillZombie then
      return bg_KillZombie_sprite, avtor_KillZombie_sprite, arrow_KillZombie_sprite
    elseif cityEventId == BeginnerDirectorEvent.CityFight or cityEventId == BeginnerDirectorEvent.CityFight2 or cityEventId == BeginnerDirectorEvent.CityFight3 then
      return bg_CityFight_sprite, avtor_CityFight_sprite, arrow_CityFight_sprite
    end
  end
end

function UIMainCityEvent:OnClick()
  local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  if cityEventId ~= -1 then
    if cityEventId == BeginnerDirectorEvent.UAV_Repaire then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICityEventUAVRewardView)
    elseif cityEventId == BeginnerDirectorEvent.ZombieSeaFirstStage or cityEventId == BeginnerDirectorEvent.ZombieSeaSecondStage then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICityEventZombieSeaReward)
    elseif cityEventId == BeginnerDirectorEvent.BigWorldKillZombie then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICityEventKillZombieReward)
    elseif cityEventId == BeginnerDirectorEvent.BigWorldKillZombie then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICityEventKillZombieReward)
    elseif cityEventId == BeginnerDirectorEvent.CityFight or cityEventId == BeginnerDirectorEvent.CityFight2 or cityEventId == BeginnerDirectorEvent.CityFight3 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICityEventCityFightReward)
    end
  end
end

return UIMainCityEvent
