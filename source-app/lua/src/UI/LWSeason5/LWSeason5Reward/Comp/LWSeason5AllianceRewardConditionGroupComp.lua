local p_img_bg_condition_white_path = "p_img_bg_condition_white"
local p_img_bg_condition_green_path = "p_img_bg_condition_green"
local p_img_icon_condition_path = "p_img_icon_condition"
local p_trans_condition_path = "p_trans_condition"
local item_script_path = require("UI/LWSeason5/LWSeason5Reward/Comp/LWSeason5AllianceRewardConditionItemComp")
local p_condition_item_template_path = "p_condition_item_template"
local base = UIBaseContainer
local LWSeason5AllianceRewardConditionGroupComp = BaseClass("LWSeason5AllianceRewardConditionGroupComp", UIBaseContainer)

function LWSeason5AllianceRewardConditionGroupComp:ComponentDefine()
  self.p_img_bg_condition_white = self:AddComponent(UIImage, p_img_bg_condition_white_path)
  self.p_img_bg_condition_green = self:AddComponent(UIImage, p_img_bg_condition_green_path)
  self.p_img_icon_condition = self:AddComponent(UIImage, p_img_icon_condition_path)
  self.p_condition_item_template = self:AddComponent(item_script_path, p_condition_item_template_path)
  self.p_trans_condition = self:AddComponent(UIBaseContainer, p_trans_condition_path)
  self.goTemplate = self.p_condition_item_template.gameObject
  self.goTemplate:GameObjectCreatePool()
  self.goTemplate:SetActive(false)
end

function LWSeason5AllianceRewardConditionGroupComp:ComponentDestroy()
  self.p_trans_condition:RemoveComponents(item_script_path)
  self.goTemplate:GameObjectRecycleAll()
  self.p_img_bg_condition_white = nil
  self.p_img_bg_condition_green = nil
  self.p_img_icon_condition = nil
  self.p_condition_item_template = nil
  self.p_trans_condition = nil
end

function LWSeason5AllianceRewardConditionGroupComp:DataDefine()
end

function LWSeason5AllianceRewardConditionGroupComp:DataDestroy()
end

function LWSeason5AllianceRewardConditionGroupComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWSeason5AllianceRewardConditionGroupComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeason5AllianceRewardConditionGroupComp:OnAddListener()
  base.OnAddListener(self)
end

function LWSeason5AllianceRewardConditionGroupComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWSeason5AllianceRewardConditionGroupComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function LWSeason5AllianceRewardConditionGroupComp:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function LWSeason5AllianceRewardConditionGroupComp:InitUi()
  self.p_img_icon_condition:SetActive(self.Data.GroupData.isFinish)
  self.p_img_bg_condition_green:SetActive(self.Data.GroupData.isFinish)
  self.p_img_bg_condition_white:SetActive(not self.Data.GroupData.isFinish)
  local titleStr = ""
  if self.Data.GroupData.title ~= nil then
    local titlePairs = string.split(self.Data.GroupData.title, ",")
    local key = titlePairs[1]
    local params = {}
    for i = 2, #titlePairs do
      table.insert(params, titlePairs[i])
    end
    titleStr = CS.GameEntry.Localization:GetString(key, table.unpack(params))
  end
  local progressStr = ""
  if self.Data.GroupData.progress ~= nil then
    local progressValue = {}
    for _, item in pairs(self.Data.GroupData.conditions) do
      table.insert(progressValue, item.progress)
    end
    progressStr = CS.GameEntry.Localization:GetString(self.Data.GroupData.progress, table.unpack(progressValue))
  end
  local itemData = {}
  itemData.icon = self.Data.GroupData.icon
  itemData.title = titleStr
  itemData.progress = progressStr
  itemData.isFinish = self.Data.GroupData.isFinish
  local go = self.goTemplate:GameObjectSpawn(self.p_trans_condition.transform)
  go.gameObject:SetActive(true)
  go.transform:Set_localScale(1, 1, 1)
  go.name = "item_" .. NameCount
  NameCount = NameCount + 1
  local cell = self.p_trans_condition:AddComponent(item_script_path, go.name)
  cell:ReInit(itemData)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.p_trans_condition.rectTransform)
end

function LWSeason5AllianceRewardConditionGroupComp:UpdateData()
end

function LWSeason5AllianceRewardConditionGroupComp:UpdateUi()
end

return LWSeason5AllianceRewardConditionGroupComp
