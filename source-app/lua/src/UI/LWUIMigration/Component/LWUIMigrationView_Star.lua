local LWUIMigration_TabBase = require("UI.LWUIMigration.Component.LWUIMigration_TabBase")
local base = LWUIMigration_TabBase
local LWUIMigrationView_Star = BaseClass("LWUIMigrationView_Star", LWUIMigration_TabBase)
local LWUIMigration_StarListItem = require("UI.LWUIMigration.Component.LWUIMigration_StarListItem")
local LWUIMigration_StarAlly = require("UI.LWUIMigration.Component.LWUIMigration_StarAlly")
local LWUIMigration_StarPlayer = require("UI.LWUIMigration.Component.LWUIMigration_StarPlayer")
local Localization = CS.GameEntry.Localization
local IMG_PATH_ARROW_UP = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png"
local IMG_PATH_ARROW_DOWN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png"

function LWUIMigrationView_Star:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUIMigrationView_Star:OnDestroy()
  self:ClearTween()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationView_Star:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compTopRect = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compMidRect = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compDownRect = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compUnderRect = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.textTmpServerName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpServerId = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgServerIcon = self.viewSkin:AddComponent(self, UIImage, 7)
  self.compPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 8)
  self.textTmpPresident = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textTmpKingName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textTmpLan = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textTmpLan2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textTmpRecruit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compSeat0 = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.compSeat1 = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.compSeat2 = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.compSeat3 = self.viewSkin:AddComponent(self, UIBaseComponent, 18)
  self.btnToLeft = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnToLeft:SetOnClick(function()
    self:OnBtnToLeftClick()
  end)
  self.btnToRight = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnToRight:SetOnClick(function()
    self:OnBtnToRightClick()
  end)
  self.textTmpDownTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.imgDrop = self.viewSkin:AddComponent(self, UIImage, 22)
  self.compNumbers = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.textTmpUnderScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.imgSeat = self.viewSkin:AddComponent(self, UIImage, 25)
  self.btnDrop = self.viewSkin:AddComponent(self, UIButton, 26)
  self.btnDrop:SetOnClick(function()
    self:OnBtnDropClick()
  end)
  self.canvasGroupMainRect = self.viewSkin:AddComponent(self, UICanvasGroup, 27)
  self.compStarSelections = self.viewSkin:AddComponent(self, UIBaseComponent, 28)
  self.btnQuiteSelections = self.viewSkin:AddComponent(self, UIButton, 29)
  self.btnQuiteSelections:SetOnClick(function()
    self:OnBtnQuiteSelectionsClick()
  end)
  self.compSelections = self.viewSkin:AddComponent(self, UIBaseContainer, 30)
  self.compStarInfo = self.viewSkin:AddComponent(self, LWUIMigration_StarListItem, 31)
  self.compBg1 = self.viewSkin:AddComponent(self, UIBaseComponent, 32)
  self.compBg2 = self.viewSkin:AddComponent(self, UIBaseComponent, 33)
  self.compBgSeats = self.viewSkin:AddComponent(self, UIBaseComponent, 34)
  self.compStarAlly2 = self.viewSkin:AddComponent(self, LWUIMigration_StarAlly, 35)
  self.compStarAlly1 = self.viewSkin:AddComponent(self, LWUIMigration_StarAlly, 36)
  self.compStarAlly3 = self.viewSkin:AddComponent(self, LWUIMigration_StarAlly, 37)
  self.compStarPlayer2 = self.viewSkin:AddComponent(self, LWUIMigration_StarPlayer, 38)
  self.compStarPlayer1 = self.viewSkin:AddComponent(self, LWUIMigration_StarPlayer, 39)
  self.compStarPlayer3 = self.viewSkin:AddComponent(self, LWUIMigration_StarPlayer, 40)
  self.btnImgServerIcon = self.viewSkin:AddComponent(self, UIButton, 41)
  self.btnImgServerIcon:SetOnClick(function()
    self:OnBtnImgServerIconClick()
  end)
  self.eventTriggerMainRect = self.viewSkin:AddComponent(self, UIEventTrigger, 42)
  self.textTmpMidTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 43)
  self.imgKingIcon = self.viewSkin:AddComponent(self, UIImage, 44)
  self.textTmpUnderNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 45)
  self.imgNum0 = self.viewSkin:AddComponent(self, UIImage, 46)
  self.imgNum1 = self.viewSkin:AddComponent(self, UIImage, 47)
  self.compImgAdd = self.viewSkin:AddComponent(self, UIBaseComponent, 48)
  self.eventTriggerMainRect:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.eventTriggerMainRect:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.viewInited = true
  self.textTmpServerName:SetLocalText("migration_activity_interface_10029")
  self.textTmpDownTitle:SetLocalText("migration_activity_recommend_limit10_1010")
  self.textTmpMidTitle:SetLocalText("migration_activity_recommend_limit10_1009")
  self.textTmpRecruit:SetLocalText("migration_activity_recommend_limit10_1008")
  self.textTmpUnderNotice:SetLocalText("migration_activity_recommend_limit10_1007")
  self.compPlayerHead:SetEnableClickShowInfo(true, true)
  self.compUnderRect:SetActive(false)
  self:SetPageListActive(false)
  self.canvasGroupMainRect:SetAlpha(0)
  self:RefreshLRButtons()
