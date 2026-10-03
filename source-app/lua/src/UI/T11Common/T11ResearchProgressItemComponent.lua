local base = UIBaseContainer
local T11ResearchProgressItemComponent = BaseClass("T11ResearchProgressItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function T11ResearchProgressItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11ResearchProgressItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11ResearchProgressItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compDoneFlag = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.compStar1 = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compStar2 = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compStar3 = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compStar4 = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compStar5 = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compStatListNode = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.allStarObjList = {}
  table.insert(self.allStarObjList, self.compStar1)
  table.insert(self.allStarObjList, self.compStar2)
  table.insert(self.allStarObjList, self.compStar3)
  table.insert(self.allStarObjList, self.compStar4)
  table.insert(self.allStarObjList, self.compStar5)
end

function T11ResearchProgressItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compDoneFlag = nil
  self.textProgress = nil
  self.imgIcon = nil
  self.compStar1 = nil
  self.compStar2 = nil
  self.compStar3 = nil
  self.compStar4 = nil
  self.compStar5 = nil
  self.compStatListNode = nil
  self.allStarObjList = nil
end

function T11ResearchProgressItemComponent:DataDefine()
end

function T11ResearchProgressItemComponent:DataDestroy()
end

function T11ResearchProgressItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11ResearchProgressItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11ResearchProgressItemComponent:SetData(equipData, isHideStageInfo, isHideProgressInfo)
  self.equipData = equipData
  if not self.equipData then
    Logger.LogError("T11ResearchProgressItemComponent:SetData equipData is nil")
    return
  end
  self.equipTmp = self.equipData.equipTmp
  if not self.equipTmp then
    Logger.LogError("T11ResearchProgressItemComponent:SetData equipTmp is nil")
    return
  end
  self.isHideStageInfo = isHideStageInfo
  self.isHideProgressInfo = isHideProgressInfo
  self:RefreshView()
end

function T11ResearchProgressItemComponent:RefreshView()
  local equipState = self.equipData:GetEquipState()
  local skillIconPath = equipState == T11EquipUpgradeState.NotUnLock and self.equipTmp.lock_icon or self.equipTmp.icon
  self.imgIcon:LoadSprite(skillIconPath)
  local isMaxStage = T11Util.IsMaxStage()
  self.compDoneFlag:SetActive(equipState == T11EquipUpgradeState.Unlocked and not isMaxStage)
  self.textProgress:SetActive(equipState == T11EquipUpgradeState.Upgrading and not self.isHideProgressInfo)
  if equipState == T11EquipUpgradeState.Upgrading then
    local curEquipUpgradeProgress = self.equipData:GetCurEquipUpgradeProgress()
    self.textProgress:SetLocalText(320362, curEquipUpgradeProgress)
  end
  self:RefreshStageStar()
end

function T11ResearchProgressItemComponent:RefreshStageStar()
  self.compStatListNode:SetActive(not self.isHideStageInfo)
  if self.isHideStageInfo then
    return
  end
  local stage = self.equipData:GetCurStage() or 0
  for i = 1, #self.allStarObjList do
    local starObj = self.allStarObjList[i]
    if i <= stage then
      starObj:SetActive(true)
    else
      starObj:SetActive(false)
    end
  end
end

return T11ResearchProgressItemComponent
