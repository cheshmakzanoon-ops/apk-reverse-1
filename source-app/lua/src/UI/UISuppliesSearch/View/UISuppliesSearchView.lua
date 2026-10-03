local UISuppliesSearchView = BaseClass("UISuppliesSearchView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UISuppliesSearchView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UISuppliesSearchView:OnEnable()
  base.OnEnable(self)
  self:Refresh()
end

function UISuppliesSearchView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISuppliesSearchView:ComponentDefine()
  self.btnPanelBg = self:AddComponent(UIButton, "panelBg")
  self.btnPanelBg:SetOnClick(function()
    self:OnBtnPanelBgClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "textTitle")
  self.textLevelName = self:AddComponent(UITextMeshProUGUIEx, "textLevelName")
  self.textContent = self:AddComponent(UITextMeshProUGUIEx, "textContent")
  self.rewardObj = self:AddComponent(UIBaseComponent, "Content/rewardObj")
  self.rewardContent = self:AddComponent(UIBaseContainer, "Content/rewardObj/ScrollView/Viewport/Content")
  self.textEmpty = self:AddComponent(UITextMeshProUGUIEx, "Content/textEmpty")
  self.btnBack = self:AddComponent(UIButton, "btnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnCollect = self:AddComponent(UIButton, "btnLayout/btnCollect")
  self.btnCollect:SetOnClick(function()
    self:OnBtnCollectClick()
  end)
  self.btnLeave = self:AddComponent(UIButton, "btnLayout/btnLeave")
  self.btnLeave:SetOnClick(function()
    self:OnBtnLeaveClick()
  end)
  self.item = self:AddComponent(UIBaseComponent, "Content/rewardObj/Item")
  self.textValue = self:AddComponent(UITextMeshProUGUIEx, "Content/rewardObj/valueContent/valueText")
  self.textBtnCollect = self:AddComponent(UITextMeshProUGUIEx, "btnLayout/btnCollect/textBtnCollect")
  self.textBtnLeave = self:AddComponent(UITextMeshProUGUIEx, "btnLayout/btnLeave/textBtnLeave")
  self.textSuccessRate = self:AddComponent(UITextMeshProUGUIEx, "btnLayout/btnCollect/rate/textSuccessRate")
  self.textRateDesc = self:AddComponent(UITextMeshProUGUIEx, "btnLayout/btnCollect/rate/textRateDesc")
  self.itemObj = self.item.gameObject
  self.itemObj:GameObjectCreatePool()
  self.successEffect = self:AddComponent(UIVfx, "Content/rewardObj/effectSuccess", VfxAssets.SuppliesSuccess)
  self.failEffect = self:AddComponent(UIVfx, "Content/rewardObj/effectFail", VfxAssets.SuppliesFail)
  self.btnLayoutObj = self:AddComponent(UIBaseComponent, "btnLayout")
  self.btnLayout = self.btnLayoutObj.transform:GetComponent(typeof(CS.BidirectionalHorizontalLayoutGroup))
  self.textBtnCollect:SetLocalText("new_detect_tips_10")
  self.textBtnLeave:SetLocalText("new_detect_tips_11")
  self.textTitle:SetLocalText("new_detect_tips_8")
  self.textEmpty:SetLocalText("new_detect_tips_29")
end

function UISuppliesSearchView:ComponentDestroy()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.itemObj:GameObjectRecycleAll()
  self.btnPanelBg = nil
  self.textTitle = nil
  self.textLevelName = nil
  self.textContent = nil
  self.rewardObj = nil
  self.rewardContent = nil
  self.textEmpty = nil
  self.btnBack = nil
  self.btnCollect = nil
  self.btnLeave = nil
  self.item = nil
  self.textValue = nil
  self.textBtnCollect = nil
  self.textBtnLeave = nil
  self.textSuccessRate = nil
  self.textRateDesc = nil
end

function UISuppliesSearchView:DataDefine()
  local tData = self:GetUserData()
  self.uuid = tData.uuid
  self.nSearchType = tData.type
  self.tSearchInfo = tData.suppliesSearchInfo
  self.tConfig = DataCenter.SuppliesSearchTemplateManager:GetConfigData(self.tSearchInfo.cfgId)
  self.nMaxLevel = #self.tConfig.tLevelDict
end

function UISuppliesSearchView:DataDestroy()
  self.nSearchType = nil
  self.tSearchInfo = nil
  self.uuid = nil
  self.tConfig = nil
  self.nMaxLevel = nil
end

function UISuppliesSearchView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.OnBtnBackClick)
  self:AddUIListener(EventId.OnGetSuppliesSearchResult, self.OnGetSearchResult)
end

function UISuppliesSearchView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.OnBtnBackClick)
  self:RemoveUIListener(EventId.OnGetSuppliesSearchResult, self.OnGetSearchResult)
  base.OnRemoveListener(self)
