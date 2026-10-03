local base = UIAsyncContainer
local AirshipDonateDetail = BaseClass("AirshipDonateDetail", base)
local commend_text_path = "tips/commendText"
local transfer_progress_path = "info/TransferProgress"
local stage_tips_path = "StageTips"
local hint_root_path = "down/timeLabel/btnInfo/HintRoot"
local time_text_path = "down/timeLabel/btnInfo/HintRoot/TimeText"
local left_icon_path = "info/TransferProgress/LeftIcon"
local right_icon_path = "info/TransferProgress/RightIcon"
local level_icon_path = "info/DonatedGroup/Root/LevelIcon"
local donated_group_path = "info/DonatedGroup"
local root_path = "info/DonatedGroup/Root"
local OwnIconPath = "Assets/Main/Sprites/UI/LWUIZoneMobilization/ljq_zhanqudongyuan_jindu_01.png"
local OpposideIconPath = "Assets/Main/Sprites/UI/LWUIZoneMobilization/ljq_zhanqudongyuan_jindu_02.png"
local LEVEL_ICON_PATH = "Assets/Main/Sprites/UI/LWUIZoneMobilization/%s.png"

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
  self:AddTimer()
end

local function OnDisable(self)
  base.OnDisable(self)
  self:RemoveTimer()
  self.hint_root:SetActive(false)
  self.showHint = nil
end

