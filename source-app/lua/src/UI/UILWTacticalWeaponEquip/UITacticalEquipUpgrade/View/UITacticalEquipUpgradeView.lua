local UITacticalEquipUpgradeView = BaseClass("UITacticalEquipUpgradeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TacticalEquipUpgradePanel = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipUpgradePanel")
local TacticalEquipMergePanel = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipMergePanel")
local TacticalEquipEmptyPanel = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipEmptyPanel")
local TacticalEquipMaxLevelPanel = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipMaxLevelPanel")
local TacticalEquipItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:RefreshShortcutShow()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPreview = self:AddComponent(UIButton, "PopUpTitle/BasicInfo/previewBtn")
  self.btnPreview:SetOnClick(function()
    self:OnBtnPreviewClick()
  end)
  self.textPowerNumber = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/BasicInfo/powerNumberText")
  self.btnOneKey = self:AddComponent(UIButton, "PopUpTitle/BtnsNode/oneKeyBtn")
  self.btnOneKey:SetOnClick(function()
    self:OnBtnOneKeyClick()
  end)
  self.btnMerge = self:AddComponent(UIButton, "PopUpTitle/BtnsNode/mergeBtn")
  self.btnMerge:SetOnClick(function()
    self:OnBtnMergeClick()
  end)
  self.btnUpgrade = self:AddComponent(UIButton, "PopUpTitle/BtnsNode/upgradeBtn")
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.btnGetMore = self:AddComponent(UIButton, "PopUpTitle/BtnsNode/getMoreBtn")
  self.btnGetMore:SetOnClick(function()
    self:OnBtnGetMoreClick()
  end)
  self.btnUse = self:AddComponent(UIButton, "PopUpTitle/BtnsNode/useBtn")
  self.btnUse:SetOnClick(function()
    self:OnBtnUseClick()
  end)
  self.btnConfirm = self:AddComponent(UIButton, "PopUpTitle/BtnsNode/confirmBtn")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.compNormalStatus = self:AddComponent(UIBaseContainer, "PopUpTitle/BasicInfo/normalStatus")
  self.compSingleStatus = self:AddComponent(UIBaseContainer, "PopUpTitle/BasicInfo/singleStatus")
  self.btnResearch = self:AddComponent(UIButton, "PopUpTitle/BtnsNode/researchBtn")
  self.btnResearch:SetOnClick(function()
    self:OnBtnResearchClick()
  end)
  self.btnReplace = self:AddComponent(UIButton, "PopUpTitle/BtnsNode/replaceBtn")
  self.btnReplace:SetOnClick(function()
    self:OnBtnReplaceClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/Common_img_title/titleText")
  self.btnMergeBan = self:AddComponent(UIButton, "PopUpTitle/BtnsNode/mergeBanBtn")
  self.btnMergeBan:SetOnClick(function()
    self:OnBtnMergeBanClick()
  end)
  self.compVfxUpgrade = self:AddComponent(UIVfx, "PopUpTitle/BasicInfo/normalStatus/MiddleBg/vfx_upgrade", VfxAssets.TacticalEquipUpgrade, {
    lifeType = UIVfxLifeType.DestroyAfterOnce,
    duration = 2
  })
  self.compVfxUpgradeBg = self:AddComponent(UIVfx, "PopUpTitle/BasicInfo/normalStatus/vfx_upgrade_bg", VfxAssets.TacticalEquipUpgradeBg, {
    lifeType = UIVfxLifeType.DestroyAfterOnce,
    duration = 2
  })
  self.vfxBgLoop = self:AddComponent(UIBaseContainer, "PopUpTitle/BasicInfo/normalStatus/MiddleBg/vfxBgLoop")
  self.compCurEquipItem = self:AddComponent(TacticalEquipItem, "PopUpTitle/BasicInfo/normalStatus/equips/curEquipItemNode/curEquipItem")
  self.compNextEquipItem = self:AddComponent(TacticalEquipItem, "PopUpTitle/BasicInfo/normalStatus/equips/nextEquipItemNode/nextEquipItem")
  self.compSingleEquipItem = self:AddComponent(TacticalEquipItem, "PopUpTitle/BasicInfo/singleStatus/maxEquipItem")
  self.upgradePanel = self:AddComponent(TacticalEquipUpgradePanel, "PopUpTitle/TacticalEquipUpgradePanel")
  self.mergePanel = self:AddComponent(TacticalEquipMergePanel, "PopUpTitle/TacticalEquipMergePanel")
  self.emptyPanel = self:AddComponent(TacticalEquipEmptyPanel, "PopUpTitle/TacticalEquipEmptyPanel")
  self.maxLevelPanel = self:AddComponent(TacticalEquipMaxLevelPanel, "PopUpTitle/TacticalEquipMaxLevelPanel")
  self.oneKeyBtnRedDot = self:AddComponent(UIBaseContainer, "PopUpTitle/BtnsNode/oneKeyBtn/oneKeyBtnRedDot")
  self.btnMap = {
    [TacticalEquipBtnStatus.Fill] = self.btnOneKey,
    [TacticalEquipBtnStatus.Merge] = self.btnMerge,
    [TacticalEquipBtnStatus.GetMore] = self.btnGetMore,
    [TacticalEquipBtnStatus.Upgrade] = self.btnUpgrade,
    [TacticalEquipBtnStatus.Use] = self.btnUse,
    [TacticalEquipBtnStatus.Confirm] = self.btnConfirm,
    [TacticalEquipBtnStatus.Replace] = self.btnReplace,
    [TacticalEquipBtnStatus.Research] = self.btnResearch,
    [TacticalEquipBtnStatus.MergeBan] = self.btnMergeBan
  }
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.compVfxUpgrade:SetLocalScaleXYZ(-1, 1, 1)
    self.vfxBgLoop:SetLocalScaleXYZ(-1, 1, 1)
  else
    self.compVfxUpgrade:SetLocalScaleXYZ(1, 1, 1)
    self.vfxBgLoop:SetLocalScaleXYZ(1, 1, 1)
  end
  self.btnLeftShortcutKey = self:AddComponent(UIButton, "PopUpTitle/ShortcutKeyRoot/LeftShortcutKey")
  self.btnLeftShortcutKey:SetOnClick(function()
    if self.OnBtnLeftShortcutKeyClick then
      self:OnBtnLeftShortcutKeyClick()
    end
  end)
  self.btnRightShortcutKey = self:AddComponent(UIButton, "PopUpTitle/ShortcutKeyRoot/RightShortcutKey")
  self.btnRightShortcutKey:SetOnClick(function()
    if self.OnBtnRightShortcutKeyClick then
      self:OnBtnRightShortcutKeyClick()
    end
  end)
  self.compShortcutKeyRoot = self:AddComponent(UIBaseContainer, "PopUpTitle/ShortcutKeyRoot")
  self.compLeftShortcutKeyRedPoint = self:AddComponent(UIBaseComponent, "PopUpTitle/ShortcutKeyRoot/LeftShortcutKey/LeftShortcutKeyRedPoint")
  self.compRightShortcutKeyRedPoint = self:AddComponent(UIBaseComponent, "PopUpTitle/ShortcutKeyRoot/RightShortcutKey/RightShortcutKeyRedPoint")
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.btnClose = nil
  self.btnPreview = nil
  self.textPowerNumber = nil
  self.btnOneKey = nil
  self.btnMerge = nil
  self.btnUpgrade = nil
  self.btnGetMore = nil
  self.btnUse = nil
  self.btnConfirm = nil
  self.compNormalStatus = nil
  self.compSingleStatus = nil
  self.btnResearch = nil
  self.btnReplace = nil
  self.textTitle = nil
  self.btnMergeBan = nil
  self.compVfxUpgrade = nil
  self.compVfxUpgradeBg = nil
  self.vfxBgLoop = nil
  self.btnLeftShortcutKey = nil
  self.btnRightShortcutKey = nil
  self.compShortcutKeyRoot = nil
  self.compLeftShortcutKeyRedPoint = nil
  self.compRightShortcutKeyRedPoint = nil
  self:StopUpgradeSound()
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.banFuncClick = nil
  if self.delayUpgradeResult then
    self.delayUpgradeResult:Stop()
    self.delayUpgradeResult = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CommonEquipDataChanged, self.RefreshStatus)
  self:AddUIListener(EventId.CommonEquipMerge, self.OnMergeEquip)
  self:AddUIListener(EventId.TacticalEquipUpgrade, self.OnUpgrade)
  self:AddUIListener(EventId.TacticalEquipResearchUpdate, self.OnResearchProgressUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.CommonEquipDataChanged, self.RefreshStatus)
  self:RemoveUIListener(EventId.CommonEquipMerge, self.OnMergeEquip)
  self:RemoveUIListener(EventId.TacticalEquipUpgrade, self.OnUpgrade)
  self:RemoveUIListener(EventId.TacticalEquipResearchUpdate, self.OnResearchProgressUpdate)
  base.OnRemoveListener(self)
