local UITreasureHuntNewHistoryView = BaseClass("UITreasureHuntNewHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local have_cost_content_path = "Content/HaveCostContent"
local have_cost_txt1_path = "Content/HaveCostContent/HaveCostTxt1"
local have_cost_img_path = "Content/HaveCostContent/HaveCostImg"
local have_cost_txt2_path = "Content/HaveCostContent/HaveCostTxt2"
local history_reward_root_path = "Content/HistoryRewardRoot"
local bottomContentH1 = 419
local bottomContentH2 = 359

function UITreasureHuntNewHistoryView:ComponentDefine()
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

function UITreasureHuntNewHistoryView:OnCreate()
  base.OnCreate(self)
  self.activityId = self:GetUserData()
  self:ComponentDefine()
  self:UpdateUI(false)
end

function UITreasureHuntNewHistoryView:OnDestroy()
  self:ClearStoredRewardScroll()
  self:ClearHistoryRewardScroll()
  self:ComponentDestroy()
  if self.delayShowTimer ~= nil then
    self.delayShowTimer:Stop()
    self.delayShowTimer = nil
  end
  base.OnDestroy(self)
end

function UITreasureHuntNewHistoryView:UpdateUI(showAnim)
  self.textTitle:SetLocalText("activity_armament_desc2")
  self.textStoredTitle:SetLocalText("activity_armament_desc3")
  self.textHistoryTitle:SetLocalText("activity_armament_desc4")
  self.textStoredEmpty:SetLocalText("activity_armament_desc6")
  self.textCanNotClaim:SetLocalText("activity_armament_desc8")
  self.textClaim:SetLocalText("activity_armament_desc5")
  self.textHistoryEmpty:SetLocalText("activity_armament_desc7")
  self:RefreshCostNumContent()
  
  local function UpdateStoredReward()
    if self.activityId == nil then
      return
    end
    local storedRewardList = DataCenter.ActivityTreasureHuntNewManager:GetCanClaimNormalRewardList(self.activityId)
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
    if self.activityId == nil then
      return
    end
    local historyRewardList = DataCenter.ActivityTreasureHuntNewManager:GetHistoryTotalRewardData(self.activityId)
    local isShow = not table.IsNullOrEmpty(historyRewardList)
    if self.objScrollHistory ~= nil then
      self.objScrollHistory:SetActive(isShow)
    end
    if self.textHistoryEmpty ~= nil then
      self.textHistoryEmpty:SetActive(not isShow)
    end
    if isShow then
      self:SortReward(historyRewardList)
      local index = 1
      for _, v in ipairs(historyRewardList) do
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

function UITreasureHuntNewHistoryView:RefreshCostNumContent()
  local costNum = DataCenter.ActivityTreasureHuntNewManager:GetCostNum(self.activityId)
  if 0 <= costNum then
    self.have_cost_content:SetActive(true)
    self.history_reward_root:SetSizeDeltaY(bottomContentH2)
    self.have_cost_txt1:SetLocalText("activity_dig_reward_notice_1")
    self.have_cost_txt2:SetText(costNum)
    local pickaxId = DataCenter.ActivityTreasureHuntNewManager:GetPickaxId(self.activityId)
    if pickaxId then
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(pickaxId)
      self.have_cost_img:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
    end
  else
    self.have_cost_content:SetActive(false)
    self.history_reward_root:SetSizeDeltaY(bottomContentH1)
  end
end

function UITreasureHuntNewHistoryView:OnClaimClick()
  if self.activityId == nil then
    return
  end
  local storedRewardList = DataCenter.ActivityTreasureHuntNewManager:GetCanClaimNormalRewardList(self.activityId)
  if not table.IsNullOrEmpty(storedRewardList) then
    DataCenter.ActivityTreasureHuntNewManager:RequestClaimStoredReward(self.activityId)
  end
end

function UITreasureHuntNewHistoryView:ClearStoredRewardScroll()
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

function UITreasureHuntNewHistoryView:ClearHistoryRewardScroll()
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

function UITreasureHuntNewHistoryView:ComponentDestroy()
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

function UITreasureHuntNewHistoryView:OnInfoUpdate()
  self:UpdateUI(true)
end

function UITreasureHuntNewHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTreasureHuntNewActivityInfoUpdated, self.OnInfoUpdate)
end

function UITreasureHuntNewHistoryView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActivityTreasureHuntNewActivityInfoUpdated, self.OnInfoUpdate)
end

function UITreasureHuntNewHistoryView:SortReward(rewardData)
  local function GetFirstLevelTemplateParaData()
    if self.activityId ~= nil then
      local template = DataCenter.ActivityTreasureHuntNewManager:GetDigTemplateByActivityId(self.activityId)
      
      if template ~= nil then
        local paramTemplateList = DataCenter.ActivityTreasureHuntNewManager:GetDigParamTemplateDic(self.activityId)
        if paramTemplateList then
          for i, v in ipairs(paramTemplateList) do
            if v.level == 1 then
              return v
            end
          end
        end
      end
    end
  end
  
  local progressBigRewardList = {}
  local template = DataCenter.ActivityTreasureHuntNewManager:GetDigTemplateByActivityId(self.activityId)
  if template ~= nil and not table.IsNullOrEmpty(template.bigRewardPreviewDict) then
    for i = 1, #template.bigRewardPreviewDict do
      local bigRewardData = template.bigRewardPreviewDict[i]
      if not table.IsNullOrEmpty(bigRewardData) then
        local data = {
          level = bigRewardData.level,
          itemId = checknumber(bigRewardData.itemId)
        }
        table.insert(progressBigRewardList, data)
      end
    end
  end
  local levelBigRewardList = {}
  local firstLevelTemplateParaData = GetFirstLevelTemplateParaData()
  if firstLevelTemplateParaData ~= nil and not table.IsNullOrEmpty(firstLevelTemplateParaData.big_reward) then
    for i, v in ipairs(firstLevelTemplateParaData.big_reward) do
      local data = {
        itemId = checknumber(v.itemId),
        level = i
      }
      table.insert(levelBigRewardList, data)
    end
  end
  local levelNormalRewardList = {}
  if firstLevelTemplateParaData ~= nil and not table.IsNullOrEmpty(firstLevelTemplateParaData.rewards) then
    for i, v in ipairs(firstLevelTemplateParaData.rewards) do
      local data = {
        itemId = checknumber(v.itemId),
        level = i
      }
      table.insert(levelNormalRewardList, data)
    end
  end
  
  local function GetPriorityData(rewardData)
    local firstClass = 999
    local secondClass = 999
    for i, v in pairs(progressBigRewardList) do
      if rewardData.itemId == v.itemId then
        firstClass = 1
        secondClass = v.level
        return firstClass, secondClass
      end
    end
    for i, v in pairs(levelBigRewardList) do
      if rewardData.itemId == v.itemId then
        firstClass = 2
        secondClass = -1 * v.level
        return firstClass, secondClass
      end
    end
    for i, v in pairs(levelNormalRewardList) do
      if rewardData.itemId == v.itemId then
        firstClass = 3
        secondClass = -1 * v.level
        return firstClass, secondClass
      end
    end
    return firstClass, secondClass
  end
  
  table.sort(rewardData, function(a, b)
    local firstClassA, secondClassA = GetPriorityData(a)
    local firstClassB, secondClassB = GetPriorityData(b)
    if firstClassA ~= firstClassB then
      return firstClassA < firstClassB
    else
      return secondClassA < secondClassB
    end
  end)
end

return UITreasureHuntNewHistoryView
