local UIAllianceStarMainBottomPanel = BaseClass("UIAllianceStarMainBottomPanel", UIBaseContainer)
local UIAllianceStarBottomProgressItem = require("UI.UIAllianceStarMain.Component.Bottom.UIAllianceStarBottomProgressItem")
local base = UIBaseContainer
local UIGray = CS.UIGray

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.backBtn = self:AddComponent(UIButton, "BackBtn")
  self.leftBtn = self:AddComponent(UIButton, "LeftBtn")
  self.rightBtn = self:AddComponent(UIButton, "RightBtn")
  self.leftBtn:SetActive(false)
  self.backBtn:SetOnClick(function()
    self.view:OnClickBack()
  end)
  self.leftBtn:SetOnClick(function()
    self:ChangeProgressCtrlStage(false)
  end)
  self.rightBtn:SetOnClick(function()
    if self.view.inThumb then
      self:ChangeProgressCtrlStage(true)
    else
      DataCenter.AllianceStarManager:ChangeCurStageInnerStage(AlStarCeremonyInnerState[AlStarCeremonyState.ReadPersonReward].State5)
    end
  end)
  self.progressScrollView = self:AddComponent(UIScrollRect, "ProgressScrollView")
  self.progressContent = self:AddComponent(UIBaseContainer, "ProgressScrollView/Viewport/Content")
  self.progressScrollView:AddValueChangeListener(BindCallback(self.RefreshBoxBubble, self))
  self.progressItemPool = self.transform:Find("ProgressScrollView/Viewport/Content/ProgressItem").gameObject
  self.progressItemPool:SetActive(false)
  self.progressItemPool:GameObjectCreatePool()
  self.boxBubble = self:AddComponent(UIButton, "BoxBubble")
  self.boxBubble:SetActive(false)
  self.boxBubble:SetOnClick(function()
    DataCenter.AllianceStarManager:ChangeProgressCtrlStageById(#self.progressItems)
  end)
end

local function ComponentDestroy(self)
  self.progressContent:RemoveComponents(UIAllianceStarBottomProgressItem)
  self.progressItemPool:GameObjectRecycleAll()
  self.progressItemPool = nil
  self.backBtn = nil
  self.leftBtn = nil
  self.rightBtn = nil
  self.progressScrollView = nil
  self.progressContent = nil
  self.boxBubble = nil
end

local function DataDefine(self)
  self.progressItems = {}
  self.scrollWidth = self:GetSizeDeltaXY()
  self:Refresh()
end

local function DataDestroy(self)
  self.progressItems = nil
  self.scrollWidth = nil
  self.contentX = nil
end

local function OnAddListener(self)
  self:AddUIListener(EventId.AllianceStarCeremonyInfoPush, self.OnAllianceStarCeremonyInfoPush)
  self:AddUIListener(EventId.AllianceStarRefreshThumb, self.OnAllianceStarRefreshThumb)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceStarCeremonyInfoPush, self.OnAllianceStarCeremonyInfoPush)
  self:RemoveUIListener(EventId.AllianceStarRefreshThumb, self.OnAllianceStarRefreshThumb)
end

local function ChangeProgressCtrlStage(self, isRight)
  DataCenter.AllianceStarManager:ChangeProgressCtrlStage(isRight)
end

local function Refresh(self)
  self.fullData = DataCenter.AllianceStarManager:GetCeremonyFullData()
  self.stageId = DataCenter.AllianceStarManager:GetProgressCtrlStageId()
  self:RefreshBtn()
  self:RefreshProgressPanel()
end

local function RefreshBtn(self)
  if self.stageId <= 1 then
    UIGray.SetGray(self.leftBtn.transform, true, false)
    UIGray.SetGray(self.rightBtn.transform, false, true)
  elseif self.stageId >= #self.fullData.ceremonyInfo + 1 then
    UIGray.SetGray(self.leftBtn.transform, false, true)
    UIGray.SetGray(self.rightBtn.transform, true, false)
  else
    UIGray.SetGray(self.leftBtn.transform, false, true)
    UIGray.SetGray(self.rightBtn.transform, false, true)
  end
end

local function RefreshProgressPanel(self)
  local ceremonyInfo = self.fullData.ceremonyInfo
  local infoCount = 0
  if ceremonyInfo then
    infoCount = #ceremonyInfo + 1
    local selectIndex = DataCenter.AllianceStarManager:GetProgressCtrlStageId()
    for i = 1, infoCount do
      local configId
      local progressItem = self.progressItems[i]
      if progressItem == nil then
        local obj = self.progressItemPool:GameObjectSpawn(self.progressContent.transform)
        obj.name = "progressItem" .. i
        progressItem = self.progressContent:AddComponent(UIAllianceStarBottomProgressItem, obj.name)
        self.progressItems[i] = progressItem
      end
      progressItem:SetActive(true)
      if i == infoCount then
        progressItem:RefreshByReward(i, selectIndex, infoCount, configId, self.fullData.participateReceive, false)
      else
        configId = ceremonyInfo[i].configId
        local selfThumbs
        local thumbInfo = DataCenter.AllianceStarManager:GetCeremonyStarThumbInfo(configId)
        local ownInNominate = DataCenter.AllianceStarManager:GetCeremonyStarOwnInNominate(configId)
        if thumbInfo then
          selfThumbs = thumbInfo.selfThumbs
        end
        progressItem:RefreshByThumb(i, selectIndex, infoCount, configId, selfThumbs, ownInNominate)
      end
    end
  end
  for i = infoCount + 1, #self.progressItems do
    self.progressItems[i]:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.progressContent.rectTransform)
  self:RefreshBoxBubble()
