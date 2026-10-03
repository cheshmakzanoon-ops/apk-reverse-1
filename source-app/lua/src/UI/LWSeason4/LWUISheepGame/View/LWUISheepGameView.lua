local base = UIBaseView
local LWUISheepGameView = BaseClass("LWUISheepGameView", base)
local LWSheepEngine = require("DataCenter.LWSheep.LWSheepEngine")
local Stack = require("Common.Stack")
local LWUISheepItem = require("UI.LWSeason4.LWUISheepGame.Component.LWUISheepItem")
local LWUISheepRewardSubCtrl = require("UI.LWSeason4.LWUISheepGame.Component.LWUISheepRewardSubCtrl")
local LWSheepUtil = require("DataCenter.LWSheep.LWSheepUtil")
local btn_reward_path = "gameArena/btn_reward"
local l_w_u_i_sheep_reward_path = "Popup/LWUISheepReward"
local g_cache_path = "gameArena/GCache"
local txt_level_path = "gameArena/levelText"
local sheep_show_arena_path = "gameArena/GShowArena"
local sheep_temporary_rena_path = "gameArena/GTemporaryArena"
local sheep_remove_rena_path = "gameArena/GRemoveArena/Group"
local btn_back_path = "Bottom/BtnBack"
local sheep_item_arena_path = "gameArena/GItemArena"
local multipleProp0_path = {
  "gameArena/GItemArena/BtnRemove",
  "gameArena/GItemArena/BtnRecall",
  "gameArena/GItemArena/BtnShuffle"
}
local SHEEP_CARD_LUA_PATH = "UI.LWSeason4.LWUISheepGame.Component.LWUISheepCardItem"
local SHEEP_CARD_PREFAB_PATH = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSheep/LWUISheepCardItem.prefab"
local SHEEP_CARD_SPEED = 1000

function LWUISheepGameView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:BuildSheepData()
end

function LWUISheepGameView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUISheepGameView:ComponentDefine()
  self.l_w_u_i_sheep_reward = self:AddComponent(LWUISheepRewardSubCtrl, l_w_u_i_sheep_reward_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.txt_level = self:AddComponent(UIText, txt_level_path)
  self.sheep_show_arena = self:AddComponent(UIBaseContainer, sheep_show_arena_path)
  self.sheep_temporary_rena = self:AddComponent(UIBaseContainer, sheep_temporary_rena_path)
  self.sheep_remove_rena = self:AddComponent(UIBaseContainer, sheep_remove_rena_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.sheep_item_arena = self:AddComponent(UIBaseContainer, sheep_item_arena_path)
  self.multipleProp0 = {
    self:AddComponent(LWUISheepItem, multipleProp0_path[1]),
    self:AddComponent(LWUISheepItem, multipleProp0_path[2]),
    self:AddComponent(LWUISheepItem, multipleProp0_path[3])
  }
  self.g_cache = self:AddComponent(UIBaseContainer, g_cache_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_reward:SetOnClick(BindCallback(self, self.OnClickReward))
end

function LWUISheepGameView:ComponentDestroy()
  self.g_cache = nil
  self.txt_level = nil
  self.sheep_show_arena = nil
  self.sheep_temporary_rena = nil
  self.sheep_remove_rena = nil
  self.btn_back = nil
  self.sheep_item_arena = nil
  self.multipleProp0 = nil
  self.l_w_u_i_sheep_reward = nil
  self.btn_reward = nil
end

function LWUISheepGameView:DataDefine()
  self.cardViews = {}
  self.cardViewStack = Stack.New()
  self.animCards = {}
  self.showCards = {}
  self.removeList = {}
  self.state = {
    a = false,
    b = false,
    c = false,
    failAction = false,
    successAction = false
  }
  self.canvasList = {}
  self.syncOps = {}
end

function LWUISheepGameView:DataDestroy()
  self.cardViews = nil
  self.cardViewStack = nil
  self.animCards = nil
  self.showCards = nil
  self.removeList = nil
  self.state = nil
  self.temporaryList = nil
  self.visualList = nil
  self.itemIds = nil
  self.check = nil
  self.lock = nil
  self.msgLock = nil
  for _, v in pairs(self.canvasList) do
    CS.UnityEngine.Object.DestroyImmediate(v)
  end
  self.canvasList = nil
  if self.engine ~= nil then
    self.engine:Delete()
  end
  self.syncOps = nil
  self.refresh = nil
  self.checkClickSync = nil
  self:RemoveTimer()
end

function LWUISheepGameView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSheepOp, self.SeasonSheepOpHandle)
  self:AddUIListener(EventId.SeasonSheepCloseGame, self.SeasonSheepCloseGameHandle)
  self:AddUIListener(EventId.SeasonGetSheepGameInfo, self.SeasonGetSheepGameInfoHandle)
  self:AddUIListener(EventId.RefreshItems, self.RefreshItemsHandle)
  self:AddUIListener(EventId.SeasonSheepCloseUseItem, self.SeasonSheepCloseUseItemHandle)
  self:AddUIListener(EventId.SeasonSheepGameESC, self.SeasonSheepGameESCHandle)
end

function LWUISheepGameView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSheepOp, self.SeasonSheepOpHandle)
  self:RemoveUIListener(EventId.SeasonSheepCloseGame, self.SeasonSheepCloseGameHandle)
  self:RemoveUIListener(EventId.SeasonGetSheepGameInfo, self.SeasonGetSheepGameInfoHandle)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemsHandle)
  self:RemoveUIListener(EventId.SeasonSheepCloseUseItem, self.SeasonSheepCloseUseItemHandle)
  self:RemoveUIListener(EventId.SeasonSheepGameESC, self.SeasonSheepGameESCHandle)
  base.OnRemoveListener(self)
