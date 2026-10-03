local UILWTruckSuperDepartureRefreshSecondConfirmPanelView = BaseClass("UILWTruckSuperDepartureRefreshSecondConfirmPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTodayRemind = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.toggleTodayRemind = self.viewSkin:AddComponent(self, UIToggle, 2)
  self.textConfirmBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textDiamondCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compDiamondContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.textTicketCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textDesContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compCostContent = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle:SetLocalText("super_trucklaunch_title03")
  self.textConfirmBtn:SetLocalText("super_trucklaunch_btn07")
  self.textTodayRemind:SetLocalText(110103)
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.textTodayRemind = nil
  self.toggleTodayRemind = nil
  self.textConfirmBtn = nil
  self.btnConfirm = nil
  self.textDiamondCount = nil
  self.compDiamondContent = nil
  self.textTicketCount = nil
  self.textDesContent = nil
  self.btnClose = nil
  self.textTitle = nil
  self.compCostContent = nil
  self.btnPanel = nil
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:DataDefine()
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:DataDestroy()
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:OnAddListener()
  base.OnAddListener(self)
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:ReInit()
  self.viewParam = self:GetUserData()
  self.textDesContent:SetText(self.viewParam.desContent)
  local configValue = DataCenter.LWMyStationDataManager:GetMeta(54)
  local oneTicket2DiamondNum = configValue and tonumber(configValue) or 0
  local countStr = ""
  if self.viewParam.ownTicketCount >= self.viewParam.needTicketCount then
    self.compDiamondContent:SetActive(false)
    countStr = "<color=#FFFFFF>" .. self.viewParam.needTicketCount .. "</color>" .. "/" .. "<color=#FFFFFF>" .. self.viewParam.ownTicketCount .. "</color>"
  else
    self.compDiamondContent:SetActive(true)
    countStr = "<color=#F97279>" .. self.viewParam.needTicketCount .. "</color>" .. "/" .. "<color=#FFFFFF>" .. self.viewParam.ownTicketCount .. "</color>"
    local lackCount = self.viewParam.needTicketCount - self.viewParam.ownTicketCount
    local needDiamond = lackCount * oneTicket2DiamondNum
    local diamondStr = ""
    if needDiamond <= LuaEntry.Player.gold then
      diamondStr = "<color=#FFFFFF>" .. string.GetFormattedStr2(needDiamond) .. "</color>"
    else
      diamondStr = "<color=#F97279>" .. string.GetFormattedStr2(needDiamond) .. "</color>"
    end
    self.textDiamondCount:SetText(diamondStr)
  end
  self.textTicketCount:SetText(countStr)
  self.toggleTodayRemind:SetActive(self.viewParam.showCheckBox)
  if self.viewParam.showCheckBox then
    self.compCostContent:SetAnchoredPositionXY(0, 32)
    self.toggleTodayRemind:SetIsOn(false)
  else
    self.compCostContent:SetAnchoredPositionXY(0, 0)
  end
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:OnBtnConfirmClick()
  if self.viewParam.clickCallBack then
    local toggleValue = not self.toggleTodayRemind:GetIsOn()
    self.viewParam.clickCallBack(toggleValue)
    self.ctrl:CloseSelf()
  end
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWTruckSuperDepartureRefreshSecondConfirmPanelView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return UILWTruckSuperDepartureRefreshSecondConfirmPanelView
