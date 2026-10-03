local base = UIBaseContainer
local QuickGiftItem = BaseClass("QuickGiftItem", base)
local firstBubbleBgPath = "Assets/Main/Sprites/UI/LWUIGiftSystem/zyf_songlizujian_qipao1.png"
local bubblBgePath = "Assets/Main/Sprites/UI/LWUIGiftSystem/zyf_songlizujian_qipao2.png"
local maskAlpha = 0.85

function QuickGiftItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function QuickGiftItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function QuickGiftItem:OnEnable()
  base.OnEnable(self)
end

function QuickGiftItem:OnDisable()
  base.OnDisable(self)
end

function QuickGiftItem:ComponentDefine()
  self.bgIcon = self:AddComponent(UIImage, "bg")
  self.giftIcon = self:AddComponent(UIImage, "icon")
  self.timeText = self:AddComponent(UITextMeshProUGUIEx, "text")
  self.bgMask = self:AddComponent(UIImage, "BGMask")
  self.iconMask = self:AddComponent(UIImage, "iconMask")
  self.bgMaskBtn = self:AddComponent(UIButton, "BGMask")
  self.iconMaskBtn = self:AddComponent(UIButton, "iconMask")
  self.btn = self:AddComponent(UIButton, "btn")
  self.timeText:SetActive(false)
  self.btn:SetOnClick(function()
    self:SendGift()
  end)
  self.bgMaskBtn:SetOnClick(function()
    UIUtil.ShowTipsId("fastsendgift_tips3")
  end)
  self.iconMaskBtn:SetOnClick(function()
    UIUtil.ShowTipsId("fastsendgift_tips3")
  end)
  
  function self.timer_action()
    self:TimeUpdate()
  end
  
  self.giftIcon:SetActive(true)
  self.timeText:SetActive(false)
end

function QuickGiftItem:TimeUpdate()
  self.curTime = self.curTime - 1
  if self.curTime == 0 then
    self.timer:Stop()
    self.timer = nil
    self.timeText:SetActive(false)
  end
  self.timeText:SetText(self.curTime)
end

function QuickGiftItem:SendGift()
  local number = DataCenter.GiftSystemManager:GetGiftNum(self.giftId)
  if number and 0 < number then
    if number == 1 then
      self:SetActive(false)
    else
      self:ClickTimeCd()
    end
    if self.callBack then
      self.callBack(self.giftId)
    end
  else
    self:SetActive(false)
  end
end

function QuickGiftItem:ClickTimeCd()
  self.mask:SetActive(true)
  self.mask:SetFillAmount(1)
  self.mask.unity_image:DOFillAmount(0, self.timeCd):SetEase(CS.DG.Tweening.Ease.InOutQuad):OnComplete(function()
    self.mask:SetActive(false)
  end)
  self.timeText:SetActive(true)
  self.timeText:SetText(self.timeCd)
  self.curTime = self.timeCd
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function QuickGiftItem:ComponentDestroy()
  self.bgIcon = nil
  self.giftIcon = nil
  self.timeText = nil
  self.bgMask = nil
  self.iconMask = nil
  self.btn = nil
end

function QuickGiftItem:DataDefine()
end

function QuickGiftItem:DataDestroy()
  self:ClearGiftItemAnim()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.giftId = nil
  self.param = nil
  self.sendUid = nil
  self.callBack = nil
end

function QuickGiftItem:SetAsFirst(isFirst)
  if not self.bgIcon then
    return
  end
  if self.param and self.param.showBubbleBg then
    local path = firstBubbleBgPath
    if isFirst then
      path = firstBubbleBgPath
    else
      path = bubblBgePath
    end
    self.bgIcon:LoadSpriteAsync(path)
    self.bgMask:LoadSpriteAsyncWithCallback(path, function()
      if self.bgMask then
        self.bgMask:SetAlpha(maskAlpha)
      end
    end)
  end
end

function QuickGiftItem:SetData(giftId, param, callBack)
  if not giftId or not param then
    return
  end
  self.giftId = giftId
  self.param = param
  self.sendUid = param.playerUid
  self.callBack = callBack
  self:UpdateGift()
end

function QuickGiftItem:UpdateGift()
  self:ClearGiftItemAnim()
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.giftId)
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(template.id)
  self.giftIcon:LoadSpriteAsync(GiftSystemConst.GetIconPathNew(goods.icon_big))
  self.iconMask:SetActive(false)
  self.bgMask:SetActive(false)
  if self.param.showBubbleBg then
    if self.param.dirType == GiftSystemConst.GiftSendPanelDirection.Left then
      self.bgIcon:SetEulerAnglesXYZ(ResetEulerAngles.x, 180, ResetEulerAngles.z)
      self.bgMask:SetEulerAnglesXYZ(ResetEulerAngles.x, 180, ResetEulerAngles.z)
    else
      self.bgIcon:SetEulerAnglesXYZ(ResetEulerAngles.x, ResetEulerAngles.y, ResetEulerAngles.z)
      self.bgMask:SetEulerAnglesXYZ(ResetEulerAngles.x, ResetEulerAngles.y, ResetEulerAngles.z)
    end
    self.bgIcon:SetActive(true)
    self.mask = self.bgMask
  else
    self.bgIcon:SetActive(false)
    self.iconMask:LoadSpriteAsyncWithCallback(GiftSystemConst.GetIconPathNew(goods.icon_big), function()
      if self.iconMask then
        self.iconMask:SetAlpha(maskAlpha)
      end
    end)
    self.mask = self.iconMask
  end
  if self.param.showItemAnim then
    self:StartGiftItemAnim()
  end
  self.timeCd = self.param.itemClickCd or 3
end

function QuickGiftItem:StartGiftItemAnim()
  self.giftIcon.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  self.animTween = self.giftIcon.transform:DOScale(1.2, 0.5):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo)
end

function QuickGiftItem:ClearGiftItemAnim()
  if self.giftIcon and self.giftIcon.transform then
    self.giftIcon.transform:DOKill()
  end
  if self.mask and self.mask.unity_image then
    self.mask.unity_image:DOKill()
  end
end

return QuickGiftItem
