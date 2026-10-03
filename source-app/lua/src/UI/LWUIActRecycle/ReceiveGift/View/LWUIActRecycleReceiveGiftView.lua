local LWUIActRecycleReceiveGiftView = BaseClass("LWUIActRecycleReceiveGiftView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIActRecycleReceiveGiftPlayerItemComponent = require("UI.LWUIActRecycle.ReceiveGift.Component.LWUIActRecycleReceiveGiftPlayerItemComponent")
local LWUIActRecycleReceiveGiftFloatItemComponent = require("UI.LWUIActRecycle.ReceiveGift.Component.LWUIActRecycleReceiveGiftFloatItemComponent")
local MAX_LIKE_COUNT = 40
local MAX_PLAYER_TEXT_COUNT = 10

function LWUIActRecycleReceiveGiftView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function LWUIActRecycleReceiveGiftView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleReceiveGiftView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.scrollViewPlayerScroll = self.viewSkin:AddComponent(self, UIScrollView, 3)
  self.scrollViewItemScroll = self.viewSkin:AddComponent(self, UIScrollView, 4)
  self.textPlayerText01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textPlayerText02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnGreat = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnGreat:SetOnClick(function()
    self:OnBtnGreatClick()
  end)
  self.textGreatBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compLayout = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.btnLike = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnLike:SetOnClick(function()
    self:OnBtnLikeClick()
  end)
  self.textLike = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compFloatLikeItem = self.viewSkin:AddComponent(self, LWUIActRecycleReceiveGiftFloatItemComponent, 12)
  self.compFloatItemRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.textFloatItem = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textTitle:SetLocalText("activity_99165_gift_1")
  self.textLike:SetLocalText("activity_99165_gift_4_btn")
  self.textGreatBtn:SetLocalText("activity_99165_gift_5_btn")
  self.scrollViewItemScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateItemCell(itemObj, index)
  end)
  self.scrollViewItemScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteItemCell(itemObj, index)
  end)
  self.scrollViewPlayerScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreatePlayerCell(itemObj, index)
  end)
  self.scrollViewPlayerScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeletePlayerCell(itemObj, index)
  end)
  self.templateFloatItem = self.compFloatLikeItem.gameObject
  self.templateFloatItem:GameObjectCreatePool()
end

function LWUIActRecycleReceiveGiftView:ComponentDestroy()
  self:ClearItems()
  self:ClearPlayers()
  if IsNotNull(self.templateFloatItem) then
    self.templateFloatItem:GameObjectRecycleAll()
    self.templateFloatItem = nil
  end
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.scrollViewPlayerScroll = nil
  self.scrollViewItemScroll = nil
  self.textPlayerText01 = nil
  self.textPlayerText02 = nil
  self.btnGreat = nil
  self.textGreatBtn = nil
  self.compLayout = nil
  self.btnLike = nil
  self.textLike = nil
  self.compFloatLikeItem = nil
  self.compFloatItemRoot = nil
  self.compUIPlayerHead = nil
  self.textFloatItem = nil
end

function LWUIActRecycleReceiveGiftView:DataDefine()
  self.msgData = nil
  self.showRewards = {}
  self.showPlayers = {}
  self.floatItemCount = 0
  self.delayMoveItemScrollTimer = nil
end

function LWUIActRecycleReceiveGiftView:DataDestroy()
  if self.delayMoveItemScrollTimer then
    self.delayMoveItemScrollTimer:Stop()
    self.delayMoveItemScrollTimer = nil
  end
  self.msgData = nil
  self.showRewards = nil
  self.showPlayers = nil
  self.floatItemCount = nil
end

function LWUIActRecycleReceiveGiftView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActRecycleThumbsUp, self.OnThumbsUp)
end

function LWUIActRecycleReceiveGiftView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActRecycleThumbsUp, self.OnThumbsUp)
  base.OnRemoveListener(self)
end

