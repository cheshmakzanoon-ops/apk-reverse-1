local UIHeroListPanelView = BaseClass("UIHeroListPanelView", UIBaseView)
local base = UIBaseView
local UIHeroListCell = require("UI.UILWHero.UIHeroListPanel.Component.UIHeroListCell")
local UIHeroEquipRecommendEntranceComponent = require("UI/UILWHero/UIHeroEquipRecommendTip/Component/UIHeroEquipRecommendEntranceComponent")
local ColMax = 4
local path = "Assets/Main/Sprites/UI/UILWHeroSquad/"
local openIconName = {
  "zyf_biandui_tanke_da.png",
  "zyf_biandui_daodan_da.png",
  "zyf_biandui_feiji_da.png"
}
local closeIconName = {
  "zyf_biandui_tanke_xiao.png",
  "zyf_biandui_daodan_xiao.png",
  "zyf_biandui_feiji_xiao.png"
}

local function OnCreate(self)
  base.OnCreate(self)
  local isArrow, callBack, gotoCondition, gotoHeroId = self:GetUserData()
  self.ctrl:InitData(isArrow, callBack)
  self:DataDefine()
  self:ComponentDefine()
  self.gotoHeroId = gotoHeroId
  if gotoCondition then
    self:SelectCondition(gotoCondition, true)
  else
    self:SelectCondition(0, true)
  end
  DataCenter.HeroTryOutManager:TrySendGetHeroTryOutInfoMessage()
end

local function OnDestroy(self)
  DataCenter.HeroDataManager:ClearNewHeroTags()
  DataCenter.HeroDataManager:MarkHeroRedPoint()
  HeroRedPointManager:GetInstance():ForceRefreshRedPoint()
  EventManager:GetInstance():Broadcast(EventId.CheckPubBubble, true)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.nodeRoot = self:AddComponent(UIBaseContainer, "Root")
  self.titleText = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.heroList = self:AddComponent(GridInfinityScrollView, "Root/MiddleContentContainer/HeroList/Content")
  self.heroListScroll = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/HeroList")
  self.recruitBtn = self:AddComponent(UIButton, "Root/BottomBar/RecruitBtn")
  self.recruitBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true}, nil, nil, nil, BindCallback(self, self.RefreshPage))
  end)
  self.recruitBtnText = self:AddComponent(UIText, "Root/BottomBar/RecruitBtn/RecruitText")
  self.titleText:SetLocalText(151077)
  self.allConditionBtn = self:AddComponent(UIButton, "Root/MiddleContentContainer/ConditionBtns/AllConditionBtn")
  self.allConditionBtnImg = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/AllConditionBtn")
  self.allConditionBtnText = self:AddComponent(UIText, "Root/MiddleContentContainer/ConditionBtns/AllConditionBtn/AllConditionBtnText")
  self.selectedArrow1 = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/AllConditionBtn/SelectedArrow1")
  self.allConditionBtnText:SetLocalText(151110)
  self.condition1Btn = self:AddComponent(UIButton, "Root/MiddleContentContainer/ConditionBtns/Condition1Btn")
  self.condition1BtnImg = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/Condition1Btn")
  self.condition1BtnIcon = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/Condition1Btn/Condition1Icon")
  self.selectedArrow2 = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/Condition1Btn/SelectedArrow2")
  self.condition2Btn = self:AddComponent(UIButton, "Root/MiddleContentContainer/ConditionBtns/Condition2Btn")
  self.condition2BtnImg = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/Condition2Btn")
  self.condition2BtnIcon = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/Condition2Btn/Condition2Icon")
  self.selectedArrow3 = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/Condition2Btn/SelectedArrow3")
  self.condition3Btn = self:AddComponent(UIButton, "Root/MiddleContentContainer/ConditionBtns/Condition3Btn")
  self.condition3BtnImg = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/Condition3Btn")
  self.condition3BtnIcon = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/Condition3Btn/Condition3Icon")
  self.selectedArrow4 = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/Condition3Btn/SelectedArrow4")
  self.allConditionBtn:SetOnClick(function()
    self:SelectCondition(0)
  end)
  self.condition1Btn:SetOnClick(function()
    self:SelectCondition(1)
  end)
  self.condition2Btn:SetOnClick(function()
    self:SelectCondition(2)
  end)
  self.condition3Btn:SetOnClick(function()
    self:SelectCondition(3)
  end)
  self.conditionBtnIcons = {
    self.allConditionBtnImg,
    self.condition1BtnImg,
    self.condition2BtnImg,
    self.condition3BtnImg
  }
  self.conditionBtnChildren = {
    self.allConditionBtnText,
    self.condition1BtnIcon,
    self.condition2BtnIcon,
    self.condition3BtnIcon
  }
  self.selectedArrows = {
    self.selectedArrow1,
    self.selectedArrow2,
    self.selectedArrow3,
    self.selectedArrow4
  }
  self.recruitBtnText:SetLocalText(320123)
  self.compEquipRecommend = self:AddComponent(UIHeroEquipRecommendEntranceComponent, "Root/BottomBar/EquipRecommend")
  self:OnBuildInfoChange()
