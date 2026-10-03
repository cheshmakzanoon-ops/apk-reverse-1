local base = UIBaseContainer
local DropinfoItemComponent = BaseClass("DropinfoItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function DropinfoItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DropinfoItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DropinfoItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 3)
  self.compDropinfoItem = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
end

function DropinfoItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textDesc = nil
  self.textTime = nil
  self.compUICommonResItem = nil
  self.compDropinfoItem = nil
end

function DropinfoItemComponent:DataDefine()
end

function DropinfoItemComponent:DataDestroy()
end

function DropinfoItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function DropinfoItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function DropinfoItemComponent:SetData(itemData)
  if not itemData then
    return
  end
  self.itemData = itemData
  self.activityId = itemData.activityId
  self.type = itemData.type
  self.data = itemData.data
  self.time = self.data.time
  self.dropType = itemData.dropType or 1
  if self.data.content then
    self.itemId = self.data.content.itemId
    self.addNum = self.data.content.addNum
    self.dropId = self.data.content.dropId
    self.dropWay = self.data.content.dropWay
    self.logIndex = self.data.content.index or -1
  end
  self:RefreshDropSourceDesc()
  self:RefreshItemIcon()
  self:RefreshTimeInfo()
end

function DropinfoItemComponent:RefreshDropSourceDesc()
  local dropWayStr = ""
  if not self.dropId then
    return ""
  end
  local actDropTmp = DataCenter.ActivityDropTemplateManager:GetDropTemplateById(self.dropId)
  if not actDropTmp then
    return ""
  end
  if self.dropType == LimitDropHistoryTabType.NormalDrop then
    if not string.IsNullOrEmpty(actDropTmp.name) then
      dropWayStr = actDropTmp:GetLogKeyByIndex(1)
    end
  elseif self.dropType == LimitDropHistoryTabType.PayDrop and self.logIndex >= 0 then
    dropWayStr = actDropTmp:GetLogKeyByIndex(self.logIndex + 1)
  else
    dropWayStr = ""
  end
  self.textDesc:SetLocalText(dropWayStr)
end

function DropinfoItemComponent:RefreshItemIcon()
  if not self.itemId then
    return
  end
  local itemData = {}
  itemData.rewardType = RewardType.GOODS
  itemData.itemId = self.itemId
  itemData.count = self.addNum
  self.compUICommonResItem:ReInit(itemData)
end

function DropinfoItemComponent:RefreshTimeInfo()
  local timeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.time or 0)
  self.textTime:SetText(timeStr)
end

return DropinfoItemComponent
