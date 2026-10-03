local ScratchOffCommonRewardItem = BaseClass("ScratchOffCommonRewardItem", UIBaseContainer)
local base = UIBaseContainer
local commonRewardTxt_path = "commonRewardTxt"
local resItem_path = "UICommonResItem"

function ScratchOffCommonRewardItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ScratchOffCommonRewardItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ScratchOffCommonRewardItem:DataDefine()
end

function ScratchOffCommonRewardItem:DataDestroy()
end

function ScratchOffCommonRewardItem:ComponentDefine()
  self.commonRewardTxt = self:AddComponent(UIText, commonRewardTxt_path)
  self.resItem = self:AddComponent(UICommonResItem, resItem_path)
end

function ScratchOffCommonRewardItem:ComponentDestroy()
end

function ScratchOffCommonRewardItem:SetData(itemInfo)
  if itemInfo == nil then
    return
  end
  self.commonRewardTxt:SetText(tostring(itemInfo.rate) .. "%")
  self.resItem:ReInit(itemInfo.resItemInfo)
end

return ScratchOffCommonRewardItem
