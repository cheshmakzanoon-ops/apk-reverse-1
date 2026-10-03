local LWUIPopupActivityDataPanelView = BaseClass("LWUIPopupActivityDataPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIPopupActivityDataPanelItemRender = require("UI.LWUIPopupActivityData.Component.LWUIPopupActivityDataPanelItemRender")
local DecoIconPath = "Assets/Main/TextureEx/UIActivityBg/AllyDuel/Info/wxy_junbei_shuoming_jiazi.png"

function LWUIPopupActivityDataPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWUIPopupActivityDataPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIPopupActivityDataPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.compActivityDataList = self.viewSkin:AddComponent(self, UIScrollViewSimple, 3)
  self.rawImgDecoIconRaw = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.compActivityDataList:Init(LWUIPopupActivityDataPanelItemRender)
end

function LWUIPopupActivityDataPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.btnMask = nil
  self.compActivityDataList = nil
  self.rawImgDecoIconRaw = nil
end

function LWUIPopupActivityDataPanelView:DataDefine()
end

function LWUIPopupActivityDataPanelView:DataDestroy()
end

function LWUIPopupActivityDataPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshPopupActivityView, self.OnRefreshPopupActivityView)
end

function LWUIPopupActivityDataPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshPopupActivityView, self.OnRefreshPopupActivityView)
  base.OnRemoveListener(self)
end

function LWUIPopupActivityDataPanelView:OnRefreshPopupActivityView()
  self:ReInit()
end

function LWUIPopupActivityDataPanelView:ReInit()
  self.compActivityDataList:Clear()
  local activityList = DataCenter.LWPopupManager:GetPopupActivityList()
  local count = #activityList
  if count == 0 then
    self:ClosePanel()
    return
  end
  for i = 1, count do
    self.compActivityDataList:AddData(activityList[i])
  end
  self.compActivityDataList:Show()
  self.rawImgDecoIconRaw:LoadSpriteAuto(DecoIconPath)
end

function LWUIPopupActivityDataPanelView:OnBtnCloseClick()
  self:ClosePanel()
end

function LWUIPopupActivityDataPanelView:OnBtnMaskClick()
  self:ClosePanel()
end

function LWUIPopupActivityDataPanelView:ClosePanel()
  self.ctrl:CloseSelf()
end

return LWUIPopupActivityDataPanelView
