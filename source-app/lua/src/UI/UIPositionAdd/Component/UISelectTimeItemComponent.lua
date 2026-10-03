local base = UIBaseContainer
local UISelectTimeItemComponent = BaseClass("UISelectTimeItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UISelectTimeItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UISelectTimeItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISelectTimeItemComponent:ComponentDefine()
  self.normalText = self:AddComponent(UITextMeshProUGUIEx, "NormalText")
  self.selectText = self:AddComponent(UITextMeshProUGUIEx, "SelectText")
end

function UISelectTimeItemComponent:ComponentDestroy()
  self.normalText = nil
  self.selectText = nil
end

function UISelectTimeItemComponent:DataDefine()
  self.textData = ""
  self.selectIndex = 0
end

function UISelectTimeItemComponent:DataDestroy()
  self.textData = nil
  self.selectIndex = nil
end

function UISelectTimeItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UISelectTimeItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISelectTimeItemComponent:SetTimeData(time_text, select_index, cur_select_index)
  self.textData = time_text or ""
  self.selectIndex = select_index or 0
  self.normalText:SetText(self.textData)
  self.selectText:SetText(self.textData)
  self:SetTimeSelect(cur_select_index)
end

function UISelectTimeItemComponent:SetTimeSelect(index)
  self.normalText:SetActive(self.selectIndex ~= index)
  self.selectText:SetActive(self.selectIndex == index)
end

return UISelectTimeItemComponent