end

function UITacticalEquipUpgradeView:OnMergeEquip(msgData)
  if not table.IsNullOrEmpty(msgData) then
    if msgData.msg.flag == nil or msgData.msg.flag < 1 then
      if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSquadEquipResultPanel) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSquadEquipResultPanel, {anim = true}, msgData)
      end
    elseif msgData.msg.flag == 1 then
      UIUtil.ShowTipsId(130310)
    end
  end
  self:RefreshStatus()
end

function UITacticalEquipUpgradeView:ReInit()
  self.ownerUuid, self.slot = self:GetUserData()
  self.curIndex = self.slot or 0
  self:RefreshStatus()
end

function UITacticalEquipUpgradeView:RefreshStatus(isFromShortcutKey)
  self:SetShowBtn(nil)
  self.textTitle:SetLocalText("squad_equip_merge_title_11", DataCenter.CommonEquipDataManager:GetEquipName(self.slot))
  self.textPowerNumber:SetActive(true)
  self.upgradePanel:SetActive(false)
  self.mergePanel:SetActive(false)
  self.emptyPanel:SetActive(false)
  self.maxLevelPanel:SetActive(false)
  self.compSingleStatus:SetActive(false)
  self.compNormalStatus:SetActive(false)
  self:CheckReplace()
  self.curEquip = DataCenter.CommonEquipDataManager:GetWearingEquipByOwnerIdAndSlot(CommonEquipType.SquadEquip, self.ownerUuid, self.slot)
  if self.curEquip ~= nil then
    self.nextEquip = self.curEquip:GetNextLvEquipInfo()
    if self.nextEquip ~= nil then
      local canReplace = DataCenter.CommonEquipDataManager:HasReplaceBatterEquip(self.curEquip, self.slot)
      if self.curEquip:IsOpenExpUpgrade() and not canReplace then
        self.upgradePanel:SetActive(true)
        self.upgradePanel:SetData(self.curEquip, self.slot, isFromShortcutKey)
        self:RefreshEquipBaseDataShow(false)
        self.textTitle:SetLocalText("squad_equip_research_title_1", DataCenter.CommonEquipDataManager:GetEquipName(self.slot))
      else
        self.mergePanel:SetActive(true)
        self.mergePanel:SetData(self.curEquip, self.slot, isFromShortcutKey)
        self:RefreshEquipBaseDataShow(false)
      end
    else
      self.maxLevelPanel:SetActive(true)
      self.maxLevelPanel:SetData(self.curEquip, self.slot, isFromShortcutKey)
      self:RefreshEquipBaseDataShow(true)
    end
    self:RefreshPower()
  else
    self.emptyPanel:SetActive(true)
    self.emptyPanel:SetData(self.curEquip, self.slot, isFromShortcutKey)
    self:RefreshEquipBaseDataShow(true)
    self.textPowerNumber:SetActive(false)
  end
  self:RefreshRedDot()
