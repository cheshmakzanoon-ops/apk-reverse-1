local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWSeason6AttackCityContainer = BaseClass("LWSeason6AttackCityContainer", base)
local DetailPage = require("UI.LWSeason6.Activity.LWSeason6AttackCityMain")
local scroll_view_path = "RightView/ScrollView"
local content_path = "RightView/ScrollView/Viewport/Content"
local page_cell_path = "RightView/PageCell"
local left_arrow_path = "RightView/SwitchArrows/LeftArrow"
local right_arrow_path = "RightView/SwitchArrows/RightArrow"
local desc_path = "RightView/desc"

function LWSeason6AttackCityContainer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  DataCenter.WorldAllianceCityDataManager:FetchBitMapCityWarInfo()
end

function LWSeason6AttackCityContainer:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeason6AttackCityContainer:ComponentDefine()
  self.scroll_view = self:AddComponent(UIScrollPage, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.left_arrow = self:AddComponent(UIButton, left_arrow_path)
  self.right_arrow = self:AddComponent(UIButton, right_arrow_path)
  self.scroll_view:SetPageChangedCallback(BindCallback(self, self.OnUpdateScroll))
  self.left_arrow:SetOnClick(function()
    self.scroll_view:ToPrevPage()
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.right_arrow:SetOnClick(function()
    self.scroll_view:ToNextPage()
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.mainPage = self:AddComponent(DetailPage, page_cell_path)
  self.thePageItem = self.mainPage.gameObject
  self.thePageItem:GameObjectCreatePool()
  self.desc = self:TryAddComponent(UITextMeshProUGUIEx, desc_path)
end

function LWSeason6AttackCityContainer:ComponentDestroy()
  self.content:RemoveComponents(DetailPage)
  self.thePageItem:GameObjectRecycleAll()
  self.desc = nil
end

function LWSeason6AttackCityContainer:OnUpdateScroll(index)
  self:RefreshLRArrow(index)
end

function LWSeason6AttackCityContainer:RefreshLRArrow(index)
  self.left_arrow:SetActive(index ~= 1)
  self.right_arrow:SetActive(index ~= self.listCnt)
end

function LWSeason6AttackCityContainer:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self:InitPages()
end

function LWSeason6AttackCityContainer:InitPages()
  local listCnt = 0
  local hasDeclareData = false
  local state, declareInfo = DataCenter.AllianceDeclareWarManager:GetDeclareState()
  if state == DeclareWarState.PreDeclare then
    hasDeclareData = true
  else
    local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
    if DeclareWarDataList ~= nil then
      local allianceId = LuaEntry.Player:GetAllianceUid()
      for _, WarData in ipairs(DeclareWarDataList) do
        if WarData.aId == allianceId then
          hasDeclareData = true
        end
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  local height = self.rectTransform.rect.size.y
  local cityWarInfoSource, cityWarInfoCenter = DataCenter.WorldAllianceCityDataManager:FetchBitMapCityWarInfo()
  local nextOpen
  local cityInfoList1 = {}
  local cityInfoList2 = {}
  if cityWarInfoSource ~= nil and cityWarInfoSource.nextOpen ~= nil then
    nextOpen = cityWarInfoSource.nextOpen
  elseif cityWarInfoCenter ~= nil and cityWarInfoCenter.nextOpen ~= nil then
    nextOpen = cityWarInfoCenter.nextOpen
  end
  if cityWarInfoSource ~= nil then
    cityInfoList1 = cityWarInfoSource.cityInfoList
  end
  if cityWarInfoCenter ~= nil then
    cityInfoList2 = cityWarInfoCenter.cityInfoList
  end
  if self.desc then
    self.desc:SetActive(not hasDeclareData)
  end
  ProfilerUtil.BeginSample("LWSeason6AttackCityContainer.InitPages")
  if nextOpen ~= nil and nextOpen.openTime ~= nil then
    local openLevel = 3
    local openTime = nextOpen.openTime or 0
    if nextOpen.levelArray == nil then
      openLevel = nextOpen.level or 3
      if 3 < openLevel then
        openLevel = 3
        openTime = 0
      end
      if hasDeclareData then
        listCnt = 2
        self.mainPage:SetActive(false)
        self:AddPage(1, openLevel, openTime, true, height)
        self:AddPage(2, openLevel, openTime, false, height)
      else
        listCnt = 0
        self.mainPage:SetActive(true)
        self.mainPage:SetData(self.activityId, openLevel, openTime, false)
        self.mainPage.rectTransform:Set_offsetMin(0, 0)
        self.mainPage.rectTransform:Set_offsetMax(0, 0)
      end
    elseif #nextOpen.levelArray > 1 then
      listCnt = 0
      self.mainPage:SetActive(false)
      if hasDeclareData then
        self:AddPage(1, openLevel, openTime, true, height)
        listCnt = 1
      end
      for k, v in ipairs(nextOpen.levelArray) do
        listCnt = listCnt + 1
        openLevel = v or 3
        self:AddPage(listCnt, openLevel, openTime, false, height)
      end
    else
      openLevel = nextOpen.levelArray[1] or 3
      if 3 < openLevel then
        openLevel = 3
        openTime = 0
      end
      if hasDeclareData then
        listCnt = 2
        self.mainPage:SetActive(false)
        self:AddPage(1, openLevel, openTime, true, height)
        self:AddPage(2, openLevel, openTime, false, height)
      else
        listCnt = 0
        self.mainPage:SetActive(true)
        self.mainPage:SetData(self.activityId, openLevel, openTime, false)
        self.mainPage.rectTransform:Set_offsetMin(0, 0)
        self.mainPage.rectTransform:Set_offsetMax(0, 0)
      end
    end
  else
    listCnt = 0
    self.mainPage:SetActive(true)
    self.mainPage:SetData(self.activityId, 3, nil, hasDeclareData)
    self.mainPage.rectTransform:Set_offsetMin(0, 0)
    self.mainPage.rectTransform:Set_offsetMax(0, 0)
  end
  self.listCnt = listCnt
  if 1 < listCnt then
    self.scroll_view:SetActive(true)
    self.left_arrow:SetActive(true)
    self.right_arrow:SetActive(true)
    self.scroll_view:SetPageCount(listCnt)
    self.scroll_view:PageTo(1)
    self:RefreshLRArrow(1)
    self.content:SetSizeDeltaY(height)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  else
    self.scroll_view:SetActive(false)
    self.left_arrow:SetActive(false)
    self.right_arrow:SetActive(false)
  end
  ProfilerUtil.EndSample()
end

function LWSeason6AttackCityContainer:AddPage(index, openLevel, openTime, forDeclare, y)
  local theName = "page_" .. UIUtil.GetLoopListItemIndex()
  local goItem = self.thePageItem:GameObjectSpawn(self.content.transform)
  goItem.name = theName
  goItem:SetActive(true)
  local itemNode = self.content:AddComponent(DetailPage, theName)
  itemNode:SetData(self.activityId, openLevel, openTime, forDeclare)
  itemNode:SetSizeDeltaXY(804, y)
end

return LWSeason6AttackCityContainer