end

function LWUIMigrationView_Star:ComponentDestroy()
  if self.starListItemReqs then
    for k, v in ipairs(self.starListItemReqs) do
      self:GameObjectDestroy(v)
    end
    self.starListItems = {}
    self.compSelections:RemoveComponents(LWUIMigration_StarListItem)
  end
  self.viewSkin = nil
  self.compTopRect = nil
  self.compMidRect = nil
  self.compDownRect = nil
  self.compUnderRect = nil
  self.textTmpServerName = nil
  self.textTmpServerId = nil
  self.imgServerIcon = nil
  self.compPlayerHead = nil
  self.textTmpPresident = nil
  self.textTmpKingName = nil
  self.btnRank = nil
  self.textTmpLan = nil
  self.textTmpLan2 = nil
  self.textTmpRecruit = nil
  self.compSeat0 = nil
  self.compSeat1 = nil
  self.compSeat2 = nil
  self.compSeat3 = nil
  self.btnToLeft = nil
  self.btnToRight = nil
  self.textTmpDownTitle = nil
  self.imgDrop = nil
  self.compNumbers = nil
  self.textTmpUnderScore = nil
  self.imgSeat = nil
  self.btnDrop = nil
  self.canvasGroupMainRect = nil
  self.compStarSelections = nil
  self.btnQuiteSelections = nil
  self.compSelections = nil
  self.compStarInfo = nil
  self.compBg1 = nil
  self.compBg2 = nil
  self.compBgSeats = nil
  self.compStarAlly2 = nil
  self.compStarAlly1 = nil
  self.compStarAlly3 = nil
  self.compStarPlayer2 = nil
  self.compStarPlayer1 = nil
  self.compStarPlayer3 = nil
  self.btnImgServerIcon = nil
  self.eventTriggerMainRect = nil
  self.textTmpMidTitle = nil
  self.imgKingIcon = nil
  self.textTmpUnderNotice = nil
  self.imgNum0 = nil
  self.imgNum1 = nil
  self.compImgAdd = nil
end

function LWUIMigrationView_Star:DataDefine()
  self.starList = nil
  self.currentPageIndex = -1
  self.pageCount = 0
  self.zoneStar = 0
  self.currentServerIndex = -1
  self.currentServerId = -1
  self.serverCount = 0
  self.cbOnBtnDropClick = Bind(self, self.OnBtnDropClick)
  self.cbOnClickedListItem = Bind(self, self.OnClickedListItem)
end

function LWUIMigrationView_Star:DataDestroy()
  self.starList = nil
  self.currentPageIndex = -1
  self.pageCount = 0
  self.currentServerIndex = -1
  self.currentServerId = -1
  self.serverCount = 0
  self.zoneStar = 0
  self.viewInited = nil
  self.cbOnBtnDropClick = nil
end

function LWUIMigrationView_Star:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationStarListRefresh, self.OnStarListRefresh)
  self:AddUIListener(EventId.ActMigrationStarDetailRefresh, self.OnServerDetailRefresh)
end

function LWUIMigrationView_Star:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationStarListRefresh, self.OnStarListRefresh)
  self:RemoveUIListener(EventId.ActMigrationStarDetailRefresh, self.OnServerDetailRefresh)
  base.OnRemoveListener(self)
end

