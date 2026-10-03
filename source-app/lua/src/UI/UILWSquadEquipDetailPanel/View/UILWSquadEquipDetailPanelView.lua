local UILWSquadEquipDetailPanelView = BaseClass("UILWSquadEquipDetailPanelView", UIBaseView)
local base = UIBaseView
local BagItem = require("UI.UILWBag.UILWBagMain.Component.UILWBagItem")
local EquipContent = require("UI.UILWSquadEquipDetailPanel.Component.UILWSquadEquipContent")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local root_path = "Root"
local back_btn_path = "UICommonPopUpTitle/CloseBtn"
local close_panel_path = "UICommonPopUpTitle/panel"
local batch_merge_btn_path = "Root/Btns/BatchMergeBtn"
local merge_btn_path = "Root/Btns/MergeBtn"
local equip_btn_path = "Root/Btns/EquipBtn"
local unequip_btn_path = "Root/Btns/UnequipBtn"
local wear_equip_container_path = "Root/EquipContent/WearEquipContent"
local wear_equip_content_path = "Root/EquipContent/WearEquipContent/EquipContent"
local change_equip_container_path = "Root/EquipContent/ChangeEquipContent"
local change_equip_curEquip_path = "Root/EquipContent/ChangeEquipContent/CurEquipContent"
local change_equip_nextEquip_path = "Root/EquipContent/ChangeEquipContent/NextEquipContent"
local equip_gridScroll_content_path = "Root/EquipContent/EquipList/EquipScroll/Viewport/Content"
local equip_gridScroll_path = "Root/EquipContent/EquipList/EquipScroll"
local selected_frame_path = "Root/SelectedFrame"
local empty_equip_text_path = "Root/EquipContent/EquipList/EmptyEquipText"
local getMore_btn_path = "Root/Btns/GetMoreBtn"
local panel_bg_btn_path = "UICommonPopUpTitle/Common_bg_orange"
local upgrade_btn_path = "Root/Btns/UpgradeBtn"
local equip_btn_redDot_path = "Root/Btns/EquipBtn/EquipBtnRedDot"
local auto_merge_btn_path = "Root/Btns/AutoMergeBtn"
local upgrade_effect_path = "Root/EquipContent/ChangeEquipContent/UpgradeEffect"
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.buildingUuid, self.equipSlotId = self:GetUserData()
  if not self.buildingUuid or not self.equipSlotId then
    self.ctrl:CloseSelf()
    return
  end
  
  local function SetNameByTemplate(template)
    if template then
      self.titleText:SetLocalText(template.name)
    else
      self.titleText:SetText("")
    end
  end
  
  local template
  if self.equipSlotId == 1 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1101)
  elseif self.equipSlotId == 2 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1201)
  elseif self.equipSlotId == 3 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1301)
  elseif self.equipSlotId == 4 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1401)
  elseif self.equipSlotId == 5 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1501)
  elseif self.equipSlotId == 6 then
    template = DataCenter.CommonEquipTemplateManager:GetTemplate(1601)
  end
  SetNameByTemplate(template)
  self:ReInit()
end

local function ResetSelectedFrame(self)
  if self.selectedFrame and not IsNull(self.selectedFrame.transform) and self.root then
    self.selectedFrame.transform:SetParent(self.root.transform)
    self.selectedFrame.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.selectedFrame:SetActive(false)
  end
end

