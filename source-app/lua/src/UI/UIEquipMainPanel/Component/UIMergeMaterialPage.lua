local UIMergeMaterialPage = BaseClass("UIMergeMaterialPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local UIEquipMaterialGroup = require("UI.UIEquipMainPanel.Component.UIEquipMaterialGroup")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function RefreshBatchMergeBtn(self)
  if self.curSelectedMaterialId == nil or self.curSelectedMaterialId <= 0 then
    self.batchMergeBtn:SetActive(false)
    return
  end
  local count = DataCenter.EquipMaterialDataManager:GetCountById(self.curSelectedMaterialId)
  if 24 <= count then
    self.batchMergeBtn:SetActive(true)
    self.batchMergeBtnText:SetText("Max")
    self.batchMergeState = 2
  elseif 20 <= count then
    self.batchMergeBtn:SetActive(true)
    self.batchMergeBtnText:SetText("5")
    self.batchMergeState = 1
  else
    self.batchMergeBtn:SetActive(false)
    self.batchMergeState = 0
  end
end

local function OnBatchMergeBtnClick(self)
  if self.curSelectedMaterialId == nil or self.curSelectedMaterialId <= 0 then
    return
  end
  if self.batchMergeState == 0 then
    return
  end
  local count = DataCenter.EquipMaterialDataManager:GetCountById(self.curSelectedMaterialId)
  if count < 4 then
    UIUtil.ShowTipsId(430750)
    return
  end
  if self.batchMergeState == 1 then
    SFSNetwork.SendMessage(MsgDefines.HeroEquipMaterialCompose, self.curSelectedMaterialId, 20)
  elseif self.batchMergeState == 2 then
    SFSNetwork.SendMessage(MsgDefines.HeroEquipMaterialCompose, self.curSelectedMaterialId, math.floor(count / 4) * 4)
  end
end

local function OnMergeBtnClick(self)
  if self.curSelectedMaterialId == nil or self.curSelectedMaterialId <= 0 then
    return
  end
  local materialCount = DataCenter.EquipMaterialDataManager:GetCountById(self.curSelectedMaterialId)
  if materialCount < 4 then
    UIUtil.ShowTipsId(430750)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.HeroEquipMaterialCompose, self.curSelectedMaterialId, 4)
end

local function ClearScroll(self)
  self.equipMaterialGroupScroll:RemoveComponents(UIEquipMaterialGroup)
  self.equipMaterialGroupList:ClearAllItems()
end

local function RefreshMaterialInfo(self)
  if self.curSelectedMaterialId == nil or self.curSelectedMaterialId <= 0 then
    self.newMaterialInfo:SetActive(false)
    self.conditionText:SetActive(true)
    self.oldMaterialNameText:SetActive(false)
    self.conditionText:SetColorRGBA(1, 1, 1, 0.7)
    self.conditionText:SetLocalText(430718)
    for _, oldMaterialItem in pairs(self.oldMaterialItems) do
      oldMaterialItem:SetActive(false)
    end
    for _, emptyMaterialSlot in pairs(self.emptyMaterialSlots) do
      emptyMaterialSlot:SetActive(true)
    end
    UIGray.SetGray(self.mergeBtn.transform, true, false)
    return
  else
    self.oldMaterialNameText:SetActive(true)
    for _, oldMaterialItem in pairs(self.oldMaterialItems) do
      oldMaterialItem:SetActive(true)
    end
    for _, emptyMaterialSlot in pairs(self.emptyMaterialSlots) do
      emptyMaterialSlot:SetActive(false)
    end
    UIGray.SetGray(self.mergeBtn.transform, false, true)
  end
  local param1 = {
    rewardType = RewardType.RESOURCE_ITEM,
    itemId = self.curSelectedMaterialId
  }
  for _, oldMaterialItem in pairs(self.oldMaterialItems) do
    oldMaterialItem:ReInit(param1)
  end
  local oldMaterialData = DataCenter.EquipMaterialDataManager:GetTemplate(self.curSelectedMaterialId)
  if oldMaterialData ~= nil then
    self.oldMaterialNameText:SetLocalText(oldMaterialData.name)
    self.oldMaterialNameText:SetColor(UIUtil.GetColorByQuality(oldMaterialData.quality))
  end
  local nextMaterialData = DataCenter.EquipMaterialDataManager:GetNextQualityMaterial(self.curSelectedMaterialId)
  if nextMaterialData ~= nil then
    self.newMaterialInfo:SetActive(true)
    self.conditionText:SetActive(false)
    local param2 = {
      rewardType = RewardType.RESOURCE_ITEM,
      itemId = nextMaterialData.id
    }
    self.newMaterialItem:ReInit(param2)
    self.newMaterialNameText:SetLocalText(nextMaterialData.name)
    self.newMaterialNameText:SetColor(UIUtil.GetColorByQuality(nextMaterialData.quality))
    UIGray.SetGray(self.mergeBtn.transform, false, true)
  else
    self.newMaterialInfo:SetActive(false)
    self.conditionText:SetActive(true)
    self.conditionText:SetColorRGBA(1, 0.882, 0.6, 1)
    self.conditionText:SetLocalText(430717)
    UIGray.SetGray(self.mergeBtn.transform, true, false)
  end
