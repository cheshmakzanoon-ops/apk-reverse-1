local base = UIBaseView
local UILWPlayerThumbsUpGloryView = BaseClass("UILWPlayerThumbsUpGloryView", base)
local PlayerThumbsUpGloryHeartInfoComponent = require("UI.LWPlayerInfo.UILWPlayerThumbsUpGlory.View.PlayerThumbsUpGloryHeartInfoComponent")
local PlayerThumbsUpGloryHeadItemComponent = require("UI.LWPlayerInfo.UILWPlayerThumbsUpGlory.View.PlayerThumbsUpGloryHeadItemComponent")
local closeBtn_path = "Close"
local claimBtn_path = "Container/ClaimBtn"
local sendGiftGo_path = "Container/SendGift"
local lineGo_path = "Container/Line"
local thumbUpGo_path = "Container/ThumbUp"
local payGiftContent_path = "Container/SendGift/PayGiftContent"
local freeGiftContent_path = "Container/SendGift/FreeContent"
local headItem_path = "Container/PlayerThumbsUpGloryHeadItem"
local heartInfo_path = "Container/PlayerThumbsUpGloryHeartInfo"
local giftPlayerDesc_path = "Container/SendGift/GiftDesc/GiftDesc"
local giftInfoList_path = "Container/SendGift/GiftDesc/GiftInfoList"
local starContent_path = "Container/ThumbUp/StarContent"
local thumbUpDesc_path = "Container/ThumbUp/ThumbUpDesc/ThumbUpDesc"
local thumbUpHeartInfo_path = "Container/ThumbUp/ThumbUpDesc/ThumbUpHeartInfo"
local effect_path = "Container/titleArea/Effect"
local title_path = "Container/titleArea/title"
local Localization = CS.GameEntry.Localization
local ContainerShowType = {Single = 1, Double = 2}
local MAX_SHOW_PLAYER_NAME_NUM = 10
local Config = {
  ContainerHeight = {
    [ContainerShowType.Single] = 160,
    [ContainerShowType.Double] = 320
  },
  ContainerMaxPlayerNum = {
    [ContainerShowType.Single] = 9,
    [ContainerShowType.Double] = 18
  },
  ContainerLinePlayerNum = {
    [ContainerShowType.Single] = 4,
    [ContainerShowType.Double] = 8
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.claimBtn = self:AddComponent(UIButton, claimBtn_path)
  self.sendGiftGo = self:AddComponent(UIBaseContainer, sendGiftGo_path)
  self.lineGo = self:AddComponent(UIBaseContainer, lineGo_path)
  self.thumbUpGo = self:AddComponent(UIBaseContainer, thumbUpGo_path)
  self.payGiftContent = self:AddComponent(UIBaseContainer, payGiftContent_path)
  self.freeGiftContent = self:AddComponent(UIBaseContainer, freeGiftContent_path)
  self.headItem = self:AddComponent(UIBaseContainer, headItem_path)
  self.heartInfo = self:AddComponent(UIBaseContainer, heartInfo_path)
  self.giftPlayerDesc = self:AddComponent(UIText, giftPlayerDesc_path)
  self.giftInfoList = self:AddComponent(UIBaseContainer, giftInfoList_path)
  self.starContent = self:AddComponent(UIBaseContainer, starContent_path)
  self.thumbUpDesc = self:AddComponent(UIText, thumbUpDesc_path)
  self.thumbUpHeartInfo = self:AddComponent(UIBaseContainer, thumbUpHeartInfo_path)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.titleText = self:AddComponent(UIText, title_path)
  self.payGiftGrid = self:AddComponent(UIGridLayoutGroup, payGiftContent_path)
  self.freeGiftGrid = self:AddComponent(UIGridLayoutGroup, freeGiftContent_path)
  self.starGrid = self:AddComponent(UIGridLayoutGroup, starContent_path)
  self.giftInfoGrid = self:AddComponent(UIGridLayoutGroup, giftInfoList_path)
  self.thumbUpHeartInfoComponent = self:AddComponent(PlayerThumbsUpGloryHeartInfoComponent, thumbUpHeartInfo_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.claimBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.headItemGo = self.headItem.gameObject
  self.headItemGo:GameObjectCreatePool()
  self.heartInfoGo = self.heartInfo.gameObject
  self.heartInfoGo:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.payGiftGrid:RemoveComponents(PlayerThumbsUpGloryHeadItemComponent)
  self.freeGiftGrid:RemoveComponents(PlayerThumbsUpGloryHeadItemComponent)
  self.starGrid:RemoveComponents(PlayerThumbsUpGloryHeadItemComponent)
  self.giftInfoGrid:RemoveComponents(PlayerThumbsUpGloryHeartInfoComponent)
  self.headItemGo:GameObjectRecycleAll()
  self.heartInfoGo:GameObjectRecycleAll()
  self.headItemGo = nil
  self.heartInfoGo = nil
  self.closeBtn = nil
  self.claimBtn = nil
  self.sendGiftGo = nil
  self.lineGo = nil
  self.thumbUpGo = nil
  self.payGiftContent = nil
  self.freeGiftContent = nil
  self.headItem = nil
  self.heartInfo = nil
  self.giftPlayerDesc = nil
  self.giftInfoList = nil
  self.starContent = nil
  self.thumbUpDesc = nil
  self.thumbUpHeartInfo = nil
  self.effect = nil
  self.titleText = nil
end

local function DataDefine(self)
  self.playerMap = {}
end

local function DataDestroy(self)
  self.playerMap = {}
end

function UILWPlayerThumbsUpGloryView:RefreshView()
  self.isShowThumbUp, self.isShowFreeGift, self.isShowPayGift = false, false, false
  self.isShowHighFive = false
  local info = self:GetUserData()
  info = info or DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(LuaEntry.Player.uid)
  if info then
    self:InitData(info)
    if self.isShowHighFive then
      self.titleText:SetLocalText("alliance_clap_hands_ui_1")
    else
      self.titleText:SetLocalText("avatar_tips008")
    end
    self:RefreshThumbUp(self:BuildThumbsUpInfo(info))
    self:RefreshSendGift(info)
    self.lineGo:SetActive(not self.isShowThumbUp or self.isShowFreeGift or self.isShowPayGift)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
    TimerManager:GetInstance():DelayFrameInvoke(function()
      self.effect:SetActive(true)
    end, 3)
  else
    self.ctrl:CloseSelf()
  end
end

function UILWPlayerThumbsUpGloryView:BuildThumbsUpInfo(info)
  local lineNum = Config.ContainerLinePlayerNum[ContainerShowType.Double]
  local data = {}
  if self.isShowHighFive then
    data = {
      isShow = self.isShowHighFive,
      playerList = info.highFivePlayerList or {},
      showType = lineNum < #(info.highFivePlayerList or {}) and ContainerShowType.Double or ContainerShowType.Single,
      diff = info.highFiveDiff or 0,
      lastCount = info.highFiveCount or 0,
      infoType = PlayerInfoHeartInfoType.HighFive,
      desc = "alliance_clap_hands_ui_2"
    }
    PostEventLog.Track(PostEventLog.Defines.CLAP_HANDS_WATCH, {
      count = data.diff
    })
  else
    data = {
      isShow = self.isShowThumbUp,
      playerList = info.ThumbsUpPlayerList or {},
      showType = self:IsOnlyThumbUp() and lineNum < #(info.ThumbsUpPlayerList or {}) and ContainerShowType.Double or ContainerShowType.Single,
      diff = info.thumbsUpCountDiff or 0,
      lastCount = info.thumbsUpCountOld or 0,
      infoType = PlayerInfoHeartInfoType.ThumbsUp,
      desc = "thumbs_up_glory_tip"
    }
  end
  return data
end

function UILWPlayerThumbsUpGloryView:RefreshThumbUp(info)
  if not info.isShow then
    self.thumbUpGo:SetActive(false)
    return
  end
  self.thumbUpGo:SetActive(true)
  self:RefreshHeadContainer(self.starGrid, info.playerList, info.showType)
  local playerNames = self:GetPlayerNameString(info.playerList)
  local num = info.diff
  self.thumbUpDesc:SetText(playerNames .. Localization:GetString(info.desc, num, num))
  self.thumbUpHeartInfoComponent:RefreshView(info.lastCount, num, nil, info.infoType)
end

function UILWPlayerThumbsUpGloryView:RefreshSendGift(info)
  self:RefreshPayGift(info)
  self:RefreshFreeGift(info)
  self:RefreshGiftDesc(info)
  self.sendGiftGo:SetActive(self.isShowFreeGift or self.isShowPayGift)
end

function UILWPlayerThumbsUpGloryView:RefreshPayGift(info)
  if not self.isShowPayGift then
    self.payGiftContent:SetActive(false)
    return
  end
  self.payGiftContent:SetActive(true)
  local showType = ContainerShowType.Single
  local payPlayerList = {}
  if info.payFollowHint then
    payPlayerList = info.payFollowHint.playerList or {}
  end
  local list = {}
  for i = 1, 4 do
    local player = payPlayerList[i]
    if player == nil then
      break
    end
    table.insert(list, player)
  end
  self:RefreshHeadContainer(self.payGiftGrid, list, showType)
end

function UILWPlayerThumbsUpGloryView:RefreshFreeGift(info)
  if not self.isShowFreeGift then
    self.freeGiftContent:SetActive(false)
    return
  end
  self.freeGiftContent:SetActive(true)
  local freePlayerList = {}
  if info.payFollowHint then
    freePlayerList = info.freeFollowHint.playerList or {}
  end
  local lineNum = Config.ContainerLinePlayerNum[ContainerShowType.Double]
  local showType = self:IsOnlyFreeGift() and lineNum < #freePlayerList and ContainerShowType.Double or ContainerShowType.Single
  self:RefreshHeadContainer(self.freeGiftGrid, freePlayerList, showType)
end

function UILWPlayerThumbsUpGloryView:RefreshGiftDesc(info)
  local list = {}
  local payPlayerList, freePlayerList, payGifts, freeGifts = {}, {}, {}, {}
  local freeNum, payNum = 0, 0
  if info.payFollowHint then
    payPlayerList = info.payFollowHint.playerList or {}
    payGifts = info.payFollowHint.gifts or {}
    payNum = info.payFollowHint.countDiff or 0
  end
  if info.freeFollowHint then
    freePlayerList = info.freeFollowHint.playerList or {}
    freeGifts = info.freeFollowHint.gifts or {}
    freeNum = info.freeFollowHint.countDiff or 0
  end
  table.insertto(list, payPlayerList)
  table.insertto(list, freePlayerList)
  local playerNames = self:GetPlayerNameString(list)
  local num = freeNum + payNum
  local numString = string.format("<color=#FDC839>%d</color>", num)
  self.giftPlayerDesc:SetText(playerNames .. Localization:GetString("follow_display_des", numString, numString))
  local gifts = {}
  table.insertto(gifts, payGifts)
  table.insertto(gifts, freeGifts)
  for k, v in ipairs(gifts) do
    local goItem = self.heartInfoGo:GameObjectSpawn(self.giftInfoGrid.transform)
    goItem.name = "item_" .. k
    goItem:SetActive(true)
    local theItem = self.giftInfoGrid:AddComponent(PlayerThumbsUpGloryHeartInfoComponent, goItem.name)
    theItem:RefreshView(v.oldCount, v.upCount, v.giftId, PlayerInfoHeartInfoType.Gift)
  end
end

function UILWPlayerThumbsUpGloryView:RefreshHeadContainer(container, playerList, showType)
  local count = 0
  for k, v in ipairs(playerList) do
    if count < Config.ContainerMaxPlayerNum[showType] then
      local goItem = self.headItemGo:GameObjectSpawn(container.transform)
      goItem.name = "item_" .. k
      goItem:SetActive(true)
      local theItem = container:AddComponent(PlayerThumbsUpGloryHeadItemComponent, goItem.name)
      local info = self.playerMap[v.uid] or v
      theItem:RefreshView(v, info)
    end
    count = count + 1
  end
  if count > Config.ContainerLinePlayerNum[showType] then
    if not self:IsOnlyFreeGift() and container == self.freeGiftGrid then
      container:SetCellSize(120, 120)
      container:SetCellSpacing(-68, 0)
    else
      container:SetCellSize(144, 144)
      container:SetCellSpacing(-80, 0)
    end
  elseif not self:IsOnlyFreeGift() and container == self.freeGiftGrid then
    container:SetCellSize(120, 120)
    container:SetCellSpacing(20, 0)
  else
    container:SetCellSize(144, 144)
    container:SetCellSpacing(0, 0)
  end
  container:SetSizeDeltaY(Config.ContainerHeight[showType])
end

function UILWPlayerThumbsUpGloryView:InitData(info)
  if info.ThumbsUpPlayerList and info.thumbsUpCountDiff then
    self.isShowThumbUp = info.thumbsUpCountDiff > 0 and table.count(info.ThumbsUpPlayerList) ~= 0
  end
  if info.highFivePlayerList and info.highFiveDiff then
    self.isShowHighFive = 0 < info.highFiveDiff and table.count(info.highFivePlayerList) ~= 0
  end
  if info.freeFollowHint and info.freeFollowHint.countDiff and info.freeFollowHint.playerList then
    self.isShowFreeGift = 0 < info.freeFollowHint.countDiff and table.count(info.freeFollowHint.playerList) ~= 0
  end
  if info.payFollowHint and info.payFollowHint.countDiff and info.payFollowHint.playerList then
    self.isShowPayGift = 0 < info.payFollowHint.countDiff and table.count(info.payFollowHint.playerList) ~= 0
  end
  if type(info.followUser) == "table" then
    for _, v in pairs(info.followUser) do
      self.playerMap[v.uid] = v
    end
  end
end

function UILWPlayerThumbsUpGloryView:IsOnlyFreeGift()
  return self.isShowFreeGift and not self.isShowPayGift and not self.isShowThumbUp
end

function UILWPlayerThumbsUpGloryView:IsOnlyThumbUp()
  return not self.isShowFreeGift and not self.isShowPayGift and self.isShowThumbUp
end

function UILWPlayerThumbsUpGloryView:GetPlayerNameString(playerList)
  local msg = ""
  local count = 1
  if type(playerList) ~= "table" then
    return msg
  end
  local maxShowName = MAX_SHOW_PLAYER_NAME_NUM
  if self.isShowThumbUp and (self.isShowPayGift or self.isShowFreeGift) then
    maxShowName = MAX_SHOW_PLAYER_NAME_NUM / 2
  end
  for _, v in ipairs(playerList) do
    local info = self.playerMap[v.uid] or v or {}
    if count < maxShowName then
      if string.IsNullOrEmpty(msg) then
        msg = UIUtil.FormatAllianceAndName(info.abbr, info.name)
      else
        msg = msg .. ", " .. UIUtil.FormatAllianceAndName(info.abbr, info.name)
      end
    elseif count == maxShowName then
      msg = msg .. " ..."
      break
    end
    count = count + 1
  end
  if not string.IsNullOrEmpty(msg) then
    msg = msg .. "\n"
  end
  return msg
end

function UILWPlayerThumbsUpGloryView:BuildFakeData(oneData)
  local ShowThumbsUp = true
  local thumbsUpPlayerNum = 20
  local ShowHighFive = true
  local highFivePlayerNum = 6
  local ShowFreeGift = false
  local freePlayerNum = 6
  local ShowPayGift = false
  local payPlayerNum = 10
  oneData.payFollowHint = {
    countOld = 0,
    countDiff = 0,
    playerList = {},
    gifts = {}
  }
  oneData.freeFollowHint = {
    countOld = 0,
    countDiff = 0,
    playerList = {},
    gifts = {}
  }
  local player = {
    allianceId = "f57a928ac4374e62a172f70ee769d1e8",
    uid = "7417708005000296",
    country = "AU",
    headSkinET = 0,
    chatBubbleId = 50006,
    headSkinId = 21016,
    name = "7417708005",
    headPicVer = 0,
    chatBubbleET = 0,
    allianceName = "31232",
    abbr = "1clx",
    headPic = ""
  }
  oneData.followUser = {
    DeepCopy(player)
  }
  if ShowThumbsUp then
    oneData.thumbsUpCountDiff = thumbsUpPlayerNum
    for i = 1, thumbsUpPlayerNum do
      table.insert(oneData.ThumbsUpPlayerList, DeepCopy(player))
    end
  end
  if ShowHighFive then
    oneData.highFiveDiff = highFivePlayerNum
    for i = 1, highFivePlayerNum do
      table.insert(oneData.highFivePlayerList, DeepCopy(player))
    end
  end
  if ShowFreeGift then
    oneData.freeFollowHint.countDiff = freePlayerNum
    local follow = {
      uid = "7417708005000296",
      giftId = 990001,
      count = 1,
      context = ""
    }
    for i = 1, freePlayerNum do
      table.insert(oneData.freeFollowHint.playerList, DeepCopy(follow))
    end
    oneData.freeFollowHint.gifts = {
      {
        giftId = 990001,
        oldCount = 0,
        upCount = freePlayerNum
      }
    }
  end
  if ShowPayGift then
    oneData.payFollowHint.countDiff = payPlayerNum
    local payFollow = {
      uid = "7417708005000296",
      giftId = 990002,
      count = 1,
      context = ""
    }
    for i = 1, payPlayerNum do
      table.insert(oneData.payFollowHint.playerList, DeepCopy(payFollow))
    end
    oneData.payFollowHint.gifts = {
      {
        giftId = 990002,
        oldCount = 0,
        upCount = payPlayerNum
      },
      {
        giftId = 990003,
        oldCount = 0,
        upCount = payPlayerNum
      }
    }
  end
end

UILWPlayerThumbsUpGloryView.OnCreate = OnCreate
UILWPlayerThumbsUpGloryView.OnDestroy = OnDestroy
UILWPlayerThumbsUpGloryView.OnEnable = OnEnable
UILWPlayerThumbsUpGloryView.OnDisable = OnDisable
UILWPlayerThumbsUpGloryView.ComponentDefine = ComponentDefine
UILWPlayerThumbsUpGloryView.ComponentDestroy = ComponentDestroy
UILWPlayerThumbsUpGloryView.DataDefine = DataDefine
UILWPlayerThumbsUpGloryView.DataDestroy = DataDestroy
return UILWPlayerThumbsUpGloryView