end

local function OnAllianceStarCeremonyInfoPush(self)
  local offsetX = 0
  local stageId = DataCenter.AllianceStarManager:GetProgressCtrlStageId()
  if self.stageId then
    offsetX = stageId < self.stageId and -50 or 50
  end
  self.stageId = stageId
  self:RefreshBtn()
  local selectIndex = DataCenter.AllianceStarManager:GetProgressCtrlStageId()
  local count = #self.progressItems
  for i = 1, count do
    local progressItem = self.progressItems[i]
    if i == selectIndex or progressItem.isSelect then
      progressItem:SetActive(true)
      if i == count then
        progressItem:RefreshByReward(i, selectIndex, count, progressItem.configId, self.fullData.participateReceive, false)
      else
        local selfThumbs
        local thumbInfo = DataCenter.AllianceStarManager:GetCeremonyStarThumbInfo(progressItem.configId)
        local ownInNominate = DataCenter.AllianceStarManager:GetCeremonyStarOwnInNominate(progressItem.configId)
        if thumbInfo then
          selfThumbs = thumbInfo.selfThumbs
        end
        progressItem:RefreshByThumb(i, selectIndex, count, progressItem.configId, selfThumbs, ownInNominate)
      end
    end
  end
  local item = self.progressItems[selectIndex]
  if item then
    local contentX = self.progressContent:GetLocalPositionXYZ()
    local posX, _, _ = item:GetLocalPositionXYZ()
    if posX + contentX + offsetX < 0 or posX + contentX + offsetX > self.scrollWidth then
      self.progressScrollView:StopMovement()
      if selectIndex == 1 then
        selectIndex = 0
      end
      self.progressScrollView:SetHorizontalNormalizedPosition(selectIndex / count)
    end
  end
end

local function OnAllianceStarRefreshThumb(self, ceremonyInfo)
  for i, v in ipairs(self.progressItems) do
    if v.configId == ceremonyInfo.configId then
      local selfThumbs
      local thumbInfo = DataCenter.AllianceStarManager:GetCeremonyStarThumbInfo(v.configId)
      if thumbInfo then
        selfThumbs = thumbInfo.selfThumbs
      end
      v:RefreshThumb(selfThumbs)
      break
    end
  end
end

local function OnAllianceStarCeremonyQuestReward(self)
  if self.progressItems then
    local rewardItem = self.progressItems[#self.progressItems]
    local fullData = DataCenter.AllianceStarManager:GetCeremonyFullData()
    rewardItem:RefreshReward(fullData.participateReceive)
  end
  self:RefreshBoxBubble()
end

local function RefreshBoxBubble(self)
  if self.fullData and not self.fullData.participateReceive then
    local contentX = self.progressContent:GetLocalPositionXYZ()
    local rewardItem = self.progressItems[#self.progressItems]
    local posX, _, _ = rewardItem:GetLocalPositionXYZ()
    if posX + contentX > self.scrollWidth then
      self.boxBubble:SetActive(true)
    else
      self.boxBubble:SetActive(false)
    end
  else
    self.boxBubble:SetActive(false)
  end
end

UIAllianceStarMainBottomPanel.OnCreate = OnCreate
UIAllianceStarMainBottomPanel.OnDestroy = OnDestroy
UIAllianceStarMainBottomPanel.OnEnable = OnEnable
UIAllianceStarMainBottomPanel.OnDisable = OnDisable
UIAllianceStarMainBottomPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainBottomPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainBottomPanel.DataDefine = DataDefine
UIAllianceStarMainBottomPanel.DataDestroy = DataDestroy
UIAllianceStarMainBottomPanel.OnAddListener = OnAddListener
UIAllianceStarMainBottomPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainBottomPanel.ChangeProgressCtrlStage = ChangeProgressCtrlStage
UIAllianceStarMainBottomPanel.Refresh = Refresh
UIAllianceStarMainBottomPanel.RefreshBtn = RefreshBtn
UIAllianceStarMainBottomPanel.RefreshProgressPanel = RefreshProgressPanel
UIAllianceStarMainBottomPanel.OnAllianceStarCeremonyInfoPush = OnAllianceStarCeremonyInfoPush
UIAllianceStarMainBottomPanel.OnAllianceStarRefreshThumb = OnAllianceStarRefreshThumb
UIAllianceStarMainBottomPanel.OnAllianceStarCeremonyQuestReward = OnAllianceStarCeremonyQuestReward
UIAllianceStarMainBottomPanel.RefreshBoxBubble = RefreshBoxBubble
return UIAllianceStarMainBottomPanel
