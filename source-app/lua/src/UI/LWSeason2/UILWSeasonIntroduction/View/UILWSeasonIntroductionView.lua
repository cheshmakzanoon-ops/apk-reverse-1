local UILWSeasonIntroductionView = BaseClass("UILWSeasonIntroductionView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local IntroductionItem = require("UI.LWSeason2.UILWSeasonIntroduction.Component.UILWSeasonIntroductionItem")
local IntroductionItemSmall = require("UI.LWSeason2.UILWSeasonIntroduction.Component.UILWSeasonIntroductionItemSmall")
local TabItem = require("UI.LWSeason2.UILWSeasonIntroduction.Component.UILWSeasonIntroductionTab")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local tab_group_path = "PopUpTitle/TabView"
local tab_item_path = "PopUpTitle/TabView/Viewport/TabContent/TabItem"
local tab_content_path = "PopUpTitle/TabView/Viewport/TabContent"
local scroll_view_path = "PopUpTitle/ScrollView"
local info_content_path = "PopUpTitle/ScrollView/Viewport/InfoContent"
local detail_big_path = "PopUpTitle/ScrollView/Viewport/InfoContent/detail_big"
local detail_small_path = "PopUpTitle/ScrollView/Viewport/InfoContent/detail_small"
local bg_path = "PopUpTitle/Common_bg_orange"
local btn_news_path = "PopUpTitle/Common_bg_orange/BtnNews"

function UILWSeasonIntroductionView:OnCreate()
  base.OnCreate(self)
  self.weekIndex = nil
  self.items = {}
  self.dataList = {}
  self.param = self:GetUserData()
  self.dataWeek = self.param.dataWeek
  self.dataTabGroup = self.param.dataTabGroup
  self:ComponentDefine()
  if self.dataWeek then
    self:UpdateData()
  elseif self.dataTabGroup then
    self:UpdateTabGroup()
  end
end

function UILWSeasonIntroductionView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonIntroductionView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.theTabItem = self.transform:Find(tab_item_path).gameObject
  self.theTabItem:GameObjectCreatePool()
  self.tabContent = self:AddComponent(UIBaseContainer, tab_content_path)
  self.tabGroup = self:AddComponent(UIBaseContainer, tab_group_path)
  self.theItemBig = self.transform:Find(detail_big_path).gameObject
  self.theItemBig:GameObjectCreatePool()
  self.theItemSmall = self.transform:Find(detail_small_path).gameObject
  self.theItemSmall:GameObjectCreatePool()
  self.dataContent = self:AddComponent(UIBaseContainer, info_content_path)
  self.ScrollView = self:AddComponent(UIScrollRect, scroll_view_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.btn_news = self:AddComponent(UIButton, btn_news_path)
  local userSeasonInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local guideId = userSeasonInfo and userSeasonInfo:GetSeasonGuideId()
  if 0 < guideId then
    self.btn_news:SetOnClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWNewsCenter, {anim = false}, {
        tabType = ChatNewsCenterTabType.StrategyGuide
      })
    end)
    self.btn_news:SetActive(true)
    self.bg:SetSizeDeltaXY(805, 1190)
  else
    self.btn_news:SetActive(false)
    self.bg:SetSizeDeltaXY(805, 1070)
  end
end

function UILWSeasonIntroductionView:ComponentDestroy()
  self.tabContent:RemoveComponents(TabItem)
  self.theTabItem:GameObjectRecycleAll()
  self.dataContent:RemoveComponents(IntroductionItem)
  self.dataContent:RemoveComponents(IntroductionItemSmall)
  self.theItemBig:GameObjectRecycleAll()
  self.theItemSmall:GameObjectRecycleAll()
  self.btn_back = nil
  self.theTabItem = nil
  self.tabContent = nil
  self.dataContent = nil
  self.ScrollView = nil
end

function UILWSeasonIntroductionView:SwitchToWeek(dataArr, weekIndex)
  if self.updating then
    return
  end
  local dataList = dataArr[weekIndex]
  local dataCount = 0
  self.dataContent:RemoveComponents(IntroductionItem)
  self.dataContent:RemoveComponents(IntroductionItemSmall)
  self.theItemBig:GameObjectRecycleAll()
  self.theItemSmall:GameObjectRecycleAll()
  if dataList then
    table.sort(dataList, function(a, b)
      if a.group == b.group then
        if a.order == b.order then
          return a.id < b.id
        end
        return a.order < b.order
      end
      return a.group < b.group
    end)
    local dataListNew = {}
    for _, v in ipairs(dataList) do
      if string.IsNullOrEmpty(v.icon) then
        if v.series then
          for _, v2 in pairs(v.series) do
            table.insert(dataListNew, {
              id = v.id,
              group = v.group,
              order = v.order,
              big = true,
              cancel_turn = v.cancel_turn,
              icon = v2.banner,
              name = v.title_key,
              desc = v2.long_key,
              video_resource = v.video_resource
            })
          end
        end
      else
        table.insert(dataListNew, {
          id = v.id,
          group = v.group,
          order = v.order,
          big = false,
          cancel_turn = v.cancel_turn,
          icon = v.icon,
          name = v.icon_name,
          desc = v.icon_des,
          video_resource = v.video_resource
        })
      end
    end
    dataList = dataListNew
    dataCount = #dataList
  end
  self.weekIndex = weekIndex
  self.dataList = dataList
  self.createIndex = 0
  self.dataCount = dataCount
  self.ScrollView:StopMovement()
  self.ScrollView:SetVerticalNormalizedPosition(1)
