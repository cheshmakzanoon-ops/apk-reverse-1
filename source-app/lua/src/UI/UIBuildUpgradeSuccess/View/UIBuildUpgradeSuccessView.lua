local UIBuildUpgradeSuccessView = BaseClass("UIBuildUpgradeSuccessView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIBuildUpgradeSuccessLine = require("UI.UIBuildUpgradeSuccess.Component.UIBuildUpgradeSuccessLine")
local FirstPayExpRewardComponent = require("UI.UIFirstPay.Component.FirstPayExpRewardComponent")
local UICommonResItemFirstPayExpComponent = require("UI.UIFirstPay.Component.UICommonResItemFirstPayExpComponent")
local UIAllianceHelpInfo = require("UI.UILWAlliance.UILWAlHelp.Component.UIAllianceHelpInfo")
local UICommonRewardPopUpComponent = require("UI.UICommonRewardTitle.UICommonRewardPopUpComponent")
local RewardUtil = require("Util.RewardUtil")
local reward_path = "UIGarageRefitUpgrade/UICommonRewardPopUp"
local title_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local next_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel"
local root_path = "UIGarageRefitUpgrade/Root"
local content_path = "UIGarageRefitUpgrade/Root/Content"
local reward_content_path = "UIGarageRefitUpgrade/Root/RewardContent"
local powerKey = "135172"
local first_pay_exp_reward_Content_path = "UIGarageRefitUpgrade/Root/FirstPayExpRewardContent"
local first_pay_exp_reward_path = "UIGarageRefitUpgrade/Root/FirstPayExpRewardContent/FirstPayExpReward"

local function PlayEffectBeforeClose(self)
  DataCenter.BuildManager.ShowUpLevelReward(self.bUuid, self.rewards)
end

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  EventManager:GetInstance():Broadcast(EventId.BuildUpgradeBonusClose)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rewardTitle = self:TryAddComponent(UICommonRewardPopUpComponent, reward_path)
  self.title_text = self:AddComponent(UIText, title_path)
  self.next_btn = self:AddComponent(UIButton, next_path)
  self.next_btn:SetOnClick(function()
    if not self.animOver then
      self.animOver = true
      if self.items and #self.items > 0 then
        for _, item in pairs(self.items) do
          item:StopAnim(true)
        end
      end
      self.rewardAnim:Play("RewardContent_idle", 0, 0)
    else
      PlayEffectBeforeClose(self)
      self.ctrl:CloseSelf()
      self.animOver = nil
    end
  end)
  self.root_anim = self:AddComponent(UIAnimator, root_path)
  self.content_go = self:AddComponent(UIBaseContainer, content_path)
  self.reward_Content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.rewardAnim = self:AddComponent(UIAnimator, reward_content_path)
  self.firstPayExpLayoutElement = self:AddComponent(UILayoutElement, first_pay_exp_reward_Content_path)
  self.firstPayExpCpt = self:AddComponent(FirstPayExpRewardComponent, first_pay_exp_reward_path)
end

local function ComponentDestroy(self)
  self.rewardTitle = nil
  self.title_text = nil
  self.next_btn = nil
  self.root_anim = nil
  self.item_anim = nil
  self.content_go = nil
  self.reward_Content = nil
  self.rewardAnim = nil
  if self.UIAllianceHelpInfoReq then
    self.UIAllianceHelpInfoReq:Destroy()
    self.UIAllianceHelpInfoReq = nil
  end
end

local function DataDefine(self)
  self.reqs = {}
  self.active = false
  self.levels = nil
  self.typeList = {}
  self.onClose = nil
  self.rewardReqs = {}
  self.items = {}
  self.animOver = nil
end

local function DataDestroy(self)
  self:ClearItems()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.delayTimer2 then
    self.delayTimer2:Stop()
    self.delayTimer2 = nil
  end
  self.animOver = nil
  self.reqs = nil
  self.active = nil
  self.levels = nil
  self.typeList = nil
  self.onClose = nil
  self.rewardReqs = nil
  self.items = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  self.active = false
  base.OnDisable(self)
end

local function ReInit(self)
  self.buildingId, self.level, self.bUuid, self.rewards, self.curUpgradeStashExp = self:GetUserData()
  self.curUpgradeStashExp = self.curUpgradeStashExp or 0
  if not table.IsNullOrEmpty(self.rewards) then
    self.viewRewards = DataCenter.RewardManager:ReturnRewardParamForMessage(self.rewards) or {}
  else
    self.viewRewards = {}
  end
  if self.buildingId == BuildingTypes.FUN_BUILD_MAIN then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.MainBuildingUpLevel, false)
  end
  self:CheckIsNeedInsertFirstPayExp(self.viewRewards)
  self:Show()
