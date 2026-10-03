local UILWSeasonActivityDetailView = BaseClass("UILWSeasonActivityDetailView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local title_text_path = "PopUpTitle/3/titleText"
local icon_path = "PopUpTitle/3/icon"
local content_path = "PopUpTitle/3/ScrollView/Viewport/Content"
local close_btn_path = "PopUpTitle/CloseBtn"

function UILWSeasonActivityDetailView:OnCreate()
  base.OnCreate(self)
  self.activityId = tostring(self:GetUserData())
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonActivityDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonActivityDetailView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.icon = self:AddComponent(UIRawImage, icon_path)
  self.content = self:AddComponent(UITextMeshProUGUIEx, content_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UILWSeasonActivityDetailView:ComponentDestroy()
  self.panel = nil
  self.title_text = nil
  self.icon = nil
  self.content = nil
  self.close_btn = nil
end

function UILWSeasonActivityDetailView:UpdateData()
  local data = LocalController:instance():getLine(TableName.Activity, self.activityId)
  if data then
    self.title_text:SetLocalText(data.name)
    if string.IsNullOrEmpty(data.banner) then
      self.icon:SetActive(false)
    else
      local path = "Assets/Main/TextureEx/Season/Activity/" .. data.banner .. ".png"
      if CS.GameEntry.Resource:HasAsset(path) then
        self.icon:SetActive(true)
        self.icon:LoadSprite(path)
      else
        self.icon:SetActive(false)
      end
    end
    if string.IsNullOrEmpty(data.story) then
      self.content:SetLocalText(data.desc)
    else
      local title, desc = string.match(data.story, "([^;]+);([^;]+)")
      if title and desc then
        self.title_text:SetLocalText(title)
        self.content:SetLocalText(desc)
      else
        self.content:SetLocalText(data.desc)
      end
    end
  else
    self.title_text:SetText("")
    self.content:SetText("")
    self.icon:SetActive(false)
  end
end

return UILWSeasonActivityDetailView
