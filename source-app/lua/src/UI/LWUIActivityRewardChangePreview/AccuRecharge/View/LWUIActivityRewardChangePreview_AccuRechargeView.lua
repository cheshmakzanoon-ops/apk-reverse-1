local LWUIActivityRewardChangePreview_AccuRechargeView = BaseClass("LWUIActivityRewardChangePreview_AccuRechargeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIActivityRewardChangePreview_AccuRechargeUpdateItem = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreview_AccuRechargeUpdateItem")
local LWUIActivityRewardChangePreview_AccuRechargeNewItem = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreview_AccuRechargeNewItem")
local LWUIActivityRewardChangePreview_AccuRecharge_Title = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreview_AccuRecharge_Title")
local LWUIActivityRewardChangePreview_AccuRecharge_Tips = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreview_AccuRecharge_Tips")

function LWUIActivityRewardChangePreview_AccuRechargeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.data, self.closeCallback, self.flyTarget = self:GetUserData()
  self.activityInfo = self.data.activityInfo
  self.baseScore = self.data.baseScore or 0
  self:OnOpen()
end

function LWUIActivityRewardChangePreview_AccuRechargeView:OnDestroy()
  if self.closeCallback and self.activityInfo then
    local updateShowData, newShowData
    if self.isPlayAnim then
      updateShowData = self.ctrl:GetUpdateShowData(self.activityInfo, self.updateTemplates)
      newShowData = self.ctrl:GetNewShowData(self.activityInfo, self.newTemplates)
    else
      local playUpdateTemplates = {}
      if self.updateTemplates then
        for i, v in ipairs(self.updateTemplates) do
          if v.config1 == 1 then
            table.insert(playUpdateTemplates, v)
          end
        end
      end
      local playNewTemplates = {}
      if self.newTemplates then
        for i, v in ipairs(self.newTemplates) do
          if v.config1 == 1 then
            table.insert(playNewTemplates, v)
          end
        end
      end
      updateShowData = self.ctrl:GetUpdateShowData(self.activityInfo, playUpdateTemplates)
      newShowData = self.ctrl:GetNewShowData(self.activityInfo, playNewTemplates)
    end
    self.closeCallback(updateShowData, newShowData)
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_AccuRechargeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.btnLWClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textConfirm = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.animatorLWUIActivityRewardChangePreviewAccuRecharge = self.viewSkin:AddComponent(self, UIAnimator, 6)
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compScrollRect = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compUpdateTitleContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compUpdateRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compUpdateTipsContent = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compNewTitleContent = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.compNewRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.compNewTipsContent = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.textConfirm:SetLocalText("activity_rewardchange_btn")
end

function LWUIActivityRewardChangePreview_AccuRechargeView:ComponentDestroy()
  self.compRoot.transform.offsetMax = Vector2.New(self.compRoot.transform.offsetMax.x, 0)
  self.compRoot.transform.offsetMin = Vector2.New(self.compRoot.transform.offsetMin.x, 0)
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.compContent = nil
  self.btnLWClose = nil
  self.btnConfirm = nil
  self.textConfirm = nil
  self.animatorLWUIActivityRewardChangePreviewAccuRecharge = nil
  self.compRoot = nil
  self.compScrollRect = nil
  self.compUpdateTitleContent = nil
  self.compUpdateRewardContent = nil
  self.compUpdateTipsContent = nil
  self.compNewTitleContent = nil
  self.compNewRewardContent = nil
  self.compNewTipsContent = nil
end

function LWUIActivityRewardChangePreview_AccuRechargeView:DataDefine()
  self.newTemplates = nil
  self.updateTemplates = nil
  self.isClosing = false
  self.closeCallback = nil
  self.contentHeight = 60
  self.isPlayAnim = false
  self.newTemplatesDailyAct = nil
  self.updateTemplatesDailyAct = nil
end

function LWUIActivityRewardChangePreview_AccuRechargeView:DataDestroy()
  if self.delayCloseTimer then
    self.delayCloseTimer:Stop()
    self.delayCloseTimer = nil
  end
  self.newTemplates = nil
  self.updateTemplates = nil
  self.isClosing = nil
  self.contentHeight = nil
  self.isPlayAnim = nil
  self.newTemplatesDailyAct = nil
  self.updateTemplatesDailyAct = nil
end

