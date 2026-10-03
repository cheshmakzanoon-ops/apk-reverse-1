local UITrainDriverIntroduceView = BaseClass("UITrainDriverIntroduceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UITrainDriverIntroduceView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITrainDriverIntroduceView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITrainDriverIntroduceView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textIntroduce = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textClose = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textText3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textText1:SetLocalText("alliance_train_how_to_play_limit_7")
  self.textText2:SetLocalText("alliance_train_how_to_play_limit_8")
  self.textText3:SetLocalText("alliance_train_how_to_play_limit_9")
  self.textIntroduce:SetLocalText("alliance_train_how_to_play")
  self.textClose:SetLocalText("alliance_train_golden_click_close_limit")
end

function UITrainDriverIntroduceView:ComponentDestroy()
  self.viewSkin = nil
  self.textIntroduce = nil
  self.textClose = nil
  self.btnPanel = nil
  self.textText1 = nil
  self.textText2 = nil
  self.textText3 = nil
end

function UITrainDriverIntroduceView:DataDefine()
end

function UITrainDriverIntroduceView:DataDestroy()
end

function UITrainDriverIntroduceView:OnAddListener()
  base.OnAddListener(self)
end

function UITrainDriverIntroduceView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITrainDriverIntroduceView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return UITrainDriverIntroduceView
