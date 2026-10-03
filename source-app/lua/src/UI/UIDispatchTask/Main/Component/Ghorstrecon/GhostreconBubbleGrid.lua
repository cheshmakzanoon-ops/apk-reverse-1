local base = UIBaseContainer
local GhostreconBubbleGrid = BaseClass("GhostreconBubbleGrid", base)
local Localization = CS.GameEntry.Localization
local icon_path = "AnimNode/Icon"
local starImg_path = "AnimNode/Icon/StarImg"
local tipText_path = "AnimNode/TipText"
local btn_path = "AnimNode/Icon"
local animNode_path = "AnimNode"
local completedEffect_path = "AnimNode/Eff_UIActivityGhostreconBubbleGrid_Button"
local yellowEffect_path = "CircleImg/Eff_ring_gold"
local purpleEffect_path = "CircleImg/Eff_ring_purple"
local buleEffect_path = "CircleImg/Eff_ring_blue"
local circleNode_path = "CircleImg"
local playerHead_path = "AnimNode/Icon/Head/UIPlayerHead"
local imagePath = "Assets/Main/Sprites/UI/UIGhostrecon/%s.png"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.starImg = self:AddComponent(UIBaseContainer, starImg_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.animNode = self:AddComponent(UIAnimator, animNode_path)
  self.completedEffect = self:AddComponent(UIBaseContainer, completedEffect_path)
  self.yellowEffect = self:AddComponent(UIBaseContainer, yellowEffect_path)
  self.purpleEffect = self:AddComponent(UIBaseContainer, purpleEffect_path)
  self.buleEffect = self:AddComponent(UIBaseContainer, buleEffect_path)
  self.circleNode = self:AddComponent(UIBaseContainer, circleNode_path)
  self.playerHead = self:AddComponent(UICommonHead, playerHead_path)
  self.btn:SetOnClick(Bind(self, self.OnClick))
  self.btn:SetSafeClickMode(true)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.starImg = nil
  self.tipText = nil
  self.btn = nil
  self.animNode = nil
  self.completedEffect = nil
  self.yellowEffect = nil
  self.purpleEffect = nil
  self.buleEffect = nil
  self.circleNode = nil
  self.playerHead = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.uuid = nil
  self.taskInfo = nil
  self.posInfo = nil
  self.cfg = nil
  self.errorUUid = nil
end

local function SetData(self, uuid)
  self.uuid = uuid
  if uuid then
    self.taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
    if self.taskInfo and (self.taskInfo:OwnIsLeader() or self.taskInfo:GetOwnMemberInfo()) then
      self:SetActive(true)
      self.cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(self.taskInfo.cfgId)
      CS.UIGray.SetGray(self.icon.transform, false, true)
      local bubbleType = self.taskInfo.bubbleType
      local color = self.cfg.color
      if not self.taskInfo:OwnIsLeader() and self.taskInfo:GetOwnMemberInfo().canReward == 0 then
        color = GhostreconQuality.Bule
      end
      self.icon:LoadSprite(string.format(imagePath, GhostreconBubbleIconImg[bubbleType][color]))
      self.tipText:SetColor(GhostreconQualitySetting[color].BubbleTextColor)
      self.starImg:SetActive(self.cfg.special)
      if self.taskInfo:OwnIsLeader() then
        self.playerHead:SetActive(false)
      else
        self.playerHead:SetActive(true)
        self.playerHead:ParseHeadInfo(self.taskInfo:GetLeaderMemberInfo().memberInfo)
      end
      self.yellowEffect:SetActive(false)
      self.purpleEffect:SetActive(false)
      self.buleEffect:SetActive(false)
      if color == GhostreconQuality.Bule then
        self.buleEffect:SetActive(true)
      elseif color == GhostreconQuality.Purple then
        self.purpleEffect:SetActive(true)
      else
        self.yellowEffect:SetActive(true)
      end
      self.completedEffect:SetActive(false)
      local now = UITimeManager:GetInstance():GetServerTime()
      if bubbleType == GhostreconTaskType.Own_NotExecuted then
        self.tipText:SetActive(false)
        if DataCenter.ActGhostreconManager.dispatchEndTime == 0 and DataCenter.ActGhostreconManager.dispatchBeginTime == 0 then
          self:SetActive(false)
        elseif now < DataCenter.ActGhostreconManager.dispatchBeginTime then
          CS.UIGray.SetGray(self.icon.transform, true, true)
        else
          self.animNode:SetTrigger("running")
        end
      elseif bubbleType == GhostreconTaskType.Own_TeamingUp or bubbleType == GhostreconTaskType.Alliance_TeamingUp then
        self.tipText:SetActive(true)
        self.tipText:SetText(#self.taskInfo.memberList .. "/" .. DataCenter.ActGhostreconManager:GetTeamMaxMemberNum())
        if DataCenter.ActGhostreconManager.dispatchEndTime == 0 and DataCenter.ActGhostreconManager.dispatchBeginTime == 0 then
          self:SetActive(false)
        elseif now < DataCenter.ActGhostreconManager.dispatchBeginTime then
          CS.UIGray.SetGray(self.icon.transform, true, true)
        else
          self.animNode:SetTrigger("idle")
        end
      elseif bubbleType == GhostreconTaskType.Own_Runing or bubbleType == GhostreconTaskType.Alliance_Runing then
        self.tipText:SetActive(true)
        self.completionTime = self.taskInfo.completionTime
        self.animNode:SetTrigger("idle")
      else
        self.tipText:SetActive(false)
        self.completedEffect:SetActive(true)
        self.animNode:SetTrigger("idle")
      end
    else
      self:SetActive(false)
    end
  else
    self:SetActive(false)
  end
  self:Update()
end

local function OnClick(self)
  if self.taskInfo then
    if self.taskInfo.bubbleType == GhostreconTaskType.Own_NotExecuted or self.taskInfo.bubbleType == GhostreconTaskType.Own_TeamingUp or self.taskInfo.bubbleType == GhostreconTaskType.Alliance_TeamingUp then
      local now = UITimeManager:GetInstance():GetServerTime()
      if now >= DataCenter.ActGhostreconManager.dispatchBeginTime and now < DataCenter.ActGhostreconManager.dispatchEndTime then
        DataCenter.ActGhostreconManager:OpenWindowByTaskData(self.taskInfo)
      elseif now < DataCenter.ActGhostreconManager.dispatchBeginTime then
        UIUtil.ShowTips(Localization:GetString("ghostrecon_036", UITimeManager:GetInstance():MilliSecondToFmtString(DataCenter.ActGhostreconManager.dispatchBeginTime - now)))
      end
    else
      DataCenter.ActGhostreconManager:OpenWindowByTaskData(self.taskInfo)
    end
  end
end

local function Update(self)
  if not self.view.ctrl:GetGhostMainShow() then
    return
  end
  if self.completionTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local diff = self.completionTime - now
    if 0 <= diff then
      self.tipText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
    elseif self.taskInfo and self.taskInfo.bubbleType == GhostreconTaskType.Own_Runing or self.taskInfo.bubbleType == GhostreconTaskType.Alliance_Runing then
      local oldBubbleType = self.taskInfo.bubbleType
      self.taskInfo:RefreshBubbleType()
      if self.taskInfo.bubbleType ~= oldBubbleType then
        self:SetData(self.uuid)
      elseif self.errorUUid ~= self.uuid then
        self.errorUUid = self.uuid
        Logger.LogError("GhostreconBubbleGrid BubbleType Error : " .. self.errorUUid .. "-" .. self.taskInfo.bubbleType)
      end
    elseif self.taskInfo == nil then
      self:SetActive(false)
    end
  end
end

local function IsGuideGrid(self)
  if self.cfg and self.cfg.color == GhostreconQuality.SuperYellow then
    return self:GetPosition()
  end
end

local function ShowSpawnAnim(self)
  self.animNode:SetTrigger("spawn")
end

GhostreconBubbleGrid.OnCreate = OnCreate
GhostreconBubbleGrid.OnDestroy = OnDestroy
GhostreconBubbleGrid.OnEnable = OnEnable
GhostreconBubbleGrid.OnDisable = OnDisable
GhostreconBubbleGrid.ComponentDefine = ComponentDefine
GhostreconBubbleGrid.ComponentDestroy = ComponentDestroy
GhostreconBubbleGrid.DataDefine = DataDefine
GhostreconBubbleGrid.DataDestroy = DataDestroy
GhostreconBubbleGrid.SetData = SetData
GhostreconBubbleGrid.OnClick = OnClick
GhostreconBubbleGrid.Update = Update
GhostreconBubbleGrid.IsGuideGrid = IsGuideGrid
GhostreconBubbleGrid.ShowSpawnAnim = ShowSpawnAnim
return GhostreconBubbleGrid
