local UILW3V3CampaignView = BaseClass("UILW3V3CampaignView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UILW3V3TeamItem = require("UI.UILW3V3Campaign.Component.UILW3V3TeamItem")
local backBtn_path = "Root/BottomBar/BtnBack"
local defPlayerHead_path = "Root/Common/DefPlayer/DefPlayerHead"
local defPlayerNameLayout_path = "Root/Common/DefPlayer/DefPlayerNameLayout"
local defPlayerPowerText_path = "Root/Common/DefPlayer/DefPlayerPower/DefPowerText"
local defPlayerTeam1_path = "Root/Common/DefPlayer/DefTeam1"
local defPlayerTeam2_path = "Root/Common/DefPlayer/DefTeam2"
local defPlayerTeam3_path = "Root/Common/DefPlayer/DefTeam3"
local atkPlayerHead_path = "Root/Common/AtkPlayer/AtkPlayerHead"
local atkPlayerNameLayout_path = "Root/Common/AtkPlayer/AtkPlayerNameLayout"
local atkPlayerPowerText_path = "Root/Common/AtkPlayer/AtkPlayerPower/AtkPowerText"
local atkPlayerTeamContainer = "Root/Common/AtkPlayer/AtkTeams"
local atkPlayerTeam_path = "Root/Common/AtkPlayer/AtkTeams/AtkTeam%d"
local atkPlayerTeamSlotArea_path = "Root/Common/AtkPlayer/AtkTeams/AtkTeam%dSlotArea"
local switch1Btn_path = "Root/Common/AtkPlayer/SwitchBtn1"
local switch2Btn_path = "Root/Common/AtkPlayer/SwitchBtn2"
local battleBtn_path = "Root/BottomBar/BattleBtn"
local defPlayerBloodTip_path = "Root/Common/DefPlayer/DefPlayerBloodTip"
local defPlayerBloodTipCell_path = "Root/Common/DefPlayer/DefPlayerBloodTip/DefPlayerBloodCell%d"
local atkPlayerBloodTip_path = "Root/Common/AtkPlayer/AtkPlayerBloodTip"
local atkPlayerBloodTipCell_path = "Root/Common/AtkPlayer/AtkPlayerBloodTip/AtkPlayerBloodCell%d"
local skipMask_path = "SkipMask"
local trashTalk_path = "Root/OngoingMode/TrashTalk"
local trashTalkText_path = "Root/OngoingMode/TrashTalk/Dialog/DialogBg/DialogText1"
local boomEffect_path = "Root/OngoingMode/BoomEffect"
local blowEffect_path = "Root/OngoingMode/BlowEffect"
local selfTalk_path = "Root/OngoingMode/SelfTalk"
local selfTalkText_path = "Root/OngoingMode/SelfTalk/Dialog/DialogBg/DialogText2"
local tipText_path = "Root/OngoingMode/TipText"
local selfBg_path = "Root/Bg3"
local otherBg_path = "Root/Bg2"

local function EditTeamIndex(self, index)
  if self.pveEnterType == PVEEnterType.Arena3V3 then
    self:Open3V3BattleScene(index)
  else
    EventManager:GetInstance():Broadcast(EventId.Arena3V3BattleSwitchTeam, index)
  end
  self.ctrl:CloseSelf()
end

local function OnBeginDragHeroSlot(self, eventData, index)
  if self.dragingIndex then
    return
  end
  self.isInDragMode = true
  self.dragingIndex = index
  self.lastDragPosX = eventData.position.x
  self.lastDragPosY = eventData.position.y
  self.slotAreas[index].transform:SetAsFirstSibling()
end

local function ResetDragAreaPos(self)
  if self.atkPlayerTeamsItem then
    for k, v in pairs(self.atkPlayerTeamsItem) do
      v.transform:DOKill()
      v.transform.position = self.slotPos[k]
    end
  end
  if self.slotAreas then
    for k, v in pairs(self.slotAreas) do
      v.transform.position = self.slotPos[k]
    end
  end
end

local function SwitchTeamSlot(self, fromIndex, toIndex)
  DataCenter.LW3V3Manager:SwitchAtkTeam(fromIndex, toIndex)
end

local function OnDragEndHeroSlot(self, eventData, index)
  if self.isInDragMode and self.dragingIndex == index then
    if self.toSwitchIndex then
      SwitchTeamSlot(self, self.dragingIndex, self.toSwitchIndex)
      self:Refresh()
    end
    ResetDragAreaPos(self)
    self.isInDragMode = false
    self.dragingIndex = nil
    self.toSwitchIndex = nil
    self.lastDragPosX = nil
    self.lastDragPosY = nil
  end
end

local function OnDragHeroSlot(self, eventData, index)
  if self.isInDragMode and self.dragingIndex == index then
    local curPosX = eventData.position.x
    local curPosY = eventData.position.y
    self.lastDragPosX = curPosX
    self.lastDragPosY = curPosY
    local uiPos = PosConverse.ScreenToUIPos(self.slotAreasContainer.rectTransform, Vector2.New(curPosX, curPosY))
    self.slotAreas[index].transform.localPosition = Vector3.New(uiPos.x, uiPos.y)
    self.atkPlayerTeamsItem[index].transform.localPosition = Vector3.New(uiPos.x, uiPos.y)
    local areaCenterPos = PosConverse.UIWorldToScreenPos(self.slotAreas[index].transform.position)
    local pos = Vector2.New(areaCenterPos.x, areaCenterPos.y)
    local rtScreenPos = pos
    if rtScreenPos.x < -8 or rtScreenPos.x > self.screenWidth + 8 then
      OnDragEndHeroSlot(self, eventData, self.dragingIndex)
      return
    end
    if rtScreenPos.y < -8 or rtScreenPos.y > self.screenHeight + 8 then
      OnDragEndHeroSlot(self, eventData, self.dragingIndex)
      return
    end
  end
end

local function SlotMoveToIndex(self, index, dstIndex, time)
  local animTime = time or 0.2
  if animTime <= 0 then
    local slot = self.atkPlayerTeamsItem[index]
    if slot then
      slot.transform.position = self.slotPos[dstIndex]
    end
  else
    local slot = self.atkPlayerTeamsItem[index]
    if slot then
      local pos = self.slotPos[dstIndex]
      slot.transform:DOMove(pos, animTime)
    end
  end
end

local function OnPointerEnterHeroSlot(self, eventData, index)
  if not self.isInDragMode then
    return
  end
  if self.isInDragMode and self.dragingIndex == index then
    return
  end
  if self.toSwitchIndex then
    return
  end
  self.toSwitchIndex = index
  SlotMoveToIndex(self, self.toSwitchIndex, self.dragingIndex)
end

local function OnPointerExitHeroSlot(self, eventData, index)
  if not self.isInDragMode then
    return
  end
  if self.isInDragMode and self.dragingIndex == index then
    return
  end
  if self.toSwitchIndex ~= index then
    return
  end
  SlotMoveToIndex(self, self.toSwitchIndex, self.toSwitchIndex)
  self.toSwitchIndex = nil
end

local function OnStartBattle(self)
  DataCenter.LW3V3Manager:StartBattle()
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 4)
end

