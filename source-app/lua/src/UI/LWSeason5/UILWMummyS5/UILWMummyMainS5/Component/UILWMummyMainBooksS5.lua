local UILWMummyMainBooksS5 = BaseClass("UILWMummyMainBooksS5", UIAsyncContainer)
local base = UIAsyncContainer
local lastActiveTab = 1
local Localization = CS.GameEntry.Localization
local IntroductionItem = require("UI.LWSeason2.UILWSeasonIntroduction.Component.UILWSeasonIntroductionItem")
local IntroductionItemSmall = require("UI.LWSeason2.UILWSeasonIntroduction.Component.UILWSeasonIntroductionItemSmall")
local UILWMummyAchieveS5 = require("UI.LWSeason5.UILWMummyS5.UILWMummyMainS5.Component.UILWMummyAchieveS5")
local toggle1_path = "Tab/toggle1"
local toggle2_path = "Tab/toggle2"
local scroll_view_path = "ScrollView"
local info_content_path = "ScrollView/Viewport/InfoContent"
local detail_big_path = "ScrollView/Viewport/InfoContent/detail_big"
local detail_small_path = "ScrollView/Viewport/InfoContent/detail_small"
local achieve_cell_path = "ScrollView/Viewport/InfoContent/achieveCell"

function UILWMummyMainBooksS5:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.items = {}
  self.dataList = {}
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
end

function UILWMummyMainBooksS5:ComponentDefine()
  self.tab_item1 = self:AddComponent(UIToggle, toggle1_path)
  self.tab_item2 = self:AddComponent(UIToggle, toggle2_path)
  self.ScrollView = self:AddComponent(UIScrollRect, scroll_view_path)
  self.dataContent = self:AddComponent(UIBaseContainer, info_content_path)
  self.theItemBig = self.transform:Find(detail_big_path).gameObject
  self.theItemBig:GameObjectCreatePool()
  self.theItemSmall = self.transform:Find(detail_small_path).gameObject
  self.theItemSmall:GameObjectCreatePool()
  self.theItemAchieve = self.transform:Find(achieve_cell_path).gameObject
  self.theItemAchieve:GameObjectCreatePool()
end

function UILWMummyMainBooksS5:OnDestroy()
  self:CleanCells()
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.scroll_view = nil
  self.info_content = nil
  self.detail_big = nil
  self.detail_small = nil
  base.OnDestroy(self)
end

function UILWMummyMainBooksS5:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNineNationAchievementInfo, self.UpdateMummyAchievementData)
end

function UILWMummyMainBooksS5:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNineNationAchievementInfo, self.UpdateMummyAchievementData)
  base.OnRemoveListener(self)
end

function UILWMummyMainBooksS5:CleanCells()
  self.dataContent:RemoveComponents(IntroductionItem)
  self.dataContent:RemoveComponents(IntroductionItemSmall)
  self.dataContent:RemoveComponents(UILWMummyAchieveS5)
  self.theItemBig:GameObjectRecycleAll()
  self.theItemSmall:GameObjectRecycleAll()
  self.theItemAchieve:GameObjectRecycleAll()
end

function UILWMummyMainBooksS5:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  if lastActiveTab == 1 then
    self.tab_item1:SetIsOn(true)
  elseif lastActiveTab == 2 then
    self.tab_item2:SetIsOn(true)
  end
  if self.activeTab == nil then
    self:OnTabChanged(lastActiveTab)
  end
end

function UILWMummyMainBooksS5:OnTabChanged(tabIndex)
  lastActiveTab = tabIndex
  self.activeTab = tabIndex
  if tabIndex == 1 then
    if self.detailDataList then
      self:ShowDetails(tabIndex, self.detailDataList)
      return
    end
    local dataCount = 0
    local config = DataCenter.SeasonDataManager:GetServerSeasonConfig()
    if config and config.ppt_1 then
      local data = DataCenter.LWWorldTipManager:GetDataBySeason(config.ppt_1)
      if data ~= nil then
        local dataList = {}
        for seasonWeek, dataWeek in pairs(data) do
          for _, item in ipairs(dataWeek) do
            table.insert(dataList, item)
          end
        end
        dataCount = #dataList
        if dataCount == 0 then
        else
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
                    icon = v2.banner,
                    name = v.title_key,
                    desc = v2.long_key
                  })
                end
              end
            else
              table.insert(dataListNew, {
                id = v.id,
                group = v.group,
                order = v.order,
                big = false,
                icon = v.icon,
                name = v.icon_name,
                desc = v.icon_des
              })
            end
          end
          self.detailDataList = dataListNew
          self:ShowDetails(tabIndex, dataListNew)
        end
      end
    end
  elseif self.achieveDataList == nil then
    SFSNetwork.SendMessage(MsgDefines.GetTempUserAchievementInfo)
    self:ShowDetails(tabIndex, {})
  else
    self:ShowDetails(tabIndex, self.achieveDataList)
  end
end

function UILWMummyMainBooksS5:ShowDetails(tabIndex, dataList)
  local goItem, theItem
  self.ScrollView:StopMovement()
  self.ScrollView:SetVerticalNormalizedPosition(1)
  self:CleanCells()
  if tabIndex == 1 then
    for _, data in ipairs(dataList) do
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
    end
  else
    if self.typeAchievement == nil then
      local seasonNum = SeasonUtil.GetSeason()
      local seasonCheck = string.format(";%s;", seasonNum)
      local typeAchievement = {}
      LocalController:instance():visitTable(TableName.Temperature_Achievement, function(id, lineData)
        if lineData and (lineData.type == 2 or lineData.type == "2") and lineData.season and string.match(lineData.season, seasonCheck) then
          local meta = {
            id = lineData:getValue("id"),
            icon = lineData:getValue("icon"),
            desc = lineData:getValue("desc")
          }
          table.insert(typeAchievement, meta)
        end
      end)
      table.sort(typeAchievement, function(a, b)
        return a.id < b.id
      end)
      self.typeAchievement = typeAchievement
    end
    for _, achievement in ipairs(self.typeAchievement) do
      goItem = self.theItemAchieve:GameObjectSpawn(self.dataContent.transform)
      goItem.name = "achievement_" .. UIUtil.GetLoopListItemIndex()
      goItem:SetActive(true)
      theItem = self.dataContent:AddComponent(UILWMummyAchieveS5, goItem.name)
      theItem:ReInit(achievement, dataList)
    end
  end
end

function UILWMummyMainBooksS5:UpdateMummyAchievementData(list)
  self.achieveDataList = list
  if self.activeTab == 2 then
    self:ShowDetails(2, self.achieveDataList)
  end
end

return UILWMummyMainBooksS5
