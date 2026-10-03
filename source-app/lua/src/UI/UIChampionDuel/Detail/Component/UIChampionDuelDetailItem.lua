local UIChampionDuelDetailItem = BaseClass("UIChampionDuelDetailItem", UIBaseContainer)
local base = UIBaseContainer
local text_title_path = "Ani/Title"
local text_desc_path = "Ani/Desc"
local btn_info_path = "Ani/InfoBtn"
local bg_path = "Ani/bg"
local index_bg_path = "Ani/indexBg"
local index_txt_path = "Ani/indexBg/indexTxt"

function UIChampionDuelDetailItem:OnCreate()
  base.OnCreate(self)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_desc = self:AddComponent(UIText, text_desc_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnInfoClick))
  self.bg = self:AddComponent(UIImage, bg_path)
  self.index_bg = self:AddComponent(UIImage, index_bg_path)
  self.index_txt = self:AddComponent(UIText, index_txt_path)
end

function UIChampionDuelDetailItem:OnDestroy()
  self.text_title = nil
  self.text_desc = nil
  self.btn_info = nil
  self.bg = nil
  self.index_bg = nil
  self.index_txt = nil
  base.OnDestroy(self)
end

function UIChampionDuelDetailItem:OnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelDetailInfo, {anim = true}, self.index)
end

function UIChampionDuelDetailItem:SetData(guideData, beginTime, curIndex)
  self.guideData = guideData
  self.curIndex = curIndex
  local index = guideData.order
  self.index = index
  self.index_txt:SetText(index)
  if curIndex < index then
    self.bg:LoadSpriteAuto("Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_list02.png")
    self.index_bg:LoadSpriteAuto("Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_icon02.png")
  else
    self.bg:LoadSpriteAuto("Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_list01.png")
    self.index_bg:LoadSpriteAuto("Assets/Main/Sprites/UI/ActSlotMachine/Mjc_huodong_laba_xianshimubiao_icon01.png")
  end
  self.text_desc:SetLocalText(guideData.desc)
  local sTime, eTime = DataCenter.ChampionDuelManager:GetStageTime(index, beginTime)
  self.text_title:SetText(self:GetTimeToMD(sTime) .. "~" .. self:GetTimeToMD(eTime))
  local pageList = DataCenter.ChampionDuelManager:GetTemplateGuideByPage(index)
  self.btn_info:SetActive(not table.IsNullOrEmpty(pageList))
end

function UIChampionDuelDetailItem:GetTimeToMD(second)
  local format = UITimeManager:GetInstance():TimeSecToServerDate(second)
  local format_time = string.format("%0d/%0d", format.month, format.day)
  return format_time
end

return UIChampionDuelDetailItem
