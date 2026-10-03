local ScienceTabOldPanel = BaseClass("ScienceTabOldPanel", UIBaseView)
local base = UIBaseView
local UIScienceTabCell = require("UI.UIScienceTabNew.Component.ScienceTabCell")
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local scroll_view_path = "BgGo/MiddleBg/ScrollView"
local content_path = "BgGo/MiddleBg/ScrollView/Viewport/Content"
local image_path = "Image"
local recommendGo_path = "BgGo/MiddleBg/Recommend"
local recommendIcon_path = "BgGo/MiddleBg/Recommend/Science/Icon"
local recommendLv_path = "BgGo/MiddleBg/Recommend/Science/LvTxt"
local recommendName_path = "BgGo/MiddleBg/Recommend/Name"
local recommendBtn_path = "BgGo/MiddleBg/Recommend/Btn"
local recommendBtnTxt_path = "BgGo/MiddleBg/Recommend/Btn/Txt"
local rocketBgContainers_path = "RocketContainer/Rockets"
local ScreenCell = 3
local rocket_design_width = 1750
local rocket_design_height = 750

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetExtraFillSize(200, 0)
  self.image = self:AddComponent(UIImage, image_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.recommendGoN = self:AddComponent(UIBaseContainer, recommendGo_path)
  self.recommendIconN = self:AddComponent(UIImage, recommendIcon_path)
  self.recommendLvN = self:AddComponent(UIText, recommendLv_path)
  self.recommendNameN = self:AddComponent(UIText, recommendName_path)
  self.recommendBtnN = self:AddComponent(UIButton, recommendBtn_path)
  self.recommendBtnN:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickRecommendBtn()
  end)
  self.recommendBtnTxtN = self:AddComponent(UIText, recommendBtnTxt_path)
  self.recommendBtnTxtN:SetLocalText(110003)
  self.researchScienceList = {}
  self.researchTabList = {}
  self.isSendFinishList = {}
end

local function ComponentDestroy(self)
  self.scroll_view = nil
  self.image = nil
  self.researchScienceList = nil
  self.researchTabList = nil
end

local function DataDefine(self)
  self.gotoTab = nil
  self.queue = nil
  self.isResearchingTab = nil
  self.bUuid = nil
end

local function DataDestroy(self)
  self.gotoTab = nil
  self.queue = nil
  self.isResearchingTab = nil
  self.bUuid = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshAll()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:AddUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  self:AddUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
  self:AddUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:RemoveUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  self:RemoveUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
  self:RemoveUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
end

local function InitUI(self, tab, bUuid)
  self.bUuid = bUuid
  if not string.IsNullOrEmpty(tab) then
    self.gotoTab = tonumber(tab)
  else
    self.gotoTab = ScienceTab.Resource
  end
  self:RefreshAll()
end

local function RefreshAll(self)
  if not (self.bUuid and self.gotoTab) or self.gotoTab <= 0 then
    return
  end
  local scaleX = Screen.width / rocket_design_width
  local scaleY = Screen.height / rocket_design_height
  local scale = math.max(scaleX, scaleY)
  local realW = rocket_design_width * scale
  local realH = rocket_design_height * scale
  local realScale = 750 / realH
  self.image.transform:Set_sizeDelta(realW, realH)
  if scaleX < scaleY then
    self.image.transform:Set_localScale(realScale, realScale, realScale)
  else
    self.image.transform:Set_localScale(1, 1, 1)
  end
  self:RefreshResearching()
  self:ShowCells()
  self:QueueTimeEndSignal(NewQueueType.Science)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIScienceTabCell)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = "row_" .. index
  local item = self.scroll_view:AddComponent(UIScienceTabCell, itemObj)
  local param = {}
  param.template = self.allTab[index]
  if self.researchTabList[param.template.id] ~= nil then
    param.isResearching = true
    param.isResearchingScienceId = self.researchTabList[param.template.id]
  else
    param.isResearching = false
    param.isResearchingScienceId = 0
  end
  item:ReInit(param)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIScienceTabCell)
end

local function ShowCells(self)
  local allTabs = DataCenter.ScienceTemplateManager:GetCurShowTab(ScienceType.Build)
  self.allTab = {}
  for i, v in ipairs(allTabs) do
    local tabState = DataCenter.ScienceTemplateManager:GetTabState(v.id, self.bUuid)
    if tabState == ScienceTabState.UnLock or tabState == ScienceTabState.LockShow then
      table.insert(self.allTab, v)
    end
  end
  table.sort(self.allTab, function(a, b)
    return a.order < b.order
  end)
  local count = table.count(self.allTab)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    local showIndex = self:GetShowIndex()
    self.scroll_view:RefillCells()
    if 1 < showIndex then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
      TimerManager:GetInstance():DelayInvoke(function()
        self.scroll_view:ScrollToCell(showIndex, 10000)
      end, 0.1)
    end
  end
end

local function UpdateScienceSignal(self)
  self:RefreshResearching()
  self:ShowCells()