end

function LWUISheepGameView:SeasonSheepCloseUseItemHandle()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISheepFail, {anim = true}, self)
end

function LWUISheepGameView:SeasonSheepOpHandle(userData)
  if userData.type == SheepGameOpType.Error then
    self:ReBuild()
    return
  end
  if userData.type == SheepGameOpType.Refresh then
    self:RefreshGame(userData)
  end
  local syncData
  if userData.type == SheepGameOpType.Click then
    syncData = self:GeSyncCheckData(userData.opPointId)
  end
  local opData = self.engine:OpCheck(userData, syncData)
  if opData == nil then
    return
  end
  if opData.type == SheepGameOpType.Click then
    if userData.eliminateRewards ~= nil and next(userData.eliminateRewards) and not string.IsNullOrEmpty(opData.opPointId) then
      local serverPosStr = opData.opPointId:split("_")
      local serverX, serverY, serverZ = toInt(serverPosStr[1]), toInt(serverPosStr[2]), toInt(serverPosStr[3])
      local gridId = LWSheepUtil.PosXYZToGridID(serverX, serverY, serverZ)
      local clickCardView = self.cardViews[gridId]
      if clickCardView then
        local rewards = {
          reward = userData.eliminateRewards
        }
        if clickCardView.firstRemoveIndex == nil then
          DataCenter.RewardManager:ShowCommonReward(rewards)
        else
          clickCardView.rewards = rewards
        end
      end
    end
    self:SyncFinish(userData.opPointId)
    self.checkClickSync = true
  elseif opData.type == SheepGameOpType.Back then
    local gridId = opData.backCard.gridId
    local backCardView = self.cardViews[gridId]
    local isTemp = userData.backType == 2
    if backCardView then
      local removeIndex = table.indexof(self.removeList, opData.backCard)
      table.remove(self.removeList, removeIndex)
      if not isTemp then
        backCardView.transform:SetParent(self.sheep_show_arena.transform)
        local viewList = {}
        for _, heightCards in pairs(self.showCards) do
          for _, card in pairs(heightCards) do
            table.insert(viewList, self.cardViews[card.gridId])
          end
        end
        
        local function sortWidth(pos)
          return pos.z * 1000000 + -1 * pos.y * 1000 + pos.x
        end
        
        table.sort(viewList, function(a, b)
          return sortWidth(a.card.pos) < sortWidth(b.card.pos)
        end)
        backCardView.transform:SetSiblingIndex(table.indexof(viewList, backCardView) - 1)
        backCardView:SetBackShowIndex()
      else
        backCardView.transform:SetParent(self.sheep_temporary_rena.transform)
        local viewList = {}
        for _, card in pairs(self.temporaryList) do
          table.insert(viewList, self.cardViews[card.gridId])
        end
        table.sort(viewList, function(a, b)
          return a.card.tempId < b.card.tempId
        end)
        backCardView.transform:SetSiblingIndex(table.indexof(viewList, backCardView) - 1)
        backCardView:SetBackTempIndex()
      end
      self:AddAnimCards(gridId)
      self:RefreshItemState()
    end
    self.state.failAction = false
  elseif opData.type == SheepGameOpType.Move then
    local viewList = {}
    for _, card in pairs(self.temporaryList) do
      table.insert(viewList, self.cardViews[card.gridId])
    end
    table.sort(viewList, function(a, b)
      return a.card.tempId < b.card.tempId
    end)
    for gridId, card in pairs(opData.moveCards) do
      table.remove(self.removeList, table.indexof(self.removeList, card))
      self.cardViews[gridId]:SetBackTempIndex()
      self:AddAnimCards(gridId)
      local backCardView = self.cardViews[gridId]
      backCardView.transform:SetParent(self.sheep_temporary_rena.transform)
      backCardView.transform:SetSiblingIndex(table.indexof(viewList, backCardView) - 1)
    end
    self.state.failAction = false
  end
  if opData.visualCards ~= nil then
    for gridId, _ in pairs(opData.visualCards) do
      self.cardViews[gridId]:RefreshMask()
    end
  end
  self:RefreshItemState()
  self.lock = false