end

local function ClearScroll(self)
  if self.heroListScroll then
    self.heroListScroll:RemoveComponents(UIHeroListCell)
  end
  if self.heroList then
    self.heroList:DestroyChildNode()
  end
end

local function OnInitScroll(self, go, index)
end

local function OnUpdateScroll(self, go, index)
  local item = self.listGO[go]
  if not item then
    item = self.heroListScroll:AddComponent(UIHeroListCell, go)
    self.listGO[go] = item
  end
  local uuid = self.showDataList[index + 1]
  item:SetActive(uuid ~= nil)
  if uuid ~= nil then
    local hasHero = DataCenter.HeroDataManager:GetHeroByUuid(uuid) ~= nil
    if hasHero then
      item:EnableRedPoint()
      item:SetData(uuid, BindCallback(self, self.OnHeroCellClick))
      item:UpdateFormationState()
      item:UpdateEquipRecommend()
    else
      item:InitWithHeroPieceItem(uuid, BindCallback(self, self.OnHeroCellClick))
      item:SetFormationShowState(false)
      item:UpdateEquipRecommend(true)
    end
  end
  self.heroCells[uuid] = item
end

local function OnDestroyScrollItem(self, go, index)
  if self.showDataList[index + 1] == nil then
    return
  end
  self.heroCells[self.showDataList[index + 1]] = nil
end

local function ShowCells(self, playGoto)
  DataCenter.EquipRecommendManager:SetRecommendDataDirty()
  self.showDataList = self.view.ctrl:GenerateHeroDataList(self.curCondition)
  local dataCount = table.count(self.showDataList)
  if 0 < dataCount then
    self.heroListScroll:SetActive(true)
    if not self.hasInitHeroScroll then
      local bindFunc1 = BindCallback(self, self.OnInitScroll)
      local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
      local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
      self.heroList:Init(bindFunc1, bindFunc2, bindFunc3)
    end
    self.hasInitHeroScroll = true
    self.heroList:SetItemCount(dataCount)
    self.heroList:ForceUpdate()
    if playGoto and self.gotoHeroId then
      local index = 0
      for i, v in ipairs(self.showDataList) do
        if v == self.gotoHeroId then
          index = i
          break
        end
      end
      if 0 < index then
        if not self.heroList:IsItemVisible(index - 1) then
          self.heroList:MoveItemByIndex(index - 1, 0)
        end
        local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(self.gotoHeroId)
        local gotoId = self.gotoHeroId
        if heroData then
          gotoId = heroData.uuid
        end
        local cell = self.heroCells[gotoId]
        if cell and not IsNull(cell.rectTransform) then
          local param = {}
          param.position = cell:GetPosition()
          local halfWidth = cell.rectTransform.rect.width
          local halfHeight = cell.rectTransform.rect.height
          param.position.x = param.position.x + 0.56 * halfWidth
          param.position.y = param.position.y - 0.56 * halfHeight
          param.positionType = PositionType.Screen
          param.isPanel = false
          param.isAutoClose = 1
          param.UseScale = 0.8
          param.id = 0
          DataCenter.ArrowManager:ShowFingerArrow(param)
        end
      end
    end
  else
    self.heroListScroll:SetActive(false)
  end
  EventManager:GetInstance():Broadcast(EventId.HeroListDataChange, self.showDataList)
end

