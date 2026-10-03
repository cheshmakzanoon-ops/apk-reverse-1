local UIPVEAdventureRecordItem = BaseClass("UIPVEAdventureRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local desc_path = "Desc"
local check_btn_path = "Check"
local check_text_path = "Check/CheckText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.check_btn = self:AddComponent(UIButton, check_btn_path)
  self.check_btn:SetOnClick(function()
    self:OnCheckClick()
  end)
  self.check_text = self:AddComponent(UIText, check_text_path)
end

local function ComponentDestroy(self)
  self.desc_text = nil
  self.check_btn = nil
  self.check_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data)
  self.check_btn:SetActive(false)
  if data.type == AdventureType.Monster then
    local soldierChange = math.abs(data.paramObj.soldierChange)
    self.desc_text:SetLocalText(302257, data.paramObj.explorerLevel, soldierChange)
  elseif data.type == AdventureType.Buff then
    local descStrList, recoverVal = DataCenter.AdventureManager:GetBuffContentStrList(data.content)
    if 0 < #descStrList then
      self.desc_text:SetLocalText(302258, string.join(descStrList, ", "))
    elseif 0 < recoverVal then
      self.desc_text:SetLocalText(302279, recoverVal)
    elseif recoverVal < 0 then
      self.desc_text:SetLocalText(302260, -recoverVal)
    else
      self.desc_text:SetText("")
    end
  elseif data.type == AdventureType.Reward then
    local names = DataCenter.RewardManager:GetRewardNames(data.paramObj.reward)
    self.desc_text:SetLocalText(302263, string.join(names, ", "))
  elseif data.type == AdventureType.Box then
    if data.subType == AdventureType.Buff then
      local descStrList, recoverVal = DataCenter.AdventureManager:GetBuffContentStrList(data.content)
      if 0 < #descStrList then
        self.desc_text:SetLocalText(302261, string.join(descStrList, ", "))
      elseif 0 < recoverVal then
        self.desc_text:SetLocalText(302284, recoverVal)
      elseif recoverVal < 0 then
        self.desc_text:SetLocalText(302260, -recoverVal)
      else
        self.desc_text:SetText("")
      end
    elseif data.subType == AdventureType.Reward then
      local names = RewardManager:GetRewardNames(data.paramObj.reward)
      self.desc_text:SetLocalText(302262, string.join(names, ", "))
    else
      self.desc_text:SetText("")
    end
  else
    self.desc_text:SetText("")
  end
end

local function OnCheckClick(self)
end

UIPVEAdventureRecordItem.OnCreate = OnCreate
UIPVEAdventureRecordItem.OnDestroy = OnDestroy
UIPVEAdventureRecordItem.ComponentDefine = ComponentDefine
UIPVEAdventureRecordItem.ComponentDestroy = ComponentDestroy
UIPVEAdventureRecordItem.DataDefine = DataDefine
UIPVEAdventureRecordItem.DataDestroy = DataDestroy
UIPVEAdventureRecordItem.OnEnable = OnEnable
UIPVEAdventureRecordItem.OnDisable = OnDisable
UIPVEAdventureRecordItem.OnAddListener = OnAddListener
UIPVEAdventureRecordItem.OnRemoveListener = OnRemoveListener
UIPVEAdventureRecordItem.SetData = SetData
UIPVEAdventureRecordItem.OnCheckClick = OnCheckClick
return UIPVEAdventureRecordItem
