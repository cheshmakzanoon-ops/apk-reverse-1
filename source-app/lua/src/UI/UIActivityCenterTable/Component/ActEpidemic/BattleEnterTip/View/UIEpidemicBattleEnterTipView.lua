local UIEpidemicBattleEnterTipView = BaseClass("UIEpidemicBattleEnterTipView", UIBaseView)
local base = UIBaseView
local BattlePopBase = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleBase.BattlePopBase")
local UIEBET_ItemCell = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleEnterTip.Component.UIEBET_ItemCell")
local panel_path = "panel"
local battle_pop_base_path = "BattlePopBase"
local scroll_view_path = "Bg/ScrollView"
local content_path = "Bg/ScrollView/Viewport/Content"
local page_cell_path = "Bg/PageCell"
local page_identify_root_path = "Bg/PageIdentify"
local page_identify_path = "Bg/PageIdentify/1"
local left_arrow_path = "Bg/LeftArrow"
local right_arrow_path = "Bg/RightArrow"
local btn_path = "Bg/Btn"
local check_path = "Bg/Check/Box"

function UIEpidemicBattleEnterTipView:OnCreate()
  base.OnCreate(self)
  local goCb = BindCallback(self, self.OnBtnGo)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(goCb)
  self.battle_pop_base = self:AddComponent(BattlePopBase, battle_pop_base_path)
  self.battle_pop_base:ReInit("YiBianJinQu_battle_tips_11", goCb)
  self.scroll_view = self:AddComponent(UIScrollPage, scroll_view_path)
  self.scroll_view:SetPageChangedCallback(BindCallback(self, self.OnUpdateScroll))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.page_identify = self:AddComponent(UIBaseContainer, page_identify_root_path)
  self.left_arrow = self:AddComponent(UIButton, left_arrow_path)
  self.left_arrow:SetOnClick(function()
    self.scroll_view:ToPrevPage()
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.right_arrow = self:AddComponent(UIButton, right_arrow_path)
  self.right_arrow:SetOnClick(function()
    self.scroll_view:ToNextPage()
    self:OnUpdateScroll(self.scroll_view.currentPageIndex)
  end)
  self.thePageItem = self.transform:Find(page_cell_path).gameObject
  self.thePageItem:GameObjectCreatePool()
  self.thePageIdentifyItem = self.transform:Find(page_identify_path).gameObject
  self.thePageIdentifyItem:GameObjectCreatePool()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(goCb)
  self.check = self:AddComponent(UIToggle, check_path)
  self.check:SetIsOn(true)
  local toggleList = {}
  local guideList = DataCenter.ActEpidemicZoneManager:GetGuideList()
  local listCnt = #guideList
  if 0 < listCnt then
    for index, v in ipairs(guideList) do
      local theName = "page_" .. index
      local goItem = self.thePageItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local itemNode = self.content:AddComponent(UIEBET_ItemCell, theName)
      itemNode:ReInit(v)
      goItem = self.thePageIdentifyItem:GameObjectSpawn(self.page_identify.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local itemToggle = self.page_identify:AddComponent(UIToggle, theName)
      local theIndex = index
      itemToggle:SetIsOn(false)
      toggleList[index] = itemToggle
      itemToggle:SetOnValueChanged(function(tf)
        if tf then
          self.scroll_view:PageTo(theIndex)
        end
      end)
    end
  end
  self.toggleList = toggleList
  self.scroll_view:SetPageCount(listCnt)
  self.scroll_view:PageTo(1)
  toggleList[1]:SetIsOn(true)
end

function UIEpidemicBattleEnterTipView:OnDestroy()
  self.content:RemoveComponents(UIEBET_ItemCell)
  self.thePageItem:GameObjectRecycleAll()
  self.page_identify:RemoveComponents(UIToggle)
  self.thePageIdentifyItem:GameObjectRecycleAll()
  self.panel = nil
  self.battle_pop_base = nil
  self.left_arrow = nil
  self.right_arrow = nil
  self.scroll_view = nil
  self.content = nil
  self.page_identify = nil
  self.thePageItem = nil
  self.thePageIdentifyItem = nil
  self.btn = nil
  self.check = nil
  base.OnDestroy(self)
end

function UIEpidemicBattleEnterTipView:OnUpdateScroll(index)
  local itemToggle = self.toggleList[index]
  if itemToggle ~= nil then
    itemToggle:SetIsOn(true)
  end
  self.left_arrow:SetActive(1 < index)
  self.right_arrow:SetActive(index < #self.toggleList)
end

function UIEpidemicBattleEnterTipView:OnBtnGo()
  if self.check:GetIsOn() then
    CommonUtil.PlayerPrefsSetString(TipEnterDragonWorld .. BattleFieldType.EpidemicZone, tostring(UITimeManager:GetInstance():GetServerSeconds()))
  end
  local cb = self:GetUserData()
  self.ctrl:CloseSelf()
  if cb then
    cb()
  end
end

return UIEpidemicBattleEnterTipView
