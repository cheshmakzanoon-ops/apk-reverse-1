local UILWRecommendBuildListView = BaseClass("UILWRecommendBuildListView", UIBaseView)
local RecommendBuildCell = require("UI.UILWRecommendBuildList.Comp.RecommendBuildCell")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local onlyRecommend = false
local sortL2H = false

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
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/TopBar/TextTitle")
  self.btnClose = self:AddComponent(UIButton, "Root/BottomBar/BtnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnSort = self:AddComponent(UIButton, "Root/BottomBar/btnSort")
  self.btnSort:SetOnClick(function()
    PostEventLog.Track(PostEventLog.Defines.RecommendSortClick)
    self:OnBtnSortClick()
  end)
  self.textSort = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/btnSort/textSort")
  self.textCount = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/textCount")
  self.listRecommendBuildCell = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/CContent")
  self.compRecommendBuildCell = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/CContent/RecommendBuildCell")
  self.btnTabItem1 = self:AddComponent(UIButton, "Root/TabHolder/TabContent/TabItem1")
  self.btnTabItem1:SetOnClick(function()
    self:OnBtnTabItem1Click()
  end)
  self.btnTabItem2 = self:AddComponent(UIButton, "Root/TabHolder/TabContent/TabItem2")
  self.btnTabItem2:SetOnClick(function()
    self:OnBtnTabItem2Click()
  end)
  self.compCondition1Select = self:AddComponent(UIBaseContainer, "Root/TabHolder/TabContent/TabItem1/Condition1Select")
  self.compCondition2Select = self:AddComponent(UIBaseContainer, "Root/TabHolder/TabContent/TabItem2/Condition2Select")
  self.textCondition1Txt = self:AddComponent(UITextMeshProUGUIEx, "Root/TabHolder/TabContent/TabItem1/Condition1Txt")
  self.textCondition2Txt = self:AddComponent(UITextMeshProUGUIEx, "Root/TabHolder/TabContent/TabItem2/Condition2Txt")
  self.compRedPointBg1 = self:AddComponent(UIBaseContainer, "Root/TabHolder/TabContent/TabItem1/RedPointBg1")
  self.compRedPointBg2 = self:AddComponent(UIBaseContainer, "Root/TabHolder/TabContent/TabItem2/RedPointBg2")
  self.compTips = self:AddComponent(UIBaseContainer, "Tips")
  self.textDescTitle = self:AddComponent(UITextMeshProUGUIEx, "Tips/DescTitle")
  self.textLvL2H = self:AddComponent(UITextMeshProUGUIEx, "Tips/sort/textLvL2H")
  self.textRecommend = self:AddComponent(UITextMeshProUGUIEx, "Tips/show/textRecommend")
  self.textAllTypes = self:AddComponent(UITextMeshProUGUIEx, "Tips/show/textAllTypes")
  self.textLvH2L = self:AddComponent(UITextMeshProUGUIEx, "Tips/sort/textLvH2L")
  self.compSelected1 = self:AddComponent(UIBaseContainer, "Tips/show/textAllTypes/checkBox1/selected1")
  self.compSelected1:SetActive(true)
  self.compSelected2 = self:AddComponent(UIBaseContainer, "Tips/show/textRecommend/checkBox2/selected2")
  self.compSelected2:SetActive(false)
  self.compSelected3 = self:AddComponent(UIBaseContainer, "Tips/sort/textLvL2H/checkBox3/selected3")
  self.compSelected3:SetActive(true)
  self.compSelected4 = self:AddComponent(UIBaseContainer, "Tips/sort/textLvH2L/checkBox4/selected4")
  self.compSelected4:SetActive(false)
  self.btnCloseTips = self:AddComponent(UIButton, "Tips/closeTips")
  self.btnCloseTips:SetOnClick(function()
    self:OnBtnCloseTipsClick()
  end)
  self.btnFilter1 = self:AddComponent(UIButton, "Tips/show/textAllTypes/btnFilter1")
  self.btnFilter1:SetOnClick(function()
    onlyRecommend = false
    self.compSelected1:SetActive(true)
    self.compSelected2:SetActive(false)
    self:OnSelectTab(self.tab)
  end)
  self.btnFilter2 = self:AddComponent(UIButton, "Tips/show/textRecommend/btnFilter2")
  self.btnFilter2:SetOnClick(function()
    onlyRecommend = true
    self.compSelected1:SetActive(false)
    self.compSelected2:SetActive(true)
    self:OnSelectTab(self.tab)
  end)
  self.compSelected1:SetActive(not onlyRecommend)
  self.compSelected2:SetActive(onlyRecommend)
  self.btnSort1 = self:AddComponent(UIButton, "Tips/sort/textLvL2H/btnSort1")
  self.btnSort1:SetOnClick(function()
    sortL2H = false
    self.compSelected3:SetActive(true)
    self.compSelected4:SetActive(false)
    self:OnSelectTab(self.tab)
  end)
  self.btnSort2 = self:AddComponent(UIButton, "Tips/sort/textLvH2L/btnSort2")
  self.btnSort2:SetOnClick(function()
    sortL2H = true
    self.compSelected3:SetActive(false)
    self.compSelected4:SetActive(true)
    self:OnSelectTab(self.tab)
  end)
  self.compSelected3:SetActive(not sortL2H)
  self.compSelected4:SetActive(sortL2H)
  self.compRecommendBuildCell.gameObject:GameObjectCreatePool()
  self.compRecommendBuildCell:SetActive(false)
  self.compTips:SetActive(false)
  self.textCount:SetLocalText("newbies_buildinglist_desc1", DataCenter.BuildQueueManager:GetOccupideQueueNum(), DataCenter.BuildQueueManager:GetAllCanUseQueueNum())
end

local function ComponentDestroy(self)
  self.compRecommendBuildCell.gameObject:GameObjectRecycleAll()
  self:ClearContents()
  self.textTitle = nil
  self.btnClose = nil
  self.btnSort = nil
  self.textSort = nil
  self.textCount = nil
  self.compRecommendBuildCell = nil
  self.btnTabItem1 = nil
  self.btnTabItem2 = nil
  self.btnTabItem3 = nil
  self.compCondition1Select = nil
  self.compCondition2Select = nil
  self.compCondition3Select = nil
  self.textCondition1Txt = nil
  self.textCondition2Txt = nil
  self.textCondition3Txt = nil
  self.compRedPointBg1 = nil
  self.compRedPointBg2 = nil
  self.compRedPointBg3 = nil
  self.compTips = nil
  self.textDescTitle = nil
  self.textLvL2H = nil
  self.textRecommend = nil
  self.textAllTypes = nil
  self.textLvH2L = nil
  self.compSelected1 = nil
  self.compSelected2 = nil
  self.compSelected3 = nil
  self.compSelected4 = nil
  self.btnCloseTips = nil
  self.recommendList = nil
end

local function DataDefine(self)
  self.tabSelectes = {
    [UIBuildListTabType.Economy] = self.compCondition1Select,
    [UIBuildListTabType.Military] = self.compCondition2Select
  }
  self.buildIds = DataCenter.BuildTemplateManager:GetBuildListIds()
  self:OnSelectTab(UIBuildListTabType.Economy)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnSortClick(self)
  self.compTips:SetActive(true)
end

local function OnBtnTabItem1Click(self)
  self:OnSelectTab(UIBuildListTabType.Economy)
end

local function OnBtnTabItem2Click(self)
  self:OnSelectTab(UIBuildListTabType.Military)
end

function UILWRecommendBuildListView:OnSelectTab(tab)
  self.tab = tab
  for k, v in pairs(self.tabSelectes) do
    v:SetActive(k == tab)
  end
  self.compRecommendBuildCell.gameObject:GameObjectRecycleAll()
  self:ClearContents()
  self.recommendList = {}
  self:GetBuilds(tab)
  if self.list and table.count(self.list) > 1 then
    table.sort(self.list, function(a, b)
      local al = a.level
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(a.itemId)
      if template.max_level == 1 then
        al = 999
      end
      local bl = b.level
      template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(b.itemId)
      if template.max_level == 1 then
        bl = 999
      end
      if al ~= bl then
        if sortL2H then
          return al > bl
        else
          return al < bl
        end
      end
      return a.itemId < b.itemId
    end)
  end
  for i = 1, table.count(self.list) do
    local item = self.compRecommendBuildCell.gameObject:GameObjectSpawn(self.listRecommendBuildCell.transform)
    item.name = item.name .. "_" .. i
    local cell = self.listRecommendBuildCell:AddComponent(RecommendBuildCell, item.name)
    cell:OnSetData(self.list[i], self.recommendList)
  end
end

function UILWRecommendBuildListView.ReorderNormal(a, b)
end

function UILWRecommendBuildListView:GetBuilds(tab)
  local listConf = self.buildIds[tab]
  self.list = {}
  for i = 1, #listConf do
    local datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(listConf[i].id)
    for ii = 1, #datas do
      if datas[ii].level > 0 then
        if onlyRecommend then
          if datas[ii]:CheckRecommend() then
            table.insert(self.list, datas[ii])
          end
        else
          table.insert(self.list, datas[ii])
        end
      end
    end
  end
  if tab == UIBuildListTabType.Military then
    table.insert(self.list, DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.FUN_BUILD_MAIN)[1])
    local datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT)
    if datas[1] and datas[1].level > 0 then
      table.insert(self.list, datas[1])
    end
    datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_TWO)
    if datas[1] and datas[1].level > 0 then
      table.insert(self.list, datas[1])
    end
    datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_THREE)
    if datas[1] and datas[1].level > 0 then
      table.insert(self.list, datas[1])
    end
    datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
    if datas[1] and datas[1].level > 0 and DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
      table.insert(self.list, datas[1])
    end
  end
