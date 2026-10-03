local UIChooseRallyPointView = BaseClass("UIChooseRallyPointView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIChooseRallyPointView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIChooseRallyPointView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChooseRallyPointView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMove = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMove:SetOnClick(function()
    self:OnBtnMoveClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textMoveBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgWhiteBg = self.viewSkin:AddComponent(self, UIImage, 7)
end

function UIChooseRallyPointView:ComponentDestroy()
  self.viewSkin = nil
  self.btnMove = nil
  self.textTitle = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.textDesc = nil
  self.textMoveBtn = nil
  self.imgWhiteBg = nil
end

function UIChooseRallyPointView:DataDefine()
  self.data = DataCenter.AllianceRallyPointDataManager:GetAllAllianceRallyPoints()
  self.items = {}
end

function UIChooseRallyPointView:DataDestroy()
  self.data = nil
  self.items = {}
end

function UIChooseRallyPointView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChangeSelectRallyPoint, self.OnChangeSelectRallyPoint)
end

function UIChooseRallyPointView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChangeSelectRallyPoint, self.OnChangeSelectRallyPoint)
  base.OnRemoveListener(self)
end

function UIChooseRallyPointView:Init()
  self.textTitle:SetLocalText(390883)
  self.textDesc:SetLocalText("s5_cross_ui01")
  self.textMoveBtn:SetLocalText(300035)
  for _, item in pairs(self.items) do
    self:RemoveAsyncComponent(item)
  end
  self.items = {}
  local luaPath = "UI.UILWAlliance.UIChooseRallyPoint.RallyPointComponent"
  local prefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UIChooseRallyPoint/RallyPoint.prefab"
  local recommendType = DataCenter.AllianceRallyPointDataManager:GetRecommendType()
  self.curType = recommendType
  for k, v in pairs(self.data) do
    self.items[k] = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.imgWhiteBg)
    self.items[k]:SetData(v, k == recommendType)
    self.items[k]:SetActive(true)
  end
end

function UIChooseRallyPointView:OnBtnMoveClick()
  local param = self:GetUserData()
  MoveCityUtil.AllianceMoveCityToSelectedRallyPoint(self.curType, param.costType, param.isInviteMove, param.pinMsgUUid)
end

function UIChooseRallyPointView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIChooseRallyPointView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIChooseRallyPointView:OnChangeSelectRallyPoint(markType)
  self.curType = markType
end

return UIChooseRallyPointView