end

local function Show(self)
  if self.root_anim ~= nil then
    self.root_anim:Play("V_ui_bujianshengji_01_anim", 0, 0)
  end
  if self.level <= 1 then
    self.ctrl:CloseSelf()
    return
  end
  local preLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildingId, self.level - 1)
  local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildingId, self.level)
  local buildingTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildingId)
  if preLevelTemplate == nil or curLevelTemplate == nil or buildingTemplate == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.title_text:SetLocalText(121453, Localization:GetString(buildingTemplate.name))
  local curNums = curLevelTemplate.local_num
  local preNums = preLevelTemplate.local_num
  local maxCount = table.count(curNums)
  local diaCount = table.count(buildingTemplate.effect_Local_dialog)
  if maxCount > diaCount then
    maxCount = diaCount
  end
  if maxCount == 0 then
    self.ctrl:CloseSelf()
    return
  end
  local sortedIndices = {}
  for i = 1, #buildingTemplate.effect_Local_dialog do
    table.insert(sortedIndices, i)
  end
  local pKeyIndexInIndices
  for i, originalIdx in ipairs(sortedIndices) do
    if buildingTemplate.effect_Local_dialog[originalIdx] == powerKey then
      pKeyIndexInIndices = i
      break
    end
  end
  if pKeyIndexInIndices and 1 < pKeyIndexInIndices then
    local val = table.remove(sortedIndices, pKeyIndexInIndices)
    table.insert(sortedIndices, 1, val)
  end
  local needAnimCount = 0
  local hasChangeValue = false
  for i = 1, maxCount do
    local index = sortedIndices[i]
    local realIndex = i
    local dialog = buildingTemplate.effect_Local_dialog[index]
    local name = Localization:GetString(dialog)
    local key = dialog
    local type = buildingTemplate.effect_Local_type[index]
    local needAdd = true
    local preValue, curValue
    if type == EffectLocalType.Dialog then
      local val = DataCenter.BuildManager:GetEffectNumWithType(curNums[index], type)
      if val == nil or val == "" then
        needAdd = false
      end
      curValue = val
    else
      preValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(preNums[index]) or 0, type)
      curValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(curNums[index]) or 0, type)
      needAdd = preValue ~= curValue
    end
    if needAdd then
      needAnimCount = needAnimCount + 1
      self.allAttrItemCount = needAnimCount
      do
        local delay = needAnimCount * 0.05
        hasChangeValue = true
        local req = Resource:InstantiateAsync(UIAssets.UIBuildUpgradeSuccessCell)
        req:completed("+", function()
          if req.isError then
            return
          end
          if not self.gameObject or not self.active then
            req:Destroy()
            return
          end
          CommonUtil.CallAutoArabicMirrorManually(req)
          local go = req.gameObject
          go:SetActive(true)
          go.name = "Line_" .. tostring(realIndex)
          local tf = go.transform
          tf:SetParent(self.content_go.transform)
          tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local item = self.content_go:AddComponent(UIBuildUpgradeSuccessLine, go)
          item:SetData(name, preValue, curValue, key)
          item:DelayPlayShowAnim("UIBuildUpgradeSuccessCell_movein", delay)
          self.items[realIndex] = item
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_go.transform)
          self.reqs[realIndex] = req
        end)
      end
    end
  end
  self.reward_Content.gameObject:SetActive(false)
  local delayTime = (needAnimCount + 1) * 0.05
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.reward_Content then
      self.reward_Content.gameObject:SetActive(true)
    end
    if self.rewardAnim then
      if self.animOver then
        self.rewardAnim:Play("RewardContent_idle", 0, 0)
      else
        self.rewardAnim:Play("RewardContent_movein", 0, 0)
      end
    end
  end, delayTime)
  self.delayTimer2 = TimerManager:GetInstance():DelayInvoke(function()
    self.animOver = true
  end, 0.5)
  if not table.IsNullOrEmpty(self.viewRewards) then
    for i = 1, table.length(self.viewRewards) do
      local req = Resource:InstantiateAsync(UIAssets.UICommonResItemFirstPayExp)
      self.rewardReqs[i] = req
      req:completed("+", function()
        if req.isError then
          return
        end
        if not self.gameObject or not self.active then
          req:Destroy()
          return
        end
        CommonUtil.CallAutoArabicMirrorManually(req)
        local go = req.gameObject
        go:SetActive(true)
        go.name = "reward_" .. tostring(i)
        local tf = go.transform
        tf:SetParent(self.reward_Content.transform)
        tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local item = self.reward_Content:AddComponent(UICommonResItemFirstPayExpComponent, go)
        item:ReInit(self.viewRewards[i])
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.reward_Content.transform)
      end)
    end
  end
  self:RefreshFirstPayExpInfo()
