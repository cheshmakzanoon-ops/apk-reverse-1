local base = UIBaseContainer
local FirstPayExpHistoryInfoItemComponent = BaseClass("FirstPayExpHistoryInfoItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function FirstPayExpHistoryInfoItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FirstPayExpHistoryInfoItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FirstPayExpHistoryInfoItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTxtDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 3)
end

function FirstPayExpHistoryInfoItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtTime = nil
  self.textTxtDes = nil
  self.compUICommonResItem = nil
end

function FirstPayExpHistoryInfoItemComponent:DataDefine()
end

function FirstPayExpHistoryInfoItemComponent:DataDestroy()
end

function FirstPayExpHistoryInfoItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function FirstPayExpHistoryInfoItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FirstPayExpHistoryInfoItemComponent:SetData(data)
  if not data then
    return
  end
  local bId = data.bid
  local lv = data.lv
  local addExp = data.addExp
  local time = data.time
  local isHistoryFlag = data.isHistoryFlag
  if isHistoryFlag then
    self.textTxtDes:SetLocalText("fp_record_desc2")
  else
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(bId, lv)
    local bName = buildTemplate and Localization:GetString(buildTemplate.name) or ""
    self.textTxtDes:SetLocalText("fp_record_desc", bName, lv)
  end
  self.textTxtTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(time or 0))
  local expResData = {}
  expResData.count = addExp or 0
  expResData.itemId = ResourceItemId.HeroExp
  expResData.rewardType = RewardType.RESOURCE_ITEM
  expResData.sortOrder = 0
  self.compUICommonResItem:ReInit(expResData)
end

return FirstPayExpHistoryInfoItemComponent
