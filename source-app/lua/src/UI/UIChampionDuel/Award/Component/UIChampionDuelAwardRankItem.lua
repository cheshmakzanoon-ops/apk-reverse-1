local UIChampionDuelAwardRankItem = BaseClass("UIChampionDuelAwardRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local text_title_path = "Title/titleText"
local layout2_path = "Bg2/Bg22/RewardScroll2/layout2"
local text_title2_path = "Bg2/Top2/titleText2"
local btn2_path = "Bg2/Di2/ReceiveBtn2"
local text_btn2_path = "Bg2/Di2/ReceiveBtn2/ReceiveBtnText2"
local sp_bg_path = "Bg2/SpBg"
local text_sp_tip_path = "Bg2/SpBg/TipText"
local head_frame_path = "Bg2/SpBg/HeadFrame/Head"
local emoji_bg_path = "Bg2/SpBg/EmojiBg"
local emoji_path = "Bg2/SpBg/EmojiBg/Emoji"
local layout3_path = "Bg3/Bg32/RewardScroll3/layout3"
local text_title3_path = "Bg3/Top3/titleText3"
local btn_info3_path = "Bg3/Top3/InfoBtn3"
local btn3_path = "Bg3/Di3/ReceiveBtn3"
local text_btn3_path = "Bg3/Di3/ReceiveBtn3/ReceiveBtnText3"

function UIChampionDuelAwardRankItem:OnCreate()
  base.OnCreate(self)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.layout2 = self:AddComponent(UIBaseContainer, layout2_path)
  self.text_title2 = self:AddComponent(UIText, text_title2_path)
  self.text_title2:SetLocalText("champion_duel_tips1041")
  self.btn2 = self:AddComponent(UIButton, btn2_path)
  self.btn2:SetOnClick(BindCallback(self, self.OnReceive2Click))
  self.text_btn2 = self:AddComponent(UIText, text_btn2_path)
  if self.transform:Find(sp_bg_path) then
    self.sp_bg = self:AddComponent(UIBaseComponent, sp_bg_path)
    self.sp_bg:SetSiblingIndex(0)
    self.text_sp_tip = self:AddComponent(UIText, text_sp_tip_path)
    self.head_frame = self:AddComponent(UIDecorationHeadFrame, head_frame_path)
    self.emoji_bg = self:AddComponent(UIImage, emoji_bg_path)
    self.emojiTrans = self.transform:Find(emoji_path)
  end
  self.layout3 = self:AddComponent(UIBaseContainer, layout3_path)
  self.text_title3 = self:AddComponent(UIText, text_title3_path)
  self.text_title3:SetLocalText("champion_duel_tips1042")
  self.btn_info3 = self:AddComponent(UIButton, btn_info3_path)
  self.btn_info3:SetOnClick(BindCallback(self, self.OnInfo3Click))
  self.btn3 = self:AddComponent(UIButton, btn3_path)
  self.btn3:SetOnClick(BindCallback(self, self.OnReceive3Click))
  self.text_btn3 = self:AddComponent(UIText, text_btn3_path)
  self.items2 = {}
  self.items3 = {}
end

function UIChampionDuelAwardRankItem:OnDestroy()
  self:ClearDelays(1)
  self:ClearDelays(2)
  if self.emojiObjKey then
    DataCenter.ChatEmojiTemplateManager:KillStickerByKey(self.emojiObjKey)
  end
  self.text_title = nil
  self.text_title2 = nil
  self.btn2 = nil
  self.text_btn2 = nil
  self.sp_bg = nil
  self.text_sp_tip = nil
  self.head_frame = nil
  self.emoji_bg = nil
  self.emojiTrans = nil
  self.text_title3 = nil
  self.btn_info3 = nil
  self.btn3 = nil
  self.text_btn3 = nil
  self.layout2:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.layout2.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.layout2 = nil
  self.layout3:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.layout3.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.layout3 = nil
  self.items2 = {}
  self.items3 = {}
  base.OnDestroy(self)
end

function UIChampionDuelAwardRankItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelRewardRefresh, self.UpdateData)
end

function UIChampionDuelAwardRankItem:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelRewardRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIChampionDuelAwardRankItem:OnInfo3Click()
  local strTip = Localization:GetString("champion_duel_tips1021")
  UIUtil.ShowBubbleTips(strTip, self.btn_info3.transform.position, 0, -30, 0)
end

function UIChampionDuelAwardRankItem:OnReceive2Click()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBtn2ClickTime ~= nil and curTime - self.lastBtn2ClickTime <= 1000 then
    return
  end
  self.lastBtn2ClickTime = curTime
  if self.info then
    DataCenter.ChampionDuelManager:ReqRewardGet(self.info.id, 0)
  end
end

