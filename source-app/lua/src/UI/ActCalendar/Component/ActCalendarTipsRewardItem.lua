local base = UIBaseContainer
local ActCalendarTipsRewardItem = BaseClass("ActCalendarTipsRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActCalendarTipsRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActCalendarTipsRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActCalendarTipsRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
end

function ActCalendarTipsRewardItem:ComponentDestroy()
  self.viewSkin = nil
  self.compResItem = nil
end

function ActCalendarTipsRewardItem:DataDefine()
end

function ActCalendarTipsRewardItem:DataDestroy()
end

function ActCalendarTipsRewardItem:SetData(props)
  if props then
    props.clickCallBack = nil
    self.compResItem:ReInit(props)
    self.compResItem:SetItemCountActive(false)
  end
end

return ActCalendarTipsRewardItem