end

function UILWSeasonIntroductionView:UpdateData()
  local goItem, theItem
  self.tabContent:RemoveComponents(TabItem)
  self.theTabItem:GameObjectRecycleAll()
  local tabDataList = {}
  for k, v in pairs(self.dataWeek) do
    table.insert(tabDataList, toInt(k))
  end
  if #self.dataWeek == 0 and self.dataWeek[0] then
    self.tabGroup:SetActive(false)
    self.ScrollView:SetSizeDeltaY(900)
    self:SwitchToWeek(self.dataWeek, 0)
    return
  end
  self.tabGroup:SetActive(true)
  self.ScrollView:SetSizeDeltaY(830)
  table.sort(tabDataList, function(a, b)
    return a < b
  end)
  self.updating = true
  local firstTab
  local firstWeekIndex = 1
  local season, seasonWeek = DataCenter.SeasonDataManager:GetSeasonWeekInfo()
  for i, weekIndex in ipairs(tabDataList) do
    if weekIndex == 1 or weekIndex <= seasonWeek then
      goItem = self.theTabItem:GameObjectSpawn(self.tabContent.transform)
      goItem.name = "item_" .. i
      goItem:SetActive(true)
      theItem = self.tabContent:AddComponent(TabItem, goItem.name)
      theItem:ReInit(weekIndex)
      theItem:SetOnValueChanged(function(tf)
        if tf then
          DataCenter.LWSoundManager:PlaySound(6100022, false)
          self:SwitchToWeek(self.dataWeek, weekIndex)
        end
      end)
      if firstTab == nil then
        firstTab = theItem
        firstWeekIndex = weekIndex
      end
    end
  end
  self.updating = false
  if firstTab then
    firstTab:SetIsOn(true)
    self.weekIndexNeedCreate = firstWeekIndex
  end
end

function UILWSeasonIntroductionView:UpdateTabGroup()
  local goItem, theItem
  self.tabContent:RemoveComponents(TabItem)
  self.theTabItem:GameObjectRecycleAll()
  self.tabGroup:SetActive(true)
  self.ScrollView:SetSizeDeltaY(830)
  self.updating = true
  local firstTab
  local firstWeekIndex = 1
  local index = 1
  for key, data in ipairs(self.dataTabGroup) do
    goItem = self.theTabItem:GameObjectSpawn(self.tabContent.transform)
    goItem.name = "item_" .. key
    goItem:SetActive(true)
    theItem = self.tabContent:AddComponent(TabItem, goItem.name)
    local tabLoc = ""
    local firstCell = table.getFirst(data)
    if firstCell ~= nil then
      tabLoc = CS.GameEntry.Localization:GetString(firstCell.tab_group)
    end
    theItem:ReInit(index, tabLoc)
    theItem:SetOnValueChanged(function(tf)
      if tf then
        DataCenter.LWSoundManager:PlaySound(6100022, false)
        self:SwitchToWeek(self.dataTabGroup, key)
      end
    end)
    if firstTab == nil then
      firstTab = theItem
      firstWeekIndex = index
    end
    index = index + 1
  end
  self.updating = false
  if firstTab then
    firstTab:SetIsOn(true)
  end
end

function UILWSeasonIntroductionView:Update100MS()
  if self.weekIndex == nil and self.weekIndexNeedCreate ~= nil then
    self:SwitchToWeek(self.dataWeek, self.weekIndexNeedCreate)
    self.weekIndexNeedCreate = nil
  elseif self.dataList and self.createIndex ~= nil and self.dataCount ~= nil and self.createIndex < self.dataCount then
    local dataCount = self.dataCount
    local dataList = self.dataList
    local maxCount = 5
    local goItem, theItem
    for i = self.createIndex + 1, dataCount do
      local data = dataList[i]
      if data.big then
        goItem = self.theItemBig:GameObjectSpawn(self.dataContent.transform)
        goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.dataContent:AddComponent(IntroductionItem, goItem.name)
      else
        goItem = self.theItemSmall:GameObjectSpawn(self.dataContent.transform)
        goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.dataContent:AddComponent(IntroductionItemSmall, goItem.name)
      end
      theItem:ReInit(data)
      self.createIndex = i
      maxCount = maxCount - 1
      if maxCount <= 0 then
        break
      end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.dataContent.transform)
  end
end

return UILWSeasonIntroductionView