end

function LWUISheepGameView:SeasonSheepCloseGameHandle()
  self.ctrl:CloseSelf()
end

function LWUISheepGameView:SeasonGetSheepGameInfoHandle()
  self.msgLock = false
end

function LWUISheepGameView:SeasonSheepGameESCHandle()
  if self.l_w_u_i_sheep_reward:GetActive() then
    self.l_w_u_i_sheep_reward:SetActive(false)
  else
    self.ctrl:CloseSelf()
  end
end

function LWUISheepGameView:RefreshItemsHandle()
  for _, itemView in ipairs(self.multipleProp0) do
    itemView:UpdateUI()
  end
end

function LWUISheepGameView:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  if self.timer1 ~= nil then
    self.timer1:Stop()
    self.timer1 = nil
  end
  if self.timer2 ~= nil then
    self.timer2:Stop()
    self.timer2 = nil
  end
end

function LWUISheepGameView:ForEachShowCardView(eachAction)
  for _, heightCards in pairs(self.showCards) do
    for _, card in pairs(heightCards) do
      local cardView = self.cardViews[card.gridId]
      if cardView ~= nil and eachAction ~= nil then
        eachAction(cardView)
      end
    end
  end
end

function LWUISheepGameView:BuildSheepData()
  self.engine = self.engine or LWSheepEngine.New()
  self.engine:BuildAction(function()
    self.engine:EnterGame()
  end, function()
    for _, v in pairs(self.cardViews) do
      v:ClearAnimData()
      v.transform:SetParent(self.g_cache.transform)
      v:SetAnchoredPositionXY(0, 0)
      self.cardViewStack:Push(v)
    end
    self.showCards = nil
    table.clear(self.removeList)
    self.temporaryList = nil
    self.visualList = nil
    self.itemIds = nil
    table.clear(self.cardViews)
    table.clear(self.animCards)
    self.check = nil
    self.msgLock = nil
    self:RemoveTimer()
  end, function()
    if self.state.failReBuild then
      self.state.failReBuild = false
      return
    end
    self.state.failAction = true
  end, function()
    self.state.successAction = true
  end, function()
    local removeList
    self.showCards, removeList, self.temporaryList, self.visualList, self.itemIds = self.engine:GetGameInfo()
    for k, v in ipairs(removeList) do
      self.removeList[k] = v
    end
    self:BuildShowArena()
    self:BuildRemoveArena()
    self:BuildTemporaryArena()
    self:BuildItemArena()
    self.txt_level:SetLocalText(450002, DataCenter.LWSheepDataManager:GetCurrentLevel())
  end, function(error)
    UIUtil.ShowTipsId("dig_game_tips_01")
    self.ctrl:CloseSelf()
  end, function()
    UIUtil.ShowTipsId("dig_game_tips_01")
    self.ctrl:CloseSelf()
  end)
  self.engine:BuildGame(DataCenter.LWSheepDataManager.sheepData)