function LWUIMigrationView_Star:SetData()
  base.SetData(self)
  self.starList = DataCenter.ActMigrationManager:TryGetStarList()
  if self.starList then
    self:OnStarListRefresh()
  end
end

function LWUIMigrationView_Star:ResetServerIndex()
  self.currentServerIndex = -1
  self.currentServerId = -1
end

function LWUIMigrationView_Star:RefreshLRButtons()
  if self.serverCount <= 0 then
    self.btnToLeft:SetActive(false)
    self.btnToRight:SetActive(false)
  else
    self.btnToLeft:SetActive(self.currentServerIndex > 1)
    self.btnToRight:SetActive(self.currentServerIndex < self.serverCount)
  end
end

function LWUIMigrationView_Star:OnStarListRefresh()
  if self:IsMvHide() then
    return
  end
  if not self.viewInited then
    return
  end
  if not self.starList then
    self.starList = DataCenter.ActMigrationManager:TryGetStarList()
  end
  if self.starList then
    self.pageCount = self.starList:GetStarCount()
    if self.currentPageIndex <= 0 then
      self.currentPageIndex = self.starList:GetMyStarIndex()
      self:ResetServerIndex()
      self:RefreshPage(self.currentPageIndex)
    end
    self.compUnderRect:SetActive(true)
  else
    self.compUnderRect:SetActive(false)
  end
end

function LWUIMigrationView_Star:OnServerDetailRefresh(info)
  if self:IsMvHide() then
    return
  end
  if not info then
    return
  end
  if self.currentServerId == info.serverId then
    self:TweenRefreshView(info)
  end
end

function LWUIMigrationView_Star:RefreshPage(index)
  if not self.starList then
    return
  end
  self.currentPageIndex = index
  local pageInfo = self.starList:GetStarInfoByIndex(index)
  if pageInfo then
    self.serverCount = pageInfo:ServerCount()
    self.compStarInfo:Setup(pageInfo, self.cbOnBtnDropClick, false)
    self.compStarInfo:SetActive(true)
    self:RefreshServer(1)
  else
    self.serverCount = 0
    self.currentServerIndex = 0
    self.compStarInfo:SetActive(false)
    self:RefreshLRButtons()
  end
end

function LWUIMigrationView_Star:RefreshServer(server)
  self.currentServerIndex = server
  local serverInfo, serverId = self.starList:TryGetServerInfo(self.currentPageIndex, self.currentServerIndex)
  self.currentServerId = serverId
  if serverInfo then
    self:TweenRefreshView(serverInfo)
  end
  self:RefreshLRButtons()
end

function LWUIMigrationView_Star:TweenRefreshView(serverInfo)
  self:ClearTween()
  if not self.canvasGroupMainRect then
    return
  end
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.sequence:Append(self.canvasGroupMainRect:FadeOut(0.1))
  self.sequence:AppendCallback(function()
    self:RefreshMainViewByServerInfo(serverInfo)
  end)
  self.sequence:Append(self.canvasGroupMainRect:FadeIn(0.1))
  self.sequence:OnComplete(function()
    self.sequence = nil
  end)
end

function LWUIMigrationView_Star:ClearTween()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
end

local _numberPath = {
  [0] = "Assets/Main/Sprites/UI/UIMultiKill/number_0.png",
  [1] = "Assets/Main/Sprites/UI/UIMultiKill/number_1.png",
  [2] = "Assets/Main/Sprites/UI/UIMultiKill/number_2.png",
  [3] = "Assets/Main/Sprites/UI/UIMultiKill/number_3.png",
  [4] = "Assets/Main/Sprites/UI/UIMultiKill/number_4.png",
  [5] = "Assets/Main/Sprites/UI/UIMultiKill/number_5.png",
  [6] = "Assets/Main/Sprites/UI/UIMultiKill/number_6.png",
  [7] = "Assets/Main/Sprites/UI/UIMultiKill/number_7.png",
  [8] = "Assets/Main/Sprites/UI/UIMultiKill/number_8.png",
  [9] = "Assets/Main/Sprites/UI/UIMultiKill/number_9.png"
}

local function _GetNumberPath(number)
  return _numberPath[number]
end

