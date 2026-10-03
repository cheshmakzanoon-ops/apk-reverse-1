local UILWFactionWarGroupPage = BaseClass("UILWFactionWarGroupPage", UIBaseContainer)
local base = UIBaseContainer
local UILWFactionWarGroupLine = require("UI.LWSeason4.UILWFactionWarGroup.Component.UILWFactionWarGroupLine")
local week_text_path = "weekText"
local group_list_path = "ViewPort/GroupList"
local group_info_path = "ViewPort/GroupList/GroupInfo"

function UILWFactionWarGroupPage:OnCreate()
  base.OnCreate(self)
  self.groupIndex = 0
  self.scroll_view_trigger = self:AddComponent(UIScrollRectEventTrigger, "")
  self.week_text = self:AddComponent(UITextMeshProUGUIEx, week_text_path)
  self.content = self:AddComponent(UIBaseContainer, group_list_path)
  self.theItem = self.transform:Find(group_info_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.scroll_view_trigger:OnBeginDrag(function()
    if self.scroll_view_parent then
      pcall(self.scroll_view_parent.DoBeginDrag, self.scroll_view_parent)
    end
  end)
  self.scroll_view_trigger:OnEndDrag(function()
    if self.scroll_view_parent then
      pcall(self.scroll_view_parent.DoEndDrag, self.scroll_view_parent)
    end
  end)
  self.scroll_view_trigger:OnPointerClick(function()
    if self.scroll_view_parent then
      pcall(self.scroll_view_parent.DoPointerClick, self.scroll_view_parent)
    end
  end)
end

function UILWFactionWarGroupPage:OnDestroy()
  self.content:RemoveComponents(UILWFactionWarGroupLine)
  self.theItem:GameObjectRecycleAll()
  self.scroll_view_trigger:OnBeginDrag(nil)
  self.scroll_view_trigger:OnEndDrag(nil)
  self.scroll_view_trigger:OnPointerClick(nil)
  self.week_text = nil
  self.content = nil
  base.OnDestroy(self)
end

function UILWFactionWarGroupPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionGroupInfoUpdate, self.OnFactionGroupInfoUpdate)
end

function UILWFactionWarGroupPage:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionGroupInfoUpdate, self.OnFactionGroupInfoUpdate)
  base.OnRemoveListener(self)
end

function UILWFactionWarGroupPage:OnFactionGroupInfoUpdate()
  if self.weekIndex == nil or self.battleWeek == nil or self.groupIndex ~= 0 then
    return
  end
  if self.same_week then
    local dataList
    local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    if myCampId == SeasonFactionType.Rebels then
      dataList = DataCenter.SeasonFactionWarDataManager.dataList1
    elseif myCampId == SeasonFactionType.Gendarmerie then
      dataList = DataCenter.SeasonFactionWarDataManager.dataList2
    end
    if dataList then
      local groupMinRank = 1
      local myAllianceId = LuaEntry.Player:GetAllianceUid()
      local level_group = DataCenter.SeasonFactionWarDataManager.level_group or {}
      for groupIndex, groupMaxRank in ipairs(level_group) do
        for _, rankData in ipairs(dataList) do
          if groupMinRank <= rankData.rank and groupMaxRank >= rankData.rank and rankData.allianceId == myAllianceId then
            self.groupIndex = groupIndex
            self:RefreshList(self.weekIndex, self.bestCount, self.itemMaxCount, self.maxCount, self.battleWeek, groupIndex)
            return
          end
        end
        groupMinRank = groupMaxRank + 1
      end
    end
    self:RefreshList(self.weekIndex, self.bestCount, self.itemMaxCount, self.maxCount, self.battleWeek, 0)
  end
end

function UILWFactionWarGroupPage:ReInit(weekIndex, bestCount, itemMaxCount, maxCount, scroll_view, battleWeek)
  self.weekIndex = weekIndex
  self.bestCount = bestCount
  self.itemMaxCount = itemMaxCount
  self.maxCount = maxCount
  self.battleWeek = battleWeek
  self.scroll_view_parent = scroll_view
  self.groupIndex = 0
  self.week_text:SetLocalText("season_s4_activity_1200005_tips3", weekIndex)
  if weekIndex == battleWeek then
    local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    if myCampId == 1 or myCampId == 2 then
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarDetail, myCampId)
    end
    self.same_week = true
    self:OnFactionGroupInfoUpdate()
  else
    self.same_week = false
    self:RefreshList(weekIndex, bestCount, itemMaxCount, maxCount, battleWeek, 0)
  end