end

function UITacticalEquipUpgradeView:RefreshRedDot()
  local feed = DataCenter.CommonEquipDataManager:GetEquipResearchCacheFeed()
  local feedCount = 0
  if feed then
    feedCount = #feed
  end
  local freeEquip, freeEquipCount = DataCenter.CommonEquipDataManager:GetAllFreeEquipBagData(self.slot)
  self.oneKeyBtnRedDot:SetActive(0 < freeEquipCount and feedCount == 0)
end

function UITacticalEquipUpgradeView:CheckReplace()
  local newEquip = DataCenter.CommonEquipDataManager:GetWearingEquipByOwnerIdAndSlot(CommonEquipType.SquadEquip, self.ownerUuid, self.slot)
  if self.curEquip and newEquip and self.curEquip.cfgId ~= newEquip.cfgId and self.curEquip.slot == newEquip.slot then
    self:OnUpgrade(newEquip.config)
  end
  self.curEquip = newEquip
end

function UITacticalEquipUpgradeView:OnUpgrade(newConfig)
  local curConfig = self.curEquip.config
  self:OnResearchProgressUpdate()
  self.banFuncClick = true
  self.delayUpgradeResult = TimerManager:GetInstance():DelayInvoke(function()
    self.banFuncClick = false
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalEquipUpgradeResult, {anim = true}, curConfig, newConfig)
  end, 1.2)