local function ComponentDefine(self)
  self.detailNode = self:AddComponent(UIBaseContainer, "")
  self.donatedProgress = self:AddComponent(UISlider, "info/DonatedGroup/DonatedProgress")
  self.donatedProgressText = self:AddComponent(UIText, "info/DonatedGroup/DonatedProgress/DonatedProgressText")
  self.divideNode = self:AddComponent(UIBaseContainer, "divide")
  self.tipsNode = self:AddComponent(UIBaseContainer, "tips")
  self.commend_text = self:AddComponent(UITextMeshProUGUIEx, commend_text_path)
  self.downNode = self:AddComponent(UIBaseContainer, "down")
  self.timeLabel = self:AddComponent(UIText, "down/timeLabel")
  self.hintBtn = self:AddComponent(UIButton, "down/timeLabel/btnInfo")
  self.hintBtn:SetOnClick(function()
    self:OnHintBtnClick()
  end)
  self.transfer_progress = self:AddComponent(UISlider, transfer_progress_path)
  self.stage_tips = self:AddComponent(UITextMeshProUGUIEx, stage_tips_path)
  self.hint_root = self:AddComponent(UIImage, hint_root_path)
  self.hint_root:SetActive(false)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.left_icon = self:AddComponent(UIImage, left_icon_path)
  self.right_icon = self:AddComponent(UIImage, right_icon_path)
  self.level_icon = self:AddComponent(UIImage, level_icon_path)
  self.donated_group = self:AddComponent(UIBaseContainer, donated_group_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
end

local function ComponentDestroy(self)
  self.detailNode = nil
  self.donatedProgress = nil
  self.donatedProgressText = nil
  self.divideNode = nil
  self.tipsNode = nil
  self.commend_text = nil
  self.downNode = nil
  self.timeLabel = nil
  self.hintBtn = nil
  self.transfer_progress = nil
  self.stage_tips = nil
  self.hint_root = nil
  self.time_text = nil
  self.left_icon = nil
  self.right_icon = nil
  self.level_icon = nil
  self.donated_group = nil
  self.root = nil
end

local function DataDefine(self)
  self.nextStageTime = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.showHint = nil
  self.stageType = nil
  self.totalTime = nil
end

local function DataDestroy(self)
  self.timer_action = nil
  self.nextStageTime = nil
  self.showHint = nil
  self.stageType = nil
  self.totalTime = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnHintBtnClick(self)
  self.showHint = not self.showHint
  self.hint_root:SetActive(self.showHint)
end

local function UpdateView(self, data)
  if data then
    local nextStageTime = data.nextStageTime
    self.nextStageTime = nextStageTime
    local timeStr = UITimeManager:GetInstance():TimeStampToTimeForLocal(nextStageTime)
    self.time_text:SetText(timeStr)
    self.detailNode:SetActive(true)
    local stage = data.stage
    if stage then
      local stageType = DataCenter.LWZoneMobilizationManager:GetStageType(stage)
      self.stageType = stageType
      if stageType == ZoneMobilizationStageType.Donated or stageType == ZoneMobilizationStageType.Sprint then
        local donateProgress = data.donateProgress
        local maxProgress = data.maxProgress
        if donateProgress and maxProgress and 0 < maxProgress then
          self.donated_group:SetActive(true)
          self.donatedProgress:SetValue(donateProgress / maxProgress)
          self.donatedProgressText:SetText(donateProgress .. "/" .. maxProgress)
          if donateProgress >= maxProgress then
            self.stage_tips:SetLocalText("zone_mobilization_building_finish")
          else
            self.stage_tips:SetLocalText("zone_mobilization_building")
          end
        else
          self.donated_group:SetActive(false)
        end
        self.transfer_progress:SetActive(false)
        self.divideNode:SetActive(true)
        self.tipsNode:SetActive(true)
        self.downNode:SetActive(true)
        self.commend_text:SetLocalText("zone_mobilization_stage_count_down")
      elseif stageType == ZoneMobilizationStageType.Battle_Place then
        local donateProgress = data.donateProgress
        local maxProgress = data.maxProgress
        if donateProgress and maxProgress and 0 < maxProgress then
          self.donated_group:SetActive(true)
          self.donatedProgress:SetValue(donateProgress / maxProgress)
          self.donatedProgressText:SetText(donateProgress .. "/" .. maxProgress)
        end
        self.divideNode:SetActive(false)
        self.tipsNode:SetActive(false)
        self.downNode:SetActive(false)
        self.transfer_progress:SetActive(false)
        self.commend_text:SetLocalText("")
        self.stage_tips:SetLocalText("zone_mobilization_building_finish")
      elseif stageType == ZoneMobilizationStageType.Battle_Transfer then
        if nextStageTime and 0 < nextStageTime then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          if nextStageTime > curTime then
            self.transfer_progress:SetActive(true)
            local progress = Mathf.Clamp01((self.totalTime - (nextStageTime - curTime)) / self.totalTime)
            self.transfer_progress:SetValue(progress)
          end
        else
          self.transfer_progress:SetActive(false)
        end
        self.donated_group:SetActive(false)
        self.divideNode:SetActive(true)
        self.tipsNode:SetActive(true)
        self.downNode:SetActive(true)
        self.commend_text:SetLocalText("zone_mobilization_transfer_time")
        self.stage_tips:SetLocalText("zone_mobilization_transfering")
        local pointInfo = CS.SceneManager.World:GetPointInfo(data.pointId)
        if pointInfo and pointInfo.serverId and pointInfo.serverId ~= LuaEntry.Player:GetSourceServerId() then
          self.left_icon:LoadSprite(OpposideIconPath)
          self.right_icon:LoadSprite(OwnIconPath)
        else
          self.left_icon:LoadSprite(OwnIconPath)
          self.right_icon:LoadSprite(OpposideIconPath)
        end
      end
      self:RefreshLevelIcon(stageType == ZoneMobilizationStageType.Sprint or stageType == ZoneMobilizationStageType.Battle_Place, data.pointId)
    end
    self:RefreshTime()
  else
    self.detailNode:SetActive(false)
  end
end

local function RefreshLevelIcon(self, show, point)
  local isRed = false
  local bossId = 0
  if point and 0 < point then
    local pointInfo = CS.SceneManager.World:GetPointInfo(point)
    if pointInfo then
      if pointInfo.serverId and pointInfo.serverId ~= LuaEntry.Player:GetSourceServerId() then
        isRed = true
      end
      bossId = pointInfo and pointInfo.zoneMobilizationPointInfo and pointInfo.zoneMobilizationPointInfo.bossId
    end
  end
  if bossId == nil or bossId == 0 then
    show = false
  end
  self.root:SetActive(show)
  if not show then
    return
  end
  local bossData = LocalController:instance():getLine(TableName.ZoneMobilizationBoss, bossId)
  if bossData then
    local icons = bossData:getValue("progress_score_icon", "")
    if not string.IsNullOrEmpty(icons) then
      local iconArr = string.split(icons, "|")
      local index = isRed and 2 or 1
      if iconArr and index <= #iconArr then
        self.level_icon:LoadSprite(string.format(LEVEL_ICON_PATH, iconArr[index]))
      end
    end
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function RefreshTime(self)
  if self.nextStageTime == nil or self.nextStageTime == 0 then
    self.timeLabel:SetText("")
    self.view.ctrl:CloseSelf()
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = self.nextStageTime - curTime
  if 0 < deltaTime then
    self.timeLabel:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    if self.stageType and self.stageType == ZoneMobilizationStageType.Battle_Transfer and 0 < self.totalTime and self.nextStageTime and curTime < self.nextStageTime then
      local progress = Mathf.Clamp01((self.totalTime - (self.nextStageTime - curTime)) / self.totalTime)
      self.transfer_progress:SetValue(progress)
    end
  else
    self.timeLabel:SetText("")
    self.view.ctrl:CloseSelf()
  end
end

local function GetProgressTotalTime(self)
  self.totalTime = DataCenter.LWZoneMobilizationManager:GetTransferTotalTime()
  return self.totalTime
end

AirshipDonateDetail.OnCreate = OnCreate
AirshipDonateDetail.OnDestroy = OnDestroy
AirshipDonateDetail.OnEnable = OnEnable
AirshipDonateDetail.OnDisable = OnDisable
AirshipDonateDetail.ComponentDefine = ComponentDefine
AirshipDonateDetail.ComponentDestroy = ComponentDestroy
AirshipDonateDetail.DataDefine = DataDefine
AirshipDonateDetail.DataDestroy = DataDestroy
AirshipDonateDetail.OnAddListener = OnAddListener
AirshipDonateDetail.OnRemoveListener = OnRemoveListener
AirshipDonateDetail.OnHintBtnClick = OnHintBtnClick
AirshipDonateDetail.RefreshTime = RefreshTime
AirshipDonateDetail.UpdateView = UpdateView
AirshipDonateDetail.AddTimer = AddTimer
AirshipDonateDetail.RemoveTimer = RemoveTimer
AirshipDonateDetail.getters.totalTime = GetProgressTotalTime
AirshipDonateDetail.RefreshLevelIcon = RefreshLevelIcon
return AirshipDonateDetail
