local LWUITranslationRatingView = BaseClass("LWUITranslationRatingView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIStartCell = require("UI.UIFiveStarGet.Component.UIStarCell")
local title_text_path = "Root/titleText"
local des_text_path = "Root/DesText"
local close_btn_path = "Root/CloseBtn"
local confirm_btn_path = "Root/ConfirmBtn"
local star_item_path = "Root/StarItemRender"
local star_item_content_path = "Root/StarContent"
local res_count_text_path = "Root/ResourceCell/ResourceNum"
local confirm_btn_img_path = "Root/ConfirmBtn"
local bg_mask_btn_path = "panel"

function LWUITranslationRatingView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.mailType, self.mailUid = self:GetUserData()
  self:ReInit()
end

function LWUITranslationRatingView:OnDestroy()
  self:ComponentDestroy()
  self.starCellList = nil
  base.OnDestroy(self)
end

function LWUITranslationRatingView:ComponentDefine()
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.res_count_text = self:AddComponent(UIText, res_count_text_path)
  self.confirm_btn_img = self:AddComponent(UIImage, confirm_btn_img_path)
  self.ba_mask_btn = self:AddComponent(UIButton, bg_mask_btn_path)
  self.ba_mask_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn:SetOnClick(function()
    if self.curSetStarCount == 0 then
      UIUtil.ShowTipsId("TranslationRate_tip_10001")
    else
      SFSNetwork.SendMessage(MsgDefines.TranslateMark, self.mailUid, self.curSetStarCount)
      self.ctrl:CloseSelf()
    end
  end)
  self.starItem = self.transform:Find(star_item_path).gameObject
  self.starItem:GameObjectCreatePool()
  self.starItem_content = self:AddComponent(UIBaseContainer, star_item_content_path)
end

function LWUITranslationRatingView:ComponentDestroy()
  self.title_text = nil
  self.des_text = nil
  self.res_count_text = nil
  self.confirm_btn_img = nil
  self.ba_mask_btn = nil
  self.close_btn = nil
  self.confirm_btn = nil
  self.starItem_content:RemoveComponents(UIStartCell)
  self.starItem_content = nil
  self.starItem:GameObjectRecycleAll()
  self.starItem = nil
end

function LWUITranslationRatingView:ReInit()
  self.starCellList = {}
  self.curSetStarCount = 0
  local languageId = SuportedLanguagesLocalName[Localization:GetLanguage()]
  if self.mailType == MailType.TranslationRating then
    self.title_text:SetText(Localization:GetString("TranslationRate_title_10001", Localization:GetString(languageId)))
    self.des_text:SetText(Localization:GetString("TranslationRate_content_10001", Localization:GetString(languageId)))
  elseif self.mailType == MailType.Automatic_TranslationRating then
    self.title_text:SetText(Localization:GetString("TranslationRate_title_10002", Localization:GetString(languageId)))
    self.des_text:SetText(Localization:GetString("TranslationRate_content_10002", Localization:GetString(languageId)))
  end
  local giveRewardNum = LuaEntry.DataConfig:TryGetNum("fanyi_pingfen", "k2")
  self.res_count_text:SetText("X" .. tostring(giveRewardNum))
  for i = 1, 5 do
    local goItem = self.starItem:GameObjectSpawn(self.starItem_content.transform)
    goItem.name = "item" .. i
    goItem:SetActive(true)
    local starCell = self.starItem_content:AddComponent(UIStartCell, goItem.name)
    starCell:InitData(i)
    table.insert(self.starCellList, starCell)
  end
  self:OnStartClick(0)
end

function LWUITranslationRatingView:OnStartClick(index)
  self.curSetStarCount = index
  if self.curSetStarCount == 0 then
    CS.UIGray.SetGray(self.confirm_btn_img.transform, true, true)
  else
    CS.UIGray.SetGray(self.confirm_btn_img.transform, false, true)
  end
  for i = 1, #self.starCellList do
    self.starCellList[i]:IconSetActive(i <= self.curSetStarCount)
  end
end

return LWUITranslationRatingView
