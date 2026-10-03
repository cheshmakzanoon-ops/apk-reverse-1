local UITrainDriverRemindView = BaseClass("UITrainDriverRemindView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UITrainDriverRemindView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITrainDriverRemindView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITrainDriverRemindView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnSure = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnSure:SetOnClick(function()
    self:OnBtnSureClick()
  end)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnBlack = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.Head = self:AddComponent(UICommonHead, "bg/Head")
  self.Head:SetAsMyself()
  self.textName:SetText(LuaEntry.Player:GetName())
  self.textTxtTitle:SetLocalText("alliance_train_message_title")
  self.textDesc:SetLocalText("alliance_train_message_desc")
end

function UITrainDriverRemindView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.btnSure = nil
  self.textName = nil
  self.textDesc = nil
  self.textTxtTitle = nil
  self.textTime = nil
  self.btnBlack = nil
end

function UITrainDriverRemindView:DataDefine()
end

function UITrainDriverRemindView:DataDestroy()
end

function UITrainDriverRemindView:OnAddListener()
  base.OnAddListener(self)
end

function UITrainDriverRemindView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITrainDriverRemindView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UITrainDriverRemindView:OnBtnSureClick()
  self.ctrl:CloseSelf()
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  if not platformData or platformData.state == TrainPlatformState.TrainNoDriver then
    return
  end
  RailwayUtil.OpenUITrainPrepare(TrainPreparePage.Driver)
end

function UITrainDriverRemindView:OnBtnBlackClick()
  self.ctrl:CloseSelf()
end

return UITrainDriverRemindView