end

local function OnClickMaterialItem(self, itemId)
  local materialCount = DataCenter.EquipMaterialDataManager:GetCountById(itemId)
  if materialCount < 4 then
    UIUtil.ShowTipsId(430750)
    return
  end
  local prevSelectedMaterialCategoryId = self.curSelectedMaterialId
  if prevSelectedMaterialCategoryId == itemId then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Select_Accessories, false)
  self:StopMergeEffect()
  for _, materialGroup in pairs(self.equipMaterialGroupItems) do
    materialGroup:SetSelected(itemId)
  end
  self.curSelectedMaterialId = itemId
  RefreshMaterialInfo(self)
  self.batchMergeBtn:SetActive(false)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.equipMaterialDataList then
    return nil
  end
  local materialGroup = self.equipMaterialDataList[index]
  local item = loopScroll:NewListViewItem("EquipMaterialGroup")
  local script = self.equipMaterialGroupScroll:GetComponent(item.gameObject.name, UIEquipMaterialGroup)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.equipMaterialGroupScroll:AddComponent(UIEquipMaterialGroup, objectName)
  end
  script:SetActive(true)
  script:SetData(materialGroup, BindCallback(self, OnClickMaterialItem))
  script:SetSelected(self.curSelectedMaterialId)
  self.equipMaterialGroupItems[materialGroup.category] = script
  return item
end

local function OnDestroy(self)
  self:StopMergeEffect()
  ClearScroll(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.equipMaterialDataList = {}
  self.equipMaterialGroupItems = {}
  self.itemIndex = 1
  self.curSelectedMaterialId = 0
  self.batchMergeState = 0
end

local function DataDestroy(self)
  self.equipMaterialDataList = nil
  self.equipMaterialGroupItems = nil
  self.itemIndex = nil
  self.curSelectedMaterialId = 0
  self.batchMergeState = 0
end

local function RefershEquipMaterialDataList(self)
  local allMaterial = DataCenter.EquipMaterialDataManager:GetAllMaterialPlayerHave(true)
  local equipMaterialDataList = {}
  for category, materialsData in pairs(allMaterial) do
    local equipMaterialGroupData = {}
    equipMaterialGroupData.category = category
    equipMaterialGroupData.materials = materialsData
    table.sort(equipMaterialGroupData.materials, function(a, b)
      local aData = DataCenter.EquipMaterialDataManager:GetTemplate(a.id)
      local bData = DataCenter.EquipMaterialDataManager:GetTemplate(b.id)
      return aData.quality > bData.quality
    end)
    table.insert(equipMaterialDataList, equipMaterialGroupData)
  end
  table.sort(equipMaterialDataList, function(a, b)
    return a.category < b.category
  end)
  self.equipMaterialDataList = equipMaterialDataList
  if self.equipMaterialDataList == nil or #self.equipMaterialDataList == 0 then
    self.equipMaterialGroupList:SetActive(false)
  else
    self.equipMaterialGroupList:SetActive(true)
    self.equipMaterialGroupList:SetListItemCount(#self.equipMaterialDataList, false, false)
    self.equipMaterialGroupList:RefreshAllShownItem()
  end
end

local function OnFinishComposeMaterial(self, cfgId)
  local curSelectedMaterial = DataCenter.EquipMaterialDataManager:GetCountById(self.curSelectedMaterialId)
  if curSelectedMaterial < 4 then
    self.curSelectedMaterialId = 0
  end
  RefershEquipMaterialDataList(self)
  RefreshBatchMergeBtn(self)
  self:StopMergeEffect()
  self:StartMergeEffect(cfgId)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroEqupiMaterialCompose, OnFinishComposeMaterial)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroEqupiMaterialCompose, OnFinishComposeMaterial)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function SetData(self)
  self:StopMergeEffect()
  RefershEquipMaterialDataList(self)
  RefreshMaterialInfo(self)
  self.batchMergeBtn:SetActive(false)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  self.batchMergeBtn:SetActive(false)