end

function LWUISheepGameView:Again()
  self.msgLock = true
  SFSNetwork.SendMessage(MsgDefines.LWSheepStartGame)
  local waitTime = 8
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILUISheepCloud, nil, function()
    waitTime = waitTime - Time.deltaTime
    if waitTime <= 0 then
      UIUtil.ShowTipsId(129063)
      self.ctrl:CloseSelf()
      return true
    else
      if not self.msgLock then
        self:ReBuild()
        return true
      end
      return false
    end
  end)
end

function LWUISheepGameView:ReBuild()
  self.state = {
    a = false,
    b = false,
    c = false,
    failAction = false,
    successAction = false
  }
  self.engine:ReBuild(DataCenter.LWSheepDataManager.sheepData)
end

function LWUISheepGameView:ToFail()
  local itemId = self.itemIds[SheepGameOpType.Move]
  local canShow = DataCenter.ItemData:GetItemCount(itemId) > 0
  canShow = canShow and self.engine:CanUseItem(SheepGameOpType.Move)
  if not canShow then
    itemId = self.itemIds[SheepGameOpType.Back]
    canShow = DataCenter.ItemData:GetItemCount(itemId) > 0
    canShow = canShow and self.engine:CanUseItem(SheepGameOpType.Back)
  end
  self:ReBuild()
  self.state.failReBuild = true
  if canShow then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISheepUseItem, {anim = true}, self)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISheepFail, {anim = true}, self)
  end
end

function LWUISheepGameView:ToSuccess()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISheepSuccess, {anim = true}, self)
end

function LWUISheepGameView:ISCanOp()
  if self.state == nil then
    return false
  end
  if not (self.state.a and self.state.b) or not self.state.c then
    return false
  end
  return true
end

function LWUISheepGameView:IsSyncFinish()
  return #self.syncOps == 0
end

function LWUISheepGameView:NextLevel()
  self:Again()
end

function LWUISheepGameView:InitFinish()
  return self:ISCanOp()
end

function LWUISheepGameView:OnClickReward()
  if DataCenter.LWSheepDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  self.l_w_u_i_sheep_reward:SetActive(true)
end

function LWUISheepGameView:AddAnimCards(gridId)
  for _, v in ipairs(self.animCards) do
    if v == gridId then
      return
    end
  end
  table.insert(self.animCards, gridId)
end

function LWUISheepGameView:BuildShowArena()
  local buildCount = 0
  for _, heightCards in pairs(self.showCards) do
    for _, card in pairs(heightCards) do
      local cardView = self.cardViewStack:Pop()
      if cardView == nil then
        buildCount = buildCount + 1
        cardView = self:LoadComponentAsync(SHEEP_CARD_LUA_PATH, SHEEP_CARD_PREFAB_PATH, self.sheep_show_arena, function(view, go, lua, info)
          lua:RefreshShow(info, self)
          buildCount = buildCount - 1
          if buildCount == 0 then
            self:ShowArenaFinish()
          end
        end, card)
      else
        cardView.transform:SetParent(self.sheep_show_arena.transform)
        cardView:RefreshShow(card, self)
      end
      self.cardViews[card.gridId] = cardView
    end
  end
  self.state.a = buildCount == 0
  if self.state.a then
    self:ShowArenaFinish()
  end
end

