local UILWMummyHistoryItem = BaseClass("UILWMummyHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local bg_head_path = "BgHead"
local target_icon_path = "targetIcon"
local win_icon_path = "winIcon"
local title_txt_path = "TitleTxt"
local sub_title_txt_path = "SubTitleTxt"
local time_text_path = "TimeText"

function UILWMummyHistoryItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.bg_head = self:AddComponent(UIImage, bg_head_path)
  self.target_icon = self:AddComponent(UIImage, target_icon_path)
  self.win_icon = self:AddComponent(UIImage, win_icon_path)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.sub_title_txt = self:AddComponent(UIText, sub_title_txt_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
end

function UILWMummyHistoryItem:OnDestroy()
  self.bg = nil
  self.bg_head = nil
  self.target_icon = nil
  self.win_icon = nil
  self.title_txt = nil
  self.sub_title_txt = nil
  self.time_text = nil
  base.OnDestroy(self)
end

function UILWMummyHistoryItem:ReInit(index, data)
  local info = data.info
  self.time_text:SetText(UITimeManager:GetInstance():GetServerTimeByUTC(data.eventTime or 0, false))
  if info then
    if info.sourceType == 1 then
      self.target_icon:LoadSprite("Assets/Main/Sprites/UI/UILWMail/lrb_zhanbao_jingjichang.png")
      self.sub_title_txt:SetLocalText("season_s3_Mummy_record01", info.deathNum, info.changeNum)
    elseif info.sourceType == 2 then
      self.target_icon:LoadSprite("Assets/Main/Sprites/UI/UILWMail/zyf_youjian_yiyuan_icon.png")
      self.sub_title_txt:SetLocalText("season_s3_Mummy_record02", info.deathNum, info.changeNum)
    elseif info.sourceType == 3 then
      self.target_icon:LoadSprite("Assets/Main/Sprites/UI/UILWMail/lyp_jijieyoujian_wanjiacheng.png")
      self.sub_title_txt:SetLocalText("season_s3_Mummy_record03", info.deathNum, info.changeNum)
    end
  end
  self.win_icon:SetActive(false)
  self.title_txt:SetActive(false)
end

return UILWMummyHistoryItem
