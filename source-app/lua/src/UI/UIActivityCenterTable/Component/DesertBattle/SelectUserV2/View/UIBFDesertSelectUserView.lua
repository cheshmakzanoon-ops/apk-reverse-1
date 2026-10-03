local base = require("UI.BattleFieldBase.SelectUser.View.UIBFBaseSelectUserView")
local UIBFDesertSelectUserView = BaseClass("UIBFDesertSelectUserView", base)
local base_node_path = "PopUpTitle/Common_bg_orange2"

function UIBFDesertSelectUserView:OnCreate()
  DataCenter.ActDragonManager:SendGetPlayerList()
  base.OnCreate(self)
end

function UIBFDesertSelectUserView:TopBarComponentDefine()
  local prefabTopBarPath = self.ctrl:GetTopBarPrefabPath()
  self.topBar = self:LoadComponentAsync(self.UIBFBaseSelectUserTopBar, prefabTopBarPath, self.transform:Find(base_node_path), function()
    if self.isPrepTime then
      self.topBar:SetAnchoredPositionXY(0, -20)
      self.find:SetAnchoredPositionXY(0, -180)
    else
      self.topBar:SetAnchoredPositionXY(0, -125)
      self.find:SetAnchoredPositionXY(0, -280)
    end
    self:UpdateData()
  end)
end

function UIBFDesertSelectUserView:SetScrollViewPosAndSize(changeBig)
  if changeBig then
    self.scroll_view:SetAnchoredPositionXY(375, -250)
    self.scroll_view:SetSizeDelta(Vector2.New(750, 744))
  else
    self.scroll_view:SetAnchoredPositionXY(375, -360)
    self.scroll_view:SetSizeDelta(Vector2.New(750, 502))
  end
end

function UIBFDesertSelectUserView:OnDestroy()
  base.OnDestroy(self)
end

function UIBFDesertSelectUserView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetDagonPlayerList, self.UpdateData)
  self:AddUIListener(EventId.DragonBattleTimes, self.OnDragonBattleTimes)
end

function UIBFDesertSelectUserView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetDagonPlayerList, self.UpdateData)
  self:RemoveUIListener(EventId.DragonBattleTimes, self.OnDragonBattleTimes)
  base.OnRemoveListener(self)
end

return UIBFDesertSelectUserView