local function OnDestroy(self)
  self:ResetSelectedFrame()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.upgradeEffect then
    self.upgradeEffect:SetActive(false)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnEquipBtnClick(self)
  if self.selectedEquipData and self.buildingUuid then
    if self.curEquip then
      local function yesCallback()
        SFSNetwork.SendMessage(MsgDefines.CommonEquipPutOn, tostring(self.buildingUuid), {
          [self.equipSlotId] = self.selectedEquipData.uuid
        })
        self.ctrl:CloseSelf()
      end
      
      if self.curEquip:GetPower() > self.selectedEquipData:GetPower() then
        UIUtil.ShowMessage(Localization:GetString("2000539"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, yesCallback)
        return
      end
    end
    SFSNetwork.SendMessage(MsgDefines.CommonEquipPutOn, tostring(self.buildingUuid), {
      [self.equipSlotId] = self.selectedEquipData.uuid
    })
  end
  self.ctrl:CloseSelf()
end

local function OnUnequipBtnClick(self)
  if self.curEquip and self.buildingUuid then
    SFSNetwork.SendMessage(MsgDefines.CommonEquipPutOff, self.curEquip.uuid)
  end
  self.ctrl:CloseSelf()
end

local function CanUpgradeWithEquipData(self, equipData, number)
  if not equipData then
    return false
  end
  local cost = equipData:GetUpgrdaeCost()
  if not table.IsNullOrEmpty(cost) then
    for id, num in pairs(cost) do
      if id == equipData.cfgId then
        return equipData.num >= num * number
      end
    end
  end
  return false
end

local function CanAutoMerge(self)
  if not table.IsNullOrEmpty(self.allEquips) then
    for _, v in pairs(self.allEquips) do
      local equipUpgradeCost = v.data:GetUpgrdaeCost()
      local equipUpgradeCostNum = 3
      if not table.IsNullOrEmpty(equipUpgradeCost) then
        for id, num in pairs(equipUpgradeCost) do
          if id == v.data.cfgId then
            equipUpgradeCostNum = num
            break
          end
        end
      end
      if equipUpgradeCostNum <= v.data.num and v.data:GetCanUpgrade() then
        return true
      end
    end
  else
    return false
  end
  return false
end

local function OnMergeBtnClick(self)
  if self.selectedEquipData then
    local canMerge = CanUpgradeWithEquipData(self, self.selectedEquipData, 1)
    if not canMerge then
      return
    end
    SFSNetwork.SendMessage(MsgDefines.CommonEquipMerge, self.selectedEquipData.uuid, 0)
  end
end

local function OnBatchMergeBtnClick(self)
  if self.selectedEquipData then
    local canMerge = CanUpgradeWithEquipData(self, self.selectedEquipData, 2)
    if not canMerge then
      return
    end
    SFSNetwork.SendMessage(MsgDefines.CommonEquipMerge, self.selectedEquipData.uuid, 1)
  end
end

local function OnGetMoreBtnClick(self)
  LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.CommonEquip, 1)
end

local function OnUpgradeBtnClick(self)
  if self.curEquip then
    local canMerge = DataCenter.CommonEquipDataManager:IsCommonEquipCanUpgrade(self.curEquip.cfgId, self.curEquip.num)
    if not canMerge then
      return
    end
    SFSNetwork.SendMessage(MsgDefines.CommonEquipMerge, self.curEquip.uuid, 0, 1)
  end
end

