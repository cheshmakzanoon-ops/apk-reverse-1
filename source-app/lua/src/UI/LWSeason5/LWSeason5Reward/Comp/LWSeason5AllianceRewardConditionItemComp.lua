local condition_des_path = "conditionDes"
local condition_icon_path = "conditionIcon"
local base = UIBaseContainer
local LWSeason5AllianceRewardConditionItemComp = BaseClass("LWSeason5AllianceRewardConditionItemComp", UIBaseContainer)

function LWSeason5AllianceRewardConditionItemComp:ComponentDefine()
  self.condition_des = self:AddComponent(UITextMeshProUGUIEx, condition_des_path)
  self.condition_icon = self:AddComponent(UIImage, condition_icon_path)
end

function LWSeason5AllianceRewardConditionItemComp:ComponentDestroy()
  self.condition_des = nil
  self.condition_icon = nil
end

function LWSeason5AllianceRewardConditionItemComp:DataDefine()
end

function LWSeason5AllianceRewardConditionItemComp:DataDestroy()
end

function LWSeason5AllianceRewardConditionItemComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWSeason5AllianceRewardConditionItemComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeason5AllianceRewardConditionItemComp:OnAddListener()
  base.OnAddListener(self)
end

function LWSeason5AllianceRewardConditionItemComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWSeason5AllianceRewardConditionItemComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function LWSeason5AllianceRewardConditionItemComp:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function LWSeason5AllianceRewardConditionItemComp:InitUi()
  self.condition_des:SetTextFormat("%s%s", self.Data.title, self.Data.progress)
  local showIcon = not self.Data.isFinish and self.Data.icon ~= nil
  self.condition_icon:SetActive(showIcon)
  if showIcon then
    self.condition_icon:LoadSpriteAsync(self.Data.icon)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.condition_des.rectTransform)
end

function LWSeason5AllianceRewardConditionItemComp:UpdateData()
end

function LWSeason5AllianceRewardConditionItemComp:UpdateUi()
end

return LWSeason5AllianceRewardConditionItemComp