function LWUISheepGameView:ShowArenaFinish()
  local viewList = {}
  for _, heightCards in pairs(self.showCards) do
    for _, card in pairs(heightCards) do
      table.insert(viewList, self.cardViews[card.gridId])
    end
  end
  
  local function sortWidth(pos)
    return pos.z * 1000000 + -1 * pos.y * 1000 + pos.x
  end
  
  table.sort(viewList, function(a, b)
    return sortWidth(a.card.pos) < sortWidth(b.card.pos)
  end)
  for index, view in ipairs(viewList) do
    view.transform:SetSiblingIndex(index - 1)
  end
  self.state.a = true
end

function LWUISheepGameView:BuildTemporaryFinish()
  self.state.c = true
  local viewList = {}
  for _, card in pairs(self.temporaryList) do
    table.insert(viewList, self.cardViews[card.gridId])
  end
  table.sort(viewList, function(a, b)
    return a.card.tempId < b.card.tempId
  end)
  for index, view in ipairs(viewList) do
    view.transform:SetSiblingIndex(index - 1)
  end
end

function LWUISheepGameView:BuildRemoveArena()
  local buildCount = 0
  for index, card in ipairs(self.removeList) do
    local cardView = self.cardViewStack:Pop()
    if cardView == nil then
      buildCount = buildCount + 1
      cardView = self:LoadComponentAsync(SHEEP_CARD_LUA_PATH, SHEEP_CARD_PREFAB_PATH, self.sheep_remove_rena, function(view, go, lua, info)
        lua:RefreshRemove(info[1], self, info[2])
        buildCount = buildCount - 1
        if buildCount == 0 then
          self.state.b = true
        end
      end, {card, index})
    else
      cardView.transform:SetParent(self.sheep_remove_rena.transform)
      cardView:RefreshRemove(card, self, index)
    end
    self.cardViews[card.gridId] = cardView
  end
  self.state.b = buildCount == 0
end

function LWUISheepGameView:BuildTemporaryArena()
  local buildCount = 0
  for index, card in pairs(self.temporaryList) do
    local cardView = self.cardViewStack:Pop()
    if cardView == nil then
      buildCount = buildCount + 1
      cardView = self:LoadComponentAsync(SHEEP_CARD_LUA_PATH, SHEEP_CARD_PREFAB_PATH, self.sheep_temporary_rena, function(view, go, lua, info)
        lua:RefreshTemporary(info[1], self, info[2])
        buildCount = buildCount - 1
        if buildCount == 0 then
          self:BuildTemporaryFinish()
        end
      end, {card, index})
    else
      cardView.transform:SetParent(self.sheep_temporary_rena.transform)
      cardView:RefreshTemporary(card, self, index)
    end
    self.cardViews[card.gridId] = cardView
  end
  if buildCount == 0 then
    self:BuildTemporaryFinish()
  end
end

function LWUISheepGameView:BuildItemArena()
  for index, itemView in ipairs(self.multipleProp0) do
    itemView:SetData(self.itemIds[index], index, self)
  end
end

function LWUISheepGameView:RefreshItemState()
  self.multipleProp0[SheepGameOpType.Back]:RefreshState()
  self.multipleProp0[SheepGameOpType.Move]:RefreshState()
  self.multipleProp0[SheepGameOpType.Refresh]:RefreshState()
end

function LWUISheepGameView:OnUseItem(itemView)
  if self.lock or self.refresh or not self:ISCanOp() then
    return
  end
  if not self:IsSyncFinish() then
    return
  end
  if self.engine:UseItem(itemView.itemType) then
    self.lock = true
    SFSNetwork.SendMessage(MsgDefines.LWSheepUseItem, itemView.itemType)
  end
end

