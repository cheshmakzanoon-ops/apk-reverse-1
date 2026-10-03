local UILWAlGuideView = BaseClass("UILWAlGuideView", UIBaseView)
local base = UIBaseView
local next_desc_btn_path_1 = "panel"
local hero_icon_path = "panel/heroIcon"
local hero_desc_txt_path = "panel/content/contentImg/contentText"
local hero_next_img_path = "panel/content/contentImg/nextImg"
local next_desc_btn_path_2 = "panel/content/contentImg/nextBtn"
local hero_name_txt_path = "panel/content/nameLayout/heroName/heroNameText"
local btn_layout_path = "panel/btnLayout"
local agree_btn_path = "panel/btnLayout/agreeBtn"
local agree_btn_txt_path = "panel/btnLayout/agreeBtn/agreeBtnText"
local refuse_btn_path = "panel/btnLayout/refuseBtn"
local refuse_btn_txt_path = "panel/btnLayout/refuseBtn/refuseBtnText"
local back_btn_path = "panel/backBtn"
local AGREE_TITLE_TXT = 110006
local REFUSE_TITLE_TXT = 390005
local DEFAULT_HERO_ICON_PATH = "Assets/Main/Sprites/LW_HeroBody/%s.png"

function UILWAlGuideView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlGuideView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlGuideView:ComponentDefine()
  self.nextDescBtn_1 = self:AddComponent(UIButton, next_desc_btn_path_1)
  self.nextDescBtn_1:SetOnClick(function()
    self:OnNextDescBtnClick()
  end)
  self.heroIconImg = self:AddComponent(UIRawImage, hero_icon_path)
  self.heroDescText = self:AddComponent(UIText, hero_desc_txt_path)
  self.heroNextImg = self:AddComponent(UIBaseContainer, hero_next_img_path)
  self.nextDescBtn_2 = self:AddComponent(UIButton, next_desc_btn_path_2)
  self.nextDescBtn_2:SetOnClick(function()
    self:OnNextDescBtnClick()
  end)
  self.heroNameText = self:AddComponent(UIText, hero_name_txt_path)
  self.btnLayout = self:AddComponent(UIBaseContainer, btn_layout_path)
  self.agreeBtn = self:AddComponent(UIButton, agree_btn_path)
  self.agreeBtnText = self:AddComponent(UIText, agree_btn_txt_path)
  self.refuseBtn = self:AddComponent(UIButton, refuse_btn_path)
  self.refuseBtnText = self:AddComponent(UIText, refuse_btn_txt_path)
  self.agreeBtn:SetOnClick(function()
    self:OnAgreeBtnClick()
  end)
  self.refuseBtn:SetOnClick(function()
    self:OnRefuseBtnClick()
  end)
  self.backBtn = self:AddComponent(UIButton, back_btn_path)
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
end

function UILWAlGuideView:ComponentDestroy()
  self.nextDescBtn_1 = nil
  self.heroIconImg = nil
  self.heroDescText = nil
  self.heroNextImg = nil
  self.nextDescBtn_2 = nil
  self.heroNameText = nil
  self.btnLayout = nil
  self.agreeBtn = nil
  self.agreeBtnText = nil
  self.refuseBtn = nil
  self.refuseBtnText = nil
  self.backBtn = nil
end

function UILWAlGuideView:DataDefine()
  self.param = {}
  self.heroDescIndex = 1
  self.heroDescList = {}
end

function UILWAlGuideView:DataDestroy()
  self.param = nil
  self.heroDescIndex = nil
  self.heroDescList = nil
end

function UILWAlGuideView:OnEnable()
  base.OnEnable(self)
  self:ReInit()
end

function UILWAlGuideView:OnDisable()
  base.OnDisable(self)
end

function UILWAlGuideView:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlGuideView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlGuideView:ReInit()
  self.param = self:GetUserData()
  if not self.param or type(self.param) ~= "table" then
    self.backBtn:SetActive(true)
    return
  end
  local dialog_id = self.param and self.param.dialog_id or 1001
  local line = LocalController:instance():getLine(TableName.LW_Dialog, dialog_id)
  local model_icon = line.path
  local name_txt = line.name
  local desc_txt_list = {}
  table.insert(desc_txt_list, line.lauguageId)
  local next_dialog_id = line.nextId
  while next_dialog_id and next_dialog_id ~= "" do
    local next_line = LocalController:instance():getLine(TableName.LW_Dialog, next_dialog_id)
    table.insert(desc_txt_list, next_line.lauguageId)
    next_dialog_id = next_line.nextId
  end
  self.heroIconImg:LoadSpriteAuto(string.format(DEFAULT_HERO_ICON_PATH, model_icon), function(texture)
    self.heroIconImg:SetNativeSize()
  end)
  self.heroNameText:SetLocalText(name_txt)
  self.heroDescList = desc_txt_list
  self.heroDescIndex = 1
  self.agreeBtn:SetActive(false)
  self.agreeBtnText:SetLocalText(self.param.agree_title_txt or AGREE_TITLE_TXT)
  self.refuseBtn:SetActive(false)
  self.refuseBtnText:SetLocalText(self.param.refuse_title_txt or REFUSE_TITLE_TXT)
  self.backBtn:SetActive(false)
  self.agreeBtn:SetActive(true)
  if self.param.refuse_callback then
    self.refuseBtn:SetActive(true)
  end
  if self.param.back_callback then
    self.backBtn:SetActive(true)
  end
  self.heroNextImg:SetActive(true)
  self.btnLayout:SetActive(false)
  self:OnNextDescBtnClick()
end

function UILWAlGuideView:OnNextDescBtnClick()
  if self.heroDescIndex <= #self.heroDescList then
    self.heroDescText:SetLocalText(self.heroDescList[self.heroDescIndex])
    if self.heroDescIndex == #self.heroDescList then
      self.btnLayout:SetActive(true)
      self.heroNextImg:SetActive(false)
    end
    self.heroDescIndex = self.heroDescIndex + 1
  end
end

function UILWAlGuideView:OnAgreeBtnClick()
  if self.param.agree_callback then
    self.param.agree_callback()
    if self.param.agree_close then
      self.ctrl:CloseSelf()
    end
  else
    self.ctrl:CloseSelf()
  end
end

function UILWAlGuideView:OnRefuseBtnClick()
  self.param.refuse_callback()
  self.ctrl:CloseSelf()
end

function UILWAlGuideView:OnBackBtnClick()
  self.param.back_callback()
  self.ctrl:CloseSelf()
end

return UILWAlGuideView
