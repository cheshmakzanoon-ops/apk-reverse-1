local base = UIBaseContainer
local UIGhostreconTaskBannerPanel = BaseClass("UIGhostreconTaskBannerPanel", base)
local Localization = CS.GameEntry.Localization
local bgImg_path = "BgImg"
local qualityImg_path = "QualityImg"
local timePanel_path = "Time"
local timeText_path = "Time/TimeText"
local tipText_path = "TipText"
local posText_path = "PosTxt"
local posBtn_path = "PosTxt"
local lvText_path = "LvText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bgImg = self:AddComponent(UIRawImage, bgImg_path)
  self.qualityImg = self:AddComponent(UIImage, qualityImg_path)
  self.timePanel = self:AddComponent(UIBaseContainer, timePanel_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.posText = self:AddComponent(UIText, posText_path)
  self.posBtn = self:AddComponent(UIButton, posBtn_path)
  self.lvText = self:AddComponent(UIText, lvText_path)
  self.posBtn:SetOnClick(function()
    local taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(self.uuid)
    if taskInfo and taskInfo.pointId then
      DataCenter.ActGhostreconManager:JumpToPoint(taskInfo.pointId, taskInfo.uuid, taskInfo.targetServer)
    end
  end)
end

local function ComponentDestroy(self)
  self.bgImg = nil
  self.qualityImg = nil
  self.timePanel = nil
  self.timeText = nil
  self.tipText = nil
  self.posText = nil
  self.posBtn = nil
  self.lvText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.uuid = nil
  self.taskInfo = nil
  self.checkTime = nil
  self.cacheBubbleType = nil
end

local function SetData(self, uuid)
  self.uuid = uuid
  self.taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
  self.cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(self.taskInfo.cfgId)
  self.lvText:SetText(Localization:GetString("ghostrecon_053") .. self.cfg.level)
  self.bgImg:LoadSprite(UIAssets.GhostreconTexturePath .. self.cfg.imgSet.BannerImg)
  self.qualityImg:LoadSprite(self.cfg.imgSet.QualityImg)
  self.qualityImg:SetNativeSize()
  if self.taskInfo.bubbleType == GhostreconTaskType.Own_NotExecuted or self.taskInfo.bubbleType == GhostreconTaskType.Own_TeamingUp or self.taskInfo.bubbleType == GhostreconTaskType.Alliance_TeamingUp then
    self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.cfg.time))
  end
  if self.taskInfo.bubbleType == GhostreconTaskType.Own_NotExecuted then
    self.tipText:SetLocalText(self.cfg.descId, self.taskInfo.targetServer)
    self.tipText:SetActive(true)
  else
    self.tipText:SetActive(false)
  end
  if self.taskInfo.bubbleType == GhostreconTaskType.Own_TeamingUp or self.taskInfo.bubbleType == GhostreconTaskType.Alliance_TeamingUp or self.taskInfo.bubbleType == GhostreconTaskType.Own_Runing or self.taskInfo.bubbleType == GhostreconTaskType.Alliance_Runing then
    local pos = SceneUtils.IndexToTilePos(self.taskInfo.pointId, ForceChangeScene.World)
    self.posText:SetLocalText(GameDialogDefine.POSITION_COORDINATE_CROSS, self.taskInfo.targetServer, pos.x, pos.y)
    self.posText:SetActive(true)
  else
    self.posText:SetActive(false)
  end
  self.cacheBubbleType = self.taskInfo.bubbleType
  self:Update()
end

local function Update(self)
  if self.cacheBubbleType == GhostreconTaskType.Own_Runing or self.cacheBubbleType == GhostreconTaskType.Alliance_Runing then
    if self.taskInfo.bubbleType == GhostreconTaskType.Own_WaitClaim or self.taskInfo.bubbleType == GhostreconTaskType.Alliance_WaitClaim then
      self.timeText:SetText("00:00:00")
      self.view.ctrl:CloseSelf()
    else
      local now = UITimeManager:GetInstance():GetServerTime()
      local diff = self.taskInfo.completionTime - now
      if 0 < diff then
        self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
      else
        self.timeText:SetText("00:00:00")
        self.view.ctrl:CloseSelf()
      end
    end
  end
end

UIGhostreconTaskBannerPanel.OnCreate = OnCreate
UIGhostreconTaskBannerPanel.OnDestroy = OnDestroy
UIGhostreconTaskBannerPanel.OnEnable = OnEnable
UIGhostreconTaskBannerPanel.OnDisable = OnDisable
UIGhostreconTaskBannerPanel.ComponentDefine = ComponentDefine
UIGhostreconTaskBannerPanel.ComponentDestroy = ComponentDestroy
UIGhostreconTaskBannerPanel.DataDefine = DataDefine
UIGhostreconTaskBannerPanel.DataDestroy = DataDestroy
UIGhostreconTaskBannerPanel.SetData = SetData
UIGhostreconTaskBannerPanel.Update = Update
return UIGhostreconTaskBannerPanel