function LWUISheepGameView:OnClickCard(isRemove, addVisualCards, cardView, isTemp)
  local count = table.count(self.removeList)
  local curPictureId = cardView.card.pictureId
  local insertPos = count + 1
  for index = count, 1, -1 do
    if self.removeList[index].pictureId == curPictureId then
      if index < 3 then
        insertPos = index + 1
        break
      end
      do
        local isSame = true
        for checkIndex = index - 1, index - 2, -1 do
          isSame = isSame and self.removeList[checkIndex].pictureId == curPictureId
        end
        if not isSame then
          insertPos = index + 1
        end
      end
      break
    end
  end
  cardView.firstRemoveIndex = insertPos
  cardView.curRemoveIndex = insertPos
  self:AddAnimCards(cardView.card.gridId)
  cardView.transform:SetParent(self.sheep_remove_rena.transform)
  table.insert(self.removeList, cardView.curRemoveIndex, cardView.card)
  for _, v in pairs(addVisualCards) do
    local cardView = self.cardViews[v.gridId]
    cardView:RefreshMask()
  end
  self.lock = true
  local checkData = {}
  local curClientData = self.engine:GetRemoveList()
  for k, v in ipairs(curClientData) do
    table.insert(checkData, {
      sheepId = v:GetPosToServer(),
      pictureId = v.pictureId
    })
  end
  table.insert(self.syncOps, 1, {
    checkData = checkData,
    pictureId = cardView.card.pictureId,
    serverPos = cardView.card:GetPosToServer(),
    isTemp = isTemp and 2 or 1,
    isSend = false
  })
end

function LWUISheepGameView:MoveToPos(cardView, type, callback)
  local tarPos
  local speed = 1
  if type == 0 then
    tarPos = Vector2(cardView.card:GetUIPosXInRemoveArena(cardView.firstRemoveIndex), 0)
    local sourcePos = cardView:GetAnchoredPosition()
    local distance = Vector2.Distance(sourcePos, tarPos)
    speed = 1.6 + distance / 1200 * 0.8
  elseif type == 1 then
    tarPos = Vector2(cardView.card:GetUIPosXInRemoveArena(cardView.removeIndex), 0)
    speed = 1.5
  elseif type == 2 then
    local pos = cardView.card:GetUIPosInGameArena()
    tarPos = Vector2(pos.x, pos.y)
    speed = 1.5
  elseif type == 3 then
    local pos = cardView.card:GetUIPosXInTempArena()
    tarPos = Vector2(pos, 0)
    speed = 1
  end
  if (type == 2 or type == 3) and self.canvasList[cardView.card.gridId] == nil then
    local canvas = cardView.gameObject:AddComponent(typeof(CS.UnityEngine.Canvas))
    canvas.overrideSorting = true
    canvas.sortingOrder = 1
    self.canvasList[cardView.card.gridId] = canvas
  end
  
  local function disable()
    if type == 2 or type == 3 then
      local canvasV = self.canvasList[cardView.card.gridId]
      if canvasV ~= null then
        CS.UnityEngine.Object.DestroyImmediate(canvasV)
        self.canvasList[cardView.card.gridId] = nil
      end
    end
  end
  
  UIUtil.MoveAnchoredPosition(cardView, tarPos, 0, SHEEP_CARD_SPEED * speed, function()
    callback()
    disable()
  end)
end