end

function UITacticalEquipUpgradeView:OnResearchProgressUpdate()
  self.compVfxUpgrade:Replay()
  self.compVfxUpgradeBg:Replay()
  self:PlayUpgradeSound()
end

function UITacticalEquipUpgradeView:RefreshEquipBaseDataShow(isSingle)
  if isSingle then
    self.compSingleStatus:SetActive(true)
    self.compSingleEquipItem:SetData(self.curEquip, self.slot)
    self.compSingleEquipItem:SetItemCountActive(false)
    if self.curEquip == nil then
      local freeEquip = DataCenter.CommonEquipDataManager:GetAllFreeEquipBagData(self.slot)
      self.compSingleEquipItem:SetRedDot(freeEquip and 0 < #freeEquip)
    else
      self.compSingleEquipItem:SetRedDot(false)
    end
  else
    self.compNormalStatus:SetActive(true)
    self.compCurEquipItem:SetData(self.curEquip, self.slot)
    self.compNextEquipItem:SetData(self.nextEquip, self.slot)
    self.compCurEquipItem:SetItemCountActive(false)
    self.compNextEquipItem:SetItemCountActive(false)
  end
end

function UITacticalEquipUpgradeView:RefreshPower()
  self.textPowerNumber:SetText(self.curEquip:GetPower())
end

function UITacticalEquipUpgradeView:SetShowBtn(showArray)
  for i, v in pairs(self.btnMap) do
    if v then
      v:SetActive(false)
    end
  end
  if showArray == nil or #showArray <= 0 then
    return
  end
  for i, v in ipairs(showArray) do
    if self.btnMap[showArray[i]] then
      self.btnMap[showArray[i]]:SetActive(true)
    end
  end
end

function UITacticalEquipUpgradeView:GetCurEquipData()
  return self.curEquip
end

function UITacticalEquipUpgradeView:GetBuildingUuid()
  return self.ownerUuid
end

local function OnBtnPreviewClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalEquipLevelPreview, {anim = true}, self.curEquip, self.slot)
end

function UITacticalEquipUpgradeView:RefreshShortcutShow()
  self.compShortcutKeyRoot:SetActive(true)
  self:RefreshShortcutKeyState()
  self:RefreshShortcutKeyRedPoint()
end

function UITacticalEquipUpgradeView:RefreshShortcutShowAndContent()
  if self.ownerUuid == nil then
    self.ownerUuid = BuildingTypes.LW_BUILD_TACTICAL_CENTER
  end
  self:DataDestroy()
  self.slot = self.curIndex
  self:RefreshStatus(true)
  self:RefreshShortcutKeyState()
  self:RefreshShortcutKeyRedPoint()
end

function UITacticalEquipUpgradeView:RefreshShortcutKeyState()
  self.btnLeftShortcutKey:SetActive(self.curIndex ~= 1)
  self.btnRightShortcutKey:SetActive(self.curIndex ~= 6)
end

function UITacticalEquipUpgradeView:RefreshShortcutKeyRedPoint()
  local leftCurIndex = math.max(self.curIndex - 1, 1)
  local isShowLeftRedPoint = self:IsShowRedPoint(leftCurIndex)
  self.compLeftShortcutKeyRedPoint:SetActive(isShowLeftRedPoint)
  local rightCurIndex = math.min(self.curIndex + 1, 6)
  local isShowRightRedPoint = self:IsShowRedPoint(rightCurIndex)
  self.compRightShortcutKeyRedPoint:SetActive(isShowRightRedPoint)
end

function UITacticalEquipUpgradeView:IsShowRedPoint(slotId)
  local hasRed = DataCenter.CommonEquipDataManager:IsHasBetterCommonEquipSlot(CommonEquipType.SquadEquip, self.ownerUuid, slotId)
  hasRed = hasRed or DataCenter.CommonEquipDataManager:IsCommonEquipCanUpgradeByOwnerSlot(CommonEquipType.SquadEquip, self.ownerUuid, slotId)
  hasRed = hasRed or DataCenter.CommonEquipDataManager:CanResearch(slotId)
  return hasRed
end

function UITacticalEquipUpgradeView:OnBtnLeftShortcutKeyClick()
  self.curIndex = math.max(self.curIndex - 1, 1)
  self:RefreshShortcutShowAndContent()
end

function UITacticalEquipUpgradeView:OnBtnRightShortcutKeyClick()
  self.curIndex = math.min(self.curIndex + 1, 6)
  self:RefreshShortcutShowAndContent()
