local UIChampionDuelDonateMsgItem = BaseClass("UIChampionDuelDonateMsgItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local blackColor = Color.New(0.16862745098039217, 0.1607843137254902, 0.18823529411764706, 1)
local whiteColor = Color.New(1.0, 1.0, 1.0, 1)
local root_path = "root"
local bg_path = "root/bg"
local u_i_player_head_path = "root/UIPlayerHead"
local player_name_text_path = "root/GenderNameGroup/PlayerNameText"
local rank_content_path = "root/rankContent"
local rank_txt_path = "root/rankContent/rankTxt"
local ranking_bg_path = "root/rankContent/RankingBg"
local ranking_text_path = "root/rankContent/RankingBg/RankingText"
local normal_ranking_text_path = "root/rankContent/NormalRankingText"
local text_path = "root/msgTxtContent/Text"
local btnTranslateFinish_path = "root/msgTxtContent/TranslateFinishBtn"
local btnTranslate_path = "root/msgTxtContent/TranslateBtn"
local btnInfo_path = "root/msgTxtContent/InfoBtn"
local randomWordKey = {
  "champion_duel_tips1068",
  "champion_duel_tips1069",
  "champion_duel_tips1070"
}

function UIChampionDuelDonateMsgItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChampionDuelDonateMsgItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelDonateMsgItem:ComponentDefine()
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.rank_content = self:AddComponent(UIImage, rank_content_path)
  self.rank_txt = self:AddComponent(UITextMeshProUGUIEx, rank_txt_path)
  self.ranking_bg = self:AddComponent(UIImage, ranking_bg_path)
  self.ranking_text = self:AddComponent(UITextMeshProUGUIEx, ranking_text_path)
  self.normal_ranking_text = self:AddComponent(UITextMeshProUGUIEx, normal_ranking_text_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.btnTranslateFinish = self:AddComponent(UIButton, btnTranslateFinish_path)
  self.btnTranslateFinish:SetOnClick(function()
    self:OnBtnTranslateFinishClick()
  end)
  self.btnTranslate = self:AddComponent(UIButton, btnTranslate_path)
  self.btnTranslate:SetOnClick(function()
    self:OnBtnTranslateClick()
  end)
  self.btnInfo = self:AddComponent(UIButton, btnInfo_path)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
end

function UIChampionDuelDonateMsgItem:ComponentDestroy()
  self:CleanPlay()
  self.anim = nil
  self.root = nil
  self.bg = nil
  self.u_i_player_head = nil
  self.player_name_text = nil
  self.rank_content = nil
  self.rank_txt = nil
  self.ranking_bg = nil
  self.ranking_text = nil
  self.normal_ranking_text = nil
  self.text = nil
  self.btnTranslateFinish = nil
  self.btnTranslate = nil
  self.btnInfo = nil
end

function UIChampionDuelDonateMsgItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelBattleTranslateFinish, self.OnTranslateBack)
end

function UIChampionDuelDonateMsgItem:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelBattleTranslateFinish, self.OnTranslateBack)
  base.OnRemoveListener(self)
end

function UIChampionDuelDonateMsgItem:OnBtnTranslateFinishClick()
  if self.data == nil or not self.btnInfo:GetActive() then
    return
  end
  local msg = self.data:GetMessage()
  self.text:SetText(msg)
  self.btnTranslateFinish:SetActive(false)
  self.btnTranslate:SetActive(true)
end

function UIChampionDuelDonateMsgItem:OnBtnTranslateClick()
  if self.data == nil or not self.btnInfo:GetActive() then
    return
  end
  local transMsg = self.data.translateMsg
  if string.IsNullOrEmpty(transMsg) then
    self.data:SetIsTranslating(true)
    local translateManager = DataCenter.MailDataManager.Translate
    translateManager:Translate(self.data, translateManager.TranslateEnum.ChampionDuel)
    self.text:SetLocalText(120039)
  else
    self.text:SetText(transMsg)
  end
  self.btnTranslateFinish:SetActive(true)
  self.btnTranslate:SetActive(false)
end

function UIChampionDuelDonateMsgItem:OnBtnInfoClick()
  if self.data == nil or self.data.uid == LuaEntry.Player:GetUid() then
    return
  end
  local wordStr = self.data.word
  if string.IsNullOrEmpty(wordStr) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
    type = ReportType.championDuel,
    uid = self.data.uid,
    name = self.data.name,
    msg = wordStr
  })
end

function UIChampionDuelDonateMsgItem:OnTranslateBack(data)
  if not (self.data ~= nil and data ~= nil and self.btnInfo:GetActive()) or self.data.uid ~= data.uid then
    return
  end
  if not self.btnTranslateFinish:GetActive() then
    return
  end
  if string.IsNullOrEmpty(data.translateMsg) then
    self.text:SetText(data.word)
    self.btnTranslateFinish:SetActive(false)
    self.btnTranslate:SetActive(true)
  else
    self.text:SetText(data.translateMsg)
    self.btnTranslateFinish:SetActive(true)
    self.btnTranslate:SetActive(false)
  end
end

