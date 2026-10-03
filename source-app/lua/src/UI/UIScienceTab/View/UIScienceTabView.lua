local UIScienceTabView = BaseClass("UIScienceTabView", UIBaseView)
local base = UIBaseView
local UIScienceTabCell = require("UI.UIScienceTab.Component.UIScienceTabCell")
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local title_text_path = "BgGo/TitleText"
local close_btn_path = "BgGo/CloseBtn"
local image_path = "Image"
local recommendGo_path = "BgGo/MiddleBg/Recommend"
local recommendIcon_path = "BgGo/MiddleBg/Recommend/Science/Icon"
local recommendLv_path = "BgGo/MiddleBg/Recommend/Science/LvTxt"
local recommendName_path = "BgGo/MiddleBg/Recommend/Name"
local recommendBtn_path = "BgGo/MiddleBg/Recommend/Btn"
local recommendBtnTxt_path = "BgGo/MiddleBg/Recommend/Btn/Txt"
local gridSv_path = "BgGo/MiddleBg/gridSv"
local gridContent_path = "BgGo/MiddleBg/gridSv/Content"
local sectionTxt_path = "BgGo/MiddleBg/GameObject/Image (2)/sectionTxt"
local rocketBgContainers_path = "RocketContainer/Rockets"
local ScreenCell = 5
local rocket_design_width = 1750
local rocket_design_height = 750

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
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.image = self:AddComponent(UIImage, image_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
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
  self.sectionTxtN = self:AddComponent(UIText, sectionTxt_path)
  self.sectionTxtN:SetLocalText(170457)
  self.researchScienceList = {}
  self.researchTabList = {}
  self.isSendFinishList = {}
  self.gridSvN = self:AddComponent(UIBaseContainer, gridSv_path)
  self.gridContentN = self:AddComponent(GridInfinityScrollView, gridContent_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.gridContentN:Init(bindFunc1, bindFunc2, bindFunc3)
end

local function ComponentDestroy(self)
  self.close_btn = nil
  self.title_text = nil
  self.image = nil
  self.researchScienceList = nil
  self.researchTabList = nil
  self:ClearItemCell()
end

local function DataDefine(self)
  self.gotoTab = nil
  self.queue = nil
  self.isResearchingTab = nil
  self.bUuid = nil
  self.gridItemsTb = {}
end

local function DataDestroy(self)
  self.gotoTab = nil
  self.queue = nil
  self.isResearchingTab = nil
  self.bUuid = nil
  self.gridItemsTb = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
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

local function Update(self)
end

local function ReInit(self)
  local tab, bUuid = self:GetUserData()
  self.bUuid = bUuid
  if tab ~= nil and tab ~= "" then
    self.gotoTab = tonumber(tab)
  else
    self.gotoTab = ScienceTab.Resource
  end
  self.title_text:SetLocalText(GameDialogDefine.SCIENCE)
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
  self:ShowGridCells()
  self:QueueTimeEndSignal(NewQueueType.Science)
end

local function UpdateScienceSignal(self)
  self:RefreshResearching()
  self:ShowGridCells()
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
  self:ShowGridCells()
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
    local recommendID = self.ctrl:GetRecommendScience()
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

local function ShowGridCells(self)
  local allTabs = DataCenter.ScienceTemplateManager:GetCurShowTab(ScienceType.Build)
  self.allTab = {}
  for i, v in ipairs(allTabs) do
    local tabState = DataCenter.ScienceTemplateManager:GetTabState(v.id)
    if tabState == ScienceTabState.UnLock or tabState == ScienceTabState.LockShow then
      table.insert(self.allTab, v)
    end
  end
  table.sort(self.allTab, function(a, b)
    return a.order < b.order
  end)
  local count = table.count(self.allTab)
  if 0 < count then
    self.gridContentN:SetItemCount(count)
    self.gridContentN:MoveItemByIndex(0, 0)
  end
end

local function OnInitScroll(self, go, index)
  local item = self.gridSvN:AddComponent(UIScienceTabCell, go)
  self.gridItemsTb[go] = item
end

local function OnUpdateScroll(self, go, index)
  local tabInfo = self.allTab[index + 1]
  go.name = tabInfo.id
  local item = self.gridItemsTb[go]
  local param = {}
  param.template = tabInfo
  if self.researchTabList[param.template.id] ~= nil then
    param.isResearching = true
    param.isResearchingScienceId = self.researchTabList[param.template.id]
  else
    param.isResearching = false
    param.isResearchingScienceId = 0
  end
  item:ReInit(param)
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearItemCell(self)
  self.gridSvN:RemoveComponents(UIScienceTabCell)
  self.gridContentN:DestroyChildNode()
end

local function OnScienceSearchingSignal(self)
  self:RefreshResearching()
  self:ShowGridCells()
end

local function OnScienceQueueFinishSignal(self)
  self:RefreshResearching()
  self:ShowGridCells()
end

local function OnClickRecommendBtn(self)
  local baseId = CommonUtil.GetScienceBaseType(self.recommendId)
  GoToUtil.GotoScience(baseId)
end

UIScienceTabView.OnCreate = OnCreate
UIScienceTabView.OnDestroy = OnDestroy
UIScienceTabView.OnEnable = OnEnable
UIScienceTabView.OnDisable = OnDisable
UIScienceTabView.Update = Update
UIScienceTabView.ComponentDefine = ComponentDefine
UIScienceTabView.ComponentDestroy = ComponentDestroy
UIScienceTabView.DataDefine = DataDefine
UIScienceTabView.DataDestroy = DataDestroy
UIScienceTabView.OnAddListener = OnAddListener
UIScienceTabView.OnRemoveListener = OnRemoveListener
UIScienceTabView.ReInit = ReInit
UIScienceTabView.OnDeleteCell = OnDeleteCell
UIScienceTabView.ShowCells = ShowCells
UIScienceTabView.OnCreateCell = OnCreateCell
UIScienceTabView.ClearScroll = ClearScroll
UIScienceTabView.UpdateScienceSignal = UpdateScienceSignal
UIScienceTabView.GetShowIndex = GetShowIndex
UIScienceTabView.UpdateBuildDataSignal = UpdateBuildDataSignal
UIScienceTabView.RefreshResearching = RefreshResearching
UIScienceTabView.QueueTimeEndSignal = QueueTimeEndSignal
UIScienceTabView.OnScienceSearchingSignal = OnScienceSearchingSignal
UIScienceTabView.OnScienceQueueFinishSignal = OnScienceQueueFinishSignal
UIScienceTabView.RefreshRecommend = RefreshRecommend
UIScienceTabView.OnClickRecommendBtn = OnClickRecommendBtn
UIScienceTabView.OnInitScroll = OnInitScroll
UIScienceTabView.OnUpdateScroll = OnUpdateScroll
UIScienceTabView.OnDestroyScrollItem = OnDestroyScrollItem
UIScienceTabView.ClearItemCell = ClearItemCell
UIScienceTabView.ShowGridCells = ShowGridCells
return UIScienceTabView
