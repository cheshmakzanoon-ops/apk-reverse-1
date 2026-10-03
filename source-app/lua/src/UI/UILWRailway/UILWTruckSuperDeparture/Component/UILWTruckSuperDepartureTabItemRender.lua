local base = UIBaseContainer
local UILWTruckSuperDepartureTabItemRender = BaseClass("UILWTruckSuperDepartureTabItemRender", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWTruckSuperDepartureTabItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTruckSuperDepartureTabItemRender:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTruckSuperDepartureTabItemRender:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUILWTruckSuperDepartureTabItemRender = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUILWTruckSuperDepartureTabItemRender:SetOnClick(function()
    self:OnBtnUILWTruckSuperDepartureTabItemRenderClick()
  end)
  self.imgSelect = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textSelectTab = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgNoSelect = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textNoSelectTab = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
end

function UILWTruckSuperDepartureTabItemRender:ComponentDestroy()
  self.viewSkin = nil
  self.btnUILWTruckSuperDepartureTabItemRender = nil
  self.imgSelect = nil
  self.textSelectTab = nil
  self.imgNoSelect = nil
  self.textNoSelectTab = nil
end

function UILWTruckSuperDepartureTabItemRender:DataDefine()
end

function UILWTruckSuperDepartureTabItemRender:DataDestroy()
end

function UILWTruckSuperDepartureTabItemRender:OnAddListener()
  base.OnAddListener(self)
end

function UILWTruckSuperDepartureTabItemRender:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTruckSuperDepartureTabItemRender:InitData(data, curSelectTabType)
  self.data = data
  self.textSelectTab:SetLocalText(self.data.tabName)
  self.textNoSelectTab:SetLocalText(self.data.tabName)
  self:SetSelectState(self.data.tabType == curSelectTabType)
end

function UILWTruckSuperDepartureTabItemRender:SetSelectState(isSelect)
  self.imgSelect:SetActive(isSelect)
end

function UILWTruckSuperDepartureTabItemRender:OnBtnUILWTruckSuperDepartureTabItemRenderClick()
  self.view:OnTabItemClick(self.data.tabType)
end

return UILWTruckSuperDepartureTabItemRender
