local UILimitDropTipView = BaseClass("UILimitDropTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DISAPPEAR_TIME = 2
local FADE_IN_OUT_TIME = 0.5
local NUM_ROLL_TIME = 1

function UILimitDropTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.serverData = DataCenter.ActLimitedTimeFeastData:PopFirstLimitDropData()
  if not self.serverData then
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshView()
end

function UILimitDropTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILimitDropTipView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgItemIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textProgressInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.canvasGroupRoot = self.viewSkin:AddComponent(self, UICanvasGroup, 4)
  self.simpleAnimationUILimitDropTip = self.viewSkin:AddComponent(self, UISimpleAnimation, 5)
  self.imgBG = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textDesc:SetLocalText("drop_item_numupdate_desc1")
end

function UILimitDropTipView:ComponentDestroy()
  self.viewSkin = nil
  self.imgItemIcon = nil
  self.textDesc = nil
  self.textProgressInfo = nil
  self.canvasGroupRoot = nil
  self.simpleAnimationUILimitDropTip = nil
  self.imgBG = nil
  if self.fadeOutTimer then
    self.fadeOutTimer:Stop()
    self.fadeOutTimer = nil
  end
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  if self.numRollTween then
    self.numRollTween:Kill()
    self.numRollTween = nil
  end
end

function UILimitDropTipView:DataDefine()
end

function UILimitDropTipView:DataDestroy()
end

function UILimitDropTipView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActLimitedTimeFeastTipViewUpdate, self.OnActLimitedTimeFeastDataUpdate)
end

function UILimitDropTipView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActLimitedTimeFeastTipViewUpdate, self.OnActLimitedTimeFeastDataUpdate)
end

function UILimitDropTipView:RefreshView()
  if not self.serverData then
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshItem()
  self:RefreshProgress()
  self:StartAutoHide()
end

function UILimitDropTipView:RefreshItem()
  if not self.serverData.itemId then
    return
  end
  local itemId = toInt(self.serverData.itemId)
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(itemId)
  self.imgItemIcon:LoadSpriteAsync(iconPath)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if template then
    self.imgBG:LoadSpriteAsync(DataCenter.ItemTemplateManager:GetToolBgByColor(template.color))
  end
end

function UILimitDropTipView:RefreshProgress()
  local curProgressVal = self.serverData.dayGroupCurNum
  local curProgress = string.format("<size=54><color=#5fef87>%s</color></size>", curProgressVal)
  local maxProgressVal = self.serverData.dayGroupLimit
  local maxProgress = string.format("<size=30>%s</size>", maxProgressVal)
  self.textProgressInfo:SetLocalText(135225, curProgress, maxProgress)
end

function UILimitDropTipView:PopNextInfoItem()
  self.serverData = DataCenter.ActLimitedTimeFeastData:PopFirstLimitDropData()
  self:RefreshView()
end

function UILimitDropTipView:StartAutoHide()
  if self.fadeOutTimer then
    self.fadeOutTimer:Stop()
    self.fadeOutTimer = nil
  end
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  self.fadeOutTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.fadeOutTimer = nil
    local isExistCacheTip = self:IsExistCacheTip()
    if not isExistCacheTip then
      self.simpleAnimationUILimitDropTip:Play("FadeOut")
      self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.ctrl:CloseSelf()
        self.closeTimer = nil
      end, FADE_IN_OUT_TIME)
    else
      if self.simpleAnimationUILimitDropTip:IsPlaying("FadeIn") then
        self.simpleAnimationUILimitDropTip:Rewind("FadeIn")
      else
        self.simpleAnimationUILimitDropTip:Play("FadeIn")
      end
      self:PopNextInfoItem()
    end
  end, DISAPPEAR_TIME)
end

function UILimitDropTipView:IsExistCacheTip()
  local remainCacheTipDataDic = DataCenter.ActLimitedTimeFeastData:GetCurLimitDropCacheDic()
  if not remainCacheTipDataDic or table.count(remainCacheTipDataDic) <= 0 then
    return false
  end
  return true
end

function UILimitDropTipView:OnActLimitedTimeFeastDataUpdate()
  if not self.closeTimer then
    return
  end
  if self.simpleAnimationUILimitDropTip:IsPlaying("FadeIn") then
    self.simpleAnimationUILimitDropTip:Rewind("FadeIn")
  else
    self.simpleAnimationUILimitDropTip:Play("FadeIn")
  end
  self:PopNextInfoItem()
end

return UILimitDropTipView
