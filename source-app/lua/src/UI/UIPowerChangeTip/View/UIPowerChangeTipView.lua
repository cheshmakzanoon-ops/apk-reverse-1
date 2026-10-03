local UIPowerChangeTipView = BaseClass("UIPowerChangeTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local POWER_ICON_MAP = {
  powerAdd = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_guanqia_piaozi_zhanli_icon.png",
  heroPowerAdd = "Assets/Main/Sprites/UI/LWCommon/Sprite/mjc_zlts_fenji_icon_yingxiong.png",
  dronePowerAdd = "Assets/Main/Sprites/UI/LWCommon/Sprite/mjc_zlts_fenji_icon_wurenji.png",
  buildingPowerAdd = "Assets/Main/Sprites/UI/LWCommon/Sprite/mjc_zlts_fenji_icon_zhuangshiwu.png",
  armyPowerAdd = "Assets/Main/Sprites/UI/LWCommon/Sprite/mjc_zlts_fenji_icon_shibing.png",
  sciencePowerAdd = "Assets/Main/Sprites/UI/LWCommon/Sprite/mjc_zlts_fenji_icon_keji.png",
  dominatorPowerAdd = "Assets/Main/Sprites/UI/LWCommon/Sprite/mjc_zlts_fenji_icon_zhuzai.png",
  battleCardPowerAdd = "Assets/Main/Sprites/UI/LWCommon/Sprite/mjc_zlts_fenji_icon_zhanshukapai.png"
}

function UIPowerChangeTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIPowerChangeTipView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self:GameObjectDestroy(self.gameObject)
  base.OnDestroy(self)
end

function UIPowerChangeTipView:OnEnable()
  base.OnEnable(self)
end

function UIPowerChangeTipView:OnDisable()
  base.OnDisable(self)
end

function UIPowerChangeTipView:ComponentDefine()
  self.canvasGroup = self:AddComponent(UICanvasGroup, "PowerChangeItem")
  self.layoutObj = self:AddComponent(UIBaseComponent, "PowerChangeItem/bg/tip")
  self.layoutGroup = self.layoutObj.transform:GetComponent(typeof(CS.BidirectionalHorizontalLayoutGroup))
  self.bgImg = self:AddComponent(UIImage, "PowerChangeItem/bg/bgImg")
  self.powerChange = self:AddComponent(UIText, "PowerChangeItem/bg/tip/PowerChange")
  self.powerChangeLit = self:AddComponent(UIText, "PowerChangeItem/bg/tip/PowerChangeLit")
  self.powerIcon = self:AddComponent(UIImage, "PowerChangeItem/bg/tip/icon")
  self.effect = self:AddComponent(UIBaseComponent, "PowerChangeItem/Eff_UIPowerChangeTip_glow")
  self.animator = self:AddComponent(UIAnimator, "")
  self.currentPlayIndex = 0
  self.playData = nil
end

function UIPowerChangeTipView:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  self:ReInit()
end

function UIPowerChangeTipView:ReInit()
  self.power = self:GetUserData()
  if IsNumber(self.power) then
    self:SetDataAndPlay(self.power)
  else
    self:SetDataAndPlayNew(self.power)
  end
end

function UIPowerChangeTipView:ComponentDestroy()
  if self.playTimer then
    self.playTimer:Stop()
    self.playTimer = nil
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.layoutObj = nil
  self.layoutGroup = nil
  self.animator = nil
  self.bgImg = nil
  self.powerChange = nil
  self.powerChangeLit = nil
  self.currentPlayIndex = 0
  self.playData = nil
  self.effect = nil
end

function UIPowerChangeTipView:DataDefine()
end

function UIPowerChangeTipView:DataDestroy()
end

