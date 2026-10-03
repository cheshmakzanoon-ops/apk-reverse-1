local UILeadingQuestWayItem = BaseClass("UILeadingQuestWayItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local desc_path = "desc"
local btn_goto_path = "btnGoto"
local txt_goto_path = "btnGoto/txtGoto"
local image_path = "Image"
local progress_path = "progressBg/progress"
local progress_text_path = "progressBg/progressText"
local recommend_path = "Image/recommend"

function UILeadingQuestWayItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILeadingQuestWayItem:OnDestroy()
  base.OnDestroy(self)
end

function UILeadingQuestWayItem:ComponentDefine()
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.btn_goto = self:AddComponent(UIButton, btn_goto_path)
  self.txt_goto = self:AddComponent(UITextMeshProUGUIEx, txt_goto_path)
  self.image = self:AddComponent(UIImage, image_path)
  self.progress = self:AddComponent(UIImage, progress_path)
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, progress_text_path)
  self.fg = self.progress.transform:GetComponent(UnityRectTransform)
  self.txt_goto:SetText(Localization:GetString("455017"))
  self.btn_goto:SetOnClick(function()
    self:OnGotoBtnClick()
  end)
  self.recommend = self:AddComponent(UIImage, recommend_path)
end

function UILeadingQuestWayItem:ComponentDestroy()
  self.desc = nil
  self.btn_goto = nil
  self.txt_goto = nil
  self.image = nil
  self.progress = nil
  self.progress_text = nil
  self.recommend = nil
end

function UILeadingQuestWayItem:OnAddListener()
  base.OnAddListener(self)
end

function UILeadingQuestWayItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILeadingQuestWayItem:SetData(type, power, recommendType)
  self.type = type
  self.power = power
  local recommend = recommendType == type
  self.recommend:SetActive(recommend)
  local icon = DataCenter.LWLeadingQuestV2Manager:GetWayIcon(type)
  if not string.IsNullOrEmpty(icon) then
    self.image:LoadSprite(icon)
  end
  local cur = DataCenter.LWLeadingQuestV2Manager:GetCurPower(type)
  local max = power
  local pro = 0
  if 0 < max then
    pro = cur / max
    self.fg:Set_sizeDelta(math.min(1, pro) * 476, 35)
  end
  pro = pro * 100
  pro = math.floor(pro)
  if cur >= max then
    self.progress_text:SetText("<color=#5fef87>" .. string.GetFormattedSeperatorNum(cur) .. "</color>" .. "/" .. string.GetFormattedSeperatorNum(max))
  else
    self.progress_text:SetText(string.GetFormattedSeperatorNum(cur) .. "/" .. string.GetFormattedSeperatorNum(max))
  end
  local descColor = "#099B4A"
  if pro < 30 then
    descColor = "#FF9000"
  elseif pro < 100 then
    descColor = "#FED40D"
  end
  local desc = DataCenter.LWLeadingQuestV2Manager:GetWayDesc(type)
  if not string.IsNullOrEmpty(desc) then
    local content = "<color=" .. descColor .. ">" .. pro .. "%</color>"
    self.desc:SetText(Localization:GetString(desc, content))
  end
end

function UILeadingQuestWayItem:OnGotoBtnClick()
  DataCenter.LWLeadingQuestV2Manager:GoTo(self.type)
end

return UILeadingQuestWayItem
