local UIAllianceStarRewardView = BaseClass("UIAllianceStarRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local have_cost_content_path = "Content/HaveCostContent"
local have_cost_txt1_path = "Content/HaveCostContent/HaveCostTxt1"
local have_cost_img_path = "Content/HaveCostContent/HaveCostImg"
local have_cost_txt2_path = "Content/HaveCostContent/HaveCostTxt2"
local history_reward_root_path = "Content/HistoryRewardRoot"
local bottomContentH1 = 419
local bottomContentH2 = 359

function UIAllianceStarRewardView:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.textStoredTitle = self:AddComponent(UIText, "Content/StoredRewardRoot/StoredRewardBase/StoreRewardTitle")
  self.canvasGroupStored = self:AddComponent(UICanvasGroup, "Content/StoredRewardRoot/StoredRewardBase/StoredRewardContentRoot")
  self.textStoredEmpty = self:AddComponent(UIText, "Content/StoredRewardRoot/StoredRewardBase/StoredRewardContentRoot/StoredRewardEmptyText")
  self.contentStored = self:AddComponent(UIBaseContainer, "Content/StoredRewardRoot/StoredRewardBase/StoredRewardContentRoot/scrollStoredRewards/Viewport/ContentStored")
  self.objScrollStored = self:AddComponent(UIBaseContainer, "Content/StoredRewardRoot/StoredRewardBase/StoredRewardContentRoot/scrollStoredRewards")
  self.textHistoryTitle = self:AddComponent(UIText, "Content/HistoryRewardRoot/HistoryRewardBase/HistoryRewardTitle")
  self.canvasGroupHistory = self:AddComponent(UICanvasGroup, "Content/HistoryRewardRoot/HistoryRewardBase/HistoryRewardContentRoot")
  self.contentHistory = self:AddComponent(UIBaseContainer, "Content/HistoryRewardRoot/HistoryRewardBase/HistoryRewardContentRoot/scrollHistoryRewards/Viewport/ContentHistory")
  self.objScrollHistory = self:AddComponent(UIBaseContainer, "Content/HistoryRewardRoot/HistoryRewardBase/HistoryRewardContentRoot/scrollHistoryRewards")
  self.textHistoryEmpty = self:AddComponent(UIText, "Content/HistoryRewardRoot/HistoryRewardBase/HistoryRewardContentRoot/HistoryRewardEmptyText")
  self.btnClaim = self:AddComponent(UIButton, "Content/ClaimStoredRewardBtn")
  self.btnClaim:SetOnClick(function()
    self:OnClaimClick()
  end)
  self.textClaim = self:AddComponent(UIText, "Content/ClaimStoredRewardBtn/Btn/BtnText")
  self.textCanNotClaim = self:AddComponent(UIText, "Content/NoClaimText")
  self.animContent = self:AddComponent(UIAnimator, "Content")
  self.have_cost_content = self:AddComponent(UIBaseContainer, have_cost_content_path)
  self.have_cost_txt1 = self:AddComponent(UITextMeshProUGUIEx, have_cost_txt1_path)
  self.have_cost_img = self:AddComponent(UIImage, have_cost_img_path)
  self.have_cost_txt2 = self:AddComponent(UITextMeshProUGUIEx, have_cost_txt2_path)
  self.history_reward_root = self:AddComponent(UIImage, history_reward_root_path)
end

function UIAllianceStarRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateUI(false)
end

function UIAllianceStarRewardView:OnDestroy()
  self:ClearStoredRewardScroll()
  self:ClearHistoryRewardScroll()
  self:ComponentDestroy()
  if self.delayShowTimer ~= nil then
    self.delayShowTimer:Stop()
    self.delayShowTimer = nil
  end
  base.OnDestroy(self)
end

function UIAllianceStarRewardView:UpdateUI(showAnim)
  self.textTitle:SetLocalText("alliance_weeklyStar_reward_title")
  self.textStoredTitle:SetLocalText("alliance_weeklyStar_reward_title2")
  self.textHistoryTitle:SetLocalText("alliance_weeklyStar_reward_title3")
  self.textStoredEmpty:SetLocalText("alliance_weeklyStar_reward_empty")
  self.textCanNotClaim:SetLocalText("alliance_weeklyStar_reward_empty")
  self.textClaim:SetLocalText("alliance_weeklyStar_reward_btn_claim")
  self.textHistoryEmpty:SetLocalText("alliance_weeklyStar_reward_empty2")
  self:RefreshCostNumContent()
  
  local function UpdateStoredReward()
    local storedRewardList = DataCenter.AllianceStarManager:GetCanClaimNormalRewardList()
    local isShow = not table.IsNullOrEmpty(storedRewardList)
    if self.objScrollStored then
      self.objScrollStored:SetActive(isShow)
    end
    if self.textStoredEmpty then
      self.textStoredEmpty:SetActive(not isShow)
    end
    if isShow then
      local storedRewardListSorted = {}
      local storedRewardListTmp = {}
      for i, v in pairs(storedRewardList) do
        if v.value ~= nil then
          if storedRewardListTmp[v.value.id] ~= nil then
            storedRewardListTmp[v.value.id].count = storedRewardListTmp[v.value.id].count + v.value.num
          else
            storedRewardListTmp[v.value.id] = {
              count = v.value.num,
              type = v.type
            }
          end
        end
      end
      for i, v in pairs(storedRewardListTmp) do
        table.insert(storedRewardListSorted, {
          itemId = checknumber(i),
          count = v.count,
          type = v.type
        })
      end
      self:SortReward(storedRewardListSorted)
      local index = 1
      for _, v in ipairs(storedRewardListSorted) do
        local request = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          if self.contentStored == nil then
            return
          end
          go.transform:SetParent(self.contentStored.transform)
          go.gameObject:SetActive(true)
          go.transform:Set_localScale(1, 1, 1)
          go.name = "itemStored_" .. tostring(index)
          local cell = self.contentStored:AddComponent(UICommonResItem, go.name)
          local para = {}
          para.rewardType = v.type
          para.itemId = v.itemId
          para.count = v.count
          cell:ReInit(para)
          index = index + 1
        end)
        table.insert(self.storedRequests, request)
      end
    end
    if self.btnClaim ~= nil then
      self.btnClaim:SetActive(isShow)
    end
    if self.textCanNotClaim ~= nil then
      self.textCanNotClaim:SetActive(not isShow)
    end
  end
  
  local function UpdateHistoryReward()
    local historyRewardList = DataCenter.AllianceStarManager:GetHistoryTotalRewardData()
    local isShow = not table.IsNullOrEmpty(historyRewardList)
    if self.objScrollHistory ~= nil then
      self.objScrollHistory:SetActive(isShow)
    end
    if self.textHistoryEmpty ~= nil then
      self.textHistoryEmpty:SetActive(not isShow)
    end
    if isShow then
      local historyRewardListSorted = {}
      local historyRewardListTmp = {}
      for i, v in pairs(historyRewardList) do
        if v.value ~= nil then
          if historyRewardListTmp[v.value.id] ~= nil then
            historyRewardListTmp[v.value.id].count = historyRewardListTmp[v.value.id].count + v.value.num
          else
            historyRewardListTmp[v.value.id] = {
              count = v.value.num,
              type = v.type
            }
          end
        end
      end
      for i, v in pairs(historyRewardListTmp) do
        table.insert(historyRewardListSorted, {
          itemId = checknumber(i),
          count = v.count,
          type = v.type
        })
      end
      self:SortReward(historyRewardListSorted)
      local index = 1
      for _, v in ipairs(historyRewardListSorted) do
        local request = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          if self.contentHistory == nil then
            return
          end
          go.transform:SetParent(self.contentHistory.transform)
          go.gameObject:SetActive(true)
          go.transform:Set_localScale(1, 1, 1)
          go.name = "itemHistory_" .. tostring(index)
          local cell = self.contentHistory:AddComponent(UICommonResItem, go.name)
          local para = {}
          para.rewardType = v.type
          para.itemId = v.itemId
          para.count = v.count
          cell:ReInit(para)
          index = index + 1
        end)
        table.insert(self.historyRequests, request)
      end
    end
  end
  
  if showAnim then
    self.animContent:Enable(true)
    local ret, time = self.animContent:PlayAnimationReturnTime("hide")
    if ret then
      if self.delayShowTimer ~= nil then
        self.delayShowTimer:Stop()
      end
      self.delayShowTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.animContent == nil then
          return
        end
        self:ClearStoredRewardScroll()
        self:ClearHistoryRewardScroll()
        self.animContent:PlayAnimationReturnTime("show")
        UpdateStoredReward()
        UpdateHistoryReward()
      end, time)
    end
  else
    self.animContent:Enable(false)
    self.canvasGroupHistory:SetAlpha(1)
    self.canvasGroupStored:SetAlpha(1)
    self:ClearStoredRewardScroll()
    self:ClearHistoryRewardScroll()
    UpdateStoredReward()
    UpdateHistoryReward()
  end
