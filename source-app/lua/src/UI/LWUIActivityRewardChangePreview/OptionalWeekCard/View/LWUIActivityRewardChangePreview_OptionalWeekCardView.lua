local LWUIActivityRewardChangePreview_OptionalWeekCardView = BaseClass("LWUIActivityRewardChangePreview_OptionalWeekCardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent = require("UI/LWUIActivityRewardChangePreview/OptionalWeekCard/Component/LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent")
local LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent = require("UI/LWUIActivityRewardChangePreview/OptionalWeekCard/Component/LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent")
local LWUIActivityRewardChangePreview_OptionalWeekCard_Title = require("UI/LWUIActivityRewardChangePreview/OptionalWeekCard/Component/LWUIActivityRewardChangePreview_OptionalWeekCard_Title")
local LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle = require("UI/LWUIActivityRewardChangePreview/OptionalWeekCard/Component/LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle")
local LWUIActivityRewardChangePreview_OptionalWeekCard_Tips = require("UI/LWUIActivityRewardChangePreview/OptionalWeekCard/Component/LWUIActivityRewardChangePreview_OptionalWeekCard_Tips")
LWUIActivityRewardChangePreview_OptionalWeekCardView.Class = {Normal = 1, Advance = 2}
LWUIActivityRewardChangePreview_OptionalWeekCardView.RewardType = {Must = 1, Select = 2}

function LWUIActivityRewardChangePreview_OptionalWeekCardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityInfo, self.closeCallback, self.flyTarget = self:GetUserData()
  self:OnOpen()
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:OnDestroy()
  if self.closeCallback and self.activityInfo then
    local callbackData
    if self.isPlayAnim then
      callbackData = self.ctrl:GetCloseShowEffectData(self.updateTemplates, self.newTemplates)
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
      callbackData = self.ctrl:GetCloseShowEffectData(playUpdateTemplates, playNewTemplates)
    end
    self.closeCallback(callbackData)
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:ComponentDefine()
  self.btnUICommonBlackMask = self:AddComponent(UIButton, "UICommonBlackMask")
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.btnLWClose = self:AddComponent(UIButton, "Root/LW_Btn_Close")
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.btnConfirm = self:AddComponent(UIButton, "Root/ConfirmBtn")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textConfirm = self:AddComponent(UITextMeshProUGUIEx, "Root/ConfirmBtn/LW_Btn_Common_New_Base/ConfirmText")
  self.compContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content")
  self.animatorLWUIActivityRewardChangePreviewOptionalWeekCard = self:AddComponent(UIAnimator, "")
  self.compRoot = self:AddComponent(UIBaseComponent, "Root")
  self.compScrollRect = self:AddComponent(UIBaseComponent, "Root/ScrollRect")
  self.compUpdateTitleContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/UpdateTitleContent")
  self.compUpdateNormalTitleContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/UpdateNormalTitleContent")
  self.compUpdateAdvanceTitleContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/UpdateAdvanceTitleContent")
  self.compNewTitleContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/NewTitleContent")
  self.compUpdateNormalMustContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/UpdateNormalMustContent")
  self.compUpdateNormalSelectContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/UpdateNormalSelectContent")
  self.compUpdateAdvanceMustContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/UpdateAdvanceMustContent")
  self.compUpdateAdvanceSelectContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/UpdateAdvanceSelectContent")
  self.compNewNormalTitleContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/NewNormalTitleContent")
  self.compNewNormalMustContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/NewNormalMustContent")
  self.compNewNormalSelectContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/NewNormalSelectContent")
  self.compNewAdvanceSelectContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/NewAdvanceSelectContent")
  self.compNewAdvanceTitleContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/NewAdvanceTitleContent")
  self.compNewAdvanceMustContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/NewAdvanceMustContent")
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:ComponentDestroy()
  self.compRoot.transform.offsetMax = Vector2.New(self.compRoot.transform.offsetMax.x, 0)
  self.compRoot.transform.offsetMin = Vector2.New(self.compRoot.transform.offsetMin.x, 0)
  self.btnUICommonBlackMask = nil
  self.btnLWClose = nil
  self.btnConfirm = nil
  self.textConfirm = nil
  self.compContent = nil
  self.animatorLWUIActivityRewardChangePreviewOptionalWeekCard = nil
  self.compRoot = nil
  self.compScrollRect = nil
  self.compUpdateTitleContent = nil
  self.compUpdateNormalTitleContent = nil
  self.compUpdateAdvanceTitleContent = nil
  self.compNewTitleContent = nil
  self.compUpdateNormalMustContent = nil
  self.compUpdateNormalSelectContent = nil
  self.compUpdateAdvanceMustContent = nil
  self.compUpdateAdvanceSelectContent = nil
  self.compNewNormalTitleContent = nil
  self.compNewNormalMustContent = nil
  self.compNewNormalSelectContent = nil
  self.compNewAdvanceSelectContent = nil
  self.compNewAdvanceTitleContent = nil
  self.compNewAdvanceMustContent = nil
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:DataDefine()
  self.newTemplates = nil
  self.updateTemplates = nil
  self.isClosing = false
  self.contentHeight = 60
  self.isPlayAnim = false
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:DataDestroy()
  self.newTemplates = nil
  self.updateTemplates = nil
  self.isClosing = false
  self.contentHeight = nil
  self.isPlayAnim = nil
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:OnOpen()
  self.newTemplates = DataCenter.ActivityRewardChangePreviewManager:GetRewardChangeTemplatesByChangeType(self.activityInfo, DataCenter.ActivityRewardChangePreviewManager.ChangeType.New)
  self.updateTemplates = DataCenter.ActivityRewardChangePreviewManager:GetRewardChangeTemplatesByChangeType(self.activityInfo, DataCenter.ActivityRewardChangePreviewManager.ChangeType.Update)
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
  self.animatorLWUIActivityRewardChangePreviewOptionalWeekCard:Play("LWUIActivityRewardChangePreview_AccuRechargeBgIn")
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:RefreshNewContent(showAnim)
  local normalTemplate, advanceTemplate
  if not table.IsNullOrEmpty(self.newTemplates) then
    for i, v in ipairs(self.newTemplates) do
      local class = v:GetOptionalWeekCardClass()
      if class == self.Class.Normal then
        normalTemplate = v
      elseif class == self.Class.Advance then
        advanceTemplate = v
      end
    end
  end
  local isShowAny = normalTemplate ~= nil or advanceTemplate ~= nil
  if not isShowAny then
    return
  end
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/OptionalWeekCard/LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateTitle.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compNewTitleContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local model = self.compNewTitleContent:AddComponent(LWUIActivityRewardChangePreview_OptionalWeekCard_Title, go.name)
    model:ReInit("activity_rewardchange_subtitle2")
    if showAnim then
      model:PlayIn()
    end
  end)
  self.contentHeight = self.contentHeight + 110
  if normalTemplate ~= nil then
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/OptionalWeekCard/LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.compNewNormalTitleContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "new_normal_subtitle"
      local model = self.compNewNormalTitleContent:AddComponent(LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle, go.name)
      model:ReInit(Localization:GetString("giftbag_name301001"))
      if showAnim then
        model:PlayIn()
      end
    end)
    self.contentHeight = self.contentHeight + 55
    local rewardDataMustNormal = normalTemplate:GetOptionalWeekCardRewardDataMustGet()
    local rewardDataSelectNormal = normalTemplate:GetOptionalWeekCardRewardDataSelect()
    self:__RefreshSingleNewContent(rewardDataMustNormal, self.Class.Normal, self.RewardType.Must, showAnim, self.compNewNormalMustContent)
    self:__RefreshSingleNewContent(rewardDataSelectNormal, self.Class.Normal, self.RewardType.Select, showAnim, self.compNewNormalSelectContent)
  end
  if advanceTemplate ~= nil then
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/OptionalWeekCard/LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.compNewAdvanceTitleContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "new_advance_subtitle"
      local model = self.compNewAdvanceTitleContent:AddComponent(LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle, go.name)
      model:ReInit(Localization:GetString("giftbag_name301002"))
      if showAnim then
        model:PlayIn()
      end
    end)
    self.contentHeight = self.contentHeight + 55
    local rewardDataMustAdvance = advanceTemplate:GetOptionalWeekCardRewardDataMustGet()
    local rewardDataSelectAdvance = advanceTemplate:GetOptionalWeekCardRewardDataSelect()
    self:__RefreshSingleNewContent(rewardDataMustAdvance, self.Class.Advance, self.RewardType.Must, showAnim, self.compNewAdvanceMustContent)
    self:__RefreshSingleNewContent(rewardDataSelectAdvance, self.Class.Advance, self.RewardType.Select, showAnim, self.compNewAdvanceSelectContent)
  end
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:__RefreshSingleNewContent(rewardData, class, rewardType, showAnim, content)
  local isShow = rewardData ~= nil
  if not isShow then
    return
  end
  if not string.IsNullOrEmpty(rewardData.rewardsStr) then
    local rewardsStrList = string.split(rewardData.rewardsStr, ",")
    for i, v in ipairs(rewardsStrList) do
      local index = i
      local rewardParaStrList = string.split(v, ";")
      if #rewardParaStrList == 3 then
        do
          local reward = {
            count = tonumber(rewardParaStrList[3]),
            itemId = tonumber(rewardParaStrList[2]),
            rewardType = tonumber(rewardParaStrList[1])
          }
          self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/OptionalWeekCard/LWUIActivityRewardChangePreview_OptionalWeekCard_NewItem.prefab", function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.name = tostring(index) .. "_" .. class .. "_" .. rewardType
            local model = content:AddComponent(LWUIActivityRewardChangePreview_OptionalWeekCard_NewItemComponent, tostring(index))
            model:ReInit(reward)
            if showAnim then
              model:PlayIn()
            end
          end)
          self.contentHeight = self.contentHeight + 110
        end
      end
    end
    local tipsText = Localization:GetString("activity_rewardchange_weekcarddesc1")
    if rewardType == self.RewardType.Select then
      tipsText = Localization:GetString("activity_rewardchange_weekcarddesc2")
    end
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/OptionalWeekCard/LWUIActivityRewardChangePreview_OptionalWeekCard_Tips.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "new_tips_" .. class .. "_" .. rewardType
      local model = content:AddComponent(LWUIActivityRewardChangePreview_OptionalWeekCard_Tips, go.name)
      model:ReInit(tipsText)
      if showAnim then
        model:PlayIn()
      end
    end)
    self.contentHeight = self.contentHeight + 80
  end
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:RefreshUpdateContent(showAnim)
  local normalTemplate, advanceTemplate
  if not table.IsNullOrEmpty(self.updateTemplates) then
    for i, v in ipairs(self.updateTemplates) do
      local class = v:GetOptionalWeekCardClass()
      if class == self.Class.Normal then
        normalTemplate = v
      elseif class == self.Class.Advance then
        advanceTemplate = v
      end
    end
  end
  local isShowAny = normalTemplate ~= nil or advanceTemplate ~= nil
  if not isShowAny then
    return
  end
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/OptionalWeekCard/LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateTitle.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.compUpdateTitleContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local model = self.compUpdateTitleContent:AddComponent(LWUIActivityRewardChangePreview_OptionalWeekCard_Title, go.name)
    model:ReInit(Localization:GetString("activity_rewardchange_subtitle1"))
    if showAnim then
      model:PlayIn()
    end
  end)
  self.contentHeight = self.contentHeight + 110
  if normalTemplate ~= nil then
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/OptionalWeekCard/LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.compUpdateNormalTitleContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "update_normal_subtitle"
      local model = self.compUpdateNormalTitleContent:AddComponent(LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle, go.name)
      model:ReInit(Localization:GetString("giftbag_name301001"))
      if showAnim then
        model:PlayIn()
      end
    end)
    self.contentHeight = self.contentHeight + 55
    local rewardDataMustNormal = normalTemplate:GetOptionalWeekCardRewardDataMustGet()
    local rewardDataSelectNormal = normalTemplate:GetOptionalWeekCardRewardDataSelect()
    self:__RefreshSingleUpdateContent(rewardDataMustNormal, self.Class.Normal, self.RewardType.Must, showAnim, self.compUpdateNormalMustContent)
    self:__RefreshSingleUpdateContent(rewardDataSelectNormal, self.Class.Normal, self.RewardType.Select, showAnim, self.compUpdateNormalSelectContent)
  end
  if advanceTemplate ~= nil then
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/OptionalWeekCard/LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.compUpdateAdvanceTitleContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "update_advance_subtitle"
      local model = self.compUpdateAdvanceTitleContent:AddComponent(LWUIActivityRewardChangePreview_OptionalWeekCard_SubTitle, go.name)
      model:ReInit(Localization:GetString("giftbag_name301002"))
      if showAnim then
        model:PlayIn()
      end
    end)
    self.contentHeight = self.contentHeight + 55
    local rewardDataMustAdvance = advanceTemplate:GetOptionalWeekCardRewardDataMustGet()
    local rewardDataSelectAdvance = advanceTemplate:GetOptionalWeekCardRewardDataSelect()
    self:__RefreshSingleUpdateContent(rewardDataMustAdvance, self.Class.Advance, self.RewardType.Must, showAnim, self.compUpdateAdvanceMustContent)
    self:__RefreshSingleUpdateContent(rewardDataSelectAdvance, self.Class.Advance, self.RewardType.Select, showAnim, self.compUpdateAdvanceSelectContent)
  end
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:__RefreshSingleUpdateContent(rewardData, class, rewardType, showAnim, content)
  local isShow = rewardData ~= nil
  if not isShow then
    return
  end
  if not string.IsNullOrEmpty(rewardData.rewardsStr) then
    local rewardsStrList = string.split(rewardData.rewardsStr, ",")
    for i, v in ipairs(rewardsStrList) do
      local index = i
      local rewardParaStrList = string.split(v, "#")
      if #rewardParaStrList == 2 then
        do
          local preRewardParaStrList = string.split(rewardParaStrList[1], ";")
          local newRewardParaStrList = string.split(rewardParaStrList[2], ";")
          if #preRewardParaStrList == 3 and #newRewardParaStrList == 3 then
            local preReward = {
              count = tonumber(preRewardParaStrList[3]),
              itemId = tonumber(preRewardParaStrList[2]),
              rewardType = tonumber(preRewardParaStrList[1])
            }
            local newReward = {
              count = tonumber(newRewardParaStrList[3]),
              itemId = tonumber(newRewardParaStrList[2]),
              rewardType = tonumber(newRewardParaStrList[1])
            }
            self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/OptionalWeekCard/LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItem.prefab", function(request)
              if request.isError then
                return
              end
              local go = request.gameObject
              go:SetActive(true)
              go.transform:SetParent(content.transform)
              go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
              go.name = tostring(index) .. "_" .. class .. "_" .. rewardType
              local model = content:AddComponent(LWUIActivityRewardChangePreview_OptionalWeekCard_UpdateItemComponent, go.name)
              model:ReInit(preReward, newReward)
              if showAnim then
                model:PlayIn()
              end
            end)
            self.contentHeight = self.contentHeight + 110
          end
        end
      end
    end
    local tipsText = Localization:GetString("activity_rewardchange_weekcarddesc1")
    if rewardType == self.RewardType.Select then
      tipsText = Localization:GetString("activity_rewardchange_weekcarddesc2")
    end
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIActivityRewardChangePreview/OptionalWeekCard/LWUIActivityRewardChangePreview_OptionalWeekCard_Tips.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "update_tips_" .. class .. "_" .. rewardType
      local model = content:AddComponent(LWUIActivityRewardChangePreview_OptionalWeekCard_Tips, go.name)
      model:ReInit(tipsText)
      if showAnim then
        model:PlayIn()
      end
    end)
    self.contentHeight = self.contentHeight + 80
  end
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:RefreshRootSize()
  local fullHeight = self.compScrollRect.rectTransform.rect.height
  if fullHeight > self.contentHeight then
    local heightDelta = fullHeight - self.contentHeight
    self.compRoot.transform.offsetMax = Vector2.New(self.compRoot.transform.offsetMax.x, -1 * heightDelta / 3)
    self.compRoot.transform.offsetMin = Vector2.New(self.compRoot.transform.offsetMin.x, heightDelta / 3 * 2)
  end
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:DoClose()
  if self.isClosing then
    return
  end
  if not self.isPlayAnim then
    self.ctrl:CloseSelf()
  else
    self.animatorLWUIActivityRewardChangePreviewOptionalWeekCard:Play("LWUIActivityRewardChangePreview_AccuRechargeBgOut")
    self.delayCloseTimer = TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActivityRewardChangePreview_OptionalWeekCard, {anim = false})
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

function LWUIActivityRewardChangePreview_OptionalWeekCardView:OnBtnUICommonBlackMaskClick()
  self:DoClose()
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:OnBtnLWCloseClick()
  self:DoClose()
end

function LWUIActivityRewardChangePreview_OptionalWeekCardView:OnBtnConfirmClick()
  self:DoClose()
end

return LWUIActivityRewardChangePreview_OptionalWeekCardView