function LWUISheepGameView:Update()
  if not self:ISCanOp() then
    return
  end
  if self.check == nil then
    self.check = true
    self.engine:CheckGameState()
  end
  self:SyncServer()
  for index = 1, #self.removeList do
    local cardView = self.cardViews[self.removeList[index].gridId]
    if cardView.firstRemoveIndex ~= nil then
      cardView.firstRemoveIndex = index
      self:AddAnimCards(cardView.card.gridId)
    elseif cardView.curRemoveIndex ~= index and cardView.removeIndex == nil then
      cardView.removeIndex = index
      self:AddAnimCards(cardView.card.gridId)
    end
  end
  local removeCount = #self.removeList
  if 3 <= removeCount then
    local removePictureId, sameCount = self.removeList[1].pictureId, 0
    for index = 1, #self.removeList do
      local card = self.removeList[index]
      if removePictureId ~= card.pictureId then
        removePictureId = card.pictureId
        sameCount = 0
      end
      local cardView = self.cardViews[card.gridId]
      if cardView.firstRemoveIndex == nil then
        sameCount = sameCount + 1
      end
      if sameCount == 3 then
        for removeIndex = index, index - 2, -1 do
          local card = self.removeList[removeIndex]
          local cardView = self.cardViews[card.gridId]
          if not cardView.isRemove then
            cardView.isRemove = true
            self:AddAnimCards(card.gridId)
          end
        end
        sameCount = 0
        removePictureId = 0
      end
    end
  end
  local animCount = #self.animCards
  for index = animCount, 1, -1 do
    local cardView = self.cardViews[self.animCards[index]]
    if cardView.backShowIndex ~= nil then
      self:MoveToPos(cardView, 2, function()
        cardView.backShowIndex = nil
        cardView.btn_card:SetInteractable(true)
      end)
    elseif cardView.backTempIndex ~= nil then
      self:MoveToPos(cardView, 3, function()
        cardView.backTempIndex = nil
        cardView.btn_card:SetInteractable(true)
      end)
    elseif cardView.firstRemoveIndex ~= nil then
      self:MoveToPos(cardView, 0, function()
        cardView.curRemoveIndex = cardView.firstRemoveIndex
        cardView.firstRemoveIndex = nil
        if cardView.rewards ~= nil then
          DataCenter.RewardManager:ShowCommonReward(cardView.rewards)
          cardView.rewards = nil
        end
      end)
    elseif cardView.isRemove then
      cardView:PlayRemoveAnim(function()
        cardView.transform:SetParent(self.g_cache.transform)
        cardView:SetAnchoredPositionXY(0, 0)
      end, function()
        cardView.isRemove = false
        table.removebyvalue(self.removeList, cardView.card, false)
      end)
    elseif cardView.removeIndex ~= nil then
      self:MoveToPos(cardView, 1, function()
        cardView.curRemoveIndex = cardView.removeIndex
        cardView.removeIndex = nil
      end)
    else
      table.remove(self.animCards, index)
    end
  end
  if animCount == 0 then
    if self.state.failAction then
      self.state.failAction = false
      self:ToFail()
    elseif self.state.successAction then
      self.state.successAction = false
      self:ToSuccess()
    end
  end
  if self.checkClickSync and animCount == 0 and self:IsSyncFinish() then
    self.checkClickSync = false
    local serverData = self.engine:GetRemoveList()
    local clientData = self.removeList
    if #serverData ~= #clientData then
      self:ReBuild()
      Logger.LogInfo("Sheep Client and Server Rebuild1")
      return
    end
    for k, card in ipairs(serverData) do
      if card:GetPosToServer() ~= clientData[k]:GetPosToServer() then
        self:ReBuild()
        Logger.LogInfo("Sheep Client and Server Rebuild2")
        return
      end
    end
  end
  if self.refresh then
    local showAnim = false
    self:ForEachShowCardView(function(view)
      if view.refreshTween ~= nil and next(view.refreshTween) then
        if view.refreshTween.tarPosA ~= nil or view.refreshTween.addRadius ~= nil then
          view:DoRefreshAnim()
          showAnim = true
        elseif view.refreshTween.needCTime ~= nil then
          self:MoveToPos(view, 2, function()
            view:ClearRefreshAnimC()
          end)
          showAnim = true
        end
      end
    end)
    if not showAnim then
      self.refresh = false
    end
  end
end

function LWUISheepGameView:SyncServer()
  local syncCount = #self.syncOps
  for opIndex = syncCount, 1, -1 do
    local syncData = self.syncOps[opIndex]
    if not syncData.isSend then
      syncData.isSend = true
      SFSNetwork.SendMessage(MsgDefines.LWSheepMove, syncData.isTemp, syncData.serverPos)
    end
  end
end

function LWUISheepGameView:SyncFinish(opPointId)
  if string.IsNullOrEmpty(opPointId) then
    return
  end
  local finishIndex = -1
  for k, v in ipairs(self.syncOps) do
    if v.serverPos == opPointId then
      finishIndex = k
    end
  end
  if finishIndex ~= -1 then
    table.remove(self.syncOps, finishIndex)
  end
end

function LWUISheepGameView:GeSyncCheckData(opPointId)
  if string.IsNullOrEmpty(opPointId) then
    return
  end
  for _, v in ipairs(self.syncOps) do
    if v.serverPos == opPointId then
      return v.checkData
    end
  end
end

