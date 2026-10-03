local condition_des_path = "conditionDes"
local condition_icon_path = "conditionIcon"
local base = UIBaseContainer
local LWS6AllianceRewardConditionItemComp = BaseClass("LWS6AllianceRewardConditionItemComp", UIBaseContainer)

function LWS6AllianceRewardConditionItemComp:ComponentDefine()
  self.condition_des = self:AddComponent(UITextMeshProUGUIEx, condition_des_path)
  self.condition_icon = self:AddComponent(UIImage, condition_icon_path)
end

function LWS6AllianceRewardConditionItemComp:ComponentDestroy()
  self.condition_des = nil
  self.condition_icon = nil
end

function LWS6AllianceRewardConditionItemComp:DataDefine()
  self.ColorGreen = "#099B4A"
  self.ColorGray = "#7F756E"
end

function LWS6AllianceRewardConditionItemComp:DataDestroy()
end

function LWS6AllianceRewardConditionItemComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWS6AllianceRewardConditionItemComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWS6AllianceRewardConditionItemComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function LWS6AllianceRewardConditionItemComp:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function LWS6AllianceRewardConditionItemComp:InitUi()
  self.condition_des:SetTextFormat("%s%s", self.Data.title, self.Data.progress)
  local showIcon = not self.Data.isFinish and self.Data.icon ~= nil
  self.condition_icon:SetActive(showIcon)
  if showIcon then
    self.condition_icon:LoadSpriteAsync(self.Data.icon)
  end
  self.condition_des:SetColorHex(self.Data.isFinish and self.ColorGreen or self.ColorGray)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.condition_des.rectTransform)
end

return LWS6AllianceRewardConditionItemComp
