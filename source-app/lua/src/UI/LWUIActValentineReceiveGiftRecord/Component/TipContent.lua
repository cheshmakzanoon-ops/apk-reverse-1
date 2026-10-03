local base = UIBaseContainer
local TipContent = BaseClass("TipContent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local intro_path = "ScrollView/Viewport/Content/Intro"
local content_path = "ScrollView/Viewport/Content"

function TipContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TipContent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TipContent:ComponentDefine()
  self.intro_text = self:AddComponent(UIText, intro_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function TipContent:ComponentDestroy()
  self.intro_text = nil
  self.content = nil
end

function TipContent:DataDefine()
end

function TipContent:DataDestroy()
end

function TipContent:OnAddListener()
  base.OnAddListener(self)
end

function TipContent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TipContent:SetData(activityId)
  self.activityId = activityId
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.rData = DataCenter.ValentineDataManager:GetActivityReceiveData(self.activityId)
  self:RefreshView()
end

function TipContent:RefreshView()
  local propertyInfo
  if self.rData and self.rData.activityGetData then
    propertyInfo = self.rData.activityGetData:GetBoxRewardPropertyInfo()
  end
  self.intro_text:SetText(Localization:GetString(self.activityInfo.story, table.unpack(propertyInfo)))
  self.content:SetAnchoredPositionXY(0, 0)
end

return TipContent
