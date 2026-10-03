local SeasonHunterRewardSelfItem = BaseClass("SeasonHunterRewardSelfItem", UIBaseContainer)
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
  local rewardList = rewardInfo.rewards
  local min = rewardInfo.minTime or 0
  local max = rewardInfo.maxTime or 1
  local maxStr = 0 < max and UITimeManager:GetInstance():SecondToFmtStringWithoutHour(max) or "..."
  local damageStr = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(min) .. "-" .. maxStr
  if not DataCenter.SeasonHunterManager:IsInBattle() then
    self.cur:SetActive(false)
    self.normal:SetActive(true)
    self.norDamage:SetText(damageStr)
  elseif curDamage >= min and (max < 0 or curDamage < max) then
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
      local nameStr = "item" .. i
      go.name = nameStr
      local cell = self.content:AddComponent(UICommonResItem, nameStr)
      cell:ReInit(rewardList[i])
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

SeasonHunterRewardSelfItem.OnCreate = OnCreate
SeasonHunterRewardSelfItem.OnDestroy = OnDestroy
SeasonHunterRewardSelfItem.ComponentDefine = ComponentDefine
SeasonHunterRewardSelfItem.ComponentDestroy = ComponentDestroy
SeasonHunterRewardSelfItem.DataDefine = DataDefine
SeasonHunterRewardSelfItem.DataDestroy = DataDestroy
SeasonHunterRewardSelfItem.OnAddListener = OnAddListener
SeasonHunterRewardSelfItem.OnRemoveListener = OnRemoveListener
SeasonHunterRewardSelfItem.Refresh = Refresh
SeasonHunterRewardSelfItem.RemoveCurItems = RemoveCurItems
return SeasonHunterRewardSelfItem