end

local function GetShowIndex(self)
  local showIndex = 1
  if self.allTab ~= nil and self.gotoTab ~= nil then
    for k, v in ipairs(self.allTab) do
      if v.id == self.gotoTab then
        local min = math.floor(ScreenCell / 2)
        local max = table.count(self.allTab) - ScreenCell + 1
        showIndex = k
        if min >= showIndex then
          showIndex = 1
        elseif max < showIndex then
          showIndex = max
        else
          showIndex = showIndex - min
        end
      end
    end
  end
  self.gotoTab = nil
  return showIndex
end

local function UpdateBuildDataSignal(self)
  self:RefreshResearching()
  self:ShowCells()
end

local function RefreshResearching(self)
  self.queueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
  self.researchScienceList = {}
  self.researchTabList = {}
  table.walk(self.queueList, function(k, v)
    if v ~= nil and v:GetQueueState() ~= NewQueueState.Free then
      local scienceId = tonumber(v.itemId)
      local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
      if template ~= nil then
        if v.funcUuid == self.bUuid then
          self.researchTabList[template.tab] = scienceId
        elseif not self.researchTabList[template.tab] then
          self.researchTabList[template.tab] = 0
        end
        self.researchScienceList[v.uuid] = false
      end
    end
  end)
  self:RefreshRecommend()
end

local function RefreshRecommend(self)
  if table.count(self.researchTabList) > 0 then
    self.recommendGoN:SetActive(false)
  else
    local recommendID = self.view.ctrl:GetRecommendScience()
    self.recommendId = recommendID
    if not recommendID then
      self.recommendGoN:SetActive(false)
    else
      self.recommendGoN:SetActive(true)
      local template = DataCenter.ScienceManager:GetScienceTemplate(recommendID)
      if template then
        self.recommendIconN:LoadSprite(string.format(LoadPath.ScienceIcons, template.icon))
        local curLv = DataCenter.ScienceManager:GetScienceLevel(recommendID)
        local maxLv = DataCenter.ScienceManager:GetScienceMaxLevel(recommendID)
        self.recommendLvN:SetText(curLv .. "/" .. maxLv)
        self.recommendNameN:SetLocalText(template.name)
      else
        self.recommendGoN:SetActive(false)
      end
    end
  end
end

local function QueueTimeEndSignal(self, data)
  local queueType = data
  if queueType == NewQueueType.Science and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScienceInfo) and table.count(self.researchScienceList) > 0 then
    table.walk(self.researchScienceList, function(k, v)
      if v == false then
        local queue = DataCenter.QueueDataManager:GetQueueByUuid(k)
        if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
          self.researchScienceList[k] = true
          DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(tonumber(queue.funcUuid))
        end
      end
    end)
  end
end

local function OnScienceSearchingSignal(self)
  self:RefreshResearching()
  self:ShowCells()
end

local function OnScienceQueueFinishSignal(self)
  self:RefreshResearching()
  self:ShowCells()
end

local function OnClickRecommendBtn(self)
  local baseId = CommonUtil.GetScienceBaseType(self.recommendId)
  GoToUtil.GotoScience(baseId)
end

ScienceTabOldPanel.OnCreate = OnCreate
ScienceTabOldPanel.OnDestroy = OnDestroy
ScienceTabOldPanel.OnEnable = OnEnable
ScienceTabOldPanel.OnDisable = OnDisable
ScienceTabOldPanel.ComponentDefine = ComponentDefine
ScienceTabOldPanel.ComponentDestroy = ComponentDestroy
ScienceTabOldPanel.DataDefine = DataDefine
ScienceTabOldPanel.DataDestroy = DataDestroy
ScienceTabOldPanel.OnAddListener = OnAddListener
ScienceTabOldPanel.OnRemoveListener = OnRemoveListener
ScienceTabOldPanel.InitUI = InitUI
ScienceTabOldPanel.RefreshAll = RefreshAll
ScienceTabOldPanel.OnDeleteCell = OnDeleteCell
ScienceTabOldPanel.ShowCells = ShowCells
ScienceTabOldPanel.OnCreateCell = OnCreateCell
ScienceTabOldPanel.ClearScroll = ClearScroll
ScienceTabOldPanel.UpdateScienceSignal = UpdateScienceSignal
ScienceTabOldPanel.GetShowIndex = GetShowIndex
ScienceTabOldPanel.UpdateBuildDataSignal = UpdateBuildDataSignal
ScienceTabOldPanel.RefreshResearching = RefreshResearching
ScienceTabOldPanel.QueueTimeEndSignal = QueueTimeEndSignal
ScienceTabOldPanel.OnScienceSearchingSignal = OnScienceSearchingSignal
ScienceTabOldPanel.OnScienceQueueFinishSignal = OnScienceQueueFinishSignal
ScienceTabOldPanel.RefreshRecommend = RefreshRecommend
ScienceTabOldPanel.OnClickRecommendBtn = OnClickRecommendBtn
return ScienceTabOldPanel
