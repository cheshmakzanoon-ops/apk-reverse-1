local base = UIBaseContainer
local UISearchFovItem = BaseClass("UISearchFovItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UISearchFovItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UISearchFovItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISearchFovItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textSecondNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnEdit = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnEdit:SetOnClick(function()
    self:OnBtnEditClick()
  end)
  self.compTitle = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.imgEdit = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textFirstNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgFlag = self.viewSkin:AddComponent(self, UIImage, 7)
  self.compNormal = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.btnDel = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnDel:SetOnClick(function()
    self:OnBtnDelClick()
  end)
  self.btnJump = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
  self.compSelectState = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.imgChecked = self.viewSkin:AddComponent(self, UIImage, 13)
  self.btnSelectState = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnSelectState:SetOnClick(function()
    self:OnBtnSelectStateClick()
  end)
end

function UISearchFovItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.textSecondNameTxt = nil
  self.btnEdit = nil
  self.compTitle = nil
  self.imgEdit = nil
  self.textFirstNameTxt = nil
  self.imgFlag = nil
  self.compNormal = nil
  self.btnShare = nil
  self.btnDel = nil
  self.btnJump = nil
  self.compSelectState = nil
  self.imgChecked = nil
  self.btnSelectState = nil
end

function UISearchFovItem:DataDefine()
end

function UISearchFovItem:DataDestroy()
end

function UISearchFovItem:OnAddListener()
  base.OnAddListener(self)
end

function UISearchFovItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISearchFovItem:OnBtnEditClick()
  if not self.data then
    return
  end
  if self.data.type == MarkType.Special or self.data.type == MarkType.Friend or self.data.type == MarkType.Enemy then
    self.view.ctrl:OnClickPosBtn(self.data)
  elseif self.data.type >= MarkType.Country_A and self.data.type <= MarkType.COUNTRY_END then
    local share_param = {}
    share_param.sid = self.data.server
    share_param.pos = self.data.pos
    share_param.oname = self.data.name
    share_param.panelType = MarkGroup.WarZone
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
    self.view.ctrl:CloseSelf()
  else
    local share_param = {}
    share_param.sid = self.data.server
    share_param.pos = self.data.pos
    share_param.oname = self.data.name
    share_param.panelType = MarkGroup.Alliance
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
    self.view.ctrl:CloseSelf()
  end
end

function UISearchFovItem:OnBtnShareClick()
  self.view.ctrl:ShareBookMark(self.data)
end

function UISearchFovItem:OnBtnDelClick()
  local data = self.data
  UIUtil.TryShowConfirm(TodayNoSecondConfirmType.WorldBookmarkDelConfirm, Localization:GetString("alliance_tag_opt_UI_5"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.view.ctrl:DelBookMark(data)
  end, function()
  end, function()
  end)
end

function UISearchFovItem:OnBtnJumpClick()
  self.view.ctrl:OnClickPosBtn(self.data)
end

function UISearchFovItem:ReInit(host, index, fov)
  self.data = fov
  self.host = host
  local showName = self.data.name
  if self.data and self.data.IsSelfAlliance and not self.data:IsSelfAlliance() then
    local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.data.allianceId)
    if data ~= nil then
      showName = string.format("[%s] %s", data.abbr, showName)
    end
  end
  self.textFirstNameTxt:SetText(showName)
  local pointId = (self.data.pos - self.data.pos % 10) / 10
  local pos = SceneUtils.IndexToTilePos(pointId)
  self.textSecondNameTxt:SetLocalText("world_tip10013", self.data.server, pos.x, pos.y)
  local img = "Common_img_mark"
  self.imgEdit:SetActive(false)
  self.btnEdit:SetActive(true)
  if self.data.type == MarkType.Special then
    img = string.format(LoadPath.CommonNewPath, "Common_img_mark")
  elseif self.data.type == MarkType.Friend then
    img = string.format(LoadPath.CommonNewPath, "Common_img_mark_friend")
  elseif self.data.type == MarkType.Enemy then
    img = string.format(LoadPath.CommonNewPath, "Common_img_mark_enemy")
  elseif self.data.type >= MarkType.Country_A and self.data.type <= MarkType.COUNTRY_END then
    img = string.format(LoadPath.AllianceMark, DataCenter.WorldFavoDataManager:GetBookMarkIconName(self.data.type))
    local flag = DataCenter.LandlordMgr:CanShowWarZoneMark()
    local sId = LuaEntry.Player:GetSourceServerId()
    local isMgr = flag and (LuaEntry.Player:IsPresident(sId) or LuaEntry.Player:IsFirstLady(sId))
    if isMgr then
      self.imgEdit:SetActive(true)
      self.btnEdit:SetActive(true)
      CS.UIGray.SetGray(self.btnDel.transform, false, true)
    else
      CS.UIGray.SetGray(self.btnDel.transform, true, false)
    end
  else
    img = string.format(LoadPath.AllianceMark, DataCenter.WorldFavoDataManager:GetBookMarkIconName(self.data.type))
    if self.data and self.data.IsSelfAlliance and self.data:IsSelfAlliance() then
      self.imgEdit:SetActive(true)
      self.btnEdit:SetActive(true)
      CS.UIGray.SetGray(self.btnDel.transform, false, true)
    else
      CS.UIGray.SetGray(self.btnDel.transform, true, false)
    end
  end
  self.imgFlag:LoadSprite(img)
  self:OnMultiSelectModeChanged(self.host:GetMultiSelectMode())
  self:RefreshSelectState()
end

function UISearchFovItem:OnMultiSelectModeChanged(multiMode)
  local showMulti = multiMode and self.data.type <= 2
  self.compNormal:SetActive(not showMulti)
  self.btnSelectState:SetActive(showMulti)
  if showMulti then
    self:RefreshSelectState()
  end
end

function UISearchFovItem:RefreshSelectState()
  self.selected = self.host and self.data and self.host:GetMultiSelected(self.data.server, self.data.pos)
  self.imgChecked:SetActive(self.selected)
end

function UISearchFovItem:OnBtnSelectStateClick()
  if self.host and self.data then
    self.host:SetMultiSelection(self.data.server, self.data.pos, not self.selected)
  end
  self:RefreshSelectState()
end

return UISearchFovItem
