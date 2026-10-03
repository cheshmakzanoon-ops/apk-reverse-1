local LWUIPlayerPackageRewardChangeView = BaseClass("LWUIPlayerPackageRewardChangeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIPlayerPackageRewardChangeDetailItemComponent = require("UI/LWUIPlayerLevelPackageRewardChange/Component/LWUIPlayerPackageRewardChangeDetailItemComponent")

function LWUIPlayerPackageRewardChangeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.giftInfo = self:GetUserData()
  self:OnOpen()
end

function LWUIPlayerPackageRewardChangeView:OnDestroy()
  EventManager:GetInstance():Broadcast(EventId.PlayerLevelPackageEntranceShow)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIPlayerPackageRewardChangeView:ComponentDefine()
  self.btnUICommonBlackMask = self:AddComponent(UIButton, "UICommonBlackMask")
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.btnLWClose = self:AddComponent(UIButton, "Root/Top/LW_Btn_Close")
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/TitleText")
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/Time/TimeText")
  self.compLine = self:AddComponent(UIBaseComponent, "Root/ScrollRect/Viewport/Content/Line")
  self.compContent = self:AddComponent(UIBaseComponent, "Root/ScrollRect/Viewport/Content")
  self.compNow = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/Now")
  self.compNext = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content/Next")
  self.animator = self:AddComponent(UIAnimator, "")
end

function LWUIPlayerPackageRewardChangeView:ComponentDestroy()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.btnUICommonBlackMask = nil
  self.btnLWClose = nil
  self.textTitle = nil
  self.textTime = nil
  self.compLine = nil
  self.compContent = nil
  self.compNow = nil
  self.compNext = nil
  self.animator = nil
end

function LWUIPlayerPackageRewardChangeView:DataDefine()
  self.giftInfo = nil
  self.curTemplate = nil
  self.nextTemplate = nil
end

function LWUIPlayerPackageRewardChangeView:DataDestroy()
  self.giftInfo = nil
  self.curTemplate = nil
  self.nextTemplate = nil
end

function LWUIPlayerPackageRewardChangeView:OnAddListener()
  base.OnAddListener(self)
end

function LWUIPlayerPackageRewardChangeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIPlayerPackageRewardChangeView:OnOpen()
  if self.giftInfo == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.curTemplate, self.nextTemplate = DataCenter.GiftPackageChangePreviewManager:GetRewardChangeShowDataByGiftInfo(self.giftInfo)
  if self.curTemplate == nil then
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshNow()
  self:RefreshNext()
  self.textTitle:SetLocalText("gift_preview_title")
  self.animator:Play("V_ui_RewardChange_in")
end

function LWUIPlayerPackageRewardChangeView:RefreshNow()
  if self.curTemplate == nil then
    return
  end
  local season = self.curTemplate:GetSeason()
  local day = self.curTemplate:GetDay()
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIPlayerLevelPackageRewardChange/LWUIPlayerPackageRewardChangeDetailItem.prefab", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compNow.transform)
    go.gameObject:SetActive(true)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.detailItemNow = self.compNow:AddComponent(LWUIPlayerPackageRewardChangeDetailItemComponent, go.name)
    self.detailItemNow:ReInit(self.curTemplate, function()
      self:TriggerRefreshLine()
    end, false, season, day)
  end)
  if season ~= nil and 0 < season then
    local seasonNum = SeasonUtil.GetSeason()
    local seasonDay = SeasonUtil.GetSeasonDay()
    self.textTime:SetLocalText("gift_preview_subtitle2", tostring(seasonNum), tostring(seasonDay))
  else
    local curOpenServerDay = UITimeManager:GetInstance():GetServerOpenDays()
    self.textTime:SetLocalText("gift_preview_time1", tostring(math.floor(curOpenServerDay)))
  end
end

function LWUIPlayerPackageRewardChangeView:RefreshNext()
  local showNext = self.nextTemplate ~= nil
  if not showNext then
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIPlayerLevelPackageRewardChange/LWUIPlayerPackageRewardChangeEmptyItem.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compNext.transform)
      go.gameObject:SetActive(true)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    end)
  else
    local season = self.nextTemplate:GetSeason()
    local day = self.nextTemplate:GetDay()
    self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIPlayerLevelPackageRewardChange/LWUIPlayerPackageRewardChangeDetailItem.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compNext.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.gameObject:SetActive(true)
      local cell = self.compNext:AddComponent(LWUIPlayerPackageRewardChangeDetailItemComponent, go.name)
      cell:ReInit(self.nextTemplate, nil, true, season, day)
    end)
  end
end

function LWUIPlayerPackageRewardChangeView:TriggerRefreshLine()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.compNow then
      local height = self.compNow.rectTransform.rect.height
      if self.compLine then
        self.compLine.rectTransform:Set_sizeDelta(height, 9)
      end
    end
  end, 0.6)
end

function LWUIPlayerPackageRewardChangeView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function LWUIPlayerPackageRewardChangeView:OnBtnLWCloseClick()
  self.ctrl:CloseSelf()
end

return LWUIPlayerPackageRewardChangeView