end

function UISuppliesSearchView:OnBtnPanelBgClick()
  self.ctrl.CloseSelf()
end

function UISuppliesSearchView:OnBtnBackClick()
  self.ctrl.CloseSelf()
end

function UISuppliesSearchView:OnRewardGetPanelClose()
  self.ctrl.CloseSelf()
end

function UISuppliesSearchView:Refresh()
  local nCurLevelId = self.tSearchInfo.curLevel
  self.tCurLevelCfg = self.tConfig.tLevelDict[nCurLevelId]
  self.tNextLevelCfg = self.tConfig.tLevelDict[nCurLevelId + 1]
  local nRate = self.tNextLevelCfg and self.tNextLevelCfg.nRate
  nRate = nRate or 0
  nRate = string.format("%.2f", nRate * 100)
  self.textSuccessRate:SetLocalText("new_detect_tips_38", nRate)
  local bFail = self.tSearchInfo.isFail == 1
  local bIsLevelZero = nCurLevelId == 0
  local bFinishAll = nCurLevelId == self.nMaxLevel
  local bShowCollect = not bFail and not bFinishAll
  local bShowLeave = not bIsLevelZero
  self.textLevelName:SetLocalText("new_detect_tips_28", nCurLevelId + 1)
  self.btnCollect:SetActive(bShowCollect)
  self.btnLeave:SetActive(bShowLeave)
  if bShowLeave and bShowCollect then
    self.btnLayout.padding.left = 74
  else
    self.btnLayout.padding.left = 0
  end
  if bIsLevelZero then
    self.textEmpty:SetActive(true)
    self.rewardObj.gameObject:SetActive(false)
    self.textContent:SetLocalText(self.tConfig.zeroLevelDialogId)
  else
    self.textEmpty:SetActive(false)
    self.rewardObj.gameObject:SetActive(true)
    self:RefreshReward()
    self.textContent:SetLocalText(self.tCurLevelCfg.sDialogId)
    if bFail then
      self.textValue:SetLocalText("new_detect_tips_12", self.tCurLevelCfg.nFailDiamondVal)
    else
      self.textValue:SetLocalText("new_detect_tips_12", self.tCurLevelCfg.nWinDiamondVal)
    end
  end
end

function UISuppliesSearchView:RefreshReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.itemObj:GameObjectRecycleAll()
  local bFail = self.tSearchInfo.isFail == 1
  local tRewards
  if bFail then
    tRewards = self.tCurLevelCfg.tRewardFailList
  else
    tRewards = self.tCurLevelCfg.tRewardList
  end
  for i, item in ipairs(tRewards) do
    local sName = "item_" .. i
    local obj = self.itemObj:GameObjectSpawn(self.rewardContent.transform)
    obj.name = sName
    obj:SetActive(true)
    local icon = self.rewardContent:AddComponent(UICommonResItem, sName)
    icon:ReInit(item)
  end
end

function UISuppliesSearchView:OnBtnCollectClick()
  DataCenter.SuppliesSearchManager:DoSuppliesSearch(self.nSearchType, self.uuid)
end

function UISuppliesSearchView:OnBtnLeaveClick()
  local bFail = self.tSearchInfo.isFail == 1
  local bFinishAll = self.tSearchInfo.curLevel == self.nMaxLevel
  
  local function funcLeave()
    DataCenter.SuppliesSearchManager:GetReward(self.nSearchType, self.uuid)
  end
  
  if bFail or bFinishAll then
    funcLeave()
  else
    UIUtil.ShowMessage(Localization:GetString("new_detect_tips_30"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, funcLeave)
  end
end

function UISuppliesSearchView:OnGetSearchResult(message)
  self.tSearchInfo = message.suppliesSearchInfo
  local bFail = self.tSearchInfo.isFail == 1
  self:PlayEffect(bFail)
  self:Refresh()
end

function UISuppliesSearchView:PlayEffect(bIsFail)
  if bIsFail then
    self.failEffect:Stop()
    self.failEffect:Replay()
  else
    self.successEffect:Stop()
    self.successEffect:Replay()
  end
end

return UISuppliesSearchView
