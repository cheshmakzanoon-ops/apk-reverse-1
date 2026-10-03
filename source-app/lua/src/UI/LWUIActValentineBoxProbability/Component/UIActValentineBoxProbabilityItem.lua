local base = UIBaseContainer
local UIActValentineBoxProbabilityItem = BaseClass("UIActValentineBoxProbabilityItem", base)
local Localization = CS.GameEntry.Localization
local M = UIActValentineBoxProbabilityItem
local UIActValentineBoxProbabilityRewardItem = require("UI.LWUIActValentineBoxProbability.Component.UIActValentineBoxProbabilityRewardItem")
local must_get_item1_text_path = "Must1/MustGetItemText1"
local must_get_item1_path = "Must1/MustGetItem1"
local must_get_item2_text_path = "Must2/MustGetItemText2"
local must_get_item2_path = "Must2/MustGetItem2"
local box_image_path = "BoxImage"
local scroll_path = "ScrollRect"
local content_path = "ScrollRect/Viewport/Content"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:ClearRewards()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.must_get_item1_text = self:AddComponent(UIText, must_get_item1_text_path)
  self.must_get_item1 = self:AddComponent(UICommonResItem, must_get_item1_path)
  self.must_get_item2_text = self:AddComponent(UIText, must_get_item2_text_path)
  self.must_get_item2 = self:AddComponent(UICommonResItem, must_get_item2_path)
  self.box_image = self:AddComponent(UIImage, box_image_path)
  self.scroll = self:AddComponent(UILoopListView2, scroll_path)
  self.scroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function M:ComponentDestroy()
  self.must_get_item1_text = nil
  self.must_get_item1 = nil
  self.must_get_item2_text = nil
  self.must_get_item2 = nil
  self.box_image = nil
  self.scroll = nil
  self.content = nil
end

function M:DataDefine()
  self.probabilityInfo = {}
  self.itemIndex = 0
end

function M:DataDestroy()
  self.probabilityInfo = nil
  self.itemIndex = nil
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:SetData(data, actId)
  self.probabilityInfo = data
  self:RefreshAll()
end

function M:ClearRewards()
  self.must_get_item1:RemoveComponents(UICommonResItem)
  self.must_get_item2:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rewardRate then
    return nil
  end
  local packData = self.rewardRate[index]
  local item = loopScroll:NewListViewItem("ProbabilityItem")
  local script = self.content:GetComponent(item.gameObject.name, UIActValentineBoxProbabilityRewardItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(UIActValentineBoxProbabilityRewardItem, objectName)
  end
  script:SetActive(true)
  script:SetData(packData, self.actId)
  return item
end

function M:RefreshAll()
  self.must_get_item2_text:SetLocalText("activity_99136_46")
  local mustInfo = self.probabilityInfo.rewardSure
  if not mustInfo then
    Logger.LogError("must info is nil")
    return
  end
  if mustInfo[1] then
    local param = {}
    param.itemId = mustInfo[1].rewardId
    param.count = mustInfo[1].rewardNum
    param.rewardType = RewardType.GOODS
    self.must_get_item1:ReInit(param)
    self.must_get_item1_text:SetLocalText("activity_99136_46")
  end
  if mustInfo[2] then
    local param = {}
    param.itemId = mustInfo[2].rewardId
    param.count = mustInfo[2].rewardNum
    param.rewardType = RewardType.GOODS
    self.must_get_item2:ReInit(param)
    self.must_get_item2_text:SetLocalText("activity_99136_46")
  end
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(self.probabilityInfo.award)
  self.box_image:LoadSprite(iconPath)
  self.rewardRate = self.probabilityInfo.rewardRate
  self:RefreshScroll()
end

function M:RefreshScroll()
  if self.rewardRate == nil or #self.rewardRate == 0 then
    self.scroll:SetActive(false)
  else
    self.scroll:SetActive(true)
    self.scroll:SetListItemCount(#self.rewardRate, false, false)
    self.scroll:RefreshAllShownItem()
  end
end

return UIActValentineBoxProbabilityItem
