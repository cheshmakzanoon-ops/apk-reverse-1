local UIBountyHunterSweepConfirmView = BaseClass("UIBountyHunterSweepConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIBountyHunterSweepConfirmView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIBountyHunterSweepConfirmView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBountyHunterSweepConfirmView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnCommon = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnCommon:SetOnClick(function()
    self:OnBtnCommonClick()
  end)
  self.toggleUseItem = self.viewSkin:AddComponent(self, UIToggle, 3)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.imgShootItemIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textShootItemNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textDescTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.compRefreshItem = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.imgRefreshItemIcon = self.viewSkin:AddComponent(self, UIImage, 10)
  self.textRefreshItemNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnIcon = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnIcon:SetOnClick(function()
    self:OnBtnIconClick()
  end)
  self.toggleUseItem:SetOnValueChanged(function(isOn)
    local countEnough = false
    if self.bountyHunterData then
      countEnough = self.bountyHunterData:GetRefreshItemCount() > 0
    end
    if isOn and not countEnough then
      UIUtil.ShowTipsId("120021")
      self.toggleUseItem:SetIsOnWithoutNotify(false)
    end
    self:RefreshItemArea()
  end)
end

function UIBountyHunterSweepConfirmView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.btnCommon = nil
  self.toggleUseItem = nil
  self.btnLWInfo = nil
  self.imgShootItemIcon = nil
  self.textShootItemNum = nil
  self.textDescTxt = nil
  self.btnMask = nil
  self.compRefreshItem = nil
  self.imgRefreshItemIcon = nil
  self.textRefreshItemNum = nil
  self.btnIcon = nil
end

function UIBountyHunterSweepConfirmView:DataDefine()
  local userData = self:GetUserData()
  self.bountyHunterData = userData.data
  self.callback = userData.callback
end

function UIBountyHunterSweepConfirmView:DataDestroy()
  self.bountyHunterData = nil
  self.callback = nil
end

function UIBountyHunterSweepConfirmView:OnAddListener()
end

function UIBountyHunterSweepConfirmView:OnRemoveListener()
end

function UIBountyHunterSweepConfirmView:RefreshView()
  if self.bountyHunterData == nil then
    return
  end
  local info = self.bountyHunterData:GetSuperShootInfo()
  if info == nil then
    return
  end
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(info.goodsId)
  self.textDescTxt:SetText(Localization:GetString("hunterbroad_alert_desc3", Localization:GetString(itemTemplate and itemTemplate.name or "")))
  self.textShootItemNum:SetText(info.costGoodsNum)
  self.imgShootItemIcon:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.icon))
  self.toggleUseItem:SetIsOnWithoutNotify(self.bountyHunterData.cost_extra_para == 1)
  self:RefreshItemArea()
end

function UIBountyHunterSweepConfirmView:RefreshItemArea()
  if self.toggleUseItem:GetIsOn() then
    local info = self.bountyHunterData:GetSuperShootInfo()
    if info == nil then
      return
    end
    local itemCount = self.bountyHunterData:GetRefreshItemCount()
    local countMax = info.costGoodsNum
    countMax = math.min(math.ceil(countMax / 20) + 1, itemCount)
    local countMin = self.bountyHunterData:GetRefreshItemUseMinNum()
    local str = ""
    if countMax <= countMin then
      if countMax == 1 then
        str = countMax
      else
        str = "1 - " .. countMax
      end
    else
      str = countMin .. " - " .. countMax
    end
    self.textRefreshItemNum:SetText(str)
    self.imgRefreshItemIcon:LoadSprite(self.bountyHunterData:GetRefreshItemIcon())
    self.compRefreshItem:SetActive(true)
  else
    self.compRefreshItem:SetActive(false)
  end
end

function UIBountyHunterSweepConfirmView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIBountyHunterSweepConfirmView:OnBtnMaskClick()
  self.ctrl:CloseSelf()
end

function UIBountyHunterSweepConfirmView:OnBtnCommonClick()
  if self.bountyHunterData and self.toggleUseItem:GetIsOn() then
    self.bountyHunterData:SetHasShownSecondConfirm(BountyHunterSecondConfirmKey.BountyHunterSuperShoot)
  end
  if self.callback then
    self.callback(self.toggleUseItem:GetIsOn())
  end
  self.ctrl:CloseSelf()
end

function UIBountyHunterSweepConfirmView:OnBtnLWInfoClick()
  if self.bountyHunterData == nil then
    return
  end
  local itemTemplate
  if self.bountyHunterData.hunterActTmpData and self.bountyHunterData.hunterActTmpData.refresh_item then
    itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.bountyHunterData.hunterActTmpData.refresh_item)
  end
  if itemTemplate == nil then
    return
  end
  local param = {}
  param.type = "nameDesc"
  param.title = Localization:GetString("hunterbroad_alert_desc4")
  local name = Localization:GetString(itemTemplate.name)
  param.desc = Localization:GetString("hunterbroad_alert_desc5", name, name)
  param.isLocal = true
  param.alignObject = self.btnLWInfo
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  if self.bountyHunterData and not self.bountyHunterData:HasShownSecondConfirm(PostEventLog.Defines.c_show_sweep_confirm_view_refresh_item) then
    PostEventLog.Track(PostEventLog.Defines.c_show_sweep_confirm_view_refresh_item, {
      activity_id = self.bountyHunterData.activityId,
      day_count = self.bountyHunterData:GetCurActivityDayCount()
    })
    self.bountyHunterData:SetHasShownSecondConfirm(PostEventLog.Defines.c_show_sweep_confirm_view_refresh_item)
  end
end

function UIBountyHunterSweepConfirmView:OnBtnIconClick()
  if self.bountyHunterData == nil then
    return
  end
  local itemTemplate
  if self.bountyHunterData.hunterActTmpData and self.bountyHunterData.hunterActTmpData.refresh_item then
    itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.bountyHunterData.hunterActTmpData.refresh_item)
  end
  if itemTemplate == nil then
    return
  end
  local param = {}
  param.type = "nameDesc"
  param.title = Localization:GetString("hunterbroad_alert_desc4")
  local name = Localization:GetString(itemTemplate.name)
  param.desc = Localization:GetString("hunterbroad_alert_desc5", name, name)
  param.isLocal = true
  param.alignObject = self.btnIcon
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  if self.bountyHunterData and not self.bountyHunterData:HasShownSecondConfirm(PostEventLog.Defines.c_show_sweep_confirm_view_refresh_item) then
    PostEventLog.Track(PostEventLog.Defines.c_show_sweep_confirm_view_refresh_item, {
      activity_id = self.bountyHunterData.activityId,
      day_count = self.bountyHunterData:GetCurActivityDayCount()
    })
    self.bountyHunterData:SetHasShownSecondConfirm(PostEventLog.Defines.c_show_sweep_confirm_view_refresh_item)
  end
end

return UIBountyHunterSweepConfirmView
