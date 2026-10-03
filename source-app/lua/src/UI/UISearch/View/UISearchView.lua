local WorldSearchItem = require("UI.UISearch.Component.WorldSearchItem")
local WorldBookmarkRoot = require("UI.UISearch.Component.WorldBookmarkRoot")
local UISearchView = BaseClass("UISearchView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local close_btn_path = "BtnClose"

function UISearchView:OnCreate()
  base.OnCreate(self)
  self.isFirst = true
  self.ctrl:InitData()
  self.searchNode = self:AddComponent(UIBaseContainer, "safeArea/SearchRoot/SearchNode")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bookmarkRoot = self:AddComponent(WorldBookmarkRoot, "safeArea/Layout")
  local searchType, level, cellIndex, guideCmd = self:GetUserData()
  if searchType == UISearchType.None then
    self.bookmarkRoot:DelayOpenWarZoneMark()
    return
  end
  self.guideCmd = guideCmd
  local pageIndex = 1
  if searchType == nil then
    local page, subtype = DataCenter.SearchPanelDataManager:GetSelectPage()
    pageIndex = page or 1
    cellIndex = subtype or 1
  else
    if searchType == UISearchType.Boss then
      pageIndex = 3
    elseif searchType == UISearchType.Resource then
      pageIndex = 2
    elseif searchType == UISearchType.Monster then
      pageIndex = 1
    end
    cellIndex = cellIndex or DataCenter.SearchPanelDataManager:GetSelectCellIndex(pageIndex) or 1
    local subType = WorldSearchItem:GetSubtypeByIndex(pageIndex, cellIndex)
    if level ~= nil and 0 < level then
      self.ctrl:SetCurNumBySearchType(searchType, level, subType)
    end
  end
  self:ShowSearchItem(pageIndex, cellIndex)
end

function UISearchView:OnDestroy()
  self:HideBg()
  self.search_obj = nil
  self.goto_btn = nil
  self.gotoWorld = nil
  self.bookmark = nil
  self.goto_obj = nil
  if self.delayAnimTime ~= nil then
    self.delayAnimTime:Stop()
    self.delayAnimTime = nil
  end
  if self.guideClickTimer ~= nil then
    self.guideClickTimer:Stop()
    self.guideClickTimer = nil
  end
  base.OnDestroy(self)
end

function UISearchView:OnEnable()
  base.OnEnable(self)
end

function UISearchView:OnDisable()
  base.OnDisable(self)
end

function UISearchView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
end

function UISearchView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
end

function UISearchView:OnSearchCallBack(param)
  if param ~= nil then
    self.ctrl:OnSearchEnd(param.pointId, param.uuid)
  end
end

function UISearchView:OnSearchClick(index)
  self:ShowSearchItem(index)
end

function UISearchView:HasOpenItem()
  if self.search_obj ~= nil and self.search_obj:GetActive() then
    return true
  end
  if self.bookmarkRoot.bookmark ~= nil and self.bookmarkRoot.bookmark:GetActive() then
    return true
  end
  return false
end

function UISearchView:ShowSearchItem(index, subIndex)
  if self.search_obj == nil then
    local subIndexComp = "UI.UISearch.Component.WorldSearchItem"
    local prefabPath = "Assets/Main/Prefabs/UI/UISearch/Search.prefab"
    if SeasonUtil.IsInSeasonNineNationBasicMode(true) then
      subIndexComp = "UI.UISearch.Component.WorldSearchItemS5"
      prefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/UISearch/SearchS5.prefab"
    elseif SeasonUtil.IsInSeasonNineNationRainforestMode(true) then
      subIndexComp = "UI.UISearch.Component.WorldSearchItemS6"
      prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/UISearch/SearchS6.prefab"
    end
    self.search_obj = self.searchNode:LoadComponentAsync(subIndexComp, prefabPath)
  end
  self.search_obj:SetSizeDeltaXY(850, 850)
  self.search_obj:SetActive(true)
  self.search_obj:SetData(index, subIndex)
  if self.guideCmd and self.guideCmd == "SearchBtn" and self.search_obj and not self.guideClickTimer then
    self.guideClickTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.search_obj:OnSearchClick()
    end, 1)
    self.arrowData = nil
  end
end

function UISearchView:HideBg()
  if self.search_obj ~= nil then
    self.search_obj:SetActive(false)
  end
  if self.bookmarkRoot ~= nil and self.bookmarkRoot.bookmark ~= nil then
    self.bookmarkRoot.bookmark:SetActive(false)
  end
end

function UISearchView:CloseBookMark()
  if self.bookmarkRoot ~= nil then
    self.bookmarkRoot:CloseBookMark()
  end
  if self.search_obj ~= nil then
    self.search_obj:SetActive(true)
  end
end

function UISearchView:CloseBookMarkRoot()
end

return UISearchView