local function ComponentDefine(self)
  self.backBtn = self:AddComponent(UIButton, backBtn_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
    if CS.SceneManager.IsInPVE() then
      DataCenter.LWBattleManager:Exit()
    end
  end)
  self.defPlayerHead = self:AddComponent(UICommonHead, defPlayerHead_path)
  self.defPlayerNameLayout = self:AddComponent(UICommonNameLayout, defPlayerNameLayout_path)
  self.defPlayerPowerText = self:AddComponent(UIText, defPlayerPowerText_path)
  self.defPlayerTeam1 = self:AddComponent(UILW3V3TeamItem, defPlayerTeam1_path)
  self.defPlayerTeam2 = self:AddComponent(UILW3V3TeamItem, defPlayerTeam2_path)
  self.defPlayerTeam3 = self:AddComponent(UILW3V3TeamItem, defPlayerTeam3_path)
  self.defPlayerItems = {
    self.defPlayerTeam1,
    self.defPlayerTeam2,
    self.defPlayerTeam3
  }
  self.atkPlayerHead = self:AddComponent(UICommonHead, atkPlayerHead_path)
  self.atkPlayerNameLayout = self:AddComponent(UICommonNameLayout, atkPlayerNameLayout_path)
  self.atkPlayerPowerText = self:AddComponent(UIText, atkPlayerPowerText_path)
  self.slotAreasContainer = self:AddComponent(UIBaseContainer, atkPlayerTeamContainer)
  self.slotAreas = {}
  self.atkPlayerTeamsItem = {}
  self.slotPos = {}
  self.screenWidth = Screen.width
  self.screenHeight = Screen.height
  for i = 1, 3 do
    local atkPlayerTeamItem = self:AddComponent(UILW3V3TeamItem, string.format(atkPlayerTeam_path, i))
    table.insert(self.atkPlayerTeamsItem, atkPlayerTeamItem)
    local slotArea = self:AddComponent(UIEventTrigger, string.format(atkPlayerTeamSlotArea_path, i))
    slotArea:OnPointerClick(function()
      if not self.isInDragMode then
        EditTeamIndex(self, i)
      end
    end)
    slotArea:OnBeginDrag(function(eventData)
      OnBeginDragHeroSlot(self, eventData, i)
    end)
    slotArea:OnDrag(function(eventData)
      OnDragHeroSlot(self, eventData, i)
    end)
    slotArea:OnEndDrag(function(eventData)
      OnDragEndHeroSlot(self, eventData, i)
    end)
    slotArea:OnPointerEnter(function(eventData)
      OnPointerEnterHeroSlot(self, eventData, i)
    end)
    slotArea:OnPointerExit(function(eventData)
      OnPointerExitHeroSlot(self, eventData, i)
    end)
    table.insert(self.slotAreas, slotArea)
    local slotPos = atkPlayerTeamItem.transform.position
    table.insert(self.slotPos, slotPos)
  end
  self.switch1Btn = self:AddComponent(UIButton, switch1Btn_path)
  self.switch1Btn:SetOnClick(function()
    DataCenter.LW3V3Manager:SwitchAtkTeam(1, 2)
    self:Refresh()
  end)
  self.switch2Btn = self:AddComponent(UIButton, switch2Btn_path)
  self.switch2Btn:SetOnClick(function()
    DataCenter.LW3V3Manager:SwitchAtkTeam(2, 3)
    self:Refresh()
  end)
  self.battleBtn = self:AddComponent(UIButton, battleBtn_path)
  self.battleBtn:SetOnClick(function()
    OnStartBattle(self)
  end)
  self.defplayerBloodTip = self:AddComponent(UIBaseContainer, defPlayerBloodTip_path)
  self.defplayerBloodTipCells = {}
  for i = 1, 3 do
    local cell = self:AddComponent(UIImage, string.format(defPlayerBloodTipCell_path, i))
    table.insert(self.defplayerBloodTipCells, cell)
  end
  self.atkplayerBloodTip = self:AddComponent(UIBaseContainer, atkPlayerBloodTip_path)
  self.atkplayerBloodTipCells = {}
  for i = 1, 3 do
    local cell = self:AddComponent(UIImage, string.format(atkPlayerBloodTipCell_path, i))
    table.insert(self.atkplayerBloodTipCells, cell)
  end
  self.skipMask = self:AddComponent(UIButton, skipMask_path)
  self.skipMask:SetOnClick(function()
    self:SkipBattleAnim()
  end)
  self.trashTalk = self:AddComponent(UICanvasGroup, trashTalk_path)
  self.trashTalkText = self:AddComponent(UIText, trashTalkText_path)
  self.boomEffect = self:AddComponent(UIBaseContainer, boomEffect_path)
  self.blowEffect = self:AddComponent(UIBaseContainer, blowEffect_path)
  self.selfTalk = self:AddComponent(UICanvasGroup, selfTalk_path)
  self.selfTalkText = self:AddComponent(UIText, selfTalkText_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.selfBg = self:AddComponent(UIRawImage, selfBg_path)
  UIGray.SetGray(self.selfBg.transform, false, true, true)
  self.otherBg = self:AddComponent(UIRawImage, otherBg_path)
  UIGray.SetGray(self.otherBg.transform, false, true, true)
end

local function ComponentDestroy(self)
  self.backBtn = nil
  self.defPlayerHead = nil
  self.defPlayerNameLayout = nil
  self.defPlayerPowerText = nil
  self.defPlayerTeam1 = nil
  self.defPlayerTeam2 = nil
  self.defPlayerTeam3 = nil
  self.defPlayerItems = nil
  self.atkPlayerHead = nil
  self.atkPlayerNameLayout = nil
  self.atkPlayerPowerText = nil
  self.atkPlayerTeam1 = nil
  self.atkPlayerTeam2 = nil
  self.atkPlayerTeam3 = nil
  self.atkPlayerTeamsItem = nil
  self.atkPlayerTeam1EditBtn = nil
  self.atkPlayerTeam2EditBtn = nil
  self.atkPlayerTeam3EditBtn = nil
  self.switch1Btn = nil
  self.switch2Btn = nil
  self.battleBtn = nil
  self.defplayerBloodTip = nil
  self.defplayerBloodTipCells = nil
  self.atkplayerBloodTip = nil
  self.atkplayerBloodTipCells = nil
  self.skipMask = nil
  self.trashTalk = nil
  self.trashTalkText = nil
  self.boomEffect = nil
  self.blowEffect = nil
  self.selfTalk = nil
  self.selfTalkText = nil
  self.tipText = nil
end

local function DataDefine(self)
  self.dragIndex = nil
end

local function DataDestroy(self)
  self.dragIndex = nil
  self.pveEnterType = nil
end

local function OnCreate(self)
  base.OnCreate(self)
  DataDefine(self)
  ComponentDefine(self)
  self:ResetAnimState()
  self:Refresh()
  local startBattle, pveEnterType = self:GetUserData()
  self.pveEnterType = pveEnterType or PVEEnterType.Default
  if startBattle then
    OnStartBattle(self)
  end
end

local function OnDestroy(self)
  if self.battleSequence then
    self.battleSequence:Kill()
    self.battleSequence = nil
  end
  ResetDragAreaPos(self)
  DataDestroy(self)
  ComponentDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
end

local function Refresh(self)
  self.opponentData = DataCenter.LW3V3Manager.opponentData
  if not self.opponentData then
    return
  end
  self.opponentPlayerInfo = self.opponentData.playerInfo
  local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(self.opponentPlayerInfo.headSkinId, self.opponentPlayerInfo.headSkinET, false)
  self.defPlayerHead:SetData(self.opponentPlayerInfo.uid, self.opponentPlayerInfo.pic, self.opponentPlayerInfo.picver, nil, headFramePath)
  self.defPlayerNameLayout:SetData(self.opponentPlayerInfo.name, self.opponentPlayerInfo.abbr, nil, nil, nil, nil, self.opponentPlayerInfo.srcServer)
  self.opponentDefTeams = {}
  for i = 1, 3 do
    local defenceTeam = DataCenter.LW3V3Manager:GetOpponentDefenceTeam(i)
    table.insert(self.opponentDefTeams, defenceTeam)
  end
  local selfUid = LuaEntry.Player.uid
  local selfPic = LuaEntry.Player.pic
  local selfPicVer = LuaEntry.Player.picVer
  local headFrame = LuaEntry.Player:GetHeadBgImg()
  self.atkPlayerHead:SetData(selfUid, selfPic, selfPicVer, nil, headFrame)
  local selfAllianceAbbr
  if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    selfAllianceAbbr = data.abbr
  end
  self.atkPlayerNameLayout:SetData(LuaEntry.Player.name, selfAllianceAbbr, nil, nil, nil, nil, LuaEntry.Player:GetSourceServerId())
  self.atkPlayerPowerText:SetText(string.GetFormattedStr(LuaEntry.Player.power))
  self.atkTeams = {}
  for i = 1, 3 do
    local atkTeam = DataCenter.LW3V3Manager:GetAtkTeamByIndex(i)
    table.insert(self.atkTeams, atkTeam)
  end
  local allAtkTeamPower = 0
  local allDefTeamPower = 0
  for i = 1, 3 do
    local defTeam = self.opponentDefTeams[i]
    local atkTeam = self.atkTeams[i]
    local atkTeamPower = 0
    local defTeamPower = 0
    if atkTeam then
      atkTeamPower = atkTeam:GetTotalCapacity()
      allAtkTeamPower = allAtkTeamPower + atkTeamPower
    end
    if defTeam then
      defTeamPower = defTeam.power
      allDefTeamPower = allDefTeamPower + defTeamPower
    end
    if defTeam then
      local heroesUuid = defTeam:GetLocalAllHeroes()
      local heroesData = {}
      for index, uuid in pairs(heroesUuid) do
        local heroData = defTeam:GetHeroDataByUuid(uuid)
        heroesData[index] = heroData
      end
      local teamPowerColor = atkTeamPower <= defTeamPower and "#FF7676" or "#FFFFFF"
      local teamPowerStr = string.format("<color=%s>%s</color>", teamPowerColor, string.GetFormattedStr(defTeamPower))
      self.defPlayerItems[i]:SetData(heroesData, teamPowerStr, defTeam.dominatorData)
    else
      self.defPlayerItems[i]:SetData(nil)
    end
    if atkTeam then
      local heroesUuid = atkTeam:GetLocalAllHeroes()
      local heroesData = {}
      for index, uuid in pairs(heroesUuid) do
        local heroData = {}
        heroData.heroUuid = uuid
        heroesData[index] = heroData
      end
      local dominatorData
      local dominatorUuid = atkTeam:GetLocalDominatorUuid()
      if dominatorUuid and 0 < dominatorUuid then
        local info = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
        if info then
          dominatorData = {
            heroId = info.dominatorId,
            rankLv = info:GetCurRankLv()
          }
        end
      end
      self.atkPlayerTeamsItem[i]:SetData(heroesData, string.GetFormattedStr(atkTeamPower), dominatorData)
    else
      self.atkPlayerTeamsItem[i]:SetData(nil)
    end
  end
  self.atkPlayerPowerText:SetText(string.GetFormattedStr(allAtkTeamPower))
  self.defPlayerPowerText:SetText(string.GetFormattedStr(allDefTeamPower))
end

local function ResetAnimState(self)
  if self.battleSequence then
    self.battleSequence:Kill()
    self.battleSequence = nil
  end
  self.switch1Btn:SetActive(true)
  self.switch2Btn:SetActive(true)
  self.battleBtn:SetActive(true)
  for k, v in pairs(self.slotAreas) do
    v:SetActive(true)
  end
  for k, v in pairs(self.defplayerBloodTipCells) do
    v:SetActive(true)
    v:SetLocalScaleXYZ(1, 1, 1)
    v:SetAlpha(1)
  end
  for k, v in pairs(self.atkplayerBloodTipCells) do
    v:SetActive(true)
    v:SetLocalScaleXYZ(1, 1, 1)
    v:SetAlpha(1)
  end
  self.skipMask:SetActive(false)
  for i = 1, 3 do
    self.atkPlayerTeamsItem[i]:SetLocalScaleXYZ(1, 1, 1)
    self.defPlayerItems[i]:SetLocalScaleXYZ(1, 1, 1)
  end
  self.trashTalk:SetActive(false)
  self.boomEffect:SetActive(false)
  self.blowEffect:SetActive(false)
  self.selfTalk:SetActive(false)
  self.tipText:SetActive(true)
  UIGray.SetGray(self.selfBg.transform, false, true, true)
  UIGray.SetGray(self.otherBg.transform, false, true, true)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
  ResetDragAreaPos(self)
end

local function GetRandomDialog(self, selfWin)
  if selfWin then
    local winDialogsStr = LuaEntry.DataConfig:TryGetStr("arena_score_settings", "k8")
    if not string.IsNullOrEmpty(winDialogsStr) then
      local winDialogs = string.split(winDialogsStr, ";")
      local randomIndex = math.random(1, #winDialogs)
      return Localization:GetString(winDialogs[randomIndex])
    end
  else
    local loseDialogs = LuaEntry.DataConfig:TryGetStr("arena_score_settings", "k7")
    if not string.IsNullOrEmpty(loseDialogs) then
      local loseDialogs = string.split(loseDialogs, ";")
      local randomIndex = math.random(1, #loseDialogs)
      return Localization:GetString(loseDialogs[randomIndex])
    end
  end
  return ""
end

local function PlayBattleAnim(self, msg)
  if self.battleSequence then
    self.battleSequence:Kill()
    self.battleSequence = nil
  end
  self.battleSequence = CS.DG.Tweening.DOTween.Sequence()
  self.switch1Btn:SetActive(false)
  self.switch2Btn:SetActive(false)
  self.battleBtn:SetActive(false)
  self.skipMask:SetActive(true)
  self.trashTalk:SetActive(false)
  self.tipText:SetActive(false)
  self.battleMsg = msg
  local defRemainBlood = 3
  local atkRemainBlood = 3
  self.battleSequence:AppendCallback(function()
    self.selfTalk:SetActive(true)
    self.selfTalkText:SetText("")
    self.selfTalkText:SetText(Localization:GetString(200561))
  end)
  self.battleSequence:AppendInterval(2)
  self.battleSequence:AppendCallback(function()
    self.selfTalk:SetActive(false)
  end)
  for i = 1, 3 do
    local defTeamItem = self.defPlayerItems[i]
    local atkTeamItem = self.atkPlayerTeamsItem[i]
    local isWin = false
    local mailValid = false
    local mailId = msg.battleArr[i].mailUid
    local mailData = DataCenter.MailDataManager:GetMailInfoById(mailId)
    if mailData then
      local ext = mailData:GetMailExt()
      if ext and ext.reportIntegrity then
        isWin = ext.attackerWin
        mailValid = true
      else
        Logger.LogError("3v3Campaign get mailData ext error : " .. (mailId or "nil"))
      end
    else
      Logger.LogError("3v3Campaign get mailData error : " .. (mailId or "nil"))
    end
    if not mailValid then
      local battleStateArr = msg.battleStateArr
      if battleStateArr then
        local res = battleStateArr[i] or 0
        isWin = res == 1
      end
    end
    self.battleSequence:AppendCallback(function()
      atkTeamItem.transform:DOMoveY(self.slotPos[i].y - 80, 0.1)
    end)
    self.battleSequence:AppendInterval(0.1)
    self.battleSequence:AppendCallback(function()
      atkTeamItem.transform:DOScale(Vector3(1.15, 1.15, 1), 0.1)
    end)
    self.battleSequence:AppendInterval(0.1)
    self.battleSequence:AppendCallback(function()
      local defTeamItemPos = defTeamItem.transform.position
      atkTeamItem.rectTransform:DOMoveY(defTeamItemPos.y - 50, 0.3):SetEase(CS.DG.Tweening.Ease.InExpo)
    end)
    self.battleSequence:AppendInterval(0.3)
    self.battleSequence:AppendCallback(function()
      defTeamItem.transform:DOScale(Vector3(1.1, 1.1, 1), 0.1)
    end)
    self.battleSequence:AppendInterval(0.1)
    self.battleSequence:AppendCallback(function()
      defTeamItem.transform:DOScale(Vector3(1, 1, 1), 0.15)
      atkTeamItem.transform:DOMove(self.slotPos[i], 0.2)
      atkTeamItem.transform:DOScale(Vector3(1, 1, 1), 0.1)
    end)
    self.battleSequence:AppendInterval(0.2)
    self.battleSequence:AppendCallback(function()
      self.boomEffect:SetActive(false)
      self.boomEffect:SetActive(true)
      if isWin then
        self.boomEffect.transform.position = defTeamItem.transform.position
      else
        self.boomEffect.transform.position = atkTeamItem.transform.position
      end
    end)
    self.battleSequence:AppendInterval(0.3)
    self.battleSequence:AppendCallback(function()
      defTeamItem:SetGray(isWin)
      atkTeamItem:SetGray(not isWin)
    end)
    self.battleSequence:AppendCallback(function()
      local bloodCell
      if isWin then
        bloodCell = self.defplayerBloodTipCells[defRemainBlood]
        defRemainBlood = defRemainBlood - 1
      else
        bloodCell = self.atkplayerBloodTipCells[atkRemainBlood]
        atkRemainBlood = atkRemainBlood - 1
      end
      if bloodCell then
        bloodCell.transform:DOScale(Vector3(1.6, 1.6, 1), 0.1)
        bloodCell.unity_image:DOFade(0, 0.1)
      end
    end)
    self.battleSequence:AppendInterval(0.3)
  end
  self.battleSequence:AppendCallback(function()
    local isWin = msg.win
    if isWin then
      UIGray.SetGray(self.selfBg.transform, false, true, true)
      UIGray.SetGray(self.otherBg.transform, true, true, true)
    else
      UIGray.SetGray(self.selfBg.transform, true, true, true)
      UIGray.SetGray(self.otherBg.transform, false, true, true)
    end
    local randomDialog = GetRandomDialog(self, isWin)
    if not string.IsNullOrEmpty(randomDialog) then
      self.trashTalk:SetActive(true)
      self.trashTalk:SetAlpha(0)
      self.trashTalk:FadeIn(1)
      self.trashTalkText:SetText("")
      self.trashTalkText:SetText(randomDialog)
    end
  end)
  self.battleSequence:AppendInterval(2)
  self.battleSequence:AppendCallback(function()
    local selfPlayerInfo = DataCenter.LW3V3Manager:PackSelfPlayerInfo()
    selfPlayerInfo.lastRank = DataCenter.LW3V3ArenaManager.lastSelfRank
    selfPlayerInfo.curRank = DataCenter.LW3V3ArenaManager.selfRank
    local otherPlayerInfo = DataCenter.LW3V3Manager.opponentData.playerInfo
    if msg.type3v3 == Type3v3.Train then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain3V3BattleResult, {anim = false}, msg, selfPlayerInfo, otherPlayerInfo)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIArena3V3BattleResult, {anim = false}, msg, selfPlayerInfo, otherPlayerInfo)
    end
  end)
end

local function SkipBattleAnim(self)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 4)
  if self.battleSequence then
    self.battleSequence:Kill()
    self.battleSequence = nil
  end
  self.battleSequence = CS.DG.Tweening.DOTween.Sequence()
  self.switch1Btn:SetActive(false)
  self.switch2Btn:SetActive(false)
  self.battleBtn:SetActive(false)
  self.skipMask:SetActive(false)
  self.boomEffect:SetActive(false)
  self.blowEffect:SetActive(false)
  self.selfTalk:SetActive(false)
  self.tipText:SetActive(false)
  local msg = self.battleMsg
  if not msg then
    return
  end
  for i = 1, 3 do
    self.atkPlayerTeamsItem[i]:SetLocalScaleXYZ(1, 1, 1)
    self.defPlayerItems[i]:SetLocalScaleXYZ(1, 1, 1)
  end
  ResetDragAreaPos(self)
  self.battleSequence = CS.DG.Tweening.DOTween.Sequence()
  local defRemainBlood = 3
  local atkRemainBlood = 3
  for i = 1, 3 do
    local defTeamItem = self.defPlayerItems[i]
    local atkTeamItem = self.atkPlayerTeamsItem[i]
    local isWin = false
    local mailValid = false
    local mailData = DataCenter.MailDataManager:GetMailInfoById(msg.battleArr[i].mailUid)
    if mailData then
      local ext = mailData:GetMailExt()
      if ext and ext.reportIntegrity then
        isWin = ext.attackerWin
        mailValid = true
      end
    end
    if not mailValid then
      local battleStateArr = msg.battleStateArr
      if battleStateArr then
        local res = battleStateArr[i] or 0
        isWin = res == 1
      end
    end
    defTeamItem:SetGray(isWin)
    atkTeamItem:SetGray(not isWin)
    self.battleSequence:AppendInterval(0.1)
    self.battleSequence:AppendCallback(function()
      local bloodCell
      if isWin then
        bloodCell = self.defplayerBloodTipCells[defRemainBlood]
        defRemainBlood = defRemainBlood - 1
      else
        bloodCell = self.atkplayerBloodTipCells[atkRemainBlood]
        atkRemainBlood = atkRemainBlood - 1
      end
      if bloodCell then
        bloodCell.transform:DOScale(Vector3(1.6, 1.6, 1), 0.1)
        bloodCell.unity_image:DOFade(0, 0.1)
      end
    end)
  end
  local isWin = msg.win
  if isWin then
    UIGray.SetGray(self.selfBg.transform, false, true, true)
    UIGray.SetGray(self.otherBg.transform, true, true, true)
  else
    UIGray.SetGray(self.selfBg.transform, true, true, true)
    UIGray.SetGray(self.otherBg.transform, false, true, true)
  end
  local randomDialog = GetRandomDialog(self, isWin)
  if not string.IsNullOrEmpty(randomDialog) then
    self.trashTalk:SetActive(true)
    self.trashTalk:FadeIn()
    self.trashTalkText:SetText(randomDialog)
  end
  self.battleSequence:AppendInterval(1)
  self.battleSequence:AppendCallback(function()
    local selfPlayerInfo = DataCenter.LW3V3Manager:PackSelfPlayerInfo()
    selfPlayerInfo.lastRank = DataCenter.LW3V3ArenaManager.lastSelfRank
    selfPlayerInfo.curRank = DataCenter.LW3V3ArenaManager.selfRank
    local otherPlayerInfo = DataCenter.LW3V3Manager.opponentData.playerInfo
    if msg.type3v3 == Type3v3.Train then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain3V3BattleResult, {anim = false}, msg, selfPlayerInfo, otherPlayerInfo)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIArena3V3BattleResult, {anim = false}, msg, selfPlayerInfo, otherPlayerInfo)
    end
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
  end)
