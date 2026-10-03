local UIServerBattleGloryView = BaseClass("UIServerBattleGloryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local UIGray = CS.UIGray
local close_path = "Close"
local title_path = "rewardPage/title"
local content_path = "rewardPage/StarContent"
local item_path = "rewardPage/UIPlayerHead"
local other_path = "rewardPage/other"
local player_name_path = "rewardPage/other/name"
local pt_text_path = "rewardPage/other/ptText"
local close_btn_path = "rewardPage/other/BtnGroup/CloseBtn"
local thumb_btn_path = "rewardPage/other/BtnGroup/ThumbBtn"
local heart_path = "rewardPage/other/heartBtn/heart"
local pop_anim_path = "rewardPage/other/heartBtn/heart/PopAnim"
local active_anim_path = "rewardPage/other/BtnGroup/ThumbBtn/ActiveAnim"
local gift_btn_path = "rewardPage/other/BtnGroup/giftBtn/btn"
local gift_btn_img_path = "rewardPage/other/BtnGroup/giftBtn/icon"
local giftIconPath = "Assets/Main/Sprites/UI/LWUIGiftSystem/lyt_lw_songli.png"

function UIServerBattleGloryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnDataInit()
  self:UpdateData()
end

function UIServerBattleGloryView:OnDataInit()
  self.giftEffectResList = {}
  self.timerList = {}
end

function UIServerBattleGloryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIServerBattleGloryView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIGridLayoutGroup, content_path)
  self.giftBtn = self:AddComponent(UIButton, gift_btn_path)
  self.giftBtnImg = self:AddComponent(UIButton, gift_btn_img_path)
  self.giftBtn:SetOnClick(function()
    self:OnGiftBtnClick()
  end)
  self.otherObject = self:AddComponent(UIBaseContainer, other_path)
  self.player_name = self:AddComponent(UITextMeshProUGUIEx, player_name_path)
  self.pt_text = self:AddComponent(UITextMeshProUGUIEx, pt_text_path)
  self.thumb_btn = self:AddComponent(UIButton, thumb_btn_path)
  self.effectPanet = self:AddComponent(UIBaseContainer, "effect")
  self.thumb_btn:SetOnClick(function()
    self:OnLikeBtnClick(self.Info)
  end)
  self.heart = self:AddComponent(UIImage, heart_path)
  self.heartBtn = self:AddComponent(UIButton, heart_path)
  self.heartBtn:SetOnClick(function()
    self:OnLikeBtnClick(self.Info)
  end)
  self.pop_anim_root = self:AddComponent(UICanvasGroup, pop_anim_path)
  self.heart_effect = self:AddComponent(UIBaseContainer, active_anim_path)
  self.eff_heart = self.transform:Find(active_anim_path):GetComponent(TypeParticleSystem)
  self.pop_anim_root:SetActive(false)
  self.heart_effect:SetActive(false)
  self.theHeartPopAnim = self.pop_anim_root.gameObject
  self.theHeartPopAnim:GameObjectCreatePool()
  self.panelType = GiftSystemConst.GiftSendPanelType.WarZone
  local isShow = DataCenter.GiftSystemManager:IsCanShowQuickBtn(self.panelType)
  if isShow then
    self.giftBtn:SetActive(true)
    self.giftBtnImg:LoadSpriteAsync(giftIconPath)
  else
    self.giftBtn:SetActive(false)
  end
end

function UIServerBattleGloryView:ComponentDestroy()
  if self.giftEffectResList then
    for _, v in pairs(self.giftEffectResList) do
      if v ~= nil then
        v:Destroy()
      end
    end
    self.giftEffectResList = nil
  end
  if self.timerList then
    for i, timer in pairs(self.timerList) do
      if timer then
        timer:Stop()
      end
    end
    self.timerList = nil
  end
  DataCenter.GiftEffectManager:RemoveCheerComponents(self.effectPanet)
  self.content:RemoveComponents(UICommonHead)
  self.theItem:GameObjectRecycleAll()
  self.theHeartPopAnim:GameObjectRecycleAll()
end

function UIServerBattleGloryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnReceiveGiftList, self.OnGiftListAnim)
end

function UIServerBattleGloryView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnReceiveGiftList, self.OnGiftListAnim)
  base.OnRemoveListener(self)
end