local function OnAutoMergeBtnClick(self)
  if self.buildingUuid and self.equipSlotId and CanAutoMerge(self) then
    SFSNetwork.SendMessage(MsgDefines.CommonEquipAutoMerge, self.equipSlotId)
  end
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.backBtn = self:AddComponent(UIButton, back_btn_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closePanel = self:AddComponent(UIButton, close_panel_path)
  self.closePanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.batchMergeBtn = self:AddComponent(UIButton, batch_merge_btn_path)
  self.batchMergeBtn:SetOnClick(function()
    self:OnBatchMergeBtnClick()
  end)
  self.mergeBtn = self:AddComponent(UIButton, merge_btn_path)
  self.mergeBtn:SetOnClick(function()
    self:OnMergeBtnClick()
  end)
  self.equipBtn = self:AddComponent(UIButton, equip_btn_path)
  self.equipBtn:SetOnClick(function()
    self:OnEquipBtnClick()
  end)
  self.unequipBtn = self:AddComponent(UIButton, unequip_btn_path)
  self.unequipBtn:SetOnClick(function()
    self:OnUnequipBtnClick()
  end)
  self.wearEquipContainer = self:AddComponent(UIBaseContainer, wear_equip_container_path)
  self.wearEquipContent = self:AddComponent(EquipContent, wear_equip_content_path)
  self.changeEquipContainer = self:AddComponent(UIBaseContainer, change_equip_container_path)
  self.changeEquipCurEquip = self:AddComponent(EquipContent, change_equip_curEquip_path)
  self.changeEquipNextEquip = self:AddComponent(EquipContent, change_equip_nextEquip_path)
  self.equipGridScroll = self:AddComponent(UIScrollView, equip_gridScroll_path)
  self.equipGridScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.equipGridScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.equipScrollEventTrigger = self:AddComponent(UIEventTrigger, equip_gridScroll_path)
  self.equipScrollEventTrigger:OnPointerClick(function(eventData)
    self:UnSelectEquip()
  end)
  self.selectedFrame = self:AddComponent(UIBaseContainer, selected_frame_path)
  self:ResetSelectedFrame()
  self.emptyEquipText = self:AddComponent(UIText, empty_equip_text_path)
  self.getMoreBtn = self:AddComponent(UIButton, getMore_btn_path)
  self.getMoreBtn:SetOnClick(function()
    OnGetMoreBtnClick(self)
  end)
  self.bgBtn = self:AddComponent(UIButton, panel_bg_btn_path)
  self.bgBtn:SetOnClick(function()
    self:UnSelectEquip()
  end)
  self.upgradeBtn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgradeBtn:SetOnClick(function()
    OnUpgradeBtnClick(self)
  end)
  self.equipBtnRedDot = self:AddComponent(UIBaseContainer, equip_btn_redDot_path)
  self.autoMergeBtn = self:AddComponent(UIButton, auto_merge_btn_path)
  self.autoMergeBtn:SetOnClick(function()
    OnAutoMergeBtnClick(self)
  end)
  self.upgradeEffect = self:AddComponent(UIBaseContainer, upgrade_effect_path)
  self.titleText = self:AddComponent(UIText, title_text_path)
end

local function ComponentDestroy(self)
  self.root = nil
  self.backBtn = nil
  self.closePanel = nil
  self.batchMergeBtn = nil
  self.mergeBtn = nil
  self.equipBtn = nil
  self.unequipBtn = nil
  self.wearEquipContainer = nil
  self.wearEquipContent = nil
  self.changeEquipContainer = nil
  self.changeEquipCurEquip = nil
  self.changeEquipNextEquip = nil
  self.equipGridScroll = nil
  self.equipScrollEventTrigger = nil
  self.selectedFrame = nil
  self.emptyEquipText = nil
  self.getMoreBtn = nil
  self.bgBtn = nil
  self.upgradeBtn = nil
  self.equipBtnRedDot = nil
  self.autoMergeBtn = nil
end

local function DataDefine(self)
  self.equipItems = {}
  self.clickEquiupCallback = BindCallback(self, self.OnSelecteEquipItem)
end

local function DataDestroy(self)
  self.equipItems = nil
  self.clickEquiupCallback = nil
end

local function OnMergeEquip(self, msgData)
  if not table.IsNullOrEmpty(msgData) then
    if msgData.msg.flag == nil or msgData.msg.flag < 1 then
      if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSquadEquipResultPanel) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSquadEquipResultPanel, {anim = true}, msgData)
      end
    elseif msgData.msg.flag == 1 then
      UIUtil.ShowTipsId(130310)
      self.upgradeEffect:SetActive(false)
      self.upgradeEffect:SetActive(true)
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CommonEquipDataChanged, self.OnEquipDataChange)
  self:AddUIListener(EventId.CommonEquipMerge, self.OnMergeEquip)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CommonEquipDataChanged, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.CommonEquipMerge, self.OnMergeEquip)