end

local function ClearItems(self)
  if self.items then
    for _, item in pairs(self.items) do
      if item.OnRecycle then
        item:OnRecycle()
      end
    end
    self.items = {}
  end
  if self.content_go then
    self.content_go:RemoveComponents(UIBuildUpgradeSuccessLine)
  end
  if self.reqs then
    for _, req in pairs(self.reqs) do
      req:Destroy()
    end
    self.reqs = {}
  end
  if self.reward_Content then
    self.reward_Content:RemoveComponents(UICommonResItemFirstPayExpComponent)
  end
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
    self.rewardReqs = {}
  end
end

function UIBuildUpgradeSuccessView:RefreshFirstPayExpInfo()
  if not self.curUpgradeStashExp or self.curUpgradeStashExp <= 0 then
    self.firstPayExpLayoutElement:SetActive(false)
    return
  end
  self.firstPayExpLayoutElement:SetActive(true)
  if self.allAttrItemCount and self.allAttrItemCount >= 4 then
    self.firstPayExpLayoutElement:SetMinHeight(100)
  else
    self.firstPayExpLayoutElement:SetMinHeight(200)
  end
  local data = {}
  data.addExp = self.curUpgradeStashExp
  self.firstPayExpCpt:Refresh(data)
end

function UIBuildUpgradeSuccessView:CheckIsNeedInsertFirstPayExp(rewardList)
  local isUnlockExpAdd = DataCenter.FirstPayManager:IsHasBoughtFirstPay()
  if not isUnlockExpAdd then
    return
  end
  if not self.curUpgradeStashExp or self.curUpgradeStashExp <= 0 then
    return
  end
  local exExpResData = {}
  exExpResData.count = self.curUpgradeStashExp
  exExpResData.itemId = ResourceItemId.HeroExp
  exExpResData.rewardType = RewardType.RESOURCE_ITEM
  exExpResData.sortOrder = 0
  exExpResData.isShowPigMark = true
  table.insert(rewardList, exExpResData)
end

UIBuildUpgradeSuccessView.OnCreate = OnCreate
UIBuildUpgradeSuccessView.OnDestroy = OnDestroy
UIBuildUpgradeSuccessView.ComponentDefine = ComponentDefine
UIBuildUpgradeSuccessView.ComponentDestroy = ComponentDestroy
UIBuildUpgradeSuccessView.DataDefine = DataDefine
UIBuildUpgradeSuccessView.DataDestroy = DataDestroy
UIBuildUpgradeSuccessView.OnEnable = OnEnable
UIBuildUpgradeSuccessView.OnDisable = OnDisable
UIBuildUpgradeSuccessView.ReInit = ReInit
UIBuildUpgradeSuccessView.ClearItems = ClearItems
UIBuildUpgradeSuccessView.Show = Show
return UIBuildUpgradeSuccessView