function LWUISheepGameView:RefreshGame()
  self.lock = true
  self.refresh = true
  local circlePos = self.sheep_show_arena.transform.position
  local radius = {
    50,
    80,
    110
  }
  local angle = 0
  local circleIndex = 2
  local needATime = 0.5
  local needBTime = 2
  local showArenaCardCount = 0
  for _, heightCards in pairs(self.showCards) do
    showArenaCardCount = showArenaCardCount + table.count(heightCards)
  end
  local small = false
  local singleCircleCount = math.floor(showArenaCardCount / 3)
  local randA, randB = 15, 30
  if singleCircleCount <= 2 then
    randA = 360 / showArenaCardCount - 5
    randB = 360 / showArenaCardCount + 5
  elseif singleCircleCount <= 5 then
    randA = 360 / singleCircleCount - 5
    randB = 360 / singleCircleCount + 5
    small = true
  end
  self:ForEachShowCardView(function(view)
    local low = -0.2
    local high = 0.2
    local rad = low + math.random() * (high - low)
    local cardRadius = radius[circleIndex] + rad
    local angle_in_degrees = angle * (math.pi / 180)
    local tarPos = circlePos + cardRadius * Vector3.New(math.sin(angle_in_degrees), math.cos(angle_in_degrees))
    view:SetRefreshOriginPos(angle, cardRadius, tarPos, needATime)
    angle = angle + math.random(math.ceil(randA), math.ceil(randB))
    if 360 < angle then
      circleIndex = circleIndex + 1
      if 3 < circleIndex then
        circleIndex = 1
      end
      if small then
        angle = 30 * circleIndex - 1
      end
    end
  end)
  self.timer = TimerManager:GetInstance():GetTimer(needATime, function()
    self:ForEachShowCardView(function(view)
      view:SetRefreshMaxRadius(300, 160 - view.refreshTween.radius, needBTime)
    end)
    if self.timer then
      self.timer:Stop()
      self.timer = nil
    end
  end)
  self.timer:Start()
  self.timer2 = TimerManager:GetInstance():GetTimer(needATime + 0.2, function()
    self:UpdateRefreshData()
    if self.timer2 then
      self.timer2:Stop()
      self.timer2 = nil
    end
  end)
  self.timer2:Start()
  self.timer1 = TimerManager:GetInstance():GetTimer(needATime + needBTime, function()
    self:ForEachShowCardView(function(view)
      view:SetRefreshEndPos(0.8)
    end)
    if self.timer1 then
      self.timer1:Stop()
      self.timer1 = nil
    end
  end)
  self.timer1:Start()
end

function LWUISheepGameView:UpdateRefreshData()
  self.visualList = nil
  self.check = nil
  self.msgLock = nil
  self:ForEachShowCardView(function(view)
    self.cardViewStack:Push(view)
    self.cardViews[view.card.gridId] = nil
  end)
  local removeViews = {}
  for _, card in ipairs(self.removeList) do
    table.insert(removeViews, self.cardViews[card.gridId])
    self.cardViews[card.gridId] = nil
  end
  local temporaryViews = {}
  for _, card in pairs(self.temporaryList) do
    temporaryViews[card.tempId] = self.cardViews[card.gridId]
    self.cardViews[card.gridId] = nil
  end
  local removeList
  self.engine:RefreshGame(DataCenter.LWSheepDataManager.sheepData)
  self.showCards, removeList, self.temporaryList, self.visualList, _ = self.engine:GetGameInfo()
  for k, v in ipairs(removeList) do
    self.removeList[k] = v
  end
  for _, heightCards in pairs(self.showCards) do
    for _, card in pairs(heightCards) do
      local cardView = self.cardViewStack:Pop()
      cardView:RefreshItem(card, self)
      self.cardViews[card.gridId] = cardView
    end
  end
  for index, view in ipairs(removeViews) do
    local card = self.removeList[index]
    view:RefreshCard(card)
    self.cardViews[card.gridId] = view
  end
  for tempId, view in pairs(temporaryViews) do
    for _, card in pairs(self.temporaryList) do
      if card.tempId == tempId then
        view:RefreshCard(card)
        self.cardViews[card.gridId] = view
      end
    end
  end
  self:ShowArenaFinish()
end

return LWUISheepGameView
