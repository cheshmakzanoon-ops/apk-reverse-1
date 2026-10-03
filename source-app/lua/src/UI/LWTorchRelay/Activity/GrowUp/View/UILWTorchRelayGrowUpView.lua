local UILWTorchRelayGrowUpView = BaseClass("UILWTorchRelayGrowUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWTorchRelayGrowUpItemComponent = require("UI/LWTorchRelay/Activity/GrowUp/Component/UILWTorchRelayGrowUpItemComponent")

function UILWTorchRelayGrowUpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWTorchRelayGrowUpView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayGrowUpView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UIWidget/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UIWidget/TitleText")
  self.textTitle:SetText(Localization:GetString("activity_torch_relay_title_1"))
  self.btnClose = self:AddComponent(UIButton, "UIWidget/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textCurrent = self:AddComponent(UIText, "Content/Layout/CurrentText")
  self.textCurrent:SetText(Localization:GetString("activity_torch_relay_desc_37"))
  self.textCurrentValue = self:AddComponent(UIText, "Content/Layout/CurrentValueText")
  self.compGrowUpItemTemplate01 = self:AddComponent(UILWTorchRelayGrowUpItemComponent, "Content/GrowUpDetailContent/GrowUpItemTemplate1")
  self.compGrowUpItemTemplate02 = self:AddComponent(UILWTorchRelayGrowUpItemComponent, "Content/GrowUpDetailContent/GrowUpItemTemplate2")
  self.compGrowUpItemTemplate03 = self:AddComponent(UILWTorchRelayGrowUpItemComponent, "Content/GrowUpDetailContent/GrowUpItemTemplate3")
  self.compsGrowUp = {
    self.compGrowUpItemTemplate01,
    self.compGrowUpItemTemplate02,
    self.compGrowUpItemTemplate03
  }
  self.compGrowUpDetailContent = self:AddComponent(UIBaseContainer, "Content/GrowUpDetailContent")
  self.btnCloseTips = self:AddComponent(UIButton, "Content/CloseTipsBtn")
  self.btnCloseTips:SetOnClick(function()
    self:OnBtnCloseTipsClick()
  end)
  self.powerUpItemIcon = self:AddComponent(UIImage, "Content/Icon")
end

function UILWTorchRelayGrowUpView:ComponentDestroy()
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textCurrent = nil
  self.textCurrentValue = nil
  self.compGrowUpItemTemplate01 = nil
  self.compGrowUpItemTemplate02 = nil
  self.compGrowUpItemTemplate03 = nil
  self.compGrowUpDetailContent = nil
  self.btnCloseTips = nil
end

function UILWTorchRelayGrowUpView:DataDefine()
end

function UILWTorchRelayGrowUpView:DataDestroy()
end

function UILWTorchRelayGrowUpView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTorchRelayActGrowUp, self.OnGrowUp)
end

function UILWTorchRelayGrowUpView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityTorchRelayActGrowUp, self.OnGrowUp)
  base.OnRemoveListener(self)
end

function UILWTorchRelayGrowUpView:OnOpen()
  self.param = self:GetUserData()
  if self.param == nil then
    return
  end
  self.activityId = self.param.activityId
  if self.activityId == nil then
    return
  end
  self:UpdateContent()
  self.btnCloseTips:SetActive(false)
end

function UILWTorchRelayGrowUpView:UpdateContent()
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil then
    return
  end
  if data.config then
    local stageConfig = data.config:GetStageConfigTemplate()
    self.powerUpItemIcon:LoadSpriteAsync(stageConfig:getMiniMileIcon())
  end
  self.textCurrentValue:SetText(tostring(data:GetCurGrowUpLevelCostItemCount()))
  for i, v in pairs(DataCenter.ActivityTorchRelayManager.GrowUpType) do
    if self.compsGrowUp[v] ~= nil then
      self.compsGrowUp[v]:ReInit(self.activityId, v)
    end
  end
end

function UILWTorchRelayGrowUpView:OnGrowUp()
  self:UpdateContent()
end

function UILWTorchRelayGrowUpView:OnTipsShow()
  self.btnCloseTips:SetActive(true)
end

function UILWTorchRelayGrowUpView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWTorchRelayGrowUpView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWTorchRelayGrowUpView:OnBtnCloseTipsClick()
  if self.compsGrowUp then
    for i, v in pairs(self.compsGrowUp) do
      v:HideTips()
    end
  end
  self.btnCloseTips:SetActive(false)
end

return UILWTorchRelayGrowUpView