function UIPowerChangeTipView:SetDataAndPlay(power)
  if self.playTimer then
    self.playTimer:Stop()
    self.playTimer = nil
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if IsNull(self.transform) then
    return
  end
  local defaultIconPath = POWER_ICON_MAP.powerAdd
  self:LoadPowerIcon(defaultIconPath)
  self.transform:Set_localPosition(0, 116, 0)
  local offsetMax = self.bgImg.rectTransform.offsetMax
  local offsetMin = self.bgImg.rectTransform.offsetMin
  offsetMax.x = 0
  offsetMax.y = 0
  offsetMin.x = 0
  offsetMin.y = 0
  self.bgImg.rectTransform.offsetMax = offsetMax
  self.bgImg.rectTransform.offsetMin = offsetMin
  self.effect.transform.localScale = Vector3.one
  self.bgImg:SetAlpha(1)
  self.layoutGroup.spacing = 16
  self.animator:SetSpeed(1)
  self.powerChangeLit:SetEnable(false)
  self.powerChange:SetEnable(true)
  self.powerChange:SetText(Localization:GetString(393067) .. "+" .. string.GetFormattedSeparatorNum(power))
  self:LoadPowerIcon(POWER_ICON_MAP.powerAdd)
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.ctrl:CloseSelf()
  end, 1.6)
end

function UIPowerChangeTipView:SetDataAndPlayNew(data)
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.playTimer then
    self.playTimer:Stop()
    self.playTimer = nil
  end
  self.playData = data
  self.currentPlayIndex = 1
  self:PlayNextItem()
end

function UIPowerChangeTipView:PlayNextItem()
  if IsNull(self.transform) then
    return
  end
  if not self.playData or self.currentPlayIndex > #self.playData then
    self.ctrl:CloseSelf()
    self.currentPlayIndex = 0
    self.playData = nil
    return
  end
  local item = self.playData[self.currentPlayIndex]
  if 0 >= item.value then
    self.currentPlayIndex = self.currentPlayIndex + 1
    self:PlayNextItem()
    return
  end
  self.transform:Set_localPosition(0, 116, 0)
  local iconPath = POWER_ICON_MAP[item.key] or POWER_ICON_MAP.powerAdd
  self:LoadPowerIcon(iconPath)
  if item.key == "powerAdd" then
    local offsetMax = self.bgImg.rectTransform.offsetMax
    local offsetMin = self.bgImg.rectTransform.offsetMin
    offsetMax.x = 0
    offsetMax.y = 0
    offsetMin.x = 0
    offsetMin.y = 0
    self.bgImg.rectTransform.offsetMax = offsetMax
    self.bgImg.rectTransform.offsetMin = offsetMin
    self.effect.transform.localScale = Vector3.one
    self.bgImg:SetAlpha(1)
    self.layoutGroup.spacing = 16
    self.animator:SetSpeed(1)
    self.powerChangeLit:SetEnable(false)
    self.powerChange:SetEnable(true)
    self.powerChange:SetText(Localization:GetString(393067) .. "+" .. string.GetFormattedSeparatorNum(item.value))
  else
    local offsetMax = self.bgImg.rectTransform.offsetMax
    local offsetMin = self.bgImg.rectTransform.offsetMin
    offsetMax.x = -80
    offsetMax.y = -10
    offsetMin.x = 80
    offsetMin.y = 10
    self.bgImg.rectTransform.offsetMax = offsetMax
    self.bgImg.rectTransform.offsetMin = offsetMin
    self.effect.transform.localScale = Vector3.New(0.6, 0.6, 1)
    self.bgImg:SetAlpha(0.8)
    self.layoutGroup.spacing = -2
    self.animator:SetSpeed(1.5)
    self.powerChange:SetEnable(false)
    self.powerChangeLit:SetEnable(true)
    self.powerChangeLit:SetText(Localization:GetString(393067) .. "+" .. string.GetFormattedSeparatorNum(item.value))
  end
  self.animator:Play("UIPowerChangeTip_movein", 0, 0)
  self.playTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.currentPlayIndex = self.currentPlayIndex + 1
    self:PlayNextItem()
  end, 1.6)
end

function UIPowerChangeTipView:LoadPowerIcon(iconPath)
  if not self.powerIcon or IsNull(self.powerIcon.gameObject) or not iconPath then
    return
  end
  self.powerIcon:LoadSprite(iconPath)
end

return UIPowerChangeTipView
