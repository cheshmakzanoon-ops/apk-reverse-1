local UIHSRRankView = BaseClass("UIHSRRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonRankItem = require("UI.UICommonRank.UICommonRankItem")
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"
local bottom_desc_path = "Root/BottomBar/BottomDesc"
local rank_des_path = "Root/ScrollView/select/rankDes"
local name_des_path = "Root/ScrollView/select/nameDes"
local power_des_path = "Root/ScrollView/select/powerDes"
local self_data_path = "Root/SelfData"
local info_btn_path = "Root/TopBar/InfoBtn"
local btn_rank_reward_path = "Root/BottomBar/BtnRankReward"
local scroll_path = "Root/ScrollView"
local tab_btns_path = "Root/tabBtns"
local tab_path = "Root/tabBtns/Viewport/ConditionBtns/Tab%d"
local empty_des_path = "emptyDes"
local SUB_TAB_KEY = {
  "building_center_desc22",
  "451030",
  "361058",
  "server_train_search_title"
}

function UIHSRRankView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  self.param.toggleTextList = self.param.toggleTextList or {}
  local tabCount = #self.param.toggleTextList
  if type(self.param.titleText) == "string" then
    local titleText = self.param.titleText
    self.param.titleText = {titleText}
    for i = 1, tabCount do
      self.param.titleText[i] = titleText
    end
  end
  self.bottom_desc = self:AddComponent(UITextMeshProUGUIEx, bottom_desc_path)
  if self.param.bottomDesc then
    self.bottom_desc:SetLocalText(self.param.bottomDesc)
  else
    self.bottom_desc:SetText("")
  end
  self.txt_title = self:AddComponent(UIText, text_title_path)
  self.name_des = self:AddComponent(UIText, name_des_path)
  self.power_des = self:AddComponent(UIText, power_des_path)
  self.rank_des = self:AddComponent(UIText, rank_des_path)
  self.close_btn = self:AddComponent(UIButton, btn_back_path)
  self.tab_btns = self:AddComponent(UIBaseContainer, tab_btns_path)
  self.empty_des = self:AddComponent(UITextMeshProUGUIEx, empty_des_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.self_data = self:AddComponent(UICommonRankItem, self_data_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetFixedItemSize(750, 135)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.tab_btns:SetActive(0 < tabCount)
  self.curType = 1
  self.tabs = {}
  if 0 < tabCount then
    for i = 1, 4 do
      local toggleText = self.param.toggleTextList[i]
      local tab = {}
      tab.tab = self:AddComponent(UIBaseContainer, string.format(tab_path, i))
      if toggleText then
        tab.tab:SetActive(true)
        local index = i
        tab.tab_select = tab.tab:AddComponent(UIBaseContainer, "select")
        tab.tab_name = tab.tab:AddComponent(UIText, "activityName")
        tab.tab_name:SetLocalText(self.param.toggleTextList[i])
        tab.tab_btn = tab.tab:AddComponent(UIButton, "TypeButton")
        tab.tab_btn:SetOnClick(function()
          self:OnClickTab(index)
        end)
        self.tabs[i] = tab
      else
        tab.tab:SetActive(false)
      end
    end
  end
  self.subTabs = {}
  for i = 1, 4 do
    local segment = self:AddComponent(UIBaseContainer, "Root/ToggleGroup/Toggle" .. i)
    local btn = segment:AddComponent(UIButton, "")
    btn:SetOnClick(function()
      self:OnClickSubTab(i)
    end)
    local select = segment:AddComponent(UIBaseContainer, "select")
    local selectTxt = segment:AddComponent(UIText, "select/selectText")
    selectTxt:SetLocalText(SUB_TAB_KEY[i])
    local unselectTxt = segment:AddComponent(UIText, "unselectText")
    unselectTxt:SetLocalText(SUB_TAB_KEY[i])
    local newSeg = {
      selectN = select,
      selectTxtN = selectTxt,
      unselectTxtN = unselectTxt,
      btnN = btn
    }
    table.insert(self.subTabs, newSeg)
  end
  self.curSubType = 1
  for i, v in ipairs(self.subTabs) do
    v.selectN:SetActive(i == self.curSubType)
  end
  self:RefreshView()
end

function UIHSRRankView:OnClickTab(type)
  if type == self.curType then
    return
  end
  self.curType = type
  self:RefreshView()
end

function UIHSRRankView:OnClickSubTab(subType)
  if subType == self.curSubType then
    return
  end
  self.curSubType = subType
  self:RefreshView()
end

function UIHSRRankView:OnDestroy()
  self:ClearScroll()
  self.param = nil
  self.txt_title = nil
  self.name_des = nil
  self.power_des = nil
  self.rank_des = nil
  self.close_btn = nil
  self.ScrollView = nil
  self.rankList = nil
  self.tab_btns = nil
  self.empty_des = nil
  self.btn_rank_reward = nil
  base.OnDestroy(self)
end

function UIHSRRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HSRRankDataRefresh, self.RefreshContent)
end

function UIHSRRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.HSRRankDataRefresh, self.RefreshContent)
  base.OnRemoveListener(self)
end

function UIHSRRankView:OnEnable()
  base.OnEnable(self)
  self:RefreshTab()
  self:RefreshContent()
end

function UIHSRRankView:OnDisable()
  base.OnDisable(self)
end

function UIHSRRankView:RefreshView()
  DataCenter.HSRDataManager:FetchRankData(self.curType, self.curSubType)
  self:RefreshTab()
  self:RefreshContent()
end

function UIHSRRankView:RefreshTab()
  for i = 1, #self.tabs do
    if self.tabs[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.curType)
    end
  end
  for i, v in ipairs(self.subTabs) do
    v.selectN:SetActive(i == self.curSubType)
  end
  self.txt_title:SetLocalText(self.param.titleText[self.curType])
  self.rank_des:SetLocalText(361013)
  self.name_des:SetLocalText(self.param.rankTitleList[self.curType][1])
  self.power_des:SetLocalText(self.param.rankTitleList[self.curType][2])
end

function UIHSRRankView:RefreshContent()
  self:ClearScroll()
  local rankData = {}
  rankData = DataCenter.HSRDataManager:GetRankData(self.curType, self.curSubType)
  self.rankList = rankData.rankList or {}
  self.rankType = 0
  if #self.rankList > 0 then
    self.rankType = self.rankList[1].uid and CommonRankType.PERSONAL or CommonRankType.ALLIANCE
    self.ScrollView:SetTotalCount(#self.rankList)
    self.ScrollView:RefillCells()
    self.empty_des:SetActive(false)
  else
    self.empty_des:SetActive(true)
  end
  local currentData
  for i = 1, #self.rankList do
    if self.rankList[i].uid == LuaEntry.Player.uid then
      currentData = self.rankList[i]
    end
  end
  if currentData == nil then
    currentData = rankData.myRank or {}
  end
  self.self_data:SetActive(true)
  self.self_data:SetItemShow(currentData, true, self.rankType)
end

function UIHSRRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UICommonRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(self.rankList[index], false, self.rankType)
  end
end

function UIHSRRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UICommonRankItem)
end

function UIHSRRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UICommonRankItem)
end

return UIHSRRankView