local function OnHeroCellClick(self, trans, id)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(id)
  if heroData ~= nil then
    DataCenter.HeroDataManager:RemoveNewHeroTag(heroData.uuid)
    local showHeroAwakenGuide = DataCenter.HeroAwakenDataManager:IsHeroAwakenOpenByHeroInfo(heroData) and not DataCenter.HeroAwakenDataManager:IsHasShownSingleHeroAwakenGuide(heroData.heroId)
    if showHeroAwakenGuide then
      local awakenTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(heroData.heroId)
      if awakenTemplate and awakenTemplate.guide_plot_id > 0 then
        self.cacheHeroUuidAfterAwakenPlot = heroData.uuid
        self.cachePlotGroupIdAwaken = awakenTemplate.guide_plot_id
        DataCenter.HeroAwakenDataManager:SetHasShownDetailByActivityInfo(heroData.heroId)
        EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
          plotGroupId = awakenTemplate.guide_plot_id,
          hideMainUI = false
        })
      else
        local arrowData = {
          arrowType = HeroDetailGuideArrowType.HeroAwaken,
          heroUid = heroData.uuid
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, id, self.showDataList, BindCallback(self, self.OnHeroDetailPanelClose), arrowData)
      end
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, id, self.showDataList, BindCallback(self, self.OnHeroDetailPanelClose))
    end
  else
    local need = HeroUtils.GetJigsawCost(id)
    local count = DataCenter.ItemData:GetItemCount(id)
    local item = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(toInt(item.para2))
    local bomb = false
    if heroConfig then
      bomb = DataCenter.LWSaveGirlManager:IsSavingHero(heroConfig.id)
    end
    if need <= count and not bomb then
      SFSNetwork.SendMessage(MsgDefines.HeroExchange, id, 1)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, id, self.showDataList, BindCallback(self, self.OnHeroDetailPanelClose))
    end
  end
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.recruitBtn = nil
  self.recruitBtnText = nil
  self.heroList = nil
  self.heroListScroll = nil
  self.nodeEmptyTip = nil
  self.allConditionBtn = nil
  self.allConditionBtnImg = nil
  self.allConditionBtnText = nil
  self.condition1Btn = nil
  self.condition1BtnImg = nil
  self.selectedArrow1 = nil
  self.condition1BtnIcon = nil
  self.condition2Btn = nil
  self.condition2BtnImg = nil
  self.selectedArrow2 = nil
  self.condition2BtnIcon = nil
  self.condition3Btn = nil
  self.condition3BtnImg = nil
  self.selectedArrow3 = nil
  self.condition3BtnIcon = nil
  self.conditionBtnIcons = nil
  self.conditionBtnChildren = nil
  self.selectedArrows = nil
  self.compEquipRecommend = nil
end

local function DataDefine(self)
  self.hasInitHeroScroll = false
  self.listGO = {}
  self.curCondition = -1
  self.heroCells = {}
  self.cacheHeroUuidAfterAwakenPlot = nil
  self.cachePlotGroupIdAwaken = nil
end

local function DataDestroy(self)
  self.showDataList = nil
  self.listGO = nil
  self.curCondition = -1
  self.heroCells = nil
  self.cacheHeroUuidAfterAwakenPlot = nil
  self.cachePlotGroupIdAwaken = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnOpen()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroExChange, self.RefreshPage)
  self:AddUIListener(EventId.BuildLevelUp, self.OnBuildInfoChange)
  self:AddUIListener(EventId.HeroEquipRecommendSwitchSuccess, self.RefreshPage)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroExChange, self.RefreshPage)
  self:RemoveUIListener(EventId.BuildLevelUp, self.OnBuildInfoChange)
  self:RemoveUIListener(EventId.HeroEquipRecommendSwitchSuccess, self.RefreshPage)
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
end

function UIHeroListPanelView:GF_window_closed(uiname)
  if uiname ~= UIWindowNames.UIHeroDetailPanel then
    return
  end
  self:ShowCells()
end

function UIHeroListPanelView:GF_window_opened(uiname)
  if uiname ~= UIWindowNames.LWNewGuideHeroView then
    return
  end
  DataCenter.ArrowManager:RemoveFingerArrow()
end

local function OnBuildInfoChange(self)
  local unlock, _ = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.HeroPanel_Require)
  self.recruitBtn.gameObject:SetActive(unlock)
end

local function OnOpen(self)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroDetailPanel) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroDetailPanel)
  end