end

local function StopMergeEffect(self)
  self.mergeEffects:SetActive(false)
  if self.mergeEffectSequence ~= nil then
    self.mergeEffectSequence:Kill()
    self.mergeEffectSequence = nil
  end
end

local function StartMergeEffect(self, cfgId)
  self.mergeEffectSequence = CS.DG.Tweening.DOTween.Sequence()
  self.mergeEffectSequence:AppendCallback(function()
    self.mergeEffects:SetActive(true)
    self.oldMaterialMergeEffects:SetActive(false)
    self.mergeArrowEffects:SetActive(false)
    for _, newMaterialMergeEffect in pairs(self.newMaterialMergeEffects) do
      newMaterialMergeEffect:SetActive(false)
    end
  end)
  self.mergeEffectSequence:AppendCallback(function()
    self.oldMaterialMergeEffects:SetActive(true)
  end)
  self.mergeEffectSequence:AppendInterval(0.2)
  self.mergeEffectSequence:AppendCallback(function()
    self.mergeArrowEffects:SetActive(true)
  end)
  self.mergeEffectSequence:AppendInterval(0.25)
  local getMaterailTempalte = DataCenter.EquipMaterialDataManager:GetTemplate(cfgId)
  if getMaterailTempalte ~= nil and getMaterailTempalte.quality >= ItemColor.BLUE then
    self.mergeEffectSequence:AppendCallback(function()
      local newMaterialMergeEffect = self.newMaterialMergeEffects[getMaterailTempalte.quality]
      if newMaterialMergeEffect ~= nil then
        newMaterialMergeEffect:SetActive(true)
      end
    end)
    self.mergeEffectSequence:AppendInterval(0.5)
  end
  self.mergeEffectSequence:OnComplete(function()
    RefreshMaterialInfo(self)
    self.mergeEffectSequence = nil
  end)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.newMaterialNameText = self:AddComponent(UIText, "CenterInfo/NewMaterialInfo/NewMaterialNameText")
  self.newMaterialInfo = self:AddComponent(UIBaseContainer, "CenterInfo/NewMaterialInfo")
  self.newMaterialItem = self:AddComponent(UICommonResItem, "CenterInfo/NewMaterialInfo/NewMaterialItem")
  self.oldMaterialItem1 = self:AddComponent(UICommonResItem, "CenterInfo/OldMaterialItem1")
  self.oldMaterialItem2 = self:AddComponent(UICommonResItem, "CenterInfo/OldMaterialItem2")
  self.oldMaterialItem3 = self:AddComponent(UICommonResItem, "CenterInfo/OldMaterialItem3")
  self.oldMaterialItem4 = self:AddComponent(UICommonResItem, "CenterInfo/OldMaterialItem4")
  self.oldMaterialItems = {
    self.oldMaterialItem1,
    self.oldMaterialItem2,
    self.oldMaterialItem3,
    self.oldMaterialItem4
  }
  self.emptyMaterialSlot1 = self:AddComponent(UIImage, "CenterInfo/EmptyMaterialSlot1")
  self.emptyMaterialSlot2 = self:AddComponent(UIImage, "CenterInfo/EmptyMaterialSlot2")
  self.emptyMaterialSlot3 = self:AddComponent(UIImage, "CenterInfo/EmptyMaterialSlot3")
  self.emptyMaterialSlot4 = self:AddComponent(UIImage, "CenterInfo/EmptyMaterialSlot4")
  self.emptyMaterialSlots = {
    self.emptyMaterialSlot1,
    self.emptyMaterialSlot2,
    self.emptyMaterialSlot3,
    self.emptyMaterialSlot4
  }
  self.oldMaterialNameText = self:AddComponent(UIText, "CenterInfo/OldMaterialNameText")
  self.mergeBtn = self:AddComponent(UIButton, "BottomInfo/MergeBtn")
  self.mergeBtnText = self:AddComponent(UIText, "BottomInfo/MergeBtn/MergeBtnText")
  self.mergeBtn:SetOnClick(function()
    OnMergeBtnClick(self)
  end)
  self.equipMaterialGroupScroll = self:AddComponent(UIBaseContainer, "CenterInfo/EquipTemplateArea/EqiupMaterialGroupScroll/Viewport/EqiupMaterialGroupContent")
  self.equipMaterialGroupList = self:AddComponent(UILoopListView2, "CenterInfo/EquipTemplateArea/EqiupMaterialGroupScroll")
  self.equipMaterialGroupList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.conditionText = self:AddComponent(UIText, "CenterInfo/ConditionText")
  self.batchMergeBtn = self:AddComponent(UIButton, "BottomInfo/BatchMergeBtn")
  self.batchMergeBtnText = self:AddComponent(UIText, "BottomInfo/BatchMergeBtn/BatchMergeBtnText")
  self.batchMergeBtn:SetOnClick(function()
    OnBatchMergeBtnClick(self)
  end)
  self.mergeEffects = self:AddComponent(UIBaseContainer, "CenterInfo/MergeEffects")
  self.oldMaterialMergeEffects = self:AddComponent(UIBaseContainer, "CenterInfo/MergeEffects/OldMaterialEffects")
  self.mergeArrowEffects = self:AddComponent(UIBaseContainer, "CenterInfo/MergeEffects/Eff_ui_peijian_jiantou_faguang")
  self.newMaterialMergeEffects = {}
  self.newMaterialMergeEffects[ItemColor.BLUE] = self:AddComponent(UIBaseContainer, "CenterInfo/MergeEffects/Eff_ui_peijian_mubiaoshengji_lan")
  self.newMaterialMergeEffects[ItemColor.PURPLE] = self:AddComponent(UIBaseContainer, "CenterInfo/MergeEffects/Eff_ui_peijian_mubiaoshengji_zi")
  self.newMaterialMergeEffects[ItemColor.ORANGE] = self:AddComponent(UIBaseContainer, "CenterInfo/MergeEffects/Eff_ui_peijian_mubiaoshengji_cheng")
  self.newMaterialMergeEffects[ItemColor.GOLDEN] = self:AddComponent(UIBaseContainer, "CenterInfo/MergeEffects/Eff_ui_peijian_mubiaoshengji_hong")
  self.mergeBtnText:SetLocalText(430712)
