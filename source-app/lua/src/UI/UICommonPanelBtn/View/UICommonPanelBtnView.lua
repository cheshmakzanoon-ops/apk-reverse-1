local UICommonPanelBtnView = BaseClass("UICommonPanelBtnView", UIBaseView)
local base = UIBaseView

function UICommonPanelBtnView:OnCreate()
  base.OnCreate(self)
  self.panelBtn = self:AddComponent(UIButton, "panel")
  self.panelBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self:ReInit()
end

function UICommonPanelBtnView:OnBtnClick()
  if not self.isCanClick then
    return
  end
  if self.clickDataList == nil or #self.clickDataList <= 0 then
    self.ctrl:CloseSelf()
  else
    if self.clickDataList[1] then
      self.clickDataList[1]()
      if self.clickDataList == nil or #self.clickDataList <= 0 then
        return
      end
      table.remove(self.clickDataList, 1)
    end
    if #self.clickDataList == 0 then
      self.ctrl:CloseSelf()
    end
  end
end

function UICommonPanelBtnView:ReInit(param)
  self.param = param and param or self:GetUserData()
  if self.param then
    self.isCanClick = self.param.isCanClick
    self.clickDataList = self.param.clickDataList
  end
end

function UICommonPanelBtnView:SetCanClick(isCanClick)
  self.isCanClick = isCanClick
end

function UICommonPanelBtnView:OnDestroy()
  self.panelBtn = nil
  self.param = nil
  self.isCanClick = nil
  self.clickDataList = nil
  base.OnDestroy(self)
end

return UICommonPanelBtnView