end

local function RefreshEquipScroll(self)
  local allEquips = DataCenter.CommonEquipDataManager:GetAllFreeEqiups(CommonEquipType.SquadEquip, self.equipSlotId)
  local freeEquipData = {}
  for i, v in ipairs(allEquips) do
    local bagData = {}
    bagData.data = v
    bagData.index = i
    bagData.callBack = self.clickEquiupCallback
    bagData.showRedPoint = false
    bagData.type = BagItemType.CommonEquip
    table.insert(freeEquipData, bagData)
  end
  self.allEquips = freeEquipData
  local maxLevelEquipUid
  local maxLevel = 0
  for _, v in pairs(allEquips) do
    if maxLevel < v:GetConfigLevel() then
      maxLevel = v:GetConfigLevel()
      maxLevelEquipUid = v.uuid
    end
  end
  self.maxLevelEquipUid = maxLevelEquipUid
  self:ClearScroll()
  local itemCount = #self.allEquips
  if 0 < itemCount then
    self.emptyEquipText:SetActive(false)
    self.equipGridScroll:SetActive(true)
    self.equipGridScroll:SetTotalCount(itemCount)
    self.equipGridScroll:RefillCells()
  else
    self.emptyEquipText:SetActive(true)
    self.equipGridScroll:SetActive(false)
  end
end

local function ReInitWearEquipContent(self)
  self.wearEquipContent:SetData(nil)
end

local function ReInitChangeEquipContent(self)
  self.changeEquipCurEquip:SetData(self.curEquip)
  self.changeEquipNextEquip:SetData(nil)
end

local function ClearScroll(self)
  self:ResetSelectedFrame()
  self.equipItems = {}
  self.equipGridScroll:ClearCells()
  self.equipGridScroll:RemoveComponents(BagItem)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  self.equipItems[index] = self.equipGridScroll:AddComponent(BagItem, itemObj)
  self.equipItems[index]:SetData(self.allEquips[index])
  local equipData = self.allEquips[index].data
  if self.maxLevelEquipUid and equipData.uuid == self.maxLevelEquipUid then
    if self.curEquip then
      self.equipItems[index].red_img:SetActive(equipData:GetConfigLevel() > self.curEquip:GetConfigLevel())
    else
      self.equipItems[index].red_img:SetActive(true)
    end
  else
    self.equipItems[index].red_img:SetActive(false)
  end
end

local function OnItemMoveOut(self, itemObj, index)
  self.equipItems[index] = nil
  self.equipGridScroll:RemoveComponent(itemObj.name, BagItem)
end

