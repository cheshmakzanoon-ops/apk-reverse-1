local UIPVEMainPveAct = BaseClass("UIPVEMainPveAct", UIBaseContainer)
local base = UIBaseContainer
local main_path = "Main"
local main_time_path = "Main/MainTime"
local main_red_path = "Main/MainRed"
local main_red_num_path = "Main/MainRed/MainRedText"
local rank_path = "Rank"
local rank_time_path = "Rank/RankTime"
local rank_num_path = "Rank/RankNum"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.main_btn = self:AddComponent(UIButton, main_path)
  self.main_btn:SetOnClick(function()
    self:OnMainClick()
  end)
  self.main_time_text = self:AddComponent(UIText, main_time_path)
  self.main_red_go = self:AddComponent(UIBaseContainer, main_red_path)
  self.main_red_go:SetActive(false)
  self.main_red_num_text = self:AddComponent(UIText, main_red_num_path)
  self.rank_btn = self:AddComponent(UIButton, rank_path)
  self.rank_btn:SetOnClick(function()
    self:OnRankClick()
  end)
  self.rank_time_text = self:AddComponent(UIText, rank_time_path)
  self.rank_num_text = self:AddComponent(UIText, rank_num_path)
end

local function ComponentDestroy(self)
  self.main_btn = nil
  self.main_time_text = nil
  self.main_red_go = nil
  self.main_red_num_text = nil
  self.rank_btn = nil
  self.rank_time_text = nil
  self.rank_num_text = nil
end

local function DataDefine(self)
  self.timer = nil
  self.active = false
end

local function DataDestroy(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.active = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PveActGetRank, self.Refresh)
  self:AddUIListener(EventId.PveActTaskReward, self.Refresh)
  self:AddUIListener(EventId.PveActStageReward, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PveActGetRank, self.Refresh)
  self:RemoveUIListener(EventId.PveActTaskReward, self.Refresh)
  self:RemoveUIListener(EventId.PveActStageReward, self.Refresh)
  base.OnRemoveListener(self)
end

local function ReInit(self, levelId)
  self.levelId = levelId
  self.actId = DataCenter.PveActManager:GetActIdByPve(levelId)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  self.timer:Start()
  self:Refresh()
end

local function Refresh(self)
  if self.actId then
    local showRank = false
    if DataCenter.PveActManager:HasRank(self.actId) then
      local rankData = DataCenter.PveActManager:GetRankData(self.actId)
      if rankData and rankData.selfRank and rankData.selfRank > 0 then
        self.rank_num_text:SetText(rankData.selfRank)
        showRank = true
      end
    end
    local _, _, smallIcon = DataCenter.PveActManager:GetIcon(self.actId)
    local redCount = DataCenter.PveActManager:GetRedCount(self.actId)
    self.main_btn:LoadSprite(smallIcon)
    self.main_red_go:SetActive(0 < redCount)
    self.main_red_num_text:SetText(redCount)
    self.rank_btn:SetActive(showRank)
  end
end

local function TimerAction(self)
  if not self.active then
    return
  end
  if self.actId then
    local restTime, restTimeStr = DataCenter.PveActManager:GetRestTime(self.actId)
    self.main_time_text:SetText(restTimeStr)
    self.rank_time_text:SetText(restTimeStr)
    if restTime <= 0 then
      self.view:ShowContent(self.view.ContentEnum.PveAct, false)
    end
  end
end

local function OnMainClick(self)
  if self.actId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPveActMain, self.actId, self.levelId)
  end
end

local function OnRankClick(self)
  if self.actId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPveActRank, self.actId, self.levelId)
  end
end

UIPVEMainPveAct.OnCreate = OnCreate
UIPVEMainPveAct.OnDestroy = OnDestroy
UIPVEMainPveAct.ComponentDefine = ComponentDefine
UIPVEMainPveAct.ComponentDestroy = ComponentDestroy
UIPVEMainPveAct.DataDefine = DataDefine
UIPVEMainPveAct.DataDestroy = DataDestroy
UIPVEMainPveAct.OnEnable = OnEnable
UIPVEMainPveAct.OnDisable = OnDisable
UIPVEMainPveAct.OnAddListener = OnAddListener
UIPVEMainPveAct.OnRemoveListener = OnRemoveListener
UIPVEMainPveAct.ReInit = ReInit
UIPVEMainPveAct.Refresh = Refresh
UIPVEMainPveAct.TimerAction = TimerAction
UIPVEMainPveAct.OnMainClick = OnMainClick
UIPVEMainPveAct.OnRankClick = OnRankClick
return UIPVEMainPveAct