end

local function OnBattleFinish(self, msg)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWPVPArenaMain)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
  PlayBattleAnim(self, msg)
end

function UILW3V3CampaignView:OnRobTrainTryRefreshView(uuid)
  if self.opponentData and self.opponentData.trainData and self.opponentData.trainData.uuid == uuid then
    self:Refresh()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.Arena3V3BattleFinish, self.OnBattleFinish)
  self:AddUIListener(EventId.RobTrainTryRefreshView, self.OnRobTrainTryRefreshView)
  self:AddUIListener(EventId.Arena3V3BattleFinishError, self.OnBattleError)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.Arena3V3BattleFinish, self.OnBattleFinish)
  self:RemoveUIListener(EventId.RobTrainTryRefreshView, self.OnRobTrainTryRefreshView)
  self:RemoveUIListener(EventId.Arena3V3BattleFinishError, self.OnBattleError)
  base.OnRemoveListener(self)
end

local function OnBattleError(self)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
end

function UILW3V3CampaignView:Open3V3BattleScene(index)
  local param = {}
  param.type = PVEType.Arena3V3
  param.enterType = PVEEnterType.Arena3V3
  param.levelId = -1
  param.sceneId = 51
  param.extraData = {}
  param.extraData.squadIndex = index or 1
  param.extraData.openWindow = false
  DataCenter.LWBattleManager:Enter(param)
end

UILW3V3CampaignView.OnCreate = OnCreate
UILW3V3CampaignView.OnDestroy = OnDestroy
UILW3V3CampaignView.OnEnable = OnEnable
UILW3V3CampaignView.OnDisable = OnDisable
UILW3V3CampaignView.ComponentDefine = ComponentDefine
UILW3V3CampaignView.ComponentDestroy = ComponentDestroy
UILW3V3CampaignView.DataDefine = DataDefine
UILW3V3CampaignView.DataDestroy = DataDestroy
UILW3V3CampaignView.Refresh = Refresh
UILW3V3CampaignView.OnAddListener = OnAddListener
UILW3V3CampaignView.OnRemoveListener = OnRemoveListener
UILW3V3CampaignView.OnBattleFinish = OnBattleFinish
UILW3V3CampaignView.ResetAnimState = ResetAnimState
UILW3V3CampaignView.SkipBattleAnim = SkipBattleAnim
UILW3V3CampaignView.OnBattleError = OnBattleError
return UILW3V3CampaignView