end

local function RefreshPage(self)
  if self.ctrl == nil then
    return
  end
  self:ShowCells()
end

local function SelectCondition(self, condition, playGoto)
  if self.curCondition == condition then
    return
  end
  self.curCondition = condition
  for i = 1, #self.conditionBtnIcons do
    local btnPosY = 0
    local childPosY = 0
    local sizeX = 0
    local sizeY = 0
    if i == condition + 1 then
      self.conditionBtnIcons[i]:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_yiji_1.png")
      if i ~= 1 then
        self.conditionBtnChildren[i]:LoadSprite(path .. openIconName[i - 1])
      end
      btnPosY = -9.2
      childPosY = 3.5
      sizeX = 194
      sizeY = 82
      self.selectedArrows[i]:SetActive(true)
    else
      self.conditionBtnIcons[i]:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_yiji_2.png")
      if i ~= 1 then
        self.conditionBtnChildren[i]:LoadSprite(path .. closeIconName[i - 1])
      end
      btnPosY = -4
      childPosY = -2
      sizeX = 198
      sizeY = 64
      self.selectedArrows[i]:SetActive(false)
    end
    local anchoredPosX = self.conditionBtnIcons[i]:GetAnchoredPositionX()
    local childAnchoredPosX = self.conditionBtnChildren[i]:GetAnchoredPositionX()
    self.conditionBtnIcons[i]:SetAnchoredPositionXY(anchoredPosX, btnPosY)
    self.conditionBtnChildren[i]:SetAnchoredPositionXY(childAnchoredPosX, childPosY)
    self.conditionBtnIcons[i].rectTransform:Set_sizeDelta(sizeX, sizeY)
  end
  self:ShowCells(playGoto)
  self.compEquipRecommend:ReInit()
end

function UIHeroListPanelView:OnHeroDetailPanelClose()
  self:RefreshPage()
end

function UIHeroListPanelView:GetUIHeroListCellByUuid(uuid)
  if self.heroCells and self.heroCells[uuid] then
    return self.heroCells[uuid]
  end
  return nil
end

function UIHeroListPanelView:ShowFingerArrowAtHeroUuid(uuid)
  self.gotoHeroId = uuid
  self:ShowCells(true)
end

function UIHeroListPanelView:OnPlotGroupDone(plotGroupId)
  if self.cachePlotGroupIdAwaken and plotGroupId == self.cachePlotGroupIdAwaken and self.cacheHeroUuidAfterAwakenPlot ~= nil then
    local arrowData = {
      arrowType = HeroDetailGuideArrowType.HeroAwaken,
      heroUid = self.cacheHeroUuidAfterAwakenPlot
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, self.cacheHeroUuidAfterAwakenPlot, self.showDataList, BindCallback(self, self.OnHeroDetailPanelClose), arrowData)
    self.cacheHeroUuidAfterAwakenPlot = nil
    self.cachePlotGroupIdAwaken = nil
  end
end

UIHeroListPanelView.OnCreate = OnCreate
UIHeroListPanelView.OnDestroy = OnDestroy
UIHeroListPanelView.OnEnable = OnEnable
UIHeroListPanelView.OnDisable = OnDisable
UIHeroListPanelView.OnAddListener = OnAddListener
UIHeroListPanelView.OnRemoveListener = OnRemoveListener
UIHeroListPanelView.ComponentDefine = ComponentDefine
UIHeroListPanelView.ComponentDestroy = ComponentDestroy
UIHeroListPanelView.DataDefine = DataDefine
UIHeroListPanelView.DataDestroy = DataDestroy
UIHeroListPanelView.OnOpen = OnOpen
UIHeroListPanelView.OnHeroCellClick = OnHeroCellClick
UIHeroListPanelView.ShowCells = ShowCells
UIHeroListPanelView.RefreshPage = RefreshPage
UIHeroListPanelView.OnInitScroll = OnInitScroll
UIHeroListPanelView.OnUpdateScroll = OnUpdateScroll
UIHeroListPanelView.OnDestroyScrollItem = OnDestroyScrollItem
UIHeroListPanelView.ClearScroll = ClearScroll
UIHeroListPanelView.SelectCondition = SelectCondition
UIHeroListPanelView.OnBuildInfoChange = OnBuildInfoChange
return UIHeroListPanelView