function LWUIActivityRewardChangePreview_AccuRechargeView:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_AccuRechargeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_AccuRechargeView:OnOpen()
  self.newTemplates = DataCenter.ActivityRewardChangePreviewManager:GetRewardChangeTemplatesByChangeType(self.activityInfo, DataCenter.ActivityRewardChangePreviewManager.ChangeType.New)
  self.updateTemplates = DataCenter.ActivityRewardChangePreviewManager:GetRewardChangeTemplatesByChangeType(self.activityInfo, DataCenter.ActivityRewardChangePreviewManager.ChangeType.Update)
  self.newTemplatesDailyAct = DataCenter.ActivityRewardChangePreviewManager:GetRewardChangeTemplatesByChangeType(self.activityInfo, DataCenter.ActivityRewardChangePreviewManager.ChangeType.DailyAct_New)
  self.updateTemplatesDailyAct = DataCenter.ActivityRewardChangePreviewManager:GetRewardChangeTemplatesByChangeType(self.activityInfo, DataCenter.ActivityRewardChangePreviewManager.ChangeType.DailyAct_Update)
  if not table.IsNullOrEmpty(self.newTemplatesDailyAct) then
    self.newTemplates = self.newTemplatesDailyAct
  end
  if not table.IsNullOrEmpty(self.updateTemplatesDailyAct) then
    self.updateTemplates = self.updateTemplatesDailyAct
  end
  if table.IsNullOrEmpty(self.newTemplates) and table.IsNullOrEmpty(self.updateTemplates) then
    self.ctrl:CloseSelf()
    return
  end
  self.isPlayAnim = not DataCenter.ActivityRewardChangePreviewManager:IsHasShownAnimByActivityInfo(self.activityInfo)
  self:RefreshUpdateContent(self.isPlayAnim)
  self:RefreshNewContent(self.isPlayAnim)
  self:RefreshRootSize()
  if self.isPlayAnim then
    DataCenter.ActivityRewardChangePreviewManager:SetHasShownAnimByActivityInfo(self.activityInfo)
  end
  self.animatorLWUIActivityRewardChangePreviewAccuRecharge:Play("LWUIActivityRewardChangePreview_AccuRechargeBgIn")
end

function LWUIActivityRewardChangePreview_AccuRechargeView:RefreshUpdateContent(showAnim)
  local showUpdate = not table.IsNullOrEmpty(self.updateTemplates)
  if not showUpdate then
    return
  end
  local changeType = self.updateTemplates[1] and tonumber(self.updateTemplates[1].change_type)
  local isRewardUpdateS4 = changeType == DataCenter.ActivityRewardChangePreviewManager.ChangeType.DailyAct_Update
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/AccuRecharge/LWUIActivityRewardChangePreview_AccuRecharge_UpdateTitle.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compUpdateTitleContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local model = self.compUpdateTitleContent:AddComponent(LWUIActivityRewardChangePreview_AccuRecharge_Title, go.name)
    if isRewardUpdateS4 then
      model:ReInit(Localization:GetString("s4_reward_change_title"))
    else
      model:ReInit(Localization:GetString("activity_rewardchange_subtitle1"))
    end
    model:PlayIn(showAnim)
  end)
  self.contentHeight = self.contentHeight + 120
  local showData = self.ctrl:GetUpdateShowData(self.activityInfo, self.updateTemplates)
  local scoreIcon = self.ctrl:GetScoreIconPath(self.activityInfo)
  for i, v in ipairs(showData) do
    local needScore = v.score + self.baseScore or 0
    self:__CreateOneUpdateItem(needScore, scoreIcon, v.preRewardData, v.newRewardData, i, showAnim, v.dontShowIconNativeSize)
    self.contentHeight = self.contentHeight + 110
  end
  local tipsText = Localization:GetString("activity_rewardchange_rechargedesc1")
  if isRewardUpdateS4 then
    if self.activityInfo.type == EnumActivity.TruckActivity.Type then
      tipsText = Localization:GetString("s4_alliance_train_reward_change_desc")
    else
      tipsText = Localization:GetString("s4_reward_change_desc")
    end
  else
    for i, v in ipairs(self.updateTemplates) do
      if tonumber(v.type_para1) == 0 then
        tipsText = Localization:GetString("activity_rewardchange_rechargedesc2")
        break
      end
    end
  end
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/AccuRecharge/LWUIActivityRewardChangePreview_AccuRecharge_Tips.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compUpdateTipsContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local model = self.compUpdateTipsContent:AddComponent(LWUIActivityRewardChangePreview_AccuRecharge_Tips, go.name)
    model:ReInit(tipsText)
    if showAnim then
      model:PlayIn()
    end
  end)
  self.contentHeight = self.contentHeight + 80
end

function LWUIActivityRewardChangePreview_AccuRechargeView:RefreshNewContent(showAnim)
  local showNew = not table.IsNullOrEmpty(self.newTemplates)
  if not showNew then
    return
  end
  local changeType = self.newTemplates[1] and tonumber(self.newTemplates[1].change_type)
  local isRewardNewS4 = changeType == DataCenter.ActivityRewardChangePreviewManager.ChangeType.DailyAct_New
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/AccuRecharge/LWUIActivityRewardChangePreview_AccuRecharge_NewTitle.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compNewTitleContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local model = self.compNewTitleContent:AddComponent(LWUIActivityRewardChangePreview_AccuRecharge_Title, go.name)
    if isRewardNewS4 then
      model:ReInit(Localization:GetString("s4_reward_add_title"))
    else
      model:ReInit(Localization:GetString("activity_rewardchange_subtitle2"))
    end
    model:PlayIn(showAnim)
  end)
  self.contentHeight = self.contentHeight + 110
  local showData = self.ctrl:GetNewShowData(self.activityInfo, self.newTemplates)
  local scoreIcon = self.ctrl:GetScoreIconPath(self.activityInfo)
  for i, v in ipairs(showData) do
    local scoreIconPath = v.scoreIconPath or scoreIcon
    local useImgNativeSize = v.scoreIconPath == nil
    self:__CreateOneNewItem(v.score, scoreIconPath, v.rewardData, i, showAnim, useImgNativeSize, v.hideStage)
    self.contentHeight = self.contentHeight + 110
  end
  local tipsText = Localization:GetString("activity_rewardchange_rechargedesc1")
  if isRewardNewS4 then
    tipsText = Localization:GetString("s4_reward_add_desc")
  else
    for i, v in ipairs(self.newTemplates) do
      if tonumber(v.type_para1) == 0 then
        tipsText = Localization:GetString("activity_rewardchange_rechargedesc2")
        break
      end
    end
  end
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/AccuRecharge/LWUIActivityRewardChangePreview_AccuRecharge_Tips.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compNewTipsContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local model = self.compNewTipsContent:AddComponent(LWUIActivityRewardChangePreview_AccuRecharge_Tips, go.name)
    model:ReInit(tipsText)
    if showAnim then
      model:PlayIn()
    end
  end)
  self.contentHeight = self.contentHeight + 80
