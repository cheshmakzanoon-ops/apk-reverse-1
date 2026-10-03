local UICD_FinalTopThree = BaseClass("UICD_FinalTopThree", UIAsyncContainer)
local base = UIAsyncContainer
local UIChampionDuelMainCity = require("UI.UIChampionDuel.Component.UIChampionDuelMainCity")
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local mainCity_path = "First/MainCity"
local base_path = {
  "First",
  "Second",
  "Third"
}
local text_server_path = {
  "First/MainCity/HeadFrame/ServerFirstText",
  "Second/ServerSecondText",
  "Third/ServerThirdText"
}
local text_name_path = {
  "First/Bar/NameFirstText",
  "Second/NameSecondText",
  "Third/NameThirdText"
}
local head_frame_path = {
  "First/MainCity/HeadFrame",
  "Second/HeadSecond",
  "Third/HeadThird"
}
local head_btn_path = {
  "First/MainCity/HeadFrame/Head/BtnFirst",
  "Second/HeadSecond/BtnSecond",
  "Third/HeadThird/BtnThird"
}
local praise_btn_path = {
  "First/MainCity/HeadFrame/PraiseBtnFirst",
  "Second/PraiseBtnSecond",
  "Third/PraiseBtnThird"
}
local emoji_bg_path = "First/EmojiBg"
local emoji_path = "First/EmojiBg/Emoji"

function UICD_FinalTopThree:OnCreate()
  base.OnCreate(self)
  self.mainCity = self:AddComponent(UIChampionDuelMainCity, mainCity_path)
  self.mainCity:SetActive(false)
  self.base_content = {}
  self.text_servers = {}
  self.text_names = {}
  self.head_frames = {}
  self.btn_heads = {}
  self.btn_praises = {}
  for i = 1, 3 do
    self.base_content[i] = self:AddComponent(UIBaseContainer, base_path[i])
    self.text_servers[i] = self:AddComponent(UIText, text_server_path[i])
    self.text_names[i] = self:AddComponent(UIText, text_name_path[i])
    self.btn_heads[i] = self:AddComponent(UIButton, head_btn_path[i])
    self.btn_heads[i]:SetOnClick(function()
      self:OnHeadBtnClick(i)
    end)
    self.btn_praises[i] = self:AddComponent(UIButton, praise_btn_path[i])
    self.btn_praises[i]:SetOnClick(function()
      self:OnPraiseBtnClick(i)
    end)
    if i == 1 then
      self.head_frames[i] = self.transform:Find(head_frame_path[i])
    else
      self.head_frames[i] = self:AddComponent(UIDecorationHeadFrame, head_frame_path[i])
    end
  end
  self.emoji_bg = self:AddComponent(UIBaseComponent, emoji_bg_path)
  self.emojiTrans = self.transform:Find(emoji_path)
end

function UICD_FinalTopThree:OnDestroy()
  self.preEmojiObjKey = nil
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  if self.emojiObjKey then
    DataCenter.ChatEmojiTemplateManager:KillStickerByKey(self.emojiObjKey)
  end
  self.emojiTrans = nil
  self.emoji_bg = nil
  self.mainCity = nil
  self.list = nil
  self.base_content = {}
  self.text_servers = {}
  self.text_names = {}
  self.head_frames = {}
  self.btn_heads = {}
  base.OnDestroy(self)
end

function UICD_FinalTopThree:OnHeadBtnClick(idx)
  local info = self.list ~= nil and self.list[idx] or nil
  if info == nil then
    return
  end
  info:OnHeadClick()
end

function UICD_FinalTopThree:OnPraiseBtnClick(idx)
  local info = self.list ~= nil and self.list[idx] or nil
  if info == nil then
    return
  end
  info:OnPraiseClick()
end

function UICD_FinalTopThree:SetData(emojiObjKey)
  self.preEmojiObjKey = emojiObjKey
  self:RefreshView()
end

function UICD_FinalTopThree:UpdateData()
  if self.preEmojiObjKey == nil then
    return
  end
  local list = DataCenter.ChampionDuelManager:GetFinalRankList()
  self.list = list
  for i = 1, 3 do
    local info = list[i]
    self.base_content[i]:SetActive(info ~= nil)
    if info ~= nil then
      if i == 1 then
        self.mainCity:SetActive(true)
        self.mainCity:ReInitWithInfo(info, nil, true, true)
      end
      self.text_servers[i]:SetText("#" .. info.server)
      info:SetNameShow(self.text_names[i])
      if i == 1 then
        local scale = self.mainCity:GetLocalScaleXYZ()
        self.head_frames[i].localScale = Vector3.New(1 / scale, 1 / scale, 1 / scale)
      else
        info:SetFrameShow(self.head_frames[i])
      end
    end
  end
  if self.timer then
    self.timer:Stop()
  end
  self.timer = TimerManager:GetInstance():DelayFrameInvoke(function()
    if self.timer then
      self.timer:Stop()
    end
    self.timer = nil
    local rewards = DataCenter.ChampionDuelManager:GetChampionSpRewardsCfgId()
    local cfgId = rewards ~= nil and rewards.emojiId or nil
    if cfgId and 0 < cfgId then
      self.emoji_bg:SetActive(true)
      if not self.emojiObjKey then
        self.emojiObjKey = self.preEmojiObjKey
        DataCenter.ChatEmojiTemplateManager:ShowStickerByCfgId(self.emojiTrans, self.emojiObjKey, cfgId)
      end
    else
      self.emoji_bg:SetActive(false)
    end
  end, 5)
end

return UICD_FinalTopThree
