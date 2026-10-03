local UIDecomposeMaterialPage = BaseClass("UIDecomposeMaterialPage", UIBaseContainer)
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

local function RefreshBatchDecomposeBtn(self)
  if self.curSelectedMaterialId == nil or self.curSelectedMaterialId <= 0 then
    self.batchDecomposeBtn:SetActive(false)
    return
  end
  local materialResourceItemId = DataCenter.EquipMaterialDataManager:GetMaterialResourceItemId(self.curSelectedMaterialId)
  local count = DataCenter.ResourceItemDataManager:GetCountByItemId(materialResourceItemId)
  if 6 < count then
    self.batchDecomposeBtn:SetActive(true)
    self.batchDecomposeBtnText:SetText("Max")
    self.batchDecomposeState = 2
  elseif 4 < count then
    self.batchDecomposeBtn:SetActive(true)
    self.batchDecomposeBtnText:SetText("5")
    self.batchDecomposeState = 1
  else
    self.batchDecomposeBtn:SetActive(false)
    self.batchDecomposeState = 0
  end
end

local function OnBatchDecomposeBtnClick(self)
  if self.curSelectedMaterialId == nil or self.curSelectedMaterialId <= 0 then
    return
  end
  if self.batchDecomposeState == 0 then
    return
  end
  local count = DataCenter.EquipMaterialDataManager:GetCountById(self.curSelectedMaterialId)
  if count < 1 then
    return
  end
  if self.batchDecomposeState == 1 then
    SFSNetwork.SendMessage(MsgDefines.HeroEquipMaterialDecompose, self.curSelectedMaterialId, 5)
  elseif self.batchDecomposeState == 2 then
    SFSNetwork.SendMessage(MsgDefines.HeroEquipMaterialDecompose, self.curSelectedMaterialId, math.floor(count))
  end
end

local function OnDecomposeBtnClick(self)
  if self.curSelectedMaterialId == nil or self.curSelectedMaterialId <= 0 then
    return
  end
  local materialCount = DataCenter.EquipMaterialDataManager:GetCountById(self.curSelectedMaterialId)
  if materialCount < 1 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.HeroEquipMaterialDecompose, self.curSelectedMaterialId, 1)
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
    self.conditionText:SetLocalText(430733)
    self.oldMaterialItem:SetActive(false)
    self.emptyMaterialSlot:SetActive(true)
    UIGray.SetGray(self.decomposeBtn.transform, true, false)
    return
  else
    self.oldMaterialNameText:SetActive(true)
    self.oldMaterialItem:SetActive(true)
    self.emptyMaterialSlot:SetActive(false)
    UIGray.SetGray(self.decomposeBtn.transform, false, true)
  end
  local param1 = {
    rewardType = RewardType.RESOURCE_ITEM,
    itemId = self.curSelectedMaterialId
  }
  self.oldMaterialItem:ReInit(param1)
  local oldMaterialData = DataCenter.EquipMaterialDataManager:GetTemplate(self.curSelectedMaterialId)
  if oldMaterialData ~= nil then
    self.oldMaterialNameText:SetLocalText(oldMaterialData.name)
    self.oldMaterialNameText:SetColor(UIUtil.GetColorByQuality(oldMaterialData.quality))
  end
  local nextMaterialData = DataCenter.EquipMaterialDataManager:GetLastQualityMaterial(self.curSelectedMaterialId)
  if nextMaterialData ~= nil then
    self.newMaterialInfo:SetActive(true)
    self.conditionText:SetActive(false)
    local param2 = {
      rewardType = RewardType.RESOURCE_ITEM,
      itemId = nextMaterialData.id
    }
    for _, oldMaterialItem in pairs(self.newMaterialItems) do
      oldMaterialItem:ReInit(param2)
    end
    self.newMaterialNameText:SetLocalText(nextMaterialData.name)
    self.newMaterialNameText:SetColor(UIUtil.GetColorByQuality(nextMaterialData.quality))
    UIGray.SetGray(self.decomposeBtn.transform, false, true)
  else
    self.newMaterialInfo:SetActive(false)
    self.conditionText:SetActive(true)
    self.conditionText:SetColorRGBA(1, 0.882, 0.6, 1)
    self.conditionText:SetLocalText(430734)
    UIGray.SetGray(self.decomposeBtn.transform, true, false)
  end
end

