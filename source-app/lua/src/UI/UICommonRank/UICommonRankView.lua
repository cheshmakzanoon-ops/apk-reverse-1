local UICommonRankView = BaseClass("UICommonRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonRankItem = require("UI.UICommonRank.UICommonRankItem")
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"
local bottom_desc_path = "Root/BottomBar/BottomDesc"
local rank_des_path = "Root/ScrollView/select/rankDes"
local name_des_path = "Root/ScrollView/select/nameDes"
local power_des_path = "Root/ScrollView/select/powerLayout/powerDes"
local power_tips_path = "Root/ScrollView/select/powerLayout/powerTips"
local btn_power_tips_path = "Root/ScrollView/select/powerLayout/powerTips/BtnPowerTips"
local self_data_path = "Root/SelfData"
local info_btn_path = "Root/TopBar/InfoBtn"
local btn_rank_reward_path = "Root/BottomBar/BtnRankReward"
local scroll_path = "Root/ScrollView"
local tab_btns_path = "Root/tabBtns"
local tab_path = "Root/tabBtns/Viewport/ConditionBtns/Tab%d"
local empty_des_path = "emptyDes"

function UICommonRankView:OnCreate()
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
  self.btn_rank_reward = self:AddComponent(UIButton, btn_rank_reward_path)
  self.btn_rank_reward:SetOnClick(function()
    self:RequestRewardInfo()
  end)
  self.power_tips = self:AddComponent(UIImage, power_tips_path)
  self.btn_power_tips = self:AddComponent(UIButton, btn_power_tips_path)
  self.btn_power_tips:SetOnClick(function()
    self:OnBtnPowerTipsClicked()
  end)
  self.btn_rank_reward:SetActive(self.param.openRewardWindowFunc)
  self.tab_btns:SetActive(0 < tabCount)
  self.selectIndex = 1
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
          self:DoSelectTabIndex(index)
        end)
        self.tabs[i] = tab
      else
        tab.tab:SetActive(false)
      end
    end
  end
  self.power_tips:SetActive(false)
end

function UICommonRankView:OnDestroy()
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

function UICommonRankView:OnAddListener()
  base.OnAddListener(self)
  if self.param.refreshEventId then
    self:AddUIListener(self.param.refreshEventId, self.RefreshContent)
  end
  if self.param.refreshRewardEventId then
    self:AddUIListener(self.param.refreshRewardEventId, self.OpenRewardWindow)
  end
end

function UICommonRankView:OnRemoveListener()
  if self.param.refreshEventId then
    self:RemoveUIListener(self.param.refreshEventId, self.RefreshContent)
  end
  if self.param.refreshRewardEventId then
    self:RemoveUIListener(self.param.refreshRewardEventId, self.OpenRewardWindow)
  end
  base.OnRemoveListener(self)
end

function UICommonRankView:OnEnable()
  base.OnEnable(self)
  self:RefreshTab()
  self:RefreshContent()
end

function UICommonRankView:OnDisable()
  base.OnDisable(self)
end

function UICommonRankView:RefreshTab()
  for i = 1, #self.tabs do
    if self.tabs[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
  self.txt_title:SetLocalText(self.param.titleText[self.selectIndex])
  self.rank_des:SetLocalText(361013)
  self.name_des:SetLocalText(self.param.rankTitleList[self.selectIndex][1])
  self.power_des:SetLocalText(self.param.rankTitleList[self.selectIndex][2])
end

function UICommonRankView:RefreshContent()
  self:ClearScroll()
  local rankData = {}
  if self.param.getRankDataFunc then
    rankData = self.param.getRankDataFunc(self.selectIndex)
    self.rankList = rankData.rankList or {}
  end
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
  local selfRankType = self.rankType
  if selfRankType == 0 and currentData then
    selfRankType = currentData.isAlliance and CommonRankType.ALLIANCE or CommonRankType.PERSONAL
  end
  self.self_data:SetActive(true)
  self.self_data:SetItemShow(currentData, true, selfRankType)
  self.powerTipsStr = nil
  if self.param.powerTipsList then
    self.powerTipsStr = self.param.powerTipsList[self.selectIndex]
    if string.IsNullOrEmpty(self.powerTipsStr) then
      self.power_tips:SetActive(false)
    else
      self.power_tips:SetActive(true)
    end
  end
end

function UICommonRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UICommonRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(self.rankList[index], false, self.rankType)
  end
end

function UICommonRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UICommonRankItem)
end

function UICommonRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UICommonRankItem)
end

function UICommonRankView:DoSelectTabIndex(index)
  if index == self.selectIndex then
    return
  end
  self.selectIndex = index
  self:RefreshTab()
  self:RefreshContent()
end

function UICommonRankView:RequestRewardInfo()
  if not self:OpenRewardWindow() and self.param.pullRewardDataFunc then
    self.param.pullRewardDataFunc()
  end
end

function UICommonRankView:OnBtnPowerTipsClicked()
  if self.powerTipsStr and self.power_tips then
    UIUtil.ShowBubbleTipsAuto(self.powerTipsStr, self.power_tips:GetPosition(), 0, -30, 0, nil, nil)
  end
end

function UICommonRankView:OpenRewardWindow()
  if self.param.openRewardWindowFunc then
    return self.param.openRewardWindowFunc()
  end
end

return UICommonRankView