end

function UITacticalEquipUpgradeView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UITacticalEquipUpgradeView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UITacticalEquipUpgradeView:OnBtnOneKeyClick()
  if self.banFuncClick then
    return
  end
  local hasFeed = self.upgradePanel:AutoFill()
  if not hasFeed then
    UIUtil.ShowTipsId("squad_equip_research_desc_13")
    LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.CommonEquip, 1)
  end
end

function UITacticalEquipUpgradeView:OnBtnMergeClick()
  if self.banFuncClick then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.CommonEquipAutoMerge, self.slot)
end

function UITacticalEquipUpgradeView:OnBtnUpgradeClick()
  if self.banFuncClick then
    return
  end
  if not self.curEquip then
    return
  end
  local equipCanUpgrade = DataCenter.CommonEquipDataManager:IsCommonEquipCanUpgrade(self.curEquip.cfgId, self.curEquip.num)
  if equipCanUpgrade then
    SFSNetwork.SendMessage(MsgDefines.CommonEquipMerge, self.curEquip.uuid, 0, 1)
  end
end

function UITacticalEquipUpgradeView:OnBtnGetMoreClick()
  if self.banFuncClick then
    return
  end
  LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.CommonEquip, 1)
end

function UITacticalEquipUpgradeView:OnBtnUseClick()
  if self.banFuncClick then
    return
  end
  local targetEquipData = self.emptyPanel:GetCurSelectEquipData()
  if targetEquipData and self.ownerUuid then
    SFSNetwork.SendMessage(MsgDefines.CommonEquipPutOn, tostring(self.ownerUuid), {
      [self.slot] = targetEquipData.uuid
    })
  end
end

function UITacticalEquipUpgradeView:OnBtnConfirmClick()
  if self.banFuncClick then
    return
  end
  self.ctrl:CloseSelf()
end

function UITacticalEquipUpgradeView:OnBtnResearchClick()
  if self.banFuncClick then
    return
  end
  local feed = self.upgradePanel:GetSelectFeedCache()
  if feed and 0 < #feed then
    local cacheResideExp = self.upgradePanel:GetCacheResideExp() or 0
    if 0 < cacheResideExp then
      UIUtil.ShowMessage(Localization:GetString("squad_equip_max_desc_3", cacheResideExp), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.SquadEquipNewUpgrade, feed, self.slot)
      end)
    else
      SFSNetwork.SendMessage(MsgDefines.SquadEquipNewUpgrade, feed, self.slot)
    end
  end
end

function UITacticalEquipUpgradeView:OnBtnReplaceClick()
  if self.banFuncClick then
    return
  end
  local targetEquipData = DataCenter.CommonEquipDataManager:GetOwnMaxLvFreeEquip(self.slot)
  if targetEquipData and self.ownerUuid then
    SFSNetwork.SendMessage(MsgDefines.CommonEquipPutOn, tostring(self.ownerUuid), {
      [self.slot] = targetEquipData.uuid
    })
  end
end

function UITacticalEquipUpgradeView:OnBtnMergeBanClick()
end

function UITacticalEquipUpgradeView:PlayUpgradeSound()
  self:StopUpgradeSound()
  self.playingUpgradeSoundId = DataCenter.LWSoundManager:PlaySound(62284, false)
end

function UITacticalEquipUpgradeView:StopUpgradeSound()
  if self.playingUpgradeSoundId then
    DataCenter.LWSoundManager:StopSound(self.playingUpgradeSoundId)
    self.playingUpgradeSoundId = nil
  end
end

UITacticalEquipUpgradeView.OnCreate = OnCreate
UITacticalEquipUpgradeView.OnDestroy = OnDestroy
UITacticalEquipUpgradeView.OnEnable = OnEnable
UITacticalEquipUpgradeView.OnDisable = OnDisable
UITacticalEquipUpgradeView.ComponentDefine = ComponentDefine
UITacticalEquipUpgradeView.ComponentDestroy = ComponentDestroy
UITacticalEquipUpgradeView.DataDefine = DataDefine
UITacticalEquipUpgradeView.DataDestroy = DataDestroy
UITacticalEquipUpgradeView.OnAddListener = OnAddListener
UITacticalEquipUpgradeView.OnRemoveListener = OnRemoveListener
UITacticalEquipUpgradeView.OnBtnPreviewClick = OnBtnPreviewClick
return UITacticalEquipUpgradeView