local function OnClickMaterialItem(self, itemId)
  local prevSelectedMaterialCategoryId = self.curSelectedMaterialId
  if prevSelectedMaterialCategoryId == itemId then
    return
  end
  for _, materialGroup in pairs(self.equipMaterialGroupItems) do
    materialGroup:SetSelected(itemId)
  end
  self.curSelectedMaterialId = itemId
  RefreshMaterialInfo(self)
  self.batchDecomposeBtn:SetActive(false)
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
  self:StopDecomposeEffect()
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
  self.batchDecomposeState = 0
end

local function DataDestroy(self)
  self.equipMaterialDataList = nil
  self.equipMaterialGroupItems = nil
  self.itemIndex = nil
  self.curSelectedMaterialId = 0
  self.batchDecomposeState = 0
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

local function OnFinishDecomposeMaterial(self, cfgId)
  local curSelectedMaterial = DataCenter.EquipMaterialDataManager:GetCountById(self.curSelectedMaterialId)
  if curSelectedMaterial < 1 then
    self.curSelectedMaterialId = 0
  end
  RefershEquipMaterialDataList(self)
  RefreshBatchDecomposeBtn(self)
  self:StartDecomposeEffect(cfgId)
end

local function StopDecomposeEffect(self)
  self.decomposeEffects:SetActive(false)
  if self.decomposeEffectSequence ~= nil then
    self.decomposeEffectSequence:Kill()
    self.decomposeEffectSequence = nil
  end
end

local function StartDecomposeEffect(self, cfgId)
  self.decomposeEffectSequence = CS.DG.Tweening.DOTween.Sequence()
  self.decomposeEffectSequence:AppendCallback(function()
    self.decomposeEffects:SetActive(true)
    self.oldMaterailEffect:SetActive(false)
    self.arrowEffect:SetActive(false)
    for _, newMaterialMergeEffect in pairs(self.newMaterailEffects) do
      newMaterialMergeEffect:SetActive(false)
    end
  end)
  self.decomposeEffectSequence:AppendCallback(function()
    self.oldMaterailEffect:SetActive(true)
  end)
  self.decomposeEffectSequence:AppendInterval(0.2)
  self.decomposeEffectSequence:AppendCallback(function()
    self.arrowEffect:SetActive(true)
  end)
  self.decomposeEffectSequence:AppendInterval(0.25)
  local getMaterailTempalte = DataCenter.EquipMaterialDataManager:GetTemplate(cfgId)
  if getMaterailTempalte ~= nil and getMaterailTempalte.quality >= ItemColor.BLUE then
    self.decomposeEffectSequence:AppendCallback(function()
      local newMaterialMergeEffect = self.newMaterailEffects[getMaterailTempalte.quality]
      if newMaterialMergeEffect ~= nil then
        newMaterialMergeEffect:SetActive(true)
      end
    end)
    self.decomposeEffectSequence:AppendInterval(0.4)
  end
  self.decomposeEffectSequence:OnComplete(function()
    RefreshMaterialInfo(self)
    self.decomposeEffectSequence = nil
  end)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroEquipMaterialDecompose, OnFinishDecomposeMaterial)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroEquipMaterialDecompose, OnFinishDecomposeMaterial)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.newMaterialNameText = self.root:AddComponent(UIText, "CenterInfo/NewMaterialInfo/NewMaterialNameText")
  self.newMaterialInfo = self.root:AddComponent(UIBaseContainer, "CenterInfo/NewMaterialInfo")
  self.newMaterialItem1 = self.root:AddComponent(UICommonResItem, "CenterInfo/NewMaterialInfo/NewMaterialItem1")
  self.newMaterialItem2 = self.root:AddComponent(UICommonResItem, "CenterInfo/NewMaterialInfo/NewMaterialItem2")
  self.newMaterialItem3 = self.root:AddComponent(UICommonResItem, "CenterInfo/NewMaterialInfo/NewMaterialItem3")
  self.newMaterialItem4 = self.root:AddComponent(UICommonResItem, "CenterInfo/NewMaterialInfo/NewMaterialItem4")
  self.newMaterialItems = {
    self.newMaterialItem1,
    self.newMaterialItem2,
    self.newMaterialItem3,
    self.newMaterialItem4
  }
  self.oldMaterialItem = self.root:AddComponent(UICommonResItem, "CenterInfo/OldMaterialItem")
  self.emptyMaterialSlot = self.root:AddComponent(UIImage, "CenterInfo/EmptyMaterialSlot")
  self.oldMaterialNameText = self.root:AddComponent(UIText, "CenterInfo/OldMaterialNameText")
  self.decomposeBtn = self.root:AddComponent(UIButton, "BottomInfo/DecomposeBtn")
  self.decomposeBtnText = self.root:AddComponent(UIText, "BottomInfo/DecomposeBtn/DecomposeBtnText")
  self.decomposeBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Click_Disassemble, false)
    OnDecomposeBtnClick(self)
  end)
  self.equipMaterialGroupScroll = self:AddComponent(UIBaseContainer, "CenterInfo/EquipTemplateArea/EqiupMaterialGroupScroll/Viewport/EqiupMaterialGroupContent")
  self.equipMaterialGroupList = self:AddComponent(UILoopListView2, "CenterInfo/EquipTemplateArea/EqiupMaterialGroupScroll")
  self.equipMaterialGroupList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.conditionText = self:AddComponent(UIText, "CenterInfo/ConditionText")
  self.batchDecomposeBtn = self:AddComponent(UIButton, "BottomInfo/BatchDecomposeBtn")
  self.batchDecomposeBtnText = self:AddComponent(UIText, "BottomInfo/BatchDecomposeBtn/BatchDecomposeBtnText")
  self.batchDecomposeBtn:SetOnClick(function()
    OnBatchDecomposeBtnClick(self)
  end)
  self.decomposeEffects = self:AddComponent(UIBaseContainer, "CenterInfo/DecomposeEffects")
  self.oldMaterailEffect = self:AddComponent(UIBaseContainer, "CenterInfo/DecomposeEffects/Eff_ui_peijian_cailiao_faguang")
  self.arrowEffect = self:AddComponent(UIBaseContainer, "CenterInfo/DecomposeEffects/Eff_ui_peijian_jiantou_faguang")
  self.newMaterailEffects = {}
  self.newMaterailEffects[ItemColor.BLUE] = self:AddComponent(UIBaseContainer, "CenterInfo/DecomposeEffects/lan")
  self.newMaterailEffects[ItemColor.PURPLE] = self:AddComponent(UIBaseContainer, "CenterInfo/DecomposeEffects/zi")
  self.newMaterailEffects[ItemColor.ORANGE] = self:AddComponent(UIBaseContainer, "CenterInfo/DecomposeEffects/cheng")
  self.newMaterailEffects[ItemColor.GOLDEN] = self:AddComponent(UIBaseContainer, "CenterInfo/DecomposeEffects/hong")
  self.decomposeBtnText:SetLocalText(430731)
