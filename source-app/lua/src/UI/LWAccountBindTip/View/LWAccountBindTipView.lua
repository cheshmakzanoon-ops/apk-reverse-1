local LWAccountBindTipView = BaseClass("LWAccountBindTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local NpcPath = "Assets/Main/TextureEx/LWAccountBind/zyf_bangdingyouxiang_yindaoyuan.png"
local EffectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/Eff_ui_S_LWUIAccountBindTip.prefab"
local black_path = "black"
local npc_path = "bg/npc"
local txt_title_path = "txtTitle"
local tip_path = "tip"
local desc_path = "desc"
local btn_bind_path = "btnBind"
local txt_bind_path = "btnBind/txtBind"
local close_tip_path = "closeTip"
local cost_value_path = "CostLayout/costValue"

function LWAccountBindTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWAccountBindTipView:OnDestroy()
  self:ClearTimer()
  self:ClearEffect()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWAccountBindTipView:OnAddListener()
  base.OnAddListener(self)
end

function LWAccountBindTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWAccountBindTipView:ComponentDefine()
  self.black = self:AddComponent(UIButton, black_path)
  self.npc = self:AddComponent(UIRawImage, npc_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.tip = self:AddComponent(UITextMeshProUGUIEx, tip_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.btn_bind = self:AddComponent(UIButton, btn_bind_path)
  self.txt_bind = self:AddComponent(UITextMeshProUGUIEx, txt_bind_path)
  self.close_tip = self:AddComponent(UITextMeshProUGUIEx, close_tip_path)
  self.cost_value = self:AddComponent(UITextMeshProUGUIEx, cost_value_path)
  self.txt_title:SetText(Localization:GetString("bind_mail_plot_2"))
  self.tip:SetText(Localization:GetString("bind_mail_plot_3"))
  self.desc:SetText(Localization:GetString("bind_mail_plot_4"))
  self.txt_bind:SetText(Localization:GetString("bind_mail_plot_5"))
  self.black:SetOnClick(function()
    if self.clickClose then
      self.ctrl:TryClose()
    end
  end)
  self.btn_bind:SetOnClick(function()
    self:OnBindBtnClick()
  end)
  local path = NpcPath
  if LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen() then
    path = LuaEntry.DataConfig:TryGetStr("bind_email_alert_config", "k5")
    if string.IsNullOrEmpty(path) then
      path = NpcPath
    end
  end
  self.npc:LoadSprite(path)
  self.npc:SetNativeSize()
  local num = LuaEntry.DataConfig:TryGetNum("bind_email_alert_config", "k6")
  self.cost_value:SetText("\195\151" .. num)
end

function LWAccountBindTipView:DataDefine()
end

function LWAccountBindTipView:ComponentDestroy()
  self.black = nil
  self.npc = nil
  self.txt_title = nil
  self.tip = nil
  self.desc = nil
  self.btn_bind = nil
  self.txt_bind = nil
  self.close_tip = nil
  self.cost_value = nil
end

function LWAccountBindTipView:DataDestroy()
end

function LWAccountBindTipView:ReInit()
  local closeTime = LuaEntry.DataConfig:TryGetNum("bind_email_alert_config", "k1", 0)
  self.clickClose = true
  if 0 < closeTime then
    self.closeTime = closeTime + Time.realtimeSinceStartup
    self.close_tip:SetActive(true)
    self.close_tip:SetText(Localization:GetString("bind_mail_plot_6", math.ceil(closeTime)))
    self.clickClose = false
    self:ClearTimer()
    self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTick, self, false, false, false)
    self.timer:Start()
  else
    self.close_tip:SetActive(false)
  end
  self.EffectDelay = TimerManager:GetInstance():DelayInvoke(function()
    self:OnEffectDelay()
  end, 0.85)
end

function LWAccountBindTipView:OnEffectDelay()
  self.EffectDelay = nil
  self.effectReq = Resource:InstantiateAsync(EffectPath)
  self.effectReq:completed("+", function(req)
    if req.isError then
      return
    end
    local gameObject = req.gameObject
    local transform = gameObject.transform
    transform:SetParent(self.transform, false)
    transform:Set_localPosition(0, 0, 0)
    transform:Set_localScale(1, 1, 1)
  end)
end

function LWAccountBindTipView:OnTick()
  local remain = self.closeTime - Time.realtimeSinceStartup
  if 0 < remain then
    self.close_tip:SetText(Localization:GetString("bind_mail_plot_6", math.ceil(remain)))
  else
    self.clickClose = true
    self:ClearTimer()
    self.close_tip:SetActive(false)
  end
end

function LWAccountBindTipView:ClearTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWAccountBindTipView:ClearEffect()
  if self.EffectDelay then
    self.EffectDelay:Stop()
    self.EffectDelay = nil
  end
  if self.effectReq then
    self.effectReq:Destroy()
    self.effectReq = nil
  end
end

function LWAccountBindTipView:OnBindBtnClick()
  DataCenter.LWAccountBindTipManager:GuideToAccountBind()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

return LWAccountBindTipView
