local TabBtnItem = BaseClass("TabBtnItem", UIBaseContainer)
local base = UIBaseContainer
local UIAdaptReddot = require("UI.UICommon.Component.UIAdaptReddot")
local compBook = {
  {
    path = "",
    name = "btnTab",
    type = UIButton,
    onClick = function(self)
      self:OnBtnClick()
    end
  },
  {
    path = "txtOff",
    name = "txtOff",
    type = UITextMeshProUGUIEx
  },
  {
    path = "imgOn",
    name = "imgOn",
    type = UIImage,
    active = false
  },
  {
    path = "imgOn/txtOn",
    name = "txtOn",
    type = UITextMeshProUGUIEx
  },
  {
    path = "reddot",
    name = "reddot",
    type = UIAdaptReddot,
    active = false
  }
}

function TabBtnItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TabBtnItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function TabBtnItem:OnBtnClick()
  if self.callBack then
    self.callBack(self.data)
  end
end

function TabBtnItem:SetIsOn(isOn)
  self.imgOn:SetActive(isOn)
end

function TabBtnItem:ReInit(data, index, callBack)
  self.data = data
  self.index = index
  self.callBack = callBack
  self.txtOff:SetLocalText(data.tabKey)
  self.txtOn:SetLocalText(data.tabKey)
  self.reddot:SetRedDotType(data.redType)
  self:SetRedNumber(ChatInterface.getMoment():GetRedDot(data.type))
end

function TabBtnItem:SetRedNumber(number)
  self.reddot:SetNumber(number)
end

function TabBtnItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function TabBtnItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TabBtnItem:DataDestroy()
end

return TabBtnItem
