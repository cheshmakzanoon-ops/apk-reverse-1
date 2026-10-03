local base = UIBaseContainer
local UIActLotteryItemGetManualItem = BaseClass("UIActLotteryItemGetManualItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local img_content_path = "ImgContent"
local img_path = "ImgContent/Img"
local text_path = "TextContent/Text"
local line_content_path = "lineContent"
local goto_btn_path = "TextContent/gotoBtn"
local btn_txt_path = "TextContent/gotoBtn/Image/btnTxt"

function UIActLotteryItemGetManualItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActLotteryItemGetManualItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotteryItemGetManualItem:ComponentDefine()
  self.img_content = self:AddComponent(UILayoutElement, img_content_path)
  self.img = self:AddComponent(UIRawImage, img_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.line_content = self:AddComponent(UIBaseContainer, line_content_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn:SetOnClick(function()
    self:OnClickGotoBtn()
  end)
  self.btn_txt = self:AddComponent(UITextMeshProUGUIEx, btn_txt_path)
end

function UIActLotteryItemGetManualItem:ComponentDestroy()
  self.img_content = nil
  self.img = nil
  self.text = nil
  self.line_content = nil
  self.goto_btn = nil
  self.btn_txt = nil
end

function UIActLotteryItemGetManualItem:DataDefine()
end

function UIActLotteryItemGetManualItem:DataDestroy()
end

function UIActLotteryItemGetManualItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActLotteryItemGetManualItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActLotteryItemGetManualItem:ReInit(activityId, data, index, totalNum)
  self.data = data
  self.index = index
  self.totalNum = totalNum
  local texturePath = string.format("Assets/Main/TextureEx/ActLottery/%s", self.data[1])
  self.img:LoadSprite(texturePath)
  self.img:SetNativeSize()
  local imgSize = self.img:GetSizeDelta()
  local imgH = imgSize.y
  self.img_content:SetPreferredHeight(imgH)
  self.img_content:SetMinHeight(imgH)
  if #self.data >= 2 then
    self.text:SetLocalText(self.data[2])
  else
    self.text:SetText("")
  end
  self.goto_btn:SetActive(#self.data >= 3)
  self.line_content:SetActive(self.index < self.totalNum)
  if #self.data >= 5 then
    self.btn_txt:SetLocalText(self.data[5])
  else
    self.btn_txt:SetLocalText("develop_guide_tip1")
  end
end

function UIActLotteryItemGetManualItem:OnClickGotoBtn()
  if self.data and #self.data >= 4 then
    local goType = tonumber(self.data[3]) or 0
    local goPara = tonumber(self.data[4]) or 0
    GoToUtil.GoToByTypeAndParam(goType, {goPara})
  end
end

return UIActLotteryItemGetManualItem
