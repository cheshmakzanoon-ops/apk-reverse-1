local AlChallengeBossBubbleItem = BaseClass("AlChallengeBossBubbleItem", UIBaseContainer)
local base = UIBaseContainer
local UITimeManager = _ENV.UITimeManager
local time_text_path = "TimeText"

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
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.time_text = nil
end

local function DataDefine(self)
  self.endTime = nil
  self.countDown = nil
  self.point = nil
end

local function DataDestroy(self)
  self.endTime = nil
  self.countDown = nil
  self.point = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.endTime = nil
  self.countDown = nil
  self.point = nil
end

local function ReInit(self)
  if self.lod <= 3 and CrossServerUtil:GetIsCrossServer() == false and DataCenter.ActivityKillZombieManager.isNewFuncOpen then
    local newAlData = DataCenter.ActivityKillZombieManager.newAlData
    local isPlanTimeFuncOpen = DataCenter.ActivityKillZombieManager:GetIsPlanTimeFuncOpen()
    local minStage = isPlanTimeFuncOpen and ChallengeZombieAlBossStage.Prepare or ChallengeZombieAlBossStage.None
    if newAlData and newAlData.bossUuid > 0 and minStage < newAlData.stage and newAlData.stage < ChallengeZombieAlBossStage.Settlement then
      self.btn:SetActive(true)
      self:RefreshView(newAlData.endTime)
      self.point = newAlData.bossPointId
      self.pointServerId = newAlData.bossServerId
      self:OnEnable()
      return
    end
  end
  self.btn:SetActive(false)
  self:OnDisable()
end

local function RefreshView(self, endTime)
  local countDown = 0
  if endTime then
    self.endTime = endTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    countDown = endTime - curTime
  end
  self.countDown = countDown
end

local function Update100MS(self)
  if self.countDown and self.countDown > 0 then
    self.countDown = self.endTime - UITimeManager:GetInstance():GetServerTime()
    self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.countDown))
  elseif self:GetActive() then
    self.btn:SetActive(false)
  end
end

local function OnInvasionBtnClick(self)
  if self.point and self.point > 0 then
    DataCenter.ActivityKillZombieManager:GotoWorldPos(self.point, nil, self.pointServerId)
  end
end

local function SetLod(self, lod)
  if self.lod ~= lod then
    self.lod = lod
    self:ReInit()
  end
end

AlChallengeBossBubbleItem.OnCreate = OnCreate
AlChallengeBossBubbleItem.OnDestroy = OnDestroy
AlChallengeBossBubbleItem.OnEnable = OnEnable
AlChallengeBossBubbleItem.OnDisable = OnDisable
AlChallengeBossBubbleItem.ComponentDefine = ComponentDefine
AlChallengeBossBubbleItem.ComponentDestroy = ComponentDestroy
AlChallengeBossBubbleItem.DataDefine = DataDefine
AlChallengeBossBubbleItem.DataDestroy = DataDestroy
AlChallengeBossBubbleItem.Update100MS = Update100MS
AlChallengeBossBubbleItem.ReInit = ReInit
AlChallengeBossBubbleItem.RefreshView = RefreshView
AlChallengeBossBubbleItem.OnInvasionBtnClick = OnInvasionBtnClick
AlChallengeBossBubbleItem.SetLod = SetLod
return AlChallengeBossBubbleItem
