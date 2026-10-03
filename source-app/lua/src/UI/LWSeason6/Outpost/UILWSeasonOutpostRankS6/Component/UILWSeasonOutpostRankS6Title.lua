local UILWSeasonOutpostRankS6Title = BaseClass("UILWSeasonOutpostRankS6Title", UIButton)
local base = UIButton
local hide_btn_path = "HideBtn"
local tip_path = "Tip"
local title_desc_path = "Tip/titleDesc"
local t1_path = "Tip/t1"
local title_icon1_path = "Tip/t1/titleIcon1"
local title_name1_path = "Tip/t1/titleName1"
local t2_path = "Tip/t2"
local title_icon2_path = "Tip/t2/titleIcon2"
local title_name2_path = "Tip/t2/titleName2"
local t3_path = "Tip/t3"
local title_icon3_path = "Tip/t3/titleIcon3"
local title_name3_path = "Tip/t3/titleName3"

function UILWSeasonOutpostRankS6Title:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.hide_btn:SetOnClick(function()
    self:SetActive(false)
  end)
end

function UILWSeasonOutpostRankS6Title:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostRankS6Title:ComponentDefine()
  self.hide_btn = self:AddComponent(UIButton, hide_btn_path)
  self.tip = self:AddComponent(UIImage, tip_path)
  self.title_desc = self:AddComponent(UITextMeshProUGUIEx, title_desc_path)
  self.t1 = self:AddComponent(UIImage, t1_path)
  self.title_icon1 = self:AddComponent(UIImage, title_icon1_path)
  self.title_name1 = self:AddComponent(UITextMeshProUGUIEx, title_name1_path)
  self.t2 = self:AddComponent(UIImage, t2_path)
  self.title_icon2 = self:AddComponent(UIImage, title_icon2_path)
  self.title_name2 = self:AddComponent(UITextMeshProUGUIEx, title_name2_path)
  self.t3 = self:AddComponent(UIImage, t3_path)
  self.title_icon3 = self:AddComponent(UIImage, title_icon3_path)
  self.title_name3 = self:AddComponent(UITextMeshProUGUIEx, title_name3_path)
end

function UILWSeasonOutpostRankS6Title:ComponentDestroy()
  self.hide_btn = nil
  self.tip = nil
  self.title_desc = nil
  self.t1 = nil
  self.title_icon1 = nil
  self.title_name1 = nil
  self.t2 = nil
  self.title_icon2 = nil
  self.title_name2 = nil
  self.t3 = nil
  self.title_icon3 = nil
  self.title_name3 = nil
end

function UILWSeasonOutpostRankS6Title:InitTitle(theId, title_root, title_icon, title_name)
  local titleData = LocalController:instance():tryGetLine(TableName.LW_TITLE, theId)
  if titleData == nil then
    title_root:SetActive(false)
  else
    title_root:SetActive(true)
    local iconPath = titleData.title_show_icon
    if string.IsNullOrEmpty(iconPath) then
      title_icon:SetActive(false)
    else
      title_icon:LoadSprite(iconPath)
      title_icon:SetActive(true)
    end
    title_name:SetLocalText(titleData.name)
  end
end

function UILWSeasonOutpostRankS6Title:ReInit()
  self:InitTitle(15022, self.t1, self.title_icon1, self.title_name1)
  self:InitTitle(15023, self.t2, self.title_icon2, self.title_name2)
  self:InitTitle(15024, self.t3, self.title_icon3, self.title_name3)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title_desc.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tip.rectTransform)
end

return UILWSeasonOutpostRankS6Title
