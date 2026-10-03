local UILWAlSelectFlagCell = BaseClass("UILWAlSelectFlagCell", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local this_path = ""
local select_go_path = "SelectFrame"
local icon_path = "Icon"
local my_path = "IsMy"

function UILWAlSelectFlagCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlSelectFlagCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSelectFlagCell:ComponentDefine()
  self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
  self.my_go = self:AddComponent(UIBaseContainer, my_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UILWAlSelectFlagCell:ComponentDestroy()
  self.select_go = nil
  self.icon = nil
  self.btn = nil
end

function UILWAlSelectFlagCell:DataDefine()
  self.param = {}
end

function UILWAlSelectFlagCell:DataDestroy()
  self.param = nil
end

function UILWAlSelectFlagCell:OnEnable()
  base.OnEnable(self)
end

function UILWAlSelectFlagCell:OnDisable()
  base.OnDisable(self)
end

function UILWAlSelectFlagCell:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlSelectFlagCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlSelectFlagCell:ReInit(param)
  self.param = param
  if param.icon ~= nil then
    self.icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, param.icon))
  end
  self.my_go:SetActive(param.isCur)
  self:SetSelect(param.isSelect)
end

function UILWAlSelectFlagCell:OnBtnClick()
  if self.param.callBack ~= nil then
    self.param.callBack(self.param.index)
  end
end

function UILWAlSelectFlagCell:SetSelect(isActive)
  self.select_go:SetActive(isActive)
end

return UILWAlSelectFlagCell
