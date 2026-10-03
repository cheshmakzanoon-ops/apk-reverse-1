local SeasonWorldSelectItem = BaseClass("SeasonWorldSelectItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = "item/btn"
local img_banner_path = "item/btn/img_banner"
local img_banner1_path = "item/btn/img_banner/img_banner1"
local tip_btn_path = "item/topPart/tipBtn"
local txt_title_path = "item/topPart/title/txt_title"
local btn_book_path = "item/topPart/btn_book"
local txt_state1_path = "item/InfoPart/txt_state1"
local txt_state2_path = "item/InfoPart/txt_state2"
local btn_go_path = "item/btn_go"

function SeasonWorldSelectItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.template = nil
end

function SeasonWorldSelectItem:OnDestroy()
  self.state = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonWorldSelectItem:ComponentDefine()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.img_banner = self:AddComponent(UIRawImage, img_banner_path)
  self.img_banner1 = self:AddComponent(UIRawImage, img_banner1_path)
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.btn_book = self:AddComponent(UIButton, btn_book_path)
  self.txt_state1 = self:AddComponent(UITextMeshProUGUIEx, txt_state1_path)
  self.txt_state2 = self:AddComponent(UITextMeshProUGUIEx, txt_state2_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn:SetOnClick(BindCallback(self, self.ClickBtn))
  self.tip_btn:SetOnClick(BindCallback(self, self.ClickTipBtn))
  self.btn_go:SetOnClick(BindCallback(self, self.ClickGoBtn))
  self.btn_book:SetOnClick(BindCallback(self, self.ClickBookBtn))
end

function SeasonWorldSelectItem:ComponentDestroy()
  self.btn = nil
  self.img_banner = nil
  self.img_banner1 = nil
  self.tip_btn = nil
  self.txt_title = nil
  self.btn_book = nil
  self.txt_state1 = nil
  self.txt_state2 = nil
  self.btn_go = nil
end

function SeasonWorldSelectItem:ClickBtn()
end

function SeasonWorldSelectItem:ClickTipBtn()
  if not string.IsNullOrEmpty(self.template.introduction) then
    local param = {
      activityRulesStr = Localization:GetString(self.template.introduction)
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function SeasonWorldSelectItem:ClickGoBtn()
  UIUtil.ShowTipsId("season_travel_world_tips_01")
end

function SeasonWorldSelectItem:ClickBookBtn()
  if not string.IsNullOrEmpty(self.template.comicgroup) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWComic, {anim = false}, tonumber(self.template.comicgroup), true)
  end
end

function SeasonWorldSelectItem:ReInit(template, gray)
  self.template = template
  self:Execute(gray)
end

function SeasonWorldSelectItem:Execute(gray)
  local template = self.template
  if not string.IsNullOrEmpty(template.big_banner) then
    self.img_banner:LoadSprite(template.big_banner)
    self.img_banner1:LoadSprite(template.big_banner)
  end
  if self.img_banner then
    CS.UIGray.SetGray(self.img_banner.transform, gray, true)
  end
  if self.img_banner1 then
    CS.UIGray.SetGray(self.img_banner1.transform, gray, true)
  end
  if not string.IsNullOrEmpty(template.big_description_1) then
    self.txt_state1:SetText(Localization:GetString(template.big_description_1))
  end
  if not string.IsNullOrEmpty(template.big_description_2) then
    self.txt_state2:SetText(Localization:GetString(template.big_description_2))
  end
  if not string.IsNullOrEmpty(template.big_name) then
    self.txt_title:SetText(Localization:GetString(template.big_name))
  end
  local showBook = not string.IsNullOrEmpty(self.template.comicgroup)
  self.btn_book:SetActive(showBook)
end

return SeasonWorldSelectItem
