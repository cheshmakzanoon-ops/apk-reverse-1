local base = UIBaseView
local LWUIRollTreasureShipView = BaseClass("LWUIRollTreasureShipView", base)
local UIGray = CS.UIGray
local img_title_icon_path = "root/content/Top/img_title_icon"
local txt_has_count_path = "root/content/Top/txt_has_count"
local txt_name_path = "root/content/Top/txt_name"
local txt_des_path = "root/content/Center/txt_des"
local btn_cancle_path = "root/content/Buttom/btn_cancle"
local btn_use_path = "root/content/Buttom/btn_use"
local img_icon_path = "root/content/Buttom/btn_use/cost/img_icon"
local txt_need_path = "root/content/Buttom/btn_use/cost/txt_need"
local txt_tip_path = "root/content/Center/txt_tip"
local btn_close_path = "root/btn_close"
local eff_ui_roll_lucky_path = "Eff_ui_roll_lucky"
local icon_path = "Eff_ui_roll_lucky/icon"

function LWUIRollTreasureShipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIRollTreasureShipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIRollTreasureShipView:OnEnable()
  base.OnEnable(self)
  self:InitView()
  self.animator:Play("CommonPopup_movein", 0, 0)
end

function LWUIRollTreasureShipView:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "root")
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.txt_has_count = self:AddComponent(UITextMeshProUGUIEx, txt_has_count_path)
  self.img_title_icon = self:AddComponent(UIImage, img_title_icon_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.btn_cancle = self:AddComponent(UIButton, btn_cancle_path)
  self.btn_use = self:AddComponent(UIButton, btn_use_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_need = self:AddComponent(UITextMeshProUGUIEx, txt_need_path)
  self.txt_tip = self:AddComponent(UITextMeshProUGUIEx, txt_tip_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.eff_ui_roll_lucky = self:AddComponent(UIAnimator, eff_ui_roll_lucky_path)
  self.btn_close:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_cancle:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_use:SetOnClick(BindCallback(self, self.OnClickUse))
end

function LWUIRollTreasureShipView:ComponentDestroy()
  self.animator = nil
  self.btn_close = nil
  self.txt_has_count = nil
  self.img_title_icon = nil
  self.txt_name = nil
  self.txt_des = nil
  self.btn_cancle = nil
  self.btn_use = nil
  self.img_icon = nil
  self.txt_need = nil
  self.txt_tip = nil
  self.eff_ui_roll_lucky = nil
  self.icon = nil
end

function LWUIRollTreasureShipView:DataDefine()
  self.tempData, self.eventId, self.configId = self:GetUserData()
  self.itemId = self.tempData.goods_show
  self.costCount = self.tempData:GetCostCout()
end

function LWUIRollTreasureShipView:DataDestroy()
  self.tempData = nil
  self.eventId = nil
  self.configId = nil
  self.itemId = nil
  self.costCount = nil
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

function LWUIRollTreasureShipView:OnClickUse()
  if self.tempData and not self.tempData:CanUseGoods() then
    UIUtil.ShowTipsId("season4_cave_exploration_tips_3")
    return
  end
  local hasCount = DataCenter.ItemData:GetItemCount(self.itemId) or 0
  if hasCount < self.costCount then
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, self.costCount)
    return
  end
  DataCenter.CaveExplorationManager:TryShipStep(self.eventId, self.configId)
  self.eff_ui_roll_lucky:SetActive(true)
  local flag, _dur = self.eff_ui_roll_lucky:PlayAnimationReturnTime("V_ui_roll_lucky_charms_in", 0, 0)
  self.animator:Play("CommonPopup_moveout", 0, 0)
  self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.closeTimer then
      self.closeTimer:Stop()
      self.closeTimer = nil
    end
    self.ctrl:CloseSelf()
  end, _dur)
end

function LWUIRollTreasureShipView:InitView()
  self.eff_ui_roll_lucky:SetActive(false)
  local icon = DataCenter.ItemTemplateManager:GetIconPath(self.itemId)
  self.img_title_icon:LoadSprite(icon)
  self.img_icon:LoadSprite(icon)
  self.icon:LoadSprite(icon)
  local name = DataCenter.ItemTemplateManager:GetName(self.itemId)
  self.txt_name:SetText(name)
  local hasCount = DataCenter.ItemData:GetItemCount(self.itemId) or 0
  self.txt_has_count:SetLocalText(391038, hasCount)
  self.txt_need:SetLocalText(135225, hasCount, self.costCount)
  local des = DataCenter.ItemTemplateManager:GetDes(self.itemId)
  self.txt_des:SetText(des)
  local canShowTip = not string.IsNullOrEmpty(self.tempData.other_tips)
  self.txt_tip:SetActive(canShowTip)
  if canShowTip then
    local strInfo = string.split(self.tempData.other_tips, "|")
    self.txt_tip:SetLocalText(strInfo[1], strInfo[2])
  end
  local canUse = self.tempData:CanUseGoods()
  UIGray.SetGray(self.btn_use.transform, not canUse, true)
end

return LWUIRollTreasureShipView