function LWUIActRecycleReceiveGiftView:OnOpen()
  self.msgData = self:GetUserData()
  if self.msgData == nil then
    return
  end
  if self.delayMoveItemScrollTimer then
    self.delayMoveItemScrollTimer:Stop()
    self.delayMoveItemScrollTimer = nil
  end
  self.showRewards = DataCenter.RewardManager:ReturnRewardParamForMessage(self.msgData.reward)
  if not table.IsNullOrEmpty(self.showRewards) then
    self.scrollViewItemScroll:SetTotalCount(#self.showRewards)
    self.scrollViewItemScroll:RefillCells()
    if #self.showRewards > 4 then
      self.delayMoveItemScrollTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.scrollViewItemScroll:ScrollToCell(5, 450)
      end, 0.5)
    end
  end
  self.showPlayers = {}
  local playerNameList = {}
  local realPlayerCount = 0
  local showLikeBtn = false
  if not table.IsNullOrEmpty(self.msgData.recommendPlayers) then
    for _, player in pairs(self.msgData.recommendPlayers) do
      if player.type == 1 then
        local playerName = UIUtil.FormatServerAllianceName(player.playerInfo.serverId, player.playerInfo.abbr, player.playerInfo.name)
        table.insert(playerNameList, playerName)
        realPlayerCount = realPlayerCount + 1
        showLikeBtn = true
      end
      table.insert(self.showPlayers, player)
    end
  end
  if not table.IsNullOrEmpty(self.showPlayers) then
    self.scrollViewPlayerScroll:SetTotalCount(#self.showPlayers)
    self.scrollViewPlayerScroll:RefillCells()
  end
  local playText = ""
  for i, v in ipairs(playerNameList) do
    if i <= MAX_PLAYER_TEXT_COUNT then
      if i ~= 1 then
        playText = playText .. ","
      end
      playText = playText .. v
    else
      playText = playText .. "..."
      break
    end
  end
  self.textPlayerText01:SetText(playText)
  self.textPlayerText02:SetLocalText("activity_99165_gift_2", realPlayerCount)
  self.textPlayerText02:SetActive(0 < realPlayerCount)
  self.compLayout:SetActive(showLikeBtn)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
end

function LWUIActRecycleReceiveGiftView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUIActRecycleReceiveGiftView:OnBtnGreatClick()
  self.ctrl:CloseSelf()
end

function LWUIActRecycleReceiveGiftView:OnBtnLikeClick()
  if self.msgData and not table.IsNullOrEmpty(self.msgData.recommendPlayers) then
    local uids = {}
    for i, v in ipairs(self.msgData.recommendPlayers) do
      if v.type == 1 and uids[v.uid] == nil and table.count(uids) < MAX_LIKE_COUNT then
        uids[v.playerInfo.uid] = true
      end
    end
    for uid, _ in pairs(uids) do
      InteractiveUtil.TryThumbsUp(tostring(uid), InteractiveUtil.ThumbsUpType.ActRecycleLike, "ActRecycleLike", function(msg)
      end)
    end
    local effectItem = self.templateFloatItem:GameObjectSpawn(self.compFloatItemRoot.transform)
    local unity_canvas_group = effectItem.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    if IsNotNull(unity_canvas_group) then
      effectItem:SetActive(true)
      effectItem.gameObject.name = "templateFloatItem" .. self.floatItemCount
      unity_canvas_group.alpha = 1
      effectItem.transform.anchoredPosition = Vector2.New(0, 0)
      effectItem.transform:DOAnchorPosY(100, 2)
      effectItem:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 2):OnComplete(function()
        effectItem:GameObjectRecycle()
      end)
      local head = self.compFloatItemRoot:AddComponent(LWUIActRecycleReceiveGiftFloatItemComponent, effectItem.gameObject)
      local userPic = LuaEntry.Player:GetPic() or ""
      local userPicVer = LuaEntry.Player.picVer or 0
      local headBgImg = LuaEntry.Player:GetHeadBgImg() or ""
      head:SetData(LuaEntry.Player:GetUid(), userPic, userPicVer, nil, headBgImg)
    else
      effectItem:GameObjectRecycle()
    end
    self.floatItemCount = self.floatItemCount + 1
  end
end

function LWUIActRecycleReceiveGiftView:OnCreateItemCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewItemScroll:AddComponent(UICommonResItem, itemObj)
  if self.showRewards and self.showRewards[index] then
    cellItem:ReInit(self.showRewards[index])
  end
end

function LWUIActRecycleReceiveGiftView:OnCreatePlayerCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewPlayerScroll:AddComponent(LWUIActRecycleReceiveGiftPlayerItemComponent, itemObj)
  if self.showPlayers and self.showPlayers[index] then
    cellItem:ReInit(self.showPlayers[index], self.msgData.activityId)
  end
end

function LWUIActRecycleReceiveGiftView:OnDeleteItemCell(itemObj, index)
  self.scrollViewItemScroll:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWUIActRecycleReceiveGiftView:OnDeletePlayerCell(itemObj, index)
  self.scrollViewPlayerScroll:RemoveComponent(itemObj.name, LWUIActRecycleReceiveGiftPlayerItemComponent)
end

function LWUIActRecycleReceiveGiftView:ClearItems()
  self.scrollViewItemScroll:ClearCells()
  self.scrollViewItemScroll:RemoveComponents(UICommonResItem)
end

function LWUIActRecycleReceiveGiftView:ClearPlayers()
  self.scrollViewPlayerScroll:ClearCells()
  self.scrollViewPlayerScroll:RemoveComponents(LWUIActRecycleReceiveGiftPlayerItemComponent)
end

return LWUIActRecycleReceiveGiftView
