local base = UIBaseContainer
local UIEBR_MvpItem = BaseClass("UIEBR_MvpItem", base)
local QuickGiftBtnCom = require("UI.LWPlayerInfo.UILWGiftSystem.Common.QuickGiftBtnCom")

function UIEBR_MvpItem:OnCreate()
  base.OnCreate(self)
  self.img_top = self:AddComponent(UIImage, "ImgBg/ImgTop")
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, "ImgBg/TitleText")
  self.player = self:AddComponent(UICommonHead, "Head/UIPlayerHead")
  self.player:SetEnableClickShowInfo(true, true)
  self.text_name = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self.text_lv = self:AddComponent(UITextMeshProUGUIEx, "LvText")
  self.text_score = self:AddComponent(UITextMeshProUGUIEx, "ScoreText")
  self.icon_score = self:AddComponent(UIImage, "ScoreText/icon")
  self.giftSendCom = self:AddComponent(QuickGiftBtnCom, "giftSendCom")
end

function UIEBR_MvpItem:OnDestroy()
  self.img_top = nil
  self.text_title = nil
  self.player = nil
  self.text_name = nil
  self.text_lv = nil
  self.text_score = nil
  self.icon_score = nil
  base.OnDestroy(self)
end

function UIEBR_MvpItem:SetData(mvp)
  local mvpType = mvp ~= nil and mvp.type or 0
  local key, score_path
  if mvpType == 1 then
    key = "YiBianJinQu_battle_result_tips_6"
    score_path = "zyf_yibianzhanchang_icon_zongjifen.png"
  elseif mvpType == 2 then
    key = "YiBianJinQu_battle_result_tips_7"
    score_path = "zyf_yibianzhanchang_icon_gongji.png"
  elseif mvpType == 3 then
    key = "YiBianJinQu_battle_result_tips_8"
    score_path = "zyf_yibianzhanchang_icon_xiezhu.png"
  elseif mvpType == 4 then
    key = "YiBianJinQu_battle_result_tips_9"
    score_path = "zyf_yibianzhanchang_icon_zhanlue.png"
  end
  local tbName = DataCenter.ActEpidemicZoneManager:GetCfgValue(BattleFieldTableKey.STAR)
  local line = LocalController:instance():getLine(tbName, mvpType)
  local topPath = line ~= nil and line:getValue("icon") or nil
  if not string.IsNullOrEmpty(topPath) then
    self.img_top:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldMvpPath, topPath), function()
      if self.img_top then
        self.img_top:SetNativeSize()
      end
    end)
    self.img_top:SetActive(true)
  else
    self.img_top:SetActive(false)
  end
  if key then
    self.text_title:SetLocalText(key)
  end
  if score_path then
    self.icon_score:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicPath, score_path))
  end
  if mvp then
    self.player:SetData(mvp.uid, mvp.pic, mvp.picVer)
    local name = UIUtil.FormatAllianceAndName(mvp.abbr, mvp.name, mvp.uid)
    self.text_name:SetText(name)
    self.text_lv:SetLocalText(140002, mvp.lv)
    self.text_score:SetText(string.GetFormattedSeparatorNum(mvp.score))
    self.giftSendCom:ReInit(mvp.uid, GiftSystemConst.GiftSendPanelType.Canyon)
  end
end

return UIEBR_MvpItem