end

function UILWFactionWarGroupPage:RefreshList(weekIndex, bestCount, itemMaxCount, maxCount, battleWeek, myGroupIndex)
  self.content:RemoveComponents(UILWFactionWarGroupLine)
  self.theItem:GameObjectRecycleAll()
  if 0 < itemMaxCount then
    local goItem, theItem
    local count = math.floor(bestCount / itemMaxCount)
    local groupMax = bestCount < maxCount and count + 1 or count
    local start = 1
    if groupMax <= 7 then
      for i = 1, count do
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "line_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWFactionWarGroupLine, goItem.name)
        theItem:ReInit(i, start, itemMaxCount * i, myGroupIndex, weekIndex == battleWeek)
        start = itemMaxCount * i + 1
      end
      if bestCount < maxCount then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "line_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWFactionWarGroupLine, goItem.name)
        theItem:ReInit(count + 1, start, maxCount, myGroupIndex, weekIndex == battleWeek)
      end
    else
      if myGroupIndex <= 3 then
        for i = 1, count do
          if i == 1 or i == 2 or i == myGroupIndex or i == count then
            goItem = self.theItem:GameObjectSpawn(self.content.transform)
            goItem.name = "line_" .. UIUtil.GetLoopListItemIndex()
            goItem:SetActive(true)
            theItem = self.content:AddComponent(UILWFactionWarGroupLine, goItem.name)
            theItem:ReInit(i, start, itemMaxCount * i, myGroupIndex, weekIndex == battleWeek)
          elseif i == 4 then
            goItem = self.theItem:GameObjectSpawn(self.content.transform)
            goItem.name = "line_" .. UIUtil.GetLoopListItemIndex()
            goItem:SetActive(true)
            theItem = self.content:AddComponent(UILWFactionWarGroupLine, goItem.name)
            theItem:SetEmpty()
          end
          start = itemMaxCount * i + 1
        end
      elseif groupMax <= myGroupIndex + 2 then
        for i = 1, count do
          if i == 1 or i == 2 or i == myGroupIndex or i == count then
            goItem = self.theItem:GameObjectSpawn(self.content.transform)
            goItem.name = "line_" .. UIUtil.GetLoopListItemIndex()
            goItem:SetActive(true)
            theItem = self.content:AddComponent(UILWFactionWarGroupLine, goItem.name)
            theItem:ReInit(i, start, itemMaxCount * i, myGroupIndex, weekIndex == battleWeek)
          elseif i == 3 then
            goItem = self.theItem:GameObjectSpawn(self.content.transform)
            goItem.name = "line_" .. UIUtil.GetLoopListItemIndex()
            goItem:SetActive(true)
            theItem = self.content:AddComponent(UILWFactionWarGroupLine, goItem.name)
            theItem:SetEmpty()
          end
          start = itemMaxCount * i + 1
        end
      else
        for i = 1, count do
          if i == 1 or i == 2 or i == myGroupIndex or i == count then
            goItem = self.theItem:GameObjectSpawn(self.content.transform)
            goItem.name = "line_" .. UIUtil.GetLoopListItemIndex()
            goItem:SetActive(true)
            theItem = self.content:AddComponent(UILWFactionWarGroupLine, goItem.name)
            theItem:ReInit(i, start, itemMaxCount * i, myGroupIndex, weekIndex == battleWeek)
          elseif i == 3 or i == myGroupIndex + 1 then
            goItem = self.theItem:GameObjectSpawn(self.content.transform)
            goItem.name = "line_" .. UIUtil.GetLoopListItemIndex()
            goItem:SetActive(true)
            theItem = self.content:AddComponent(UILWFactionWarGroupLine, goItem.name)
            theItem:SetEmpty()
          end
          start = itemMaxCount * i + 1
        end
      end
      if bestCount < maxCount then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "line_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWFactionWarGroupLine, goItem.name)
        theItem:ReInit(count + 1, start, maxCount, myGroupIndex, weekIndex == battleWeek)
      end
    end
  end
end

return UILWFactionWarGroupPage