function LWUIMigrationView_Star:RefreshMainViewByServerInfo(serverInfo)
  if not self.viewInited then
    return
  end
  if not serverInfo then
    return
  end
  self.textTmpServerId:SetText(string.format("#%s", serverInfo.serverId))
  local pKing = serverInfo.presidentInfo
  if pKing then
    self.compPlayerHead:SetActive(true)
    self.compPlayerHead:ParseHeadInfo(pKing)
    self.textTmpPresident:SetLocalText(457202)
    self.textTmpPresident:SetActive(true)
    local nameStr = UIUtil.FormatAllianceAndName(pKing.abbr, pKing.name, pKing.uid)
    self.textTmpKingName:SetText(nameStr)
    self.imgKingIcon:SetActive(true)
  else
    self.compPlayerHead:SetActive(false)
    self.textTmpPresident:SetActive(false)
    self.textTmpKingName:SetText("")
    self.imgKingIcon:SetActive(false)
  end
  self.zoneStar = serverInfo.zoneStar
  local cfg = self.zoneStar and self.zoneStar > 0 and LocalController:instance():getLine(TableName.LW_Migration_Zone_Star, self.zoneStar)
  if cfg then
    self.imgServerIcon:LoadSpriteAuto(cfg.icon)
    self.imgServerIcon:SetActive(true)
    local numberParam = tonumber(serverInfo.zoneStarParam or 0)
    if numberParam and 0 < numberParam then
      self.compNumbers:SetActive(false)
      if cfg.condition == 2 or cfg.condition == 3 or cfg.condition == 4 or cfg.condition == 5 then
        self.compNumbers:SetActive(true)
        if 99 < numberParam then
          self.imgNum0:LoadSpriteAuto(_GetNumberPath(9))
          self.imgNum1:LoadSpriteAuto(_GetNumberPath(9))
          self.compImgAdd:SetActive(true)
          self.imgNum1:SetActive(true)
        elseif numberParam < 10 then
          self.imgNum0:LoadSpriteAuto(_GetNumberPath(numberParam))
          self.imgNum1:SetActive(false)
          self.compImgAdd:SetActive(false)
        else
          self.imgNum0:LoadSpriteAuto(_GetNumberPath(math.floor(numberParam / 10)))
          self.imgNum1:LoadSpriteAuto(_GetNumberPath(numberParam % 10))
          self.compImgAdd:SetActive(false)
          self.imgNum1:SetActive(true)
        end
      else
        self.compNumbers:SetActive(false)
      end
    else
      self.compNumbers:SetActive(false)
    end
  else
    self.imgServerIcon:SetActive(false)
  end
  local lan1 = serverInfo.languageList and serverInfo.languageList[1]
  local lan2 = serverInfo.languageList and serverInfo.languageList[2]
  local lans = {lan1, lan2}
  local comps = {
    self.textTmpLan,
    self.textTmpLan2
  }
  local bgs = {
    self.compBg1,
    self.compBg2
  }
  for i = 1, 2 do
    local lan = lans[i]
    local comp = comps[i]
    local bg = bgs[i]
    if lan then
      bg:SetActive(true)
      comp:SetLocalText(lan)
    else
      bg:SetActive(false)
    end
  end
  self.compSeat0:SetActive(0 < DataCenter.ActMigrationManager:GetSeatMaxCountByStateAndIdentify(serverInfo.serverState, ActMigrationIdentity.SuperLow))
  self.compSeat1:SetActive(0 < DataCenter.ActMigrationManager:GetSeatMaxCountByStateAndIdentify(serverInfo.serverState, ActMigrationIdentity.Low))
  self.compSeat2:SetActive(0 < DataCenter.ActMigrationManager:GetSeatMaxCountByStateAndIdentify(serverInfo.serverState, ActMigrationIdentity.Normal))
  self.compSeat3:SetActive(0 < DataCenter.ActMigrationManager:GetSeatMaxCountByStateAndIdentify(serverInfo.serverState, ActMigrationIdentity.High))
  local allyComps = {
    self.compStarAlly1,
    self.compStarAlly2,
    self.compStarAlly3
  }
  local topAlliances = serverInfo.topAllianceList or {}
  for i = 1, Mathf.Max(#allyComps, 3) do
    local comp = allyComps[i]
    local info = topAlliances[i]
    if info then
      comp:Setup(i, info, self.currentServerId)
      comp:SetActive(true)
    else
      comp:SetActive(false)
    end
  end
  local playerHeads = {
    self.compStarPlayer1,
    self.compStarPlayer2,
    self.compStarPlayer3
  }
  local topDogHeads = serverInfo.topPlayerList or {}
  for i = 1, Mathf.Max(#playerHeads, 3) do
    local comp = playerHeads[i]
    local info = topDogHeads[i]
    if info then
      comp:Setup(i, info)
      comp:SetActive(true)
    else
      comp:SetActive(false)
    end
  end
end

function LWUIMigrationView_Star:RefreshStarListItems()
  if not self.starListItems or not self.pageCount then
    return
  end
  if #self.starListItems < self.pageCount then
    return
  end
  local ct = Mathf.Max(#self.starListItems, self.pageCount)
  for i = 1, ct do
    local item = self.starListItems[i]
    local info = self.starList:GetStarInfoByIndex(i)
    if not info then
      if item then
        item:SetActive(false)
      end
    else
      item:Setup(info, self.cbOnClickedListItem, self.currentPageIndex == i)
      item:SetActive(true)
    end
  end
end

function LWUIMigrationView_Star:OnBtnDropClick()
  if self.frameCount and Time.frameCount == self.frameCount then
    return
  end
  if self.pageCount > 1 then
    if self.starListItemReqs then
      self:RefreshStarListItems()
    else
      self.starListItemReqs = {}
      self.starListItems = {}
      for i = 1, self.pageCount do
        local request = self:GameObjectInstantiateAsync(UIAssets.LWUIMigration_StarListItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.compSelections.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.name = string.format("[Async]ActMigrationStarListItem_%s", i)
          local cell = self.compSelections:AddComponent(LWUIMigration_StarListItem, go.name)
          table.insert(self.starListItems, cell)
          self:RefreshStarListItems()
        end)
        table.insert(self.starListItemReqs, request)
      end
    end
    self:SetPageListActive(true)
  else
    return
  end
end

function LWUIMigrationView_Star:OnBtnQuiteSelectionsClick()
  self.frameCount = Time.frameCount
  self:SetPageListActive(false)
end

function LWUIMigrationView_Star:OnClickedListItem(info)
  self:SetPageListActive(false)
  if not info then
    return
  end
  self:RefreshPage(info.index)
end

function LWUIMigrationView_Star:SetPageListActive(active)
  self.isPageListActive = active
  self.compStarSelections:SetActive(active)
  self.imgDrop:LoadSpriteAuto(active and IMG_PATH_ARROW_DOWN or IMG_PATH_ARROW_UP)
  self.btnDrop:SetActive(not active)
end

function LWUIMigrationView_Star:OnBtnToLeftClick()
  if not self.currentServerIndex or self.currentServerIndex <= 1 then
    return
  end
  self:RefreshServer(self.currentServerIndex - 1)
end

function LWUIMigrationView_Star:OnBtnToRightClick()
  if not self.currentServerIndex or self.currentServerIndex >= self.serverCount then
    return
  end
  self:RefreshServer(self.currentServerIndex + 1)
end

function LWUIMigrationView_Star:OnBtnRankClick()
  if not self.currentServerId then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.currentServerId)
end

function LWUIMigrationView_Star:OnBtnImgServerIconClick()
  if not self.zoneStar then
    return
  end
  if self.zoneStar == 1 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationZoneStarPreview, {anim = true}, {
      star = self.zoneStar,
      serverId = self.currentServerId
    })
    return
  end
  local cfg = LocalController:instance():getLine(TableName.LW_Migration_Zone_Star, self.zoneStar)
  if not cfg then
    return
  end
  UIUtil.ShowBubbleTipsAuto(Localization:GetString(cfg.desc), self.btnImgServerIcon.transform.position, 0, -25, 40, nil, nil)
end

function LWUIMigrationView_Star:OnBeginDrag(eventData)
  self.startDragPosX = eventData.position.x
end

function LWUIMigrationView_Star:OnEndDrag(eventData)
  if self.startDragPosX then
    local curX = eventData.position.x
    local offset = curX - self.startDragPosX
    local threshold = 70
    if offset > threshold then
      self:OnBtnToLeftClick()
    elseif offset < -threshold then
      self:OnBtnToRightClick()
    end
    self.startDragPosX = nil
  end
end

return LWUIMigrationView_Star