end

local function ComponentDestroy(self)
  self.root = nil
  self.newMaterialNameText = nil
  self.newMaterialInfo = nil
  self.newMaterialItem = nil
  self.oldMaterialItem1 = nil
  self.oldMaterialItem2 = nil
  self.oldMaterialItem3 = nil
  self.oldMaterialItem4 = nil
  self.oldMaterialItems = nil
  self.emptyMaterialSlot1 = nil
  self.emptyMaterialSlot2 = nil
  self.emptyMaterialSlot3 = nil
  self.emptyMaterialSlot4 = nil
  self.emptyMaterialSlots = nil
  self.oldMaterialNameText = nil
  self.mergeBtn = nil
  self.mergeBtnText = nil
  self.equipMaterialGroupScroll = nil
  self.equipMaterialGroupContent = nil
  self.conditionText = nil
  self.batchMergeBtn = nil
  self.batchMergeBtnText = nil
  self.mergeEffects = nil
  self.oldMaterialMergeEffects = nil
  self.mergeArrowEffects = nil
  self.newMaterialMergeEffects = nil
end

UIMergeMaterialPage.OnCreate = OnCreate
UIMergeMaterialPage.OnDestroy = OnDestroy
UIMergeMaterialPage.OnEnable = OnEnable
UIMergeMaterialPage.OnDisable = OnDisable
UIMergeMaterialPage.DataDefine = DataDefine
UIMergeMaterialPage.DataDestroy = DataDestroy
UIMergeMaterialPage.ComponentDefine = ComponentDefine
UIMergeMaterialPage.ComponentDestroy = ComponentDestroy
UIMergeMaterialPage.OnAddListener = OnAddListener
UIMergeMaterialPage.OnRemoveListener = OnRemoveListener
UIMergeMaterialPage.StartMergeEffect = StartMergeEffect
UIMergeMaterialPage.StopMergeEffect = StopMergeEffect
UIMergeMaterialPage.SetData = SetData
return UIMergeMaterialPage