end

function UIAllianceStarRewardView:RefreshCostNumContent()
  self.have_cost_content:SetActive(false)
  self.history_reward_root:SetSizeDeltaY(bottomContentH1)
end

function UIAllianceStarRewardView:OnClaimClick()
  local storedRewardList = DataCenter.AllianceStarManager:GetCanClaimNormalRewardList()
  if not table.IsNullOrEmpty(storedRewardList) then
    DataCenter.AllianceStarManager:RequestClaimStoredReward()
  end
end

function UIAllianceStarRewardView:ClearStoredRewardScroll()
  if self.storedRequests then
    if self.contentStored then
      self.contentStored:RemoveComponents(UICommonResItem)
    end
    for i, v in pairs(self.storedRequests) do
      v:Destroy()
    end
  end
  self.storedRequests = {}
end

function UIAllianceStarRewardView:ClearHistoryRewardScroll()
  if self.historyRequests then
    if self.contentHistory then
      self.contentHistory:RemoveComponents(UICommonResItem)
    end
    for i, v in pairs(self.historyRequests) do
      v:Destroy()
    end
  end
  self.historyRequests = {}
end

function UIAllianceStarRewardView:ComponentDestroy()
  self.textTitle = nil
  self.btnClose = nil
  self.textStoredTitle = nil
  self.textStoredEmpty = nil
  self.contentStored = nil
  self.textHistoryTitle = nil
  self.contentHistory = nil
  self.textHistoryEmpty = nil
  self.btnClaim = nil
  self.textClaim = nil
  self.textCanNotClaim = nil
  self.objScrollStored = nil
  self.objScrollHistory = nil
  self.animContent = nil
  self.have_cost_content = nil
  self.have_cost_txt1 = nil
  self.have_cost_img = nil
  self.have_cost_txt2 = nil
  self.history_reward_root = nil
end

function UIAllianceStarRewardView:OnInfoUpdate()
  self:UpdateUI(true)
end

function UIAllianceStarRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceStarCeremonyRewardInfoPush, self.OnInfoUpdate)
end

function UIAllianceStarRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceStarCeremonyRewardInfoPush, self.OnInfoUpdate)
end

function UIAllianceStarRewardView:SortReward(rewardData)
  return rewardData
end

return UIAllianceStarRewardView
