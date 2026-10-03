local PveTriggerPointBubbleNeedCell = BaseClass("PveTriggerPointBubbleNeedCell")
local need_icon_path = "NeedIcon"
local need_count_path = "NeedCount"
local own_count_path = "OwnCount"
local complete_icon_path = "CompleteIcon"

function PveTriggerPointBubbleNeedCell:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function PveTriggerPointBubbleNeedCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function PveTriggerPointBubbleNeedCell:ComponentDefine()
  self.need_icon = self.transform:Find(need_icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
  self.need_count = self.transform:Find(need_count_path):GetComponent(typeof(CS.SuperTextMesh))
  self.own_count = self.transform:Find(own_count_path):GetComponent(typeof(CS.SuperTextMesh))
  self.complete_icon = self.transform:Find(complete_icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
end

function PveTriggerPointBubbleNeedCell:ComponentDestroy()
  self.need_icon = nil
  self.need_count = nil
  self.own_count = nil
  self.gameObject = nil
  self.transform = nil
end

function PveTriggerPointBubbleNeedCell:DataDefine()
  self.param = nil
  self.enough = nil
  self.num = nil
end

function PveTriggerPointBubbleNeedCell:DataDestroy()
  self.param = nil
  self.enough = nil
  self.num = nil
end

function PveTriggerPointBubbleNeedCell:ReInit(param)
  self.param = param
  if self.param.needType == TriggerNeedType.ResourceItem then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.param.needId)
    if template ~= nil then
      self.need_icon:LoadSprite(string.format(LoadPath.ItemPath, template.pic))
    end
    self:RefreshResourceItem()
  elseif self.param.needType == TriggerNeedType.Goods then
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.needId)
    if template ~= nil then
      self.need_icon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
    end
    self:RefreshGoods()
  elseif self.param.needType == TriggerNeedType.Resource then
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(self.param.needId)
    if template then
      self.need_icon:LoadSprite(string.format(LoadPath.LWCommonPath, template.icon))
    end
    self:RefreshResource()
  end
  self.need_count.text = "/" .. string.GetFormattedSeperatorNum(self.param.needCount)
end

function PveTriggerPointBubbleNeedCell:RefreshResourceItem()
  if self:RefreshComplete() then
    return
  end
  if self.param.needType == TriggerNeedType.ResourceItem then
    local resData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.param.needId)
    local haveCount = resData ~= nil and resData.number or 0
    self:RefreshOwnNum(haveCount)
    self:RefreshColor(haveCount >= self.param.needCount)
  end
end

function PveTriggerPointBubbleNeedCell:RefreshGoods()
  if self:RefreshComplete() then
    return
  end
  if self.param.needType == TriggerNeedType.Goods then
    local haveCount = DataCenter.ItemData:GetItemCount(self.param.needId)
    self:RefreshOwnNum(haveCount)
    self:RefreshColor(haveCount >= self.param.needCount)
  end
end

function PveTriggerPointBubbleNeedCell:RefreshResource()
  if self:RefreshComplete() then
    return
  end
  if self.param.needType == TriggerNeedType.Resource then
    local haveCount = DataCenter.BattleLevel:GetResourceCount(self.param.needId)
    self:RefreshOwnNum(haveCount)
    self:RefreshColor(haveCount >= self.param.needCount)
  end
end

function PveTriggerPointBubbleNeedCell:IsComplete()
  return DataCenter.BattleLevel:IsItemSubmit(self.param.triggerId, self.param.index)
end

function PveTriggerPointBubbleNeedCell:RefreshComplete()
  if self:IsComplete() then
    self.own_count.gameObject:SetActive(false)
    self.need_count.gameObject:SetActive(false)
    self.complete_icon.gameObject:SetActive(true)
  else
    if not self.param.needShowNum then
      self.own_count.gameObject:SetActive(false)
      self.need_count.gameObject:SetActive(false)
    else
      self.own_count.gameObject:SetActive(true)
      self.need_count.gameObject:SetActive(true)
    end
    self.complete_icon.gameObject:SetActive(false)
  end
end

function PveTriggerPointBubbleNeedCell:RefreshColor(enough)
  if self.enough ~= enough then
    self.enough = enough
    if enough then
      self.own_count.outline = true
      self.own_count.color32 = WorldGreenColor32
    else
      self.own_count.outline = false
      self.own_count.color32 = WorldRedColor32
    end
  end
end

function PveTriggerPointBubbleNeedCell:RefreshOwnNum(num)
  if self.num ~= num then
    self.num = num
    self.own_count.text = string.GetFormattedSeperatorNum(num)
  end
end

return PveTriggerPointBubbleNeedCell