function UIChampionDuelDonateMsgItem:ReInit(data)
  self.data = data
  local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET)
  self.u_i_player_head:SetData(data.uid, data.pic, data.picVer, nil, headFrame)
  self.u_i_player_head:SetEnableClickShowInfo(true, true)
  local playerName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, data.name)
  if not string.IsNullOrEmpty(data.allianceName) then
    playerName = "[" .. data.allianceName .. "]" .. playerName
  end
  self.player_name_text:SetText(playerName)
  if not string.IsNullOrEmpty(data.word) then
    self.text:SetText(data.word)
    self.btnTranslateFinish:SetActive(false)
    self.btnTranslate:SetActive(true)
    self.btnInfo:SetActive(true)
  else
    self.btnTranslateFinish:SetActive(false)
    self.btnTranslate:SetActive(false)
    self.btnInfo:SetActive(false)
    local randomWord = randomWordKey[math.random(1, #randomWordKey)]
    self.text:SetText(Localization:GetString(randomWord))
  end
  if data.groupId and data.groupId > 0 then
    self.rank_txt:SetText(Localization:GetString("champion_duel_tips1022", DataCenter.ChampionDuelManager:GetGroupLetter(data.groupId)))
  else
    self.rank_txt:SetText(Localization:GetString("champion_duel_tips1051", data.server))
  end
  self.player_name_text:SetColor(blackColor)
  if data.rank == 1 then
    self.bg:SetActive(true)
    self.rank_content:SetActive(true)
    self.ranking_bg:SetActive(true)
    self.normal_ranking_text:SetActive(false)
    self.ranking_text:SetText(data.rank)
    self.bg:LoadSpriteAuto(string.format(LoadPath.UIChampionDuelSpritePath, "lrb_guanjunduijue_quanminkuanghuan_1bg00"))
    self.rank_content:LoadSpriteAuto(string.format(LoadPath.UIChampionDuelSpritePath, "lrb_guanjunduijue_quanminkuanghuan_paihang01"))
    self.ranking_bg:LoadSpriteAuto(string.format(LoadPath.UIChampionDuelSpritePath, "lrb_zhengduosai_paiming01.png"))
  elseif data.rank == 2 then
    self.bg:SetActive(true)
    self.rank_content:SetActive(true)
    self.ranking_bg:SetActive(true)
    self.normal_ranking_text:SetActive(false)
    self.ranking_text:SetText(data.rank)
    self.bg:LoadSpriteAuto(string.format(LoadPath.UIChampionDuelSpritePath, "lrb_guanjunduijue_quanminkuanghuan_2bg00"))
    self.rank_content:LoadSpriteAuto(string.format(LoadPath.UIChampionDuelSpritePath, "lrb_guanjunduijue_quanminkuanghuan_paihang02"))
    self.ranking_bg:LoadSpriteAuto(string.format(LoadPath.UIChampionDuelSpritePath, "lrb_zhengduosai_paiming02.png"))
  elseif data.rank >= 3 and data.rank <= 20 then
    self.bg:SetActive(true)
    self.rank_content:SetActive(true)
    self.ranking_bg:SetActive(true)
    self.normal_ranking_text:SetActive(false)
    self.ranking_text:SetText(data.rank)
    self.bg:LoadSpriteAuto(string.format(LoadPath.UIChampionDuelSpritePath, "lrb_guanjunduijue_quanminkuanghuan_3bg00"))
    self.rank_content:LoadSpriteAuto(string.format(LoadPath.UIChampionDuelSpritePath, "lrb_guanjunduijue_quanminkuanghuan_paihang03"))
    self.ranking_bg:LoadSpriteAuto(string.format(LoadPath.UIChampionDuelSpritePath, "lrb_zhengduosai_paiming03.png"))
  else
    self.bg:SetActive(false)
    self.rank_content:SetActive(false)
    self.player_name_text:SetColor(whiteColor)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.rectTransform)
  local rootSize = self.root:GetSizeDelta()
  local selfSize = self:GetSizeDelta()
  self:SetSizeDeltaXY(selfSize.x, rootSize.y)
  self:CleanPlay()
end

function UIChampionDuelDonateMsgItem:CleanPlay()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self.anim:Enable(false)
end

function UIChampionDuelDonateMsgItem:StartPlay(cbF, cbE, bFirst)
  self.root:SetActive(false)
  self:RunAnim(1, function()
    if cbF then
      cbF()
    end
    self:RunAnim(2, function()
      self:RunAnim(3, function()
        self:RunAnim(4, function()
          if cbE then
            cbE()
          end
        end)
      end)
    end)
  end, bFirst)
end

function UIChampionDuelDonateMsgItem:RunAnim(step, cb, bFirst)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  local animName
  if step == 1 then
    if CommonUtil.IsArabicAutoMirrorOpen() then
      animName = "Eff_UIChampionDuelMsgShowArabic"
    else
      animName = "Eff_UIChampionDuelMsgShow"
    end
  elseif step == 2 then
    if CommonUtil.IsArabicAutoMirrorOpen() then
      animName = "Eff_UIChampionDuelMsgScale90Arabic"
    else
      animName = "Eff_UIChampionDuelMsgScale90"
    end
  elseif step == 3 then
    if CommonUtil.IsArabicAutoMirrorOpen() then
      animName = "Eff_UIChampionDuelMsgScale80Arabic"
    else
      animName = "Eff_UIChampionDuelMsgScale80"
    end
  elseif step == 4 then
    if CommonUtil.IsArabicAutoMirrorOpen() then
      animName = "Eff_UIChampionDuelMsgScale70Arabic"
    else
      animName = "Eff_UIChampionDuelMsgScale70"
    end
  end
  if animName == nil then
    return
  end
  if bFirst then
    self:PlayAnim(animName, cb)
    return
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self:PlayAnim(animName, cb)
  end, 2)
end

function UIChampionDuelDonateMsgItem:PlayAnim(animName, cb)
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self.root:SetActive(true)
  self.anim:Enable(true)
  local ret, time = self.anim:GetAnimationReturnTime(animName)
  self.anim:Play(animName, 0, 0)
  if ret then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.timer then
        self.timer:Stop()
      end
      self.timer = nil
      self.anim:Enable(false)
      if cb then
        cb()
      end
    end, time)
  end
end

return UIChampionDuelDonateMsgItem
