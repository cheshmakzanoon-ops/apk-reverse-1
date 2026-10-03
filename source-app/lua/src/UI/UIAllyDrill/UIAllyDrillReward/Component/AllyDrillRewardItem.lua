local AllyDrillRewardItem = BaseClass("AllyDrillRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.content = self:AddComponent(UIBaseContainer, "ScrollRect/ViewPort/Content")
  self.normal = self:AddComponent(UIBaseComponent, "normal")
  self.norDamage = self:AddComponent(UIText, "normal/norDamage")
  self.cur = self:AddComponent(UIBaseComponent, "cur")
  self.curDamage = self:AddComponent(UIText, "cur/curDamage")
end

local function ComponentDestroy(self)
  self:RemoveCurItems()
  self.content = nil
  self.normal = nil
  self.norDamage = nil
  self.cur = nil
  self.curDamage = nil
end

local function DataDefine(self)
  self.itemReqs = {}
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, rewardInfo, curDamage)
  local rewardList = rewardInfo.reward
  local min = rewardInfo.min or 0
  local max = rewardInfo.max or 1
  local maxStr = 0 < max and string.GetFormattedStr2(max) or "..."
  local damageStr = string.GetFormattedStr2(min) .. "-" .. maxStr
  if curDamage >= min and (max < 0 or curDamage < max) then
    self.cur:SetActive(true)
    self.normal:SetActive(false)
    self.curDamage:SetText(damageStr)
  else
    self.cur:SetActive(false)
    self.normal:SetActive(true)
    self.norDamage:SetText(damageStr)
  end
  self:RemoveCurItems()
  for i = 1, #rewardList do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(self.content.transform)
      transform:Set_localScale(0.75, 0.75, 1)
      transform:Set_sizeDelta(150, 150)
      transform:Set_pivot(0, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(UICommonResItem, nameStr)
      local data = rewardList[i]
      local param = UICommonResItem.Param.New()
      param.rewardType = data.type
      if type(data.value) == "table" then
        param.itemId = data.value.id
        param.count = data.value.num
      else
        param.itemId = data.type
        param.count = data.value
      end
      param.rewardType = data.type
      param.heroUuid = data.heroUuid
      param.isHeroBox = data.isHeroBox
      cell:ReInit(param)
    end)
  end
end

local function RemoveCurItems(self)
  self.content:RemoveComponents(UICommonResItem)
  if self.itemReqs then
    for _, v in pairs(self.itemReqs) do
      v:Destroy()
    end
    self.itemReqs = {}
  end
end

AllyDrillRewardItem.OnCreate = OnCreate
AllyDrillRewardItem.OnDestroy = OnDestroy
AllyDrillRewardItem.ComponentDefine = ComponentDefine
AllyDrillRewardItem.ComponentDestroy = ComponentDestroy
AllyDrillRewardItem.DataDefine = DataDefine
AllyDrillRewardItem.DataDestroy = DataDestroy
AllyDrillRewardItem.OnAddListener = OnAddListener
AllyDrillRewardItem.OnRemoveListener = OnRemoveListener
AllyDrillRewardItem.Refresh = Refresh
AllyDrillRewardItem.RemoveCurItems = RemoveCurItems
return AllyDrillRewardItem
