local UIBFDsbDuelActFirstPopUpView = BaseClass("UIBFDsbDuelActFirstPopUpView", UIBaseView)
local base = UIBaseView

function UIBFDsbDuelActFirstPopUpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIBFDsbDuelActFirstPopUpView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActFirstPopUpView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnJump = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTitle:SetLocalText("dsb_duel_activitiy_name_1001")
  self.textTips:SetLocalText("dsb_duel_interface_1050")
  self.text:SetLocalText("110036")
end

function UIBFDsbDuelActFirstPopUpView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.textTitle = nil
  self.textTips = nil
  self.btnJump = nil
  self.text = nil
end

function UIBFDsbDuelActFirstPopUpView:DataDefine()
end

function UIBFDsbDuelActFirstPopUpView:DataDestroy()
end

function UIBFDsbDuelActFirstPopUpView:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActFirstPopUpView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActFirstPopUpView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActFirstPopUpView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActFirstPopUpView:OnBtnJumpClick()
  self.ctrl:CloseSelf()
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_RACE_ENTRANCE)
  if buildData ~= nil then
    local worldPos = buildData:GetCenterVec()
    SceneUtils.ChangeToCity(function()
      GoToUtil.GotoCityPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        local param = {}
        worldPos.y = worldPos.y + 8
        param.position = CS.CSUtils.WorldPositionToUISpacePosition(worldPos)
        param.position.x = param.position.x + 5
        param.arrowType = ArrowType.Building
        param.positionType = PositionType.Screen
        DataCenter.ArrowManager:ShowArrow(param)
      end)
    end)
  end
end

function UIBFDsbDuelActFirstPopUpView:ReInit()
  BattlefieldDsbDuelUtils.ActInfo:SetIsShownPopUp(true)
end

return UIBFDsbDuelActFirstPopUpView
