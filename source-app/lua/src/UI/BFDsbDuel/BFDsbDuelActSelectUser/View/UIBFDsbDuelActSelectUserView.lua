local base = require("UI.BattleFieldBase.SelectUser.View.UIBFBaseSelectUserView")
local UIBFDsbDuelActSelectUserView = BaseClass("UIBFDsbDuelActSelectUserView", base)
local base_node_path = "PopUpTitle/Common_bg_orange2"

function UIBFDsbDuelActSelectUserView:OnCreate()
  BattlefieldDsbDuelUtils.ActInfo:SendActPlayerListMsg()
  base.OnCreate(self)
end

function UIBFDsbDuelActSelectUserView:OnDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActSelectUserView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActPlayerListUpdate, self.UpdateData)
end

function UIBFDsbDuelActSelectUserView:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActPlayerListUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActSelectUserView:TopBarComponentDefine()
  local prefabTopBarPath = self.ctrl:GetTopBarPrefabPath()
  self.topBar = self:LoadComponentAsync(self.UIBFBaseSelectUserTopBar, prefabTopBarPath, self.transform:Find(base_node_path), function()
    if self.isPrepTime then
      self.topBar:SetAnchoredPositionXY(0, -85)
      self.find:SetAnchoredPositionXY(0, -20)
    else
      self.topBar:SetAnchoredPositionXY(0, -85)
      self.find:SetAnchoredPositionXY(0, -20)
    end
    self:UpdateData()
  end)
end

function UIBFDsbDuelActSelectUserView:SetScrollViewPosAndSize(changeBig)
  self.scroll_view:SetAnchoredPositionXY(375, -230)
  self.scroll_view:SetSizeDelta(Vector2.New(750, 650))
end

return UIBFDsbDuelActSelectUserView