function UIServerBattleGloryView:OnGiftListAnim(param)
  if not param or param.openType ~= GiftSystemConst.GiftSendPanelType.WarZone then
    return
  end
  local playList = {}
  local giftList = param.giveInfo
  for _, info in ipairs(giftList) do
    for i = 1, info.number do
      table.insert(playList, {
        giftId = info.itemId,
        playerUid = info.suid
      })
    end
  end
  for index, data in ipairs(playList) do
    local delay = index * 0.5
    local timer = TimerManager:GetInstance():DelayInvoke(function()
      local showParam = {
        effectInfo = data,
        parent = self.effectPanet
      }
      local res = DataCenter.GiftEffectManager:AddCheerEffect(showParam)
      table.insert(self.giftEffectResList, res)
    end, delay)
    table.insert(self.timerList, timer)
  end
end

function UIServerBattleGloryView:OnGiftBtnClick()
  local playerUId = self.Info.uid
  local param = {
    playerUid = playerUId,
    serverId = self.Info.serverId,
    dirType = GiftSystemConst.GiftSendPanelDirection.Up,
    openType = self.panelType,
    target = self.giftBtn,
    showItemAnim = true,
    clickAnim = true
  }
  DataCenter.GiftSystemManager:ShowQuick(param)
end

function UIServerBattleGloryView:UpdateData(hasThumbsUp)
  local info, title = self:GetUserData()
  self.Info = info
  if not info then
    self.ctrl:CloseSelf()
    return
  end
  local isShow = DataCenter.GiftSystemManager:IsCanShowQuickBtn(self.panelType)
  if self.Info.uid and not hasThumbsUp and isShow then
    DataCenter.GiftSystemManager:GetPanelGift(self.Info.uid, GiftSystemConst.GiftSendPanelType.WarZone)
  end
  self.title:SetText(Localization:GetString(title or "zone_war_ui_tittle01"))
  self:RefreshWithOther(info, hasThumbsUp)
end

function UIServerBattleGloryView:RefreshWithOther(info, hasThumbsUp)
  self.hasThumbsUp = hasThumbsUp
  self.content:RemoveComponents(UICommonHead)
  self.theItem:GameObjectRecycleAll()
  self.otherObject:SetActive(true)
  self.player_name:SetText(UIUtil.FormatAllianceAndName(info.abbr, info.name))
  self.player_name:SetActive(true)
  self.pt_text:SetText("+" .. string.GetFormattedSeparatorNum(info.score) .. "pt")
  local goItem = self.theItem:GameObjectSpawn(self.content.transform)
  goItem.name = "item_self"
  goItem:SetActive(true)
  local theItem = self.content:AddComponent(UICommonHead, goItem.name)
  theItem:ParseHeadInfo(info)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.otherObject.transform)
  if not hasThumbsUp and info.uid ~= LuaEntry.Player.uid and InteractiveUtil.CanThumbsUp(InteractiveUtil.ThumbsUpType.ServerBattle) then
    self.thumb_btn:SetInteractable(true)
    UIGray.SetGray(self.thumb_btn.transform, false, true)
  else
    self.thumb_btn:SetInteractable(false)
    UIGray.SetGray(self.thumb_btn.transform, true, false)
  end
end

function UIServerBattleGloryView:OnLikeBtnClick(info)
  if not info or self.hasThumbsUp then
    return
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  InteractiveUtil.TryThumbsUp(info.uid, InteractiveUtil.ThumbsUpType.ServerBattle, "ServerBattleGlory", function()
    self:UpdateData(true)
    self.heart_effect:SetActive(true)
    self.eff_heart:Play()
    local effectItem = self.theHeartPopAnim:GameObjectSpawn(self.heart.transform)
    local unity_canvas_group = effectItem.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    if unity_canvas_group then
      effectItem.name = "Count" .. 1
      effectItem:SetActive(true)
      unity_canvas_group.alpha = 1
      unity_canvas_group:DOFade(0, 0.75)
      local sequence = CS.DG.Tweening.DOTween.Sequence()
      sequence:Join(effectItem.transform:DOLocalMove(Vector3.New(0, 50, 0), 0.75):SetEase(CS.DG.Tweening.Ease.OutCirc))
      sequence:AppendCallback(function()
        effectItem:GameObjectRecycle()
        self.eff_heart:Stop()
        self.heart_effect:SetActive(false)
      end)
    else
      effectItem:GameObjectRecycle()
    end
  end)
end

return UIServerBattleGloryView