end

function LWUIActivityRewardChangePreview_AccuRechargeView:__CreateOneUpdateItem(score, scoreIcon, preReward, newReward, index, showAnim)
  local prefabPath
  if not table.IsNullOrEmpty(self.updateTemplatesDailyAct) then
    prefabPath = "Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/AccuRecharge/LWUIActivityRewardChangePreview_DailyAct_UpdateItem.prefab"
  else
    prefabPath = "Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/AccuRecharge/LWUIActivityRewardChangePreview_AccuRecharge_UpdateItem.prefab"
  end
  self:GameObjectInstantiateAsync(prefabPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compUpdateRewardContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = tostring(index)
    go.name = nameStr
    local model = self.compUpdateRewardContent:AddComponent(LWUIActivityRewardChangePreview_AccuRechargeUpdateItem, nameStr)
    local dontSetScore = not table.IsNullOrEmpty(self.updateTemplatesDailyAct)
    model:ReInit(score, scoreIcon, preReward, newReward, dontSetScore)
    model:PlayIn(showAnim)
  end)
end

function LWUIActivityRewardChangePreview_AccuRechargeView:__CreateOneNewItem(score, scoreIcon, reward, index, showAnim, useImgNativeSize, isHideStage)
  local prefabPath
  if isHideStage then
    prefabPath = "Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/AccuRecharge/LWUIActivityRewardChangePreview_DailyAct_NewItem.prefab"
  else
    prefabPath = "Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/AccuRecharge/LWUIActivityRewardChangePreview_AccuRecharge_NewItem.prefab"
  end
  self:GameObjectInstantiateAsync(prefabPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compNewRewardContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = tostring(index)
    go.name = nameStr
    local model = self.compNewRewardContent:AddComponent(LWUIActivityRewardChangePreview_AccuRechargeNewItem, nameStr)
    model:ReInit(score, scoreIcon, reward, useImgNativeSize)
    if showAnim then
      model:PlayIn()
    end
  end)
end

function LWUIActivityRewardChangePreview_AccuRechargeView:DoClose()
  if self.isClosing then
    return
  end
  if not self.isPlayAnim then
    self.ctrl:CloseSelf()
  else
    self.animatorLWUIActivityRewardChangePreviewAccuRecharge:Play("LWUIActivityRewardChangePreview_AccuRechargeBgOut")
    self.delayCloseTimer = TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActivityRewardChangePreview_AccuRecharge, {anim = false})
    end, 1.5)
    self.isClosing = true
    if IsNotNull(self.flyTarget) and IsNotNull(self.flyTarget.gameObject) then
      local effectPath = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_reward_change_accu_guangqiu.prefab"
      local startPos = self.compScrollRect.transform.position
      local endPos = self.flyTarget.transform.position
      UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, 0.5, nil, function()
        EventManager:GetInstance():Broadcast(EventId.ActivityRewardChangePreviewShowEffect)
      end)
    end
  end
end

function LWUIActivityRewardChangePreview_AccuRechargeView:RefreshRootSize()
  local fullHeight = self.compScrollRect.rectTransform.rect.height
  if fullHeight > self.contentHeight then
    local heightDelta = fullHeight - self.contentHeight
    self.compRoot.transform.offsetMax = Vector2.New(self.compRoot.transform.offsetMax.x, -1 * heightDelta / 3)
    self.compRoot.transform.offsetMin = Vector2.New(self.compRoot.transform.offsetMin.x, heightDelta / 3 * 2)
  end
end

function LWUIActivityRewardChangePreview_AccuRechargeView:OnBtnUICommonBlackMaskClick()
  self:DoClose()
end

function LWUIActivityRewardChangePreview_AccuRechargeView:OnBtnLWCloseClick()
  self:DoClose()
end

function LWUIActivityRewardChangePreview_AccuRechargeView:OnBtnConfirmClick()
  self:DoClose()
end

return LWUIActivityRewardChangePreview_AccuRechargeView
