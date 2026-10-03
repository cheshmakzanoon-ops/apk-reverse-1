local UITrainProbabilityView = BaseClass("UITrainProbabilityView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITrainProbabilityDetailInfo = require("UI.UILWRailway.UITrainProbability.Component.UITrainProbabilityDetailInfo")

function UITrainProbabilityView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UITrainProbabilityView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITrainProbabilityView:ComponentDefine()
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.compDetailInfo = self:AddComponent(UITrainProbabilityDetailInfo, "Root/Common_bg/detailInfo")
  self.textTitle:SetLocalText(320475)
end

function UITrainProbabilityView:ComponentDestroy()
  self.btnClose = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.compDetailInfo = nil
end

function UITrainProbabilityView:DataDefine()
end

function UITrainProbabilityView:DataDestroy()
end

function UITrainProbabilityView:OnAddListener()
  base.OnAddListener(self)
end

function UITrainProbabilityView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITrainProbabilityView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UITrainProbabilityView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UITrainProbabilityView:OnOpen()
  local dataList = DataCenter.LWTrainDataManager:GetProbabilityDataList()
  self.compDetailInfo:SetData(dataList)
end

return UITrainProbabilityView
