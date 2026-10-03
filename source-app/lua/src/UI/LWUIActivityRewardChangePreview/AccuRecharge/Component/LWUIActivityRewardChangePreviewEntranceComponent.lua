local base = UIBaseContainer
local LWUIActivityRewardChangePreviewEntranceComponent = BaseClass("LWUIActivityRewardChangePreviewEntranceComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIActivityRewardChangePreviewEntranceComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActivityRewardChangePreviewEntranceComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActivityRewardChangePreviewEntranceComponent:ComponentDefine()
  self.img = self:AddComponent(UIImage, "Image")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function LWUIActivityRewardChangePreviewEntranceComponent:ComponentDestroy()
  self.img = nil
  self.btn = nil
end

function LWUIActivityRewardChangePreviewEntranceComponent:DataDefine()
end

function LWUIActivityRewardChangePreviewEntranceComponent:DataDestroy()
end

function LWUIActivityRewardChangePreviewEntranceComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityRewardChangePreviewShowEffect, self.OnShowEffect)
end

function LWUIActivityRewardChangePreviewEntranceComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityRewardChangePreviewShowEffect, self.OnShowEffect)
  base.OnRemoveListener(self)
end

function LWUIActivityRewardChangePreviewEntranceComponent:ReInit(activityInfo, closeCallback, autoOpen, baseScore)
  self.activityInfo = activityInfo
  self.closeCallback = closeCallback
  self.baseScore = baseScore or 0
  local isShow = false
  if activityInfo ~= nil then
    local rewardChangeTemplates = DataCenter.ActivityRewardChangePreviewManager:GetRewardChangeTemplatesByActivityInfo(activityInfo)
    isShow = not table.IsNullOrEmpty(rewardChangeTemplates)
  end
  self:SetActive(isShow)
  if isShow then
    self.img:LoadSprite("Assets/Main/Sprites/UI/UIPersonalArms/wxy_junbei_liwu_btn.png")
    if autoOpen and not DataCenter.ActivityRewardChangePreviewManager:IsHasShownAnimByActivityInfo(self.activityInfo) then
      self:OnBtnClick()
    end
  end
end

function LWUIActivityRewardChangePreviewEntranceComponent:OnBtnClick()
  if self.activityInfo then
    DataCenter.ActivityRewardChangePreviewManager:SetHasShownDetailByActivityInfo(self.activityInfo)
    if self.activityInfo.type == EnumActivity.OptionalWeekCard.Type then
      if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIActivityRewardChangePreview_OptionalWeekCard) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActivityRewardChangePreview_OptionalWeekCard, {anim = true}, self.activityInfo, function(data)
          if self.closeCallback then
            self.closeCallback(data)
          end
        end, self)
      end
    elseif (self.activityInfo.type == EnumActivity.AccuRecharge.Type or self.activityInfo.type == EnumActivity.PersonalArmsNew.Type or self.activityInfo.type == EnumActivity.MonsterInvasion.Type or self.activityInfo.type == EnumActivity.TruckActivity.Type or self.activityInfo.type == EnumActivity.LuckyRoll.Type) and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIActivityRewardChangePreview_AccuRecharge) then
      local data = {}
      data.activityInfo = self.activityInfo
      data.baseScore = self.baseScore
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActivityRewardChangePreview_AccuRecharge, {anim = true}, data, function(updateShowData, newShowData)
        if self.closeCallback then
          self.closeCallback(updateShowData, newShowData)
        end
      end, self)
    end
  end
end

function LWUIActivityRewardChangePreviewEntranceComponent:OnShowEffect()
  self.fingerHandle = self:GameObjectInstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_reward_change_accu_guangqiu_glow.prefab", function(handle)
    if handle.isError or IsNull(self.transform) then
      return
    end
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(self.transform)
    transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.fingerHandle then
        self.fingerHandle:Destroy()
        self.fingerHandle = nil
      end
    end, 1)
  end)
end

return LWUIActivityRewardChangePreviewEntranceComponent