end

local function ComponentDestroy(self)
  self.root = nil
  self.newMaterialNameText = nil
  self.newMaterialInfo = nil
  self.newMaterialItem1 = nil
  self.newMaterialItem2 = nil
  self.newMaterialItem3 = nil
  self.newMaterialItem4 = nil
  self.newMaterialItems = nil
  self.oldMaterialItem = nil
  self.emptyMaterialSlot = nil
  self.oldMaterialNameText = nil
  self.decomposeBtn = nil
  self.decomposeBtnText = nil
  self.equipMaterialGroupScroll = nil
  self.equipMaterialGroupContent = nil
  self.equipMaterialGroupList = nil
  self.conditionText = nil
  self.batchDecomposeBtn = nil
  self.batchDecomposeBtnText = nil
  self.decomposeEffects = nil
  self.oldMaterailEffect = nil
  self.arrowEffect = nil
  self.newMaterailEffects = nil
end

local function SetData(self)
  self:StopDecomposeEffect()
  RefershEquipMaterialDataList(self)
  RefreshMaterialInfo(self)
  self.batchDecomposeBtn:SetActive(false)
end

UIDecomposeMaterialPage.OnCreate = OnCreate
UIDecomposeMaterialPage.OnDestroy = OnDestroy
UIDecomposeMaterialPage.OnEnable = OnEnable
UIDecomposeMaterialPage.OnDisable = OnDisable
UIDecomposeMaterialPage.DataDefine = DataDefine
UIDecomposeMaterialPage.DataDestroy = DataDestroy
UIDecomposeMaterialPage.ComponentDefine = ComponentDefine
UIDecomposeMaterialPage.ComponentDestroy = ComponentDestroy
UIDecomposeMaterialPage.SetData = SetData
UIDecomposeMaterialPage.OnAddListener = OnAddListener
UIDecomposeMaterialPage.OnRemoveListener = OnRemoveListener
UIDecomposeMaterialPage.StartDecomposeEffect = StartDecomposeEffect
UIDecomposeMaterialPage.StopDecomposeEffect = StopDecomposeEffect
return UIDecomposeMaterialPage
