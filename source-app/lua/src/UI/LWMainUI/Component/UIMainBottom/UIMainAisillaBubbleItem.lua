local UIMainAisillaBubbleItem = BaseClass("UIMainAisillaBubbleItem", UIBaseContainer)
local base = UIBaseContainer
local UITimeManager = _ENV.UITimeManager
local ActivityMonsterInvasionDataManager = DataCenter.ActivityMonsterInvasionDataManager
local InvasionAisillaActStatus = _ENV.InvasionAisillaActStatus
local hint_bubble_path = "BubbleGroup"
local hint_bg_path = "BubbleGroup/Bg"
local hint_text_path = "BubbleGroup/Bg/HintText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.lod = 1
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnInvasionBtnClick))
  self.hint_bubble = self:AddComponent(UIBaseContainer, hint_bubble_path)
  self.bg = self:AddComponent(UIImage, hint_bg_path)
  self.hint_text = self:AddComponent(UITextMeshProUGUIEx, hint_text_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.hint_bubble = nil
  self.bg = nil
  self.hint_text = nil
end

local function DataDefine(self)
  self:AddListeners()
  self.battleStartTime = nil
  self.showHint = nil
  self.aisillaActStatus = nil
end

local function DataDestroy(self)
  self:RemoveListeners()
  self.battleStartTime = nil
  self.showHint = nil
  self.aisillaActStatus = nil
end

local function AddListeners(self)
  self:AddUIListener(EventId.RefreshAisillaChallengeInfo, self.RefreshAisillaChallengeInfo)
  self:AddUIListener(EventId.AisillaPlanTimeChange, self.ReInit)
end

local function RemoveListeners(self)
  self:RemoveUIListener(EventId.RefreshAisillaChallengeInfo, self.RefreshAisillaChallengeInfo)
  self:RemoveUIListener(EventId.AisillaPlanTimeChange, self.ReInit)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  if self.lod <= 3 and CrossServerUtil:GetIsCrossServer() == false then
    local aisillaActStatus = ActivityMonsterInvasionDataManager:GetAisillaActStatus()
    self.aisillaActStatus = aisillaActStatus
    local invasionBossInfo = ActivityMonsterInvasionDataManager:GetInvasionBossInfo()
    if invasionBossInfo then
      local isWorld = CS.SceneManager.CurrSceneID == SceneManagerSceneID.World
      local isOverPlanTime = ActivityMonsterInvasionDataManager:IsOverPlanTime()
      if isWorld and aisillaActStatus == InvasionAisillaActStatus.CREATE and isOverPlanTime then
        self.hint_bubble:SetActive(false)
        self.btn:SetActive(true)
        self:RefreshView(invasionBossInfo.battleStartTime)
        self:OnEnable()
        return
      end
    end
  end
  self.btn:SetActive(false)
  self:OnDisable()
end

local function RefreshView(self, battleStartTime)
  local countDown = 0
  if battleStartTime then
    self.battleStartTime = battleStartTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    countDown = battleStartTime - curTime
  end
  local showHint = 0 < countDown
  self.showHint = showHint
  self.countDown = countDown
  self.hint_bubble:SetActive(showHint)
end

local function Update100MS(self)
  if self.showHint then
    if self.countDown and self.countDown > 0 then
      self.countDown = self.battleStartTime - UITimeManager:GetInstance():GetServerTime()
      self.hint_text:SetLocalText("activity_godzilla_battle_count_down")
    else
      self.showHint = false
      self.hint_bubble:SetActive(false)
    end
  end
end

local function OnInvasionBtnClick(self)
  ActivityMonsterInvasionDataManager:GotoInvasionAisillaPoint(true)
end

local function RefreshAisillaChallengeInfo(self, param)
  if param == nil then
    self.btn:SetActive(false)
    self:OnDisable()
    return
  end
  local status = param.status
  self.aisillaActStatus = status
  local isOverPlanTime = ActivityMonsterInvasionDataManager:IsOverPlanTime()
  if status == InvasionAisillaActStatus.CREATE and isOverPlanTime then
    self.btn:SetActive(true)
    self:OnEnable()
    local battleStartTime = param.battleStartTime
    self:RefreshView(battleStartTime)
  else
    self.btn:SetActive(false)
    self:OnDisable()
  end
end

local function SetLod(self, lod)
  if self.lod ~= lod then
    self.lod = lod
    self:ReInit()
  end
end

UIMainAisillaBubbleItem.OnCreate = OnCreate
UIMainAisillaBubbleItem.OnDestroy = OnDestroy
UIMainAisillaBubbleItem.OnEnable = OnEnable
UIMainAisillaBubbleItem.OnDisable = OnDisable
UIMainAisillaBubbleItem.ComponentDefine = ComponentDefine
UIMainAisillaBubbleItem.ComponentDestroy = ComponentDestroy
UIMainAisillaBubbleItem.DataDefine = DataDefine
UIMainAisillaBubbleItem.DataDestroy = DataDestroy
UIMainAisillaBubbleItem.Update100MS = Update100MS
UIMainAisillaBubbleItem.ReInit = ReInit
UIMainAisillaBubbleItem.RefreshView = RefreshView
UIMainAisillaBubbleItem.OnInvasionBtnClick = OnInvasionBtnClick
UIMainAisillaBubbleItem.AddListeners = AddListeners
UIMainAisillaBubbleItem.RemoveListeners = RemoveListeners
UIMainAisillaBubbleItem.RefreshAisillaChallengeInfo = RefreshAisillaChallengeInfo
UIMainAisillaBubbleItem.SetLod = SetLod
return UIMainAisillaBubbleItem