end

function UILWRecommendBuildListView:ClearContents()
  self.listRecommendBuildCell:RemoveComponents(RecommendBuildCell)
end

local function OnBtnCloseTipsClick(self)
  self.compTips:SetActive(false)
end

UILWRecommendBuildListView.OnCreate = OnCreate
UILWRecommendBuildListView.OnDestroy = OnDestroy
UILWRecommendBuildListView.OnEnable = OnEnable
UILWRecommendBuildListView.OnDisable = OnDisable
UILWRecommendBuildListView.ComponentDefine = ComponentDefine
UILWRecommendBuildListView.ComponentDestroy = ComponentDestroy
UILWRecommendBuildListView.DataDefine = DataDefine
UILWRecommendBuildListView.DataDestroy = DataDestroy
UILWRecommendBuildListView.OnAddListener = OnAddListener
UILWRecommendBuildListView.OnRemoveListener = OnRemoveListener
UILWRecommendBuildListView.OnBtnCloseClick = OnBtnCloseClick
UILWRecommendBuildListView.OnBtnSortClick = OnBtnSortClick
UILWRecommendBuildListView.OnBtnTabItem1Click = OnBtnTabItem1Click
UILWRecommendBuildListView.OnBtnTabItem2Click = OnBtnTabItem2Click
UILWRecommendBuildListView.OnBtnCloseTipsClick = OnBtnCloseTipsClick
return UILWRecommendBuildListView
