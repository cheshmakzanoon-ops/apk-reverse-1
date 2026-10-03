local MainBuildUpgradeSuccessView = BaseClass("MainBuildUpgradeSuccessView", UIBaseView)
local UIBuildUpgradeSuccessLine = require("UI.UIBuildUpgradeSuccess.Component.UIBuildUpgradeSuccessLine")
local UICommonResItemFirstPayExpComponent = require("UI.UIFirstPay.Component.UICommonResItemFirstPayExpComponent")
local FirstPayExpRewardComponent = require("UI.UIFirstPay.Component.FirstPayExpRewardComponent")
local BuildInfoItem = require("UI.MainBuildUpgradeSuccess.Component.BuildInfoItem")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local base = UIBaseView
local first_pay_exp_reward_path = "Root/FirstPayExpRewardContent/FirstPayExpReward"

function MainBuildUpgradeSuccessView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function MainBuildUpgradeSuccessView:ComponentDefine()
  self.anim = self:AddComponent(UIAnimator, "Root")
  local aniRoot = self:AddComponent(UIBaseContainer, "Root/AniRoot")
  aniRoot.gameObject:SetActive(true)
  local aniRootNewbies = self:AddComponent(UIBaseContainer, "Root/AniRootNewbies")
  aniRootNewbies.gameObject:SetActive(false)
  self.oldLevelText = self:AddComponent(UIText, "Root/AniRoot/TopArea/TopAniRoot/OldLevelText")
  self.newLevelText = self:AddComponent(UIText, "Root/AniRoot/TopArea/TopAniRoot/NewLevelText")
  self.titleText = self:AddComponent(UIText, "Root/AniRoot/BottomArea/BottomAniRoot/CongratulationText")
  self.infoArea = self:AddComponent(UIBaseContainer, "Root/AniRoot/BottomArea/BottomAniRoot/InfoArea")
  self.reward_Content = self:AddComponent(UIBaseContainer, "Root/AniRoot/BottomArea/BottomAniRoot/itemLayout")
  self.buildList = self:AddComponent(UIScrollView, "Root/buildInfoList")
  self.unlockText = self:AddComponent(UIText, "Root/unlockTitleText")
  self.close = self:AddComponent(UIButton, "closeBtn")
  self.close:SetOnClick(function()
    local time = 0
    local abTest = DataCenter.FirstPayManager:IsBuildingUpgradeGetExpFunctionOn()
    local animAni = abTest and "UpgradePanelDisappearAni_Exp" or "UpgradePanelDisappearAni"
    local ani, t = self.anim:PlayAnimationReturnTime(animAni, 0, 0)
    time = t
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self.delay = nil
      local openData = DataCenter.FunctionOnManager:GetOpenDataByLevel(self.level)
      if openData then
        local actId = DataCenter.ActivityListDataManager:GetOpenIdByType(EnumActivity.LeadingQuestV2.Type)
        DataCenter.UIPopWindowManager:Prepend(UIWindowNames.UIFunctionOnAnim, {anim = true}, openData)
        GoToUtil.CloseAllWindows()
      else
        UIManager.Instance:DestroyWindow(UIWindowNames.MainBuildUpgradeSuccess)
      end
    end, time)
  end)
  self.buildList:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.buildList:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.titleText:SetLocalText(104201)
  self.unlockText:SetLocalText(115636)
  self.firstPayExpCpt = self:AddComponent(FirstPayExpRewardComponent, first_pay_exp_reward_path)
end

function MainBuildUpgradeSuccessView:ComponentDestroy()
  if self.reqs then
    for _, req in pairs(self.reqs) do
      req:Destroy()
    end
  end
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  if self.delay then
    self.delay:Stop()
    self.delay = nil
    UIManager.Instance:DestroyWindow(UIWindowNames.MainBuildUpgradeSuccess)
  end
  self.oldLevelText = nil
  self.newLevelText = nil
  self.titleText = nil
  self.infoArea = nil
  self.reward_Content = nil
  self.buildList = nil
  self.anim = nil
  self.close = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function MainBuildUpgradeSuccessView:ShowScroll()
  local count = #self.buildDataList
  self.buildList:SetTotalCount(count)
  if 0 < count then
    self.buildList:RefillCells()
  end
end

function MainBuildUpgradeSuccessView:ClearScroll()
  self.buildList:ClearCells()
  self.buildList:RemoveComponents(UICommonResItemFirstPayExpComponent)
end

function MainBuildUpgradeSuccessView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.buildList:AddComponent(BuildInfoItem, itemObj)
  item:ReInit(self.buildDataList[index])
end

function MainBuildUpgradeSuccessView:ReInit()
  self.buildingId, self.level, self.bUuid, self.rewards, self.curUpgradeStashExp = self:GetUserData()
  if self.buildingId == BuildingTypes.FUN_BUILD_MAIN then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.MainBuildingUpLevel, false)
  end
  self:Show()
  self.oldLevelText:SetText(self.level - 1)
  self.newLevelText:SetText(self.level)
end