local function RefreshBtns(self)
  if self.curEquip == nil then
    self.upgradeBtn:SetActive(false)
    if self.selectedEquipData == nil then
      self.equipBtn:SetActive(false)
      self.unequipBtn:SetActive(false)
      self.batchMergeBtn:SetActive(false)
      self.mergeBtn:SetActive(false)
      local showAutoMerge = CanAutoMerge(self)
      self.getMoreBtn:SetActive(not showAutoMerge)
      self.autoMergeBtn:SetActive(showAutoMerge)
    else
      self.equipBtn:SetActive(true)
      self.unequipBtn:SetActive(false)
      self.batchMergeBtn:SetActive(true)
      self.mergeBtn:SetActive(true)
      self.autoMergeBtn:SetActive(false)
      if self.selectedEquipData:GetCanUpgrade() then
        self.mergeBtn:SetActive(true)
        self.batchMergeBtn:SetActive(true)
        local canMerge = CanUpgradeWithEquipData(self, self.selectedEquipData, 1)
        self.mergeBtn:SetActive(canMerge)
        local canMulMerge = CanUpgradeWithEquipData(self, self.selectedEquipData, 2)
        self.batchMergeBtn:SetActive(canMulMerge)
        self.getMoreBtn:SetActive(not canMerge)
      else
        self.mergeBtn:SetActive(false)
        self.batchMergeBtn:SetActive(false)
        self.getMoreBtn:SetActive(true)
      end
    end
  elseif self.selectedEquipData == nil then
    self.equipBtn:SetActive(false)
    self.unequipBtn:SetActive(true)
    self.batchMergeBtn:SetActive(false)
    self.mergeBtn:SetActive(false)
    local equipCanUpgrade = DataCenter.CommonEquipDataManager:IsCommonEquipCanUpgrade(self.curEquip.cfgId, self.curEquip.num)
    if equipCanUpgrade then
      self.upgradeBtn:SetActive(true)
      self.getMoreBtn:SetActive(false)
      self.autoMergeBtn:SetActive(false)
    elseif CanAutoMerge(self) then
      self.upgradeBtn:SetActive(false)
      self.getMoreBtn:SetActive(false)
      self.autoMergeBtn:SetActive(true)
    else
      self.upgradeBtn:SetActive(false)
      self.getMoreBtn:SetActive(true)
      self.autoMergeBtn:SetActive(false)
    end
  else
    self.equipBtn:SetActive(true)
    self.unequipBtn:SetActive(false)
    self.batchMergeBtn:SetActive(true)
    self.mergeBtn:SetActive(true)
    self.upgradeBtn:SetActive(false)
    self.autoMergeBtn:SetActive(false)
    if self.selectedEquipData:GetCanUpgrade() then
      self.mergeBtn:SetActive(true)
      self.batchMergeBtn:SetActive(true)
      local canMerge = CanUpgradeWithEquipData(self, self.selectedEquipData, 1)
      self.mergeBtn:SetActive(canMerge)
      local canMulMerge = CanUpgradeWithEquipData(self, self.selectedEquipData, 2)
      self.batchMergeBtn:SetActive(canMulMerge)
      self.getMoreBtn:SetActive(not canMerge)
    else
      self.mergeBtn:SetActive(false)
      self.batchMergeBtn:SetActive(false)
      self.getMoreBtn:SetActive(true)
    end
  end
end

local function ReInit(self)
  local hasEquipNow = false
  self.curEquip = DataCenter.CommonEquipDataManager:GetWearingEquipByOwnerIdAndSlot(CommonEquipType.SquadEquip, self.buildingUuid, self.equipSlotId)
  if self.curEquip then
    hasEquipNow = true
  end
  self.wearEquipContainer:SetActive(not hasEquipNow)
  self.changeEquipContainer:SetActive(hasEquipNow)
  if hasEquipNow then
    self:ReInitChangeEquipContent()
  else
    self:ReInitWearEquipContent()
  end
  self:RefreshEquipScroll()
  self:RefreshBtns()
end

local function OnSelecteEquipItem(self, transform, index)
  if self.selectedFrame and not IsNull(self.selectedFrame.transform) then
    self.selectedFrame.transform:SetParent(transform)
    self.selectedFrame.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.selectedFrame:SetActive(true)
    self.selectedFrame:SetAnchoredPositionXY(0, 0)
  end
  local equipData = self.allEquips[index]
  self.selectedEquipData = equipData.data
  if self.curEquip then
    self.changeEquipNextEquip:SetData(self.selectedEquipData)
    self:RefreshBtns()
  else
    self.wearEquipContent:SetData(self.selectedEquipData)
    self:RefreshBtns()
  end
  if self.maxLevelEquipUid and self.selectedEquipData.uuid == self.maxLevelEquipUid then
    if self.curEquip then
      self.equipBtnRedDot:SetActive(self.selectedEquipData:GetConfigLevel() > self.curEquip:GetConfigLevel())
    else
      self.equipBtnRedDot:SetActive(true)
    end
  else
    self.equipBtnRedDot:SetActive(false)
  end
end

