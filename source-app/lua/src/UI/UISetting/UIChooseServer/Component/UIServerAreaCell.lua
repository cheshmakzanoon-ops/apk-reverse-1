local UIServerAreaCell = BaseClass("UIServerAreaCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Color_Select_MainTitle = Color.New(0.8156862745098039, 0.40784313725490196, 0.19607843137254902, 1)
local Unselect_Color = Color.New(1, 1, 1, 0.5)

function UIServerAreaCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIServerAreaCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIServerAreaCell:OnEnable()
  base.OnEnable(self)
end

function UIServerAreaCell:OnDisable()
  base.OnDisable(self)
end

function UIServerAreaCell:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.un_select_img = self:AddComponent(UIImage, "unselect")
  self.select_img = self:AddComponent(UIImage, "select")
  self._server_txt = self:AddComponent(UIText, "Txt_ServerArea")
end

function UIServerAreaCell:ComponentDestroy()
  self.btn = nil
  self._server_txt = nil
end

function UIServerAreaCell:DataDefine()
  self.param = {}
end

function UIServerAreaCell:DataDestroy()
  self.param = nil
end

function UIServerAreaCell:ReInit(param, index, callback)
  self.param = param
  self.callback = callback
  self.index = param.index
  if param ~= nil then
    if param.index < 0 then
      if param.index == -1 then
        self._server_txt:SetLocalText(208234)
      elseif param.index == -2 then
        self._server_txt:SetText("TestServers")
      end
    else
      local minId = param.minNum
      local maxId = param.maxNum
      self._server_txt:SetText(minId .. "-" .. maxId)
    end
  end
  self:OnCheckSelect()
end

function UIServerAreaCell:OnBtnClick()
  if self.callback then
    self.callback(self.index)
  end
end

function UIServerAreaCell:OnCheckSelect(data)
  if self.param ~= nil and self.index == self.view.selectIndex then
    self.un_select_img:SetActive(false)
    self.select_img:SetActive(true)
    self._server_txt:SetColor(WhiteColor)
  else
    self.un_select_img:SetActive(true)
    self.select_img:SetActive(false)
    self._server_txt:SetColor(Unselect_Color)
  end
end

function UIServerAreaCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnSelectAccountServer, self.OnCheckSelect)
end

function UIServerAreaCell:RemoveListener()
  self:RemoveUIListener(EventId.OnSelectAccountServer, self.OnCheckSelect)
  base.OnRemoveListener(self)
end

return UIServerAreaCell
