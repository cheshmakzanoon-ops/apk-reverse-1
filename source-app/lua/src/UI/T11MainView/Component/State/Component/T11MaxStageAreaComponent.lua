local base = UIBaseContainer
local T11MaxStageAreaComponent = BaseClass("T11MaxStageAreaComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11ResearchProgressItemComponent = require("UI.T11Common.T11ResearchProgressItemComponent")
local T11SoldierSkillItemComponent = require("UI.T11Common.T11SoldierSkillItemComponent")
local item_root_path = "ItemRoot"
local research_progress_info_path = "ResearchProgressInfo"
local t11_research_progress_item_path = "ItemRoot/T11ResearchProgressItem"
local t11_research_progress_arrow_path = "ItemRoot/T11ResearchProgressArrow"
local t11_soldier_skill_item_path = "ResearchProgressInfo/T11SoldierSkillItem"

function T11MaxStageAreaComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11MaxStageAreaComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11MaxStageAreaComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnResearch = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnResearch:SetOnClick(function()
    self:OnBtnResearchClick()
  end)
  self.compItemRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  local itemRoot = self:AddComponent(UIBaseContainer, item_root_path)
  itemRoot:SetActive(false)
  self.progressRoot = self:AddComponent(UIBaseContainer, research_progress_info_path)
  self.allEquipItemList = {}
  self.allArrowObjList = {}
  self.equipItemObj = self:AddComponent(UIBaseContainer, t11_research_progress_item_path).gameObject
  self.equipItemObj:GameObjectCreatePool()
  self.arrItemObj = self:AddComponent(UIBaseContainer, t11_research_progress_arrow_path).gameObject
  self.arrItemObj:GameObjectCreatePool()
  self.unlockSkillItem = self:AddComponent(T11SoldierSkillItemComponent, t11_soldier_skill_item_path)
end

function T11MaxStageAreaComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnResearch = nil
  self.compItemRoot = nil
  self.allEquipItemList = nil
  self.allArrowObjList = nil
  self.progressRoot:RemoveAllComponentes()
  self.equipItemObj:GameObjectRecycleAll()
  self.arrItemObj:GameObjectRecycleAll()
end

function T11MaxStageAreaComponent:DataDefine()
end

function T11MaxStageAreaComponent:DataDestroy()
end

function T11MaxStageAreaComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11SuccessChangeSoldierMode, self.RefreshUnlockSkillInfo)
end

function T11MaxStageAreaComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.T11SuccessChangeSoldierMode, self.RefreshUnlockSkillInfo)
  base.OnRemoveListener(self)
end

function T11MaxStageAreaComponent:OnBtnResearchClick()
  UIUtil.ShowTipsId(151091)
end

function T11MaxStageAreaComponent:RefreshView()
  self:RefreshEquipProgressInfo()
  self:RefreshUnlockSkillInfo()
end

function T11MaxStageAreaComponent:RefreshEquipProgressInfo()
  local allEquipDataList = T11Util.GetShowMaxStageEquipDataList()
  for index, v in ipairs(allEquipDataList) do
    local equipData = v
    local equipId = equipData:GetEquipId()
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
    local arrObj = self.allArrowObjList[index]
    if not arrObj then
      arrObj = self.arrItemObj:GameObjectSpawn(self.progressRoot.transform)
      self.allArrowObjList[index] = arrObj
    end
    arrObj:SetActive(true)
    arrObj.transform:SetAsLastSibling()
  end
end

function T11MaxStageAreaComponent:RefreshUnlockSkillInfo()
  local nextUnlockSkillData = self:GetShowMaxUnlockSkillData()
  if not nextUnlockSkillData then
    self.unlockSkillItem:SetActive(false)
    return
  end
  if CS.UnityEngine.Application.isEditor then
    local curStage = T11Util.GetCurStage()
    local soldierType = T11Util.GetCurT11SoldierType()
    T11Util.ShowLog(string.format("cur skill unlock info: curStage:%d,soldierType:%d", curStage, soldierType))
  end
  self.unlockSkillItem:Init(nextUnlockSkillData)
  self.unlockSkillItem:SetActive(true)
  self.unlockSkillItem.transform:SetAsLastSibling()
end

function T11MaxStageAreaComponent:GetShowMaxUnlockSkillData()
  local curStage = T11Util.GetCurStage()
  local soldierType = T11Util.GetCurT11SoldierType()
  local skillInfo = T11Util.GetSkillInfoByStage(curStage, soldierType)
  return skillInfo
end

return T11MaxStageAreaComponent