local function UnSelectEquip(self)
  self.selectedEquipData = nil
  self:ResetSelectedFrame()
  if self.curEquip then
    self.changeEquipNextEquip:SetData(self.selectedEquipData)
  else
    self.wearEquipContent:SetData(self.selectedEquipData)
  end
  self:RefreshBtns()
end

local function OnEquipDataChange(self)
  local prevSelectedEquipData = self.selectedEquipData
  self:UnSelectEquip()
  self:RefreshEquipScroll()
  local transform, index
  if prevSelectedEquipData and self.allEquips then
    for i, v in pairs(self.allEquips) do
      if v.data and v.data and v.data.uuid == prevSelectedEquipData.uuid and self.equipItems[i] then
        transform = self.equipItems[i].transform
        index = i
        break
      end
    end
  end
  if transform and index then
    OnSelecteEquipItem(self, transform, index)
  end
  local hasEquipNow = false
  self.curEquip = DataCenter.CommonEquipDataManager:GetWearingEquipByOwnerIdAndSlot(CommonEquipType.SquadEquip, self.buildingUuid, self.equipSlotId)
  if self.curEquip then
    hasEquipNow = true
  end
  self.wearEquipContainer:SetActive(not hasEquipNow)
  self.changeEquipContainer:SetActive(hasEquipNow)
  if hasEquipNow then
    self:ReInitChangeEquipContent()
  else
    self:ReInitWearEquipContent()
  end
  self:RefreshBtns()
end

UILWSquadEquipDetailPanelView.OnCreate = OnCreate
UILWSquadEquipDetailPanelView.OnDestroy = OnDestroy
UILWSquadEquipDetailPanelView.OnEnable = OnEnable
UILWSquadEquipDetailPanelView.OnDisable = OnDisable
UILWSquadEquipDetailPanelView.ComponentDefine = ComponentDefine
UILWSquadEquipDetailPanelView.ComponentDestroy = ComponentDestroy
UILWSquadEquipDetailPanelView.DataDefine = DataDefine
UILWSquadEquipDetailPanelView.DataDestroy = DataDestroy
UILWSquadEquipDetailPanelView.OnAddListener = OnAddListener
UILWSquadEquipDetailPanelView.OnRemoveListener = OnRemoveListener
UILWSquadEquipDetailPanelView.RefreshEquipScroll = RefreshEquipScroll
UILWSquadEquipDetailPanelView.ReInitWearEquipContent = ReInitWearEquipContent
UILWSquadEquipDetailPanelView.ReInitChangeEquipContent = ReInitChangeEquipContent
UILWSquadEquipDetailPanelView.ClearScroll = ClearScroll
UILWSquadEquipDetailPanelView.OnItemMoveIn = OnItemMoveIn
UILWSquadEquipDetailPanelView.OnItemMoveOut = OnItemMoveOut
UILWSquadEquipDetailPanelView.ResetSelectedFrame = ResetSelectedFrame
UILWSquadEquipDetailPanelView.RefreshBtns = RefreshBtns
UILWSquadEquipDetailPanelView.OnSelecteEquipItem = OnSelecteEquipItem
UILWSquadEquipDetailPanelView.OnEquipDataChange = OnEquipDataChange
UILWSquadEquipDetailPanelView.OnEquipBtnClick = OnEquipBtnClick
UILWSquadEquipDetailPanelView.OnUnequipBtnClick = OnUnequipBtnClick
UILWSquadEquipDetailPanelView.OnBatchMergeBtnClick = OnBatchMergeBtnClick
UILWSquadEquipDetailPanelView.OnMergeBtnClick = OnMergeBtnClick
UILWSquadEquipDetailPanelView.UnSelectEquip = UnSelectEquip
UILWSquadEquipDetailPanelView.OnMergeEquip = OnMergeEquip
UILWSquadEquipDetailPanelView.ReInit = ReInit
return UILWSquadEquipDetailPanelView