function MainBuildUpgradeSuccessView:Show()
  if self.level <= 1 then
    self.ctrl:CloseSelf()
    return
  end
  self.preLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildingId, self.level - 1)
  self.curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.buildingId, self.level)
  self.buildingTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildingId)
  if self.preLevelTemplate == nil or self.curLevelTemplate == nil or self.buildingTemplate == nil then
    local abTest = DataCenter.FirstPayManager:IsBuildingUpgradeGetExpFunctionOn()
    local animAni = abTest and "Disappear_Exp" or "Disappear"
    self.anim:SetTrigger(animAni, 0, 0)
    return
  end
  local para4 = self.curLevelTemplate.para4
  self:ClearScroll()
  if not string.IsNullOrEmpty(para4) then
    self.unlockText:SetActive(true)
    self.buildDataList = string.split(para4, ";")
    self:ShowScroll()
  else
    self.unlockText:SetActive(false)
  end
  local curNums = self.curLevelTemplate.local_num
  local preNums = self.preLevelTemplate.local_num
  local maxCount = table.count(curNums)
  local diaCount = table.count(self.buildingTemplate.effect_Local_dialog)
  if maxCount > diaCount then
    maxCount = diaCount
  end
  if maxCount == 0 then
    self.ctrl:CloseSelf()
    return
  end
  local hasChangeValue = false
  for i = 1, maxCount do
    local dialog = self.buildingTemplate.effect_Local_dialog[i]
    local name = Localization:GetString(dialog)
    local type = self.buildingTemplate.effect_Local_type[i]
    local needAdd = true
    local preValue, curValue
    if type == EffectLocalType.Dialog then
      local val = DataCenter.BuildManager:GetEffectNumWithType(curNums[i], type)
      if val == nil or val == "" then
        needAdd = false
      end
      curValue = val
    else
      preValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(preNums[i]) or 0, type)
      curValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(curNums[i]) or 0, type)
      needAdd = preValue ~= curValue
    end
    if needAdd then
      hasChangeValue = true
      do
        local req = Resource:InstantiateAsync(UIAssets.UIMainBuildUpgradeSuccessCell)
        req:completed("+", function()
          if req.isError then
            return
          end
          if not self.gameObject then
            req:Destroy()
            return
          end
          CommonUtil.CallAutoArabicMirrorManually(req)
          local go = req.gameObject
          go:SetActive(true)
          go.name = "Line_" .. tostring(i)
          local tf = go.transform
          tf:SetParent(self.infoArea.transform)
          tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local item = self.infoArea:AddComponent(UIBuildUpgradeSuccessLine, go)
          item:SetData(name, preValue, curValue)
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.infoArea.transform)
          self.reqs[i] = req
        end)
      end
    end
  end
  self:ShowRewards()
  self:RefreshFirstPayExpInfo()
end

function MainBuildUpgradeSuccessView:ShowRewards()
  if not table.IsNullOrEmpty(self.rewards) then
    self.viewRewards = DataCenter.RewardManager:ReturnRewardParamForMessage(self.rewards) or {}
  else
    self.viewRewards = {}
  end
  self:CheckIsNeedInsertFirstPayExp(self.viewRewards)
  if not table.IsNullOrEmpty(self.viewRewards) then
    for i = 1, table.length(self.viewRewards) do
      local req = Resource:InstantiateAsync(UIAssets.UICommonResItemFirstPayExp)
      req:completed("+", function()
        if req.isError then
          return
        end
        if not self.gameObject then
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
        self.rewardReqs[i] = req
      end)
    end
  end
  local abTest = DataCenter.FirstPayManager:IsBuildingUpgradeGetExpFunctionOn()
  local animAni = abTest and "Appear_Exp" or "Appear"
  self.anim:SetTrigger(animAni, 0, 0)
end

function MainBuildUpgradeSuccessView:OnDeleteCell(itemObj, index)
  self.buildList:RemoveComponent(itemObj.name, BuildInfoItem)
end

function MainBuildUpgradeSuccessView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function MainBuildUpgradeSuccessView:OnEnable()
  base.OnEnable(self)
end

function MainBuildUpgradeSuccessView:OnDisable()
  base.OnDisable(self)
end

function MainBuildUpgradeSuccessView:DataDefine()
  self.reqs = {}
  self.rewardReqs = {}
  self.buildDataList = {}
  self.preLevelTemplate = nil
  self.curLevelTemplate = nil
  self.buildingTemplate = nil
end

function MainBuildUpgradeSuccessView:DataDestroy()
  self.reqs = nil
  self.rewardReqs = nil
  self.buildDataList = nil
  self.preLevelTemplate = nil
  self.curLevelTemplate = nil
  self.buildingTemplate = nil
end

function MainBuildUpgradeSuccessView:CheckIsNeedInsertFirstPayExp(rewardList)
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

function MainBuildUpgradeSuccessView:RefreshFirstPayExpInfo()
  local data = {}
  data.addExp = self.curUpgradeStashExp
  self.firstPayExpCpt:Refresh(data)
end

return MainBuildUpgradeSuccessView
