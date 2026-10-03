local base = UIBaseContainer
local T11SkillProgressUpgradeAreaComponent = BaseClass("T11SkillProgressUpgradeAreaComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UPGRADE_EFF_PREFAB_PATH = "Assets/Main/Prefabs/UI/T11/Effect/Eff_ui_T11_upgrade_small.prefab"
local T11ResearchProgressItemComponent = require("UI.T11Common.T11ResearchProgressItemComponent")
local T11ResearchProgressArrowComponent = require("UI.T11Common.T11ResearchProgressArrowComponent")
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local Const = require("DataCenter.T11DataManager.T11Constant")
local item_root_path = "ItemRoot"
local research_progress_info_path = "ResearchProgressInfo"
local t11_research_progress_item_path = "ItemRoot/T11ResearchProgressItem"
local t11_research_progress_arrow_path = "ItemRoot/T11ResearchProgressArrow"
local t11_soldier_skill_item_path = "ResearchProgressInfo/T11SoldierSkillItem"
local equip_upgrade_eff_path = "UpgradeEffPoint"

function T11SkillProgressUpgradeAreaComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SkillProgressUpgradeAreaComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SkillProgressUpgradeAreaComponent:ComponentDefine()
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
  self.unlockSkillItem = self:AddComponent(T11SoldierSkillItemComponent, t11_soldier_skill_item_path)
  self.equipUpgradeEff = self:AddComponent(UIVfx, equip_upgrade_eff_path, UPGRADE_EFF_PREFAB_PATH)
end

function T11SkillProgressUpgradeAreaComponent:ComponentDestroy()
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

function T11SkillProgressUpgradeAreaComponent:DataDefine()
end

function T11SkillProgressUpgradeAreaComponent:DataDestroy()
  if self.effTimer then
    self.effTimer:Stop()
    self.effTimer = nil
  end
end

function T11SkillProgressUpgradeAreaComponent:OnDisable()
  base.OnDisable(self)
  if self.effTimer then
    self.effTimer:Stop()
    self.effTimer = nil
  end
end

function T11SkillProgressUpgradeAreaComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11ProgressUpgradeSuccess, self.OnProgressUpgradeSuccess)
  self:AddUIListener(EventId.T11SuccessChangeSoldierMode, self.OnT11SuccessChangeSoldierMode)
  self:AddUIListener(EventId.RefreshItems, self.RefreshRedDot)
  self:AddUIListener(EventId.ResourceUpdated, self.RefreshRedDot)
  self:AddUIListener(EventId.RefreshResourceItem, self.RefreshRedDot)
end

function T11SkillProgressUpgradeAreaComponent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.T11ProgressUpgradeSuccess, self.OnProgressUpgradeSuccess)
  self:RemoveUIListener(EventId.T11SuccessChangeSoldierMode, self.OnT11SuccessChangeSoldierMode)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshRedDot)
  self:RemoveUIListener(EventId.ResourceUpdated, self.RefreshRedDot)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.RefreshRedDot)
end

function T11SkillProgressUpgradeAreaComponent:RefreshView(fromUpgrade)
  self:RefreshEquipProgressInfo(fromUpgrade)
  self:RefreshUnlockSkillInfo()
  self:RefreshRedDot()
end

function T11SkillProgressUpgradeAreaComponent:RefreshEquipProgressInfo(fromUpgrade)
  local allEquipDataList = T11Util.GetCurStageAllEquipData()
  local isExistUnlockSkill = T11Util.GetNextStageSkillData() ~= nil
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
    local isGenArr = not isLastItem or isExistUnlockSkill
    if isGenArr then
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
end

function T11SkillProgressUpgradeAreaComponent:RefreshUnlockSkillInfo()
  local nextUnlockSkillData = T11Util.GetNextStageSkillData()
  if not nextUnlockSkillData then
    self.unlockSkillItem:SetActive(false)
    return
  end
  if CS.UnityEngine.Application.isEditor then
    local curStage = T11Util.GetCurStage()
    local soldierType = T11Util.GetCurT11SoldierType()
    T11Util.ShowLog(string.format("cur skill unlock info: curStage:%d,soldierType:%d", curStage, soldierType))
  end
  local isShowUnlockState = true
  self.unlockSkillItem:Init(nextUnlockSkillData, isShowUnlockState)
  self.unlockSkillItem:SetActive(true)
  self.unlockSkillItem.transform:SetAsLastSibling()
end

function T11SkillProgressUpgradeAreaComponent:OnBtnResearchClick()
  EventManager:GetInstance():Broadcast(EventId.T11ShowUpgradeConfirm)
end

function T11SkillProgressUpgradeAreaComponent:OnProgressUpgradeSuccess()
  local fromUpgrade = true
  self:RefreshView(fromUpgrade)
end

function T11SkillProgressUpgradeAreaComponent:OnT11SuccessChangeSoldierMode()
  self:RefreshUnlockSkillInfo()
end

function T11SkillProgressUpgradeAreaComponent:RefreshRedDot()
  if T11Util.IsMaxExp() then
    self.compRedDot:SetActive(false)
    return
  end
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

return T11SkillProgressUpgradeAreaComponent