function UIChampionDuelAwardRankItem:OnReceive3Click()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBtn3ClickTime ~= nil and curTime - self.lastBtn3ClickTime <= 1000 then
    return
  end
  self.lastBtn3ClickTime = curTime
  if self.info then
    DataCenter.ChampionDuelManager:ReqRewardGet(self.info.id, 1)
  end
end

function UIChampionDuelAwardRankItem:UpdateData(id)
  if id == nil or self.info == nil or self.info.id ~= id then
    return
  end
  self:ReInit(self.index, self.info, self.func)
end

function UIChampionDuelAwardRankItem:ReInit(index, info)
  self.info = info
  self.index = index
  local data = DataCenter.ChampionDuelManager:GetRewardInfo(info.id)
  local paras = string.split(info.para, ",")
  local rank1 = tonumber(paras[1]) or 1
  local rank2 = tonumber(paras[2]) or 1
  local rankStr = rank1 == rank2 and paras[1] or paras[1] .. "-" .. paras[2]
  local langKey = info.stage < 4 and "champion_duel_tips1011" or "champion_duel_tips1015"
  self.text_title:SetLocalText(langKey, rankStr)
  local state = data ~= nil and data.status or 0
  self.text_btn2:SetLocalText(state == 2 and "170003" or "170004")
  CS.UIGray.SetGray(self.btn2.transform, state ~= 1, state == 1)
  local spShow = info.stage == ChampionDuelState.KnockOut and rank1 == 1
  self:RefreshReward(info.rank_person, self.layout2, self.items2, 1)
  self:RefreshSpShow(info, rank1)
  state = data ~= nil and data.srStatus or 0
  if state == 2 then
    self.text_btn3:SetLocalText("170003")
  else
    local count = data ~= nil and data.srCount or 0
    if 0 < count then
      self.text_btn3:SetLocalText("champion_duel_tips1040", count)
    else
      self.text_btn3:SetLocalText("170004")
    end
  end
  CS.UIGray.SetGray(self.btn3.transform, state ~= 1, state == 1)
  self:RefreshReward(info.rank_alliance, self.layout3, self.items3, 2)
end

function UIChampionDuelAwardRankItem:ClearDelays(idx)
  local layout = idx == 1 and self.layout2 or self.layout3
  if layout then
    layout:RemoveComponents(UICommonResItem)
  end
  self.asyncs = self.asyncs or {}
  self.asyncs[idx] = self.asyncs[idx] or {}
  for _, v in pairs(self.asyncs[idx]) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self.asyncs[idx] = {}
end

function UIChampionDuelAwardRankItem:RefreshReward(rewards, content, items, idx)
  local rLen = rewards ~= nil and #rewards or 0
  local bHaveReward = 0 < rLen
  content:SetActive(bHaveReward)
  self:ClearDelays(idx)
  if not bHaveReward then
    return
  end
  local strFormat = string.format
  for i = 1, rLen do
    self.asyncs[idx][i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(content.transform)
      go.transform.localScale = Vector3.New(0.7, 0.7, 1)
      go.transform:Set_sizeDelta(100, 100)
      go.transform:Set_pivot(0, 1)
      local nameStr = strFormat("item_%d_%d", idx, i)
      go.name = nameStr
      local cell = content:AddComponent(UICommonResItem, nameStr)
      cell:SetActive(true)
      cell:ReInit(rewards[i])
      items[i] = cell
    end)
  end
end

function UIChampionDuelAwardRankItem:RefreshSpShow(info, rank)
  local active = self.sp_bg ~= nil and self.sp_bg:GetActive() or false
  local toActive = false
  if active and info.stage == ChampionDuelState.KnockOut and rank == 1 then
    toActive = true
    local rewards = DataCenter.ChampionDuelManager:GetChampionSpRewardsCfgId()
    if self.emojiObjKey == nil then
      local cfgId = rewards ~= nil and rewards.emojiId or nil
      if cfgId and 0 < cfgId then
        self.emojiObjKey = "UICD_AwardRankItem"
        DataCenter.ChatEmojiTemplateManager:ShowStickerByCfgId(self.emojiTrans, self.emojiObjKey, cfgId)
      end
    end
    local bubbleImg = rewards.bubbleImg or nil
    if bubbleImg then
      self.emoji_bg:LoadSpriteAuto(bubbleImg)
    end
    local frameImg = rewards.frameImg or nil
    if frameImg then
      self.head_frame:SetFrame(frameImg)
    end
    local list = DataCenter.ChampionDuelManager:GetFinalRankList()
    local teamInfo = list[1]
    if teamInfo then
      teamInfo:SetNameShow(self.text_sp_tip)
      self.head_frame:SetHead(teamInfo.uid, teamInfo.head, teamInfo.frame)
    else
      self.text_sp_tip:SetLocalText("champion_duel_tips1170")
      self.head_frame:UseSystemHead()
    end
  end
end

return UIChampionDuelAwardRankItem
