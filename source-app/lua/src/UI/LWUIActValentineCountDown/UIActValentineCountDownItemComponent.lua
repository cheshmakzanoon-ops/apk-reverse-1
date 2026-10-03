local base = UIBaseContainer
local UIActValentineCountDownItemComponent = BaseClass("UIActValentineCountDownItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIActValentineCountDownItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActValentineCountDownItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActValentineCountDownItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnTip = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnTip:SetOnClick(function()
    self:OnBtnTipClick()
  end)
end

function UIActValentineCountDownItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnTip = nil
end

function UIActValentineCountDownItemComponent:DataDefine()
end

function UIActValentineCountDownItemComponent:DataDestroy()
end

function UIActValentineCountDownItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIActValentineCountDownItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActValentineCountDownItemComponent:OnBtnTipClick()
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.TreasureBoxTimeTip)
  param.content = "Valentine_send_bp_desc_12"
  param.alignObject = self.btnTip
  param.showArrow = true
  param.preferTop = false
  param.width = 514
  param.unEnableTouchThrough = true
  param.isTitleCountDown = true
  param.contentAlignType = CS.UnityEngine.TextAnchor.MiddleLeft
  if CommonUtil.IsArabic() then
    param.contentAlignType = CS.UnityEngine.TextAnchor.MiddleRight
  end
  local activityList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ActValentineSendGift.Type)
  local endTime = 0
  if activityList and 0 < #activityList then
    endTime = activityList[1].endTime
  end
  if 0 < endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    param.time = endTime - curTime
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonSimpleTipView, {anim = true}, param)
  end
end

function UIActValentineCountDownItemComponent:ReInit()
end

return UIActValentineCountDownItemComponent
