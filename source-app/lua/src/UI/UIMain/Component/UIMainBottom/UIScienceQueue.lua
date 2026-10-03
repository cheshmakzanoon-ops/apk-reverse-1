local UIScienceQueue = BaseClass("UIScienceQueue", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local common_red_point_path = "btn/CommonRedPoint"
local text_path = "btn/text"
local btn_path = "btn"
local harmer_path = "btn/icon"
local bubble_path = "bubble"
local bubble_btn = "bubble/bubble_btn/"
local bubble_btn_text_path = "bubble/bubble_btn/bubble_btn_text"
local EMPTY_ICON = "Assets/Main/Sprites/UI/UIBuildQueue/zyf_chengjian_dikuai.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.commonRedPoint:SetType(CommonRedPointPriority.LevelNormal)
  self.commonRedPoint:SetId(CommonRedPointId.MainUI_ScienceQueue)
  self.text = self:AddComponent(UIText, text_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.harmer = self:AddComponent(UIBaseContainer, harmer_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClickView))
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.QUEUE_TIME_END, self.Refresh)
  self:AddUIListener(EventId.OnScienceQueueFinish, self.Refresh)
  self:AddUIListener(EventId.OnScienceQueueResearch, self.Refresh)
  self:AddUIListener(EventId.AddSpeedSuccess, self.Refresh)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.Refresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.QUEUE_TIME_END, self.Refresh)
  self:RemoveUIListener(EventId.OnScienceQueueFinish, self.Refresh)
  self:RemoveUIListener(EventId.OnScienceQueueResearch, self.Refresh)
  self:RemoveUIListener(EventId.AddSpeedSuccess, self.Refresh)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.Refresh)
end

local function Refresh(self)
  if SceneUtils.GetIsInWorld() then
    self.gameObject:SetActive(false)
    return
  end
  local allScienceQueues = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
  local filterdQueues = {}
  for i, v in ipairs(allScienceQueues) do
    local buildUuid = v.funcUuid
    if buildUuid then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
      if buildData and buildData.level >= 1 then
        table.insert(filterdQueues, v)
      end
    end
  end
  local unlock = 0 < #filterdQueues
  self.gameObject:SetActive(unlock)
  if unlock then
    local freeQueueNum = 0
    for i, v in ipairs(filterdQueues) do
      local state = v:GetQueueState()
      if state == NewQueueState.Free or state == NewQueueState.Finish then
        freeQueueNum = freeQueueNum + 1
      end
    end
    self.commonRedPoint:SetDefaultVisible(0 < freeQueueNum)
    self.text:SetText(string.format("%d/%d", #filterdQueues - freeQueueNum, #filterdQueues))
  end
end

local function OnClickView(self)
  self.commonRedPoint:SetViewed()
  local showRecommend1Data, showRecommend2Data = DataCenter.ScienceRecommendManager:GetRecommendScience()
  local recommendData
  if showRecommend1Data then
    recommendData = showRecommend1Data
  elseif showRecommend2Data then
    recommendData = showRecommend2Data
  end
  if recommendData then
    local allScienceQueues = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
    for i, v in ipairs(allScienceQueues) do
      local buildUuid = v.funcUuid
      if buildUuid then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
        if buildData and buildData.level >= 1 then
          local state = v:GetQueueState()
          if state == NewQueueState.Free then
            DataCenter.UIPopWindowManager:Push(UIWindowNames.UILWScienceMain, recommendData.tab, buildUuid)
            GoToUtil.GotoScience(recommendData.science_id, recommendData.tab, buildUuid, true)
            return
          end
        end
      end
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceQueue)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self:Refresh()
end

UIScienceQueue.OnDestroy = OnDestroy
UIScienceQueue.OnCreate = OnCreate
UIScienceQueue.ComponentDefine = ComponentDefine
UIScienceQueue.DataDestroy = DataDestroy
UIScienceQueue.ComponentDestroy = ComponentDestroy
UIScienceQueue.DataDefine = DataDefine
UIScienceQueue.OnEnable = OnEnable
UIScienceQueue.OnDisable = OnDisable
UIScienceQueue.OnClickView = OnClickView
UIScienceQueue.ReInit = ReInit
UIScienceQueue.Refresh = Refresh
UIScienceQueue.OnAddListener = OnAddListener
UIScienceQueue.OnRemoveListener = OnRemoveListener
return UIScienceQueue
