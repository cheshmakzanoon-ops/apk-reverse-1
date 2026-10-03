local Vip18DisplayPanel = BaseClass("Vip18DisplayPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local canvas_group_path = "canvasGroup"
local full_empty_btn_path = "fullEmptyBtn"
local mask_btn_path = "maskBtn"
local AnimationType = {
  Show = "show",
  Show2 = "show2",
  Show3 = "show3",
  Hide = "hide"
}
local AnimationNames = {
  Show = "Eff_VipExtendVip18PanelIn",
  Show2 = "Eff_VipExtendVip18PanelIn2",
  Show3 = "Eff_VipExtendVip18PanelIn3",
  Show4 = "Eff_VipExtendVip18PanelIn4",
  Hide = "Eff_VipExtendVip18PanelOut"
}

function Vip18DisplayPanel:OnCreate()
  base.OnCreate(self)
  self.canvas_group = self:AddComponent(UICanvasGroup, canvas_group_path)
  self.infoBtn = self:AddComponent(UIButton, "infoIcon/infoIconBtn")
  self.infoBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipExtendCitySkinProductDesc)
  end)
  self.full_empty_btn = self:AddComponent(UIButton, full_empty_btn_path)
  self.full_empty_btn:SetOnClick(function()
    self:OnClickFullEmptyBtn()
  end)
  self.mask_btn = self:AddComponent(UIButton, mask_btn_path)
  self.mask_btn:SetOnClick(function()
    self:OnClickMaskBtn()
  end)
  self.animator = self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
end

function Vip18DisplayPanel:OnDestroy()
  self.full_empty_btn = nil
  self.mask_btn = nil
  self.onNextPageClickHandler = nil
  self.onNexBubbleHandler = nil
  base.OnDestroy(self)
end

function Vip18DisplayPanel:OnEnable()
  base.OnEnable(self)
end

function Vip18DisplayPanel:OnDisable()
  base.OnDisable(self)
end

function Vip18DisplayPanel:InvokeNextPageClickHandler()
  if self.onNextPageClickHandler then
    self.onNextPageClickHandler(self.holder)
  end
end

function Vip18DisplayPanel:OnClickFullEmptyBtn()
  self:InvokeNextPageClickHandler()
  self.animator:Play(AnimationNames.Show4, -1, 0)
  self.animator:Update(0)
  TimerManager:GetInstance():DelayInvoke(function()
    if IsNull(self.gameObject) or self.animator == nil then
      return
    end
    self:ResetAllTrigger()
  end, 1.2)
end

function Vip18DisplayPanel:OnClickMaskBtn()
  self:FastEndAnimation()
end

function Vip18DisplayPanel:FastEndAnimation()
  local stateInfo = self.animator:GetCurrentAnimatorStateInfo(0)
  if stateInfo == nil then
    Logger.Log("\229\189\147\229\137\141\230\151\160\229\138\168\231\148\187")
    return
  end
  self.animator:Play(stateInfo.fullPathHash, 0, 1)
  self.animator:Update(1)
  self:ResetAllTrigger()
end

function Vip18DisplayPanel:InitPanel(param)
  if param ~= nil then
    self.onNextPageClickHandler = param.onNextPageClickHandler
  end
  self:InvokeNextPageClickHandler()
  self.gameObject:SetActive(true)
  self.animator:Play(AnimationNames.Show, -1, 0)
  self.animator:Update(0)
  TimerManager:GetInstance():DelayInvoke(function()
    if IsNull(self.gameObject) or self.animator == nil then
      return
    end
    self:ResetAllTrigger()
  end, 6.0)
end

function Vip18DisplayPanel:BackToGiftBox()
  self.gameObject:SetActive(true)
  self.animator:Play(AnimationNames.Show3, -1, 0)
  self.animator:Update(0)
  TimerManager:GetInstance():DelayInvoke(function()
    if IsNull(self.gameObject) or self.animator == nil then
      return
    end
    self:ResetAllTrigger()
  end, 1.2)
end

function Vip18DisplayPanel:HidePanel()
  self:FastEndAnimation()
end

function Vip18DisplayPanel:ResetAllTrigger()
  for _, v in pairs(AnimationType) do
    self.animator:ResetTrigger(v)
  end
end

return Vip18DisplayPanel
