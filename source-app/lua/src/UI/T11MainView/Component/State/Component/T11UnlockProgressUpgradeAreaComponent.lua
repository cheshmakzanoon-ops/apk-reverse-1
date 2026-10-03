local base = UIBaseContainer
local T11UnlockProgressUpgradeAreaComponent = BaseClass("T11UnlockProgressUpgradeAreaComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UPGRADE_EFF_PREFAB_PATH = "Assets/Main/Prefabs/UI/T11/Effect/Eff_ui_T11_upgrade_big.prefab"
local T11ResearchProgressItemComponent = require("UI.T11Common.T11ResearchProgressItemComponent")
local T11ResearchProgressArrowComponent = require("UI.T11Common.T11ResearchProgressArrowComponent")
local Const = require("DataCenter.T11DataManager.T11Constant")
local item_root_path = "ItemRoot"
local research_progress_info_path = "ResearchProgressInfo"
local t11_research_progress_item_path = "ItemRoot/T11ResearchProgressItem"
local t11_research_progress_arrow_path = "ItemRoot/T11ResearchProgressArrow"
local equip_upgrade_eff_path = "UpgradeEffPoint"

function T11UnlockProgressUpgradeAreaComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11UnlockProgressUpgradeAreaComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11UnlockProgressUpgradeAreaComponent:OnDisable()
  base.OnDisable(self)
  if self.effTimer then
    self.effTimer:Stop()
    self.effTimer = nil
  end
end

function T11UnlockProgressUpgradeAreaComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnResearch = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnResearch:SetOnClick(function()
    self:OnBtnResearchClick()
  end)
  self.compUpgradeEffPoint = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compRedDot = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  local itemRoot = self:AddComponent(UIBaseContainer, item_root_path)
  itemRoot:SetActive(false)
  self.progressRoot = self:AddComponent(UIBaseContainer, research_progress_info_path)
  self.allEquipItemList = {}
  self.allArrowItemList = {}
  self.equipItemObj = self:AddComponent(UIBaseContainer, t11_research_progress_item_path).gameObject
  self.equipItemObj:GameObjectCreatePool()
  self.arrItemObj = self:AddComponent(UIBaseContainer, t11_research_progress_arrow_path).gameObject
  self.arrItemObj:GameObjectCreatePool()
  self.equipUpgradeEff = self:AddComponent(UIVfx, equip_upgrade_eff_path, UPGRADE_EFF_PREFAB_PATH)
end

function T11UnlockProgressUpgradeAreaComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnResearch = nil
  self.compUpgradeEffPoint = nil
  self.compRedDot = nil
  self.allEquipItemList = nil
  self.allArrowItemList = nil
  self.progressRoot:RemoveAllComponentes()
  self.equipItemObj:GameObjectRecycleAll()
  self.arrItemObj:GameObjectRecycleAll()
end

function T11UnlockProgressUpgradeAreaComponent:DataDefine()
end

function T11UnlockProgressUpgradeAreaComponent:DataDestroy()
  if self.effTimer then
    self.effTimer:Stop()
    self.effTimer = nil
  end
end

function T11UnlockProgressUpgradeAreaComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11ProgressUpgradeSuccess, self.OnProgressUpgradeSuccess)
  self:AddUIListener(EventId.RefreshItems, self.RefreshRedDot)
  self:AddUIListener(EventId.ResourceUpdated, self.RefreshRedDot)
  self:AddUIListener(EventId.RefreshResourceItem, self.RefreshRedDot)
end

function T11UnlockProgressUpgradeAreaComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.T11ProgressUpgradeSuccess, self.OnProgressUpgradeSuccess)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshRedDot)
  self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshRedDot)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.RefreshRedDot)
  base.OnRemoveListener(self)
end

function T11UnlockProgressUpgradeAreaComponent:OnBtnResearchClick()
  EventManager:GetInstance():Broadcast(EventId.T11ShowUpgradeConfirm)
end

function T11UnlockProgressUpgradeAreaComponent:RefreshView(fromUpgrade)
  local allEquipDataList = T11Util.GetCurStageAllEquipData()
  local curUpgradeEquipId, progress = T11Util.GetCurUpgradeEquipIdAndProgress()
  local isFindCurUpgradeEquip = false
  for index, v in ipairs(allEquipDataList) do
    local equipData = v
    local equipId = equipData:GetEquipId()
    if curUpgradeEquipId == equipId then
      isFindCurUpgradeEquip = true
    end
    local name = tostring(equipId)
    local equipItem = self.allEquipItemList[index]
    if not equipItem then
      local equipObj = self.equipItemObj:GameObjectSpawn(self.progressRoot.transform)
      equipObj.transform.name = name
      equipItem = self.progressRoot:AddComponent(T11ResearchProgressItemComponent, name)
      self.allEquipItemList[index] = equipItem
    else
      equipItem.transform.name = name
    end
    equipItem.transform:SetAsLastSibling()
    equipItem:SetActive(true)
    equipItem:SetData(equipData)
    if fromUpgrade and curUpgradeEquipId == equipId and progress == 0 then
      self.compUpgradeEffPoint.transform.position = equipItem.transform.position
      if self.effTimer then
        self.effTimer:Stop()
        self.effTimer = nil
      end
      self.effTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.equipUpgradeEff:Replay()
      end, 1)
    end
    local isLastItem = index == #allEquipDataList
    if not isLastItem then
      local arrItem = self.allArrowItemList[index]
      if not arrItem then
        local arrObj = self.arrItemObj:GameObjectSpawn(self.progressRoot.transform)
        local arrName = "arr_" .. index
        arrObj.transform.name = arrName
        arrItem = self.progressRoot:AddComponent(T11ResearchProgressArrowComponent, arrName)
        self.allArrowItemList[index] = arrItem
      end
      arrItem:SetActive(true)
      arrItem:SetGrayState(isFindCurUpgradeEquip)
      arrItem.transform:SetAsLastSibling()
    end
  end
  self:RefreshRedDot()
end

function T11UnlockProgressUpgradeAreaComponent:OnProgressUpgradeSuccess()
  local fromUpgrade = true
  self:RefreshView(fromUpgrade)
end

function T11UnlockProgressUpgradeAreaComponent:RefreshRedDot()
  local show = true
  local toProgressId = T11Util.GetNextUpgradeProgressId()
  local toProgressTmp = T11Util.GetUpgradeTmpByProgressId(toProgressId)
  local dataList = toProgressTmp:GetCostDataAfterParse()
  for _, v in ipairs(dataList) do
    local type = v.type or 0
    local itemId = v.itemId or 0
    local costNum = v.costNum or 0
    local have = 0
    if type == CommonCostNeedType.ResourceItem then
      have = DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
    elseif type == CommonCostNeedType.Goods then
      have = DataCenter.ItemData:GetItemCount(itemId)
    elseif type == CommonCostNeedType.Resource then
      have = LuaEntry.Resource:GetCntByResType(itemId)
    end
    if costNum > have then
      show = false
      break
    end
  end
  self.compRedDot:SetActive(show)
end

return T11UnlockProgressUpgradeAreaComponent
