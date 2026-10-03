local ParkourBonusProgressItem = BaseClass("ParkourBonusProgressItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "NumText")
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.imgSure = self:AddComponent(UIImage, "SureImg")
end

local function ComponentDestroy(self)
  self.textNum = nil
  self.imgIcon = nil
  self.imgSure = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, param, maxNum)
  self.progressNum = param.progressNum
  self.rewardId = param.rewardId
  self.textNum:SetText(math.floor(self.progressNum / maxNum * 100) .. "%")
  self:Refresh(0)
end

local function Refresh(self, nowProgressNum)
  if nowProgressNum >= self.progressNum then
    self.textNum:SetActive(false)
    self.imgSure:SetActive(true)
  else
    self.textNum:SetActive(true)
    self.imgSure:SetActive(false)
  end
end

ParkourBonusProgressItem.OnCreate = OnCreate
ParkourBonusProgressItem.OnDestroy = OnDestroy
ParkourBonusProgressItem.OnEnable = OnEnable
ParkourBonusProgressItem.OnDisable = OnDisable
ParkourBonusProgressItem.ComponentDefine = ComponentDefine
ParkourBonusProgressItem.ComponentDestroy = ComponentDestroy
ParkourBonusProgressItem.DataDefine = DataDefine
ParkourBonusProgressItem.DataDestroy = DataDestroy
ParkourBonusProgressItem.OnAddListener = OnAddListener
ParkourBonusProgressItem.OnRemoveListener = OnRemoveListener
ParkourBonusProgressItem.SetData = SetData
ParkourBonusProgressItem.Refresh = Refresh
return ParkourBonusProgressItem
