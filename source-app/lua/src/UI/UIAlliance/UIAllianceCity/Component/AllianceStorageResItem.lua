local AllianceStorageResItem = BaseClass("AllianceStorageResItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local resName_path = "resName"
local resIcon_path = "UICommonResItem/clickBtn/ItemIcon"
local curCount_path = "resCount"
local addCount_path = "resAdd"

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
  self.resNameN = self:AddComponent(UIText, resName_path)
  self.resIconN = self:AddComponent(UIImage, resIcon_path)
  self.resCountN = self:AddComponent(UIText, curCount_path)
  self.addCountN = self:AddComponent(UIText, addCount_path)
end

local function ComponentDestroy(self)
  self.resNameN = nil
  self.resIconN = nil
  self.resCountN = nil
  self.addCountN = nil
end

local function DataDefine(self)
  self.curRewardType = nil
end

local function DataDestroy(self)
  self.curRewardType = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, rewardType)
  self.curRewardType = rewardType
  if self.curRewardType == RewardType.ALLIANCE_POINT then
    self.resNameN:SetLocalText(390964)
    self.resIconN:LoadSprite(string.format(LoadPath.ItemPath, "allianceCoin"))
    local ownCount = DataCenter.AllianceStorageManager:GetResCountByRewardType(self.curRewardType)
    self.resCountN:SetText(string.GetFormattedStr(ownCount))
    self.addCountN:SetText("")
  else
    self.resNameN:SetLocalText(390967)
    self.resIconN:LoadSprite(string.format(LoadPath.ItemPath, "allianceResource"))
    local strConf = LuaEntry.DataConfig:TryGetStr("union_resources", "k1")
    local strArr = string.split(strConf, ";")
    local baseAdd = tonumber(strArr[1])
    local maxNum = tonumber(strArr[2])
    local effNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_STORAGE_MAX)
    maxNum = math.modf(maxNum * (1 + effNum / 100))
    local maxEff = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_STORAGE_MAX)
    local addEff_percent = LuaEntry.Effect:GetGameEffect(EffectDefine.SAPPHIRE_PRODUCT_SPEED_PERCENT)
    local addEff_num = LuaEntry.Effect:GetGameEffect(EffectDefine.SAPPHIRE_PRODUCT_SPEED_NUM)
    local newAdd = (baseAdd * 3600 + addEff_num) * (1 + addEff_percent)
    local addPerH = newAdd
    local ownCount = DataCenter.AllianceStorageManager:GetResCountByRewardType(self.curRewardType)
    self.resCountN:SetText(string.GetFormattedStr(math.modf(ownCount)) .. "/" .. string.GetFormattedStr(maxNum))
    self.addCountN:SetText(Localization:GetString("390968", string.GetFormattedStr(addPerH)))
  end
end

AllianceStorageResItem.OnCreate = OnCreate
AllianceStorageResItem.OnDestroy = OnDestroy
AllianceStorageResItem.ComponentDefine = ComponentDefine
AllianceStorageResItem.ComponentDestroy = ComponentDestroy
AllianceStorageResItem.DataDefine = DataDefine
AllianceStorageResItem.DataDestroy = DataDestroy
AllianceStorageResItem.OnAddListener = OnAddListener
AllianceStorageResItem.OnRemoveListener = OnRemoveListener
AllianceStorageResItem.SetItem = SetItem
return AllianceStorageResItem
