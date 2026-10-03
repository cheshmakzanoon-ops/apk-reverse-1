local base = UIBaseContainer
local RevivalPlanMainBoxPreviewComponent = BaseClass("RevivalPlanMainBoxPreviewComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function RevivalPlanMainBoxPreviewComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RevivalPlanMainBoxPreviewComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RevivalPlanMainBoxPreviewComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "bg/title")
  self.compRewardLayout = self:AddComponent(UIBaseContainer, "bg/rewardLayout")
  self.btnBg = self:AddComponent(UIButton, "")
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.collectTitle = self:AddComponent(UIText, "bg/titleLayout/collectTitle")
  self.collectCount = self:AddComponent(UIText, "bg/titleLayout/collectCount")
  self.collectImage = self:AddComponent(UIImage, "bg/titleLayout/collectImage")
end

function RevivalPlanMainBoxPreviewComponent:ComponentDestroy()
  self.textTitle = nil
  self.compRewardLayout = nil
  self.btnBg = nil
  self.collectTitle = nil
  self.collectCount = nil
  self.collectImage = nil
end

function RevivalPlanMainBoxPreviewComponent:DataDefine()
  self.itemReqs = {}
  self.itemList = {}
  self.itemGoList = {}
end

function RevivalPlanMainBoxPreviewComponent:DataDestroy()
  self.itemReqs = nil
  self.itemList = nil
  self.itemGoList = nil
end

function RevivalPlanMainBoxPreviewComponent:OnAddListener()
  base.OnAddListener(self)
end

function RevivalPlanMainBoxPreviewComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RevivalPlanMainBoxPreviewComponent:SetData(activityInfoData, requireCount)
  self.textTitle:SetText(Localization:GetString("revival_plan_035"))
  self.collectTitle:SetText(Localization:GetString("revival_plan_042"))
  local key = DataCenter.RevivalPlanManager:GetActivityKeyId(activityInfoData)
  local keyCount = DataCenter.RevivalPlanManager:GetActivityKeyCount(activityInfoData)
  if 0 < key then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(key)
    if goods then
      local icon = goods.icon
      if not string.IsNullOrEmpty(icon) then
        self.collectImage:LoadSprite(string.format(LoadPath.ItemPath, icon))
      end
    end
  end
  self.collectCount:SetText("\195\151" .. tostring(keyCount))
  local rewardList = DataCenter.RevivalPlanManager:GetBoxRewardPreview(activityInfoData)
  self:ShowRewardImp(rewardList)
  self:SetActive(true)
end

function RevivalPlanMainBoxPreviewComponent:ShowRewardImp(rewardList)
  self.rewardList = rewardList
  local rewardCount = #rewardList
  local itemCount = #self.itemList
  local itemReqCount = #self.itemReqs
  local count = Mathf.Min(rewardCount, itemCount)
  for i = 1, count do
    local item = self.itemList[i]
    local data = rewardList[i]
    item:ReInit(data)
    local go = self.itemGoList[i]
    if go then
      go:SetActive(true)
    end
  end
  for i = count + 1, itemCount do
    local go = self.itemGoList[i]
    if go then
      go:SetActive(false)
    end
  end
  for i = itemReqCount + 1, rewardCount do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if req.isError then
        return
      end
      local scale = 1.1
      local item = req.gameObject
      item.name = "reward_item" .. i
      item.transform:SetParent(self.compRewardLayout.transform)
      item.transform:Set_localScale(scale, scale, 1)
      local cell = self.compRewardLayout:AddComponent(UICommonResItem, item.name)
      self.itemList[i] = cell
      self.itemGoList[i] = item
      local data = self.rewardList[i]
      if data == nil then
        item:SetActive(false)
        return
      end
      item:SetActive(true)
      cell:ReInit(data)
    end)
  end
end

function RevivalPlanMainBoxPreviewComponent:ClearContent()
  if table.count(self.itemList) > 0 then
    self.compRewardLayout:RemoveComponents(UICommonResItem)
    self.itemList = nil
  end
  self.itemGoList = nil
  if 0 < table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
    self.itemReqs = nil
  end
end

function RevivalPlanMainBoxPreviewComponent:OnBtnBgClick()
  self:SetActive(false)
  EventManager:GetInstance():Broadcast(EventId.RevivalPlanBoxPreviewClose)
end

return RevivalPlanMainBoxPreviewComponent
