local UIDesertBattleDetailView = BaseClass("UIDesertBattleDetailView", UIBaseView)
local base = UIBaseView
local UIDesertBattleDetailItem = require("UI.UIActivityCenterTable.Component.DesertBattle.Detail.Component.UIDesertBattleDetailItem")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local page_cell_path = "PopUpTitle/ScrollView/Viewport/PageCell"
local page_identify_root_path = "PopUpTitle/PageIdentify"
local page_identify_path = "PopUpTitle/PageIdentify/1"
local left_arrow_path = "PopUpTitle/SwitchArrows/LeftArrow"
local right_arrow_path = "PopUpTitle/SwitchArrows/RightArrow"

function UIDesertBattleDetailView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function UIDesertBattleDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertBattleDetailView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scroll_view = self:AddComponent(UIScrollPage, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.page_identify = self:AddComponent(UIBaseContainer, page_identify_root_path)
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
  self.thePageItem = self.transform:Find(page_cell_path).gameObject
  self.thePageItem:GameObjectCreatePool()
  self.thePageIdentifyItem = self.transform:Find(page_identify_path).gameObject
  self.thePageIdentifyItem:GameObjectCreatePool()
  local ToggleList = {}
  local GuideList = {}
  if type(self.param) == "table" then
    GuideList = self.param
  elseif self.param == BattleFieldType.Desert then
    GuideList = DataCenter.ActDragonManager:GetGuideList()
  elseif self.param == BattleFieldType.WinterStorm then
    GuideList = DataCenter.ActWinterStormManager:GetGuideList()
  elseif self.param == BattleFieldType.EpidemicZone then
    GuideList = DataCenter.ActEpidemicZoneManager:GetGuideList()
  elseif self.param == BattleFieldType.DsbDuel then
    GuideList = BattlefieldDsbDuelUtils.ActInfo:GetGuideList()
  end
  local listCnt = #GuideList
  if 0 < listCnt then
    for index, v in ipairs(GuideList) do
      local theName = "page_" .. index
      local goItem = self.thePageItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local itemNode = self.content:AddComponent(UIDesertBattleDetailItem, theName)
      itemNode:ReInit(v)
      goItem = self.thePageIdentifyItem:GameObjectSpawn(self.page_identify.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local itemToggle = self.page_identify:AddComponent(UIToggle, theName)
      local theIndex = index
      itemToggle:SetIsOn(false)
      ToggleList[index] = itemToggle
      itemToggle:SetOnValueChanged(function(tf)
        if tf then
          self.scroll_view:PageTo(theIndex)
        end
      end)
    end
  end
  self.GuideList = GuideList
  self.ToggleList = ToggleList
  self.scroll_view:SetPageCount(listCnt)
  self.scroll_view:PageTo(1)
  self:RefreshLRArrow(1)
  ToggleList[1]:SetIsOn(true)
end

function UIDesertBattleDetailView:OnUpdateScroll(index)
  local itemToggle = self.ToggleList[index]
  if itemToggle ~= nil then
    itemToggle:SetIsOn(true)
  end
  self:RefreshLRArrow(index)
end

function UIDesertBattleDetailView:RefreshLRArrow(index)
  self.left_arrow:SetActive(index ~= 1)
  self.right_arrow:SetActive(index ~= #self.ToggleList)
end

function UIDesertBattleDetailView:ComponentDestroy()
  self.content:RemoveComponents(UIDesertBattleDetailItem)
  self.thePageItem:GameObjectRecycleAll()
  self.page_identify:RemoveComponents(UIToggle)
  self.thePageIdentifyItem:GameObjectRecycleAll()
  self.btn_back = nil
end

return UIDesertBattleDetailView
