local base = UIAsyncContainer
local UILLGroupInvitationMain = BaseClass("UILLGroupInvitationMain", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local LLServerItem = require("UI.Landlord.Main.Component.LLServerItem")
local ActMgr = DataCenter.LandlordMgr

function UILLGroupInvitationMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILLGroupInvitationMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLGroupInvitationMain:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compServer5 = self.viewSkin:AddComponent(self, LLServerItem, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.head = self.viewSkin:AddComponent(self, UICommonHead, 3)
  self.textLv = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textLeave = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compInputField = self.viewSkin:AddComponent(self, UIInput, 8)
  self.textInputCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.imgGiftIcon = self.viewSkin:AddComponent(self, UIImage, 10)
  self.btnGift = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnGift:SetOnClick(function()
    self:OnBtnGiftClick()
  end)
  self.textGitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.compArrow2 = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.btnGreen = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnGreen:SetOnClick(function()
    self:OnBtnGreenClick()
  end)
  self.compServer3 = self.viewSkin:AddComponent(self, LLServerItem, 15)
  self.compServer1 = self.viewSkin:AddComponent(self, LLServerItem, 16)
  self.compServer4 = self.viewSkin:AddComponent(self, LLServerItem, 17)
  self.compServer2 = self.viewSkin:AddComponent(self, LLServerItem, 18)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.compArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 20)
  self.compSuccess = self.viewSkin:AddComponent(self, UIBaseComponent, 21)
  self.sa = self.viewSkin:AddComponent(self, UISimpleAnimation, 22)
  self.imgGift = self.viewSkin:AddComponent(self, UIImage, 23)
  self.textMsg = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.scrollRectShowMsg = self.viewSkin:AddComponent(self, UIScrollRect, 25)
  self.compKingIcon = self.viewSkin:AddComponent(self, UIBaseComponent, 26)
  self.compServerList = {
    self.compServer1,
    self.compServer2,
    self.compServer3,
    self.compServer4,
    self.compServer5
  }
end

function UILLGroupInvitationMain:ComponentDestroy()
  self.viewSkin = nil
  self.compServer5 = nil
  self.btnClose = nil
  self.head = nil
  self.textLv = nil
  self.textName = nil
  self.textPower = nil
  self.textLeave = nil
  self.compInputField = nil
  self.textInputCount = nil
  self.imgGiftIcon = nil
  self.btnGift = nil
  self.textGitNum = nil
  self.compArrow2 = nil
  self.btnGreen = nil
  self.compServer3 = nil
  self.compServer1 = nil
  self.compServer4 = nil
  self.compServer2 = nil
  self.textDesc = nil
  self.compArrow = nil
  self.compSuccess = nil
  self.sa = nil
  self.imgGift = nil
  self.textMsg = nil
  self.scrollRectShowMsg = nil
  self.compKingIcon = nil
  self.compServerList = nil
end

function UILLGroupInvitationMain:DataDefine()
  self.maxCount = 60
  self.compInputField:SetText("")
  self:OnInputFieldChanged("")
  self.head:SetEnableClickShowInfo(true, true)
  self.compInputField:SetCharacterLimit(self.maxCount)
  self.compInputField:SetOnValueChange(function(value)
    self:OnInputFieldChanged(value)
  end)
  self.compInputField:SetOnEndEdit(function(value)
    self:OnInputFieldChanged(value)
  end)
end

function UILLGroupInvitationMain:DataDestroy()
  self:CleanArrowDelay()
  self.view = nil
  self.sInfo = nil
  self.isInvite = nil
  self.flying = nil
  self.lastClickTime = nil
end

function UILLGroupInvitationMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordServerInviteGiftInfo, self.RefreshGift)
  self:AddUIListener(EventId.LandlordServerInviteSuccess, self.FlyToClose)
end

function UILLGroupInvitationMain:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordServerInviteGiftInfo, self.RefreshGift)
  self:RemoveUIListener(EventId.LandlordServerInviteSuccess, self.FlyToClose)
  base.OnRemoveListener(self)
end

function UILLGroupInvitationMain:RealClose()
  if self.view and self.view.RealClose then
    self.view:RealClose()
  end
end

function UILLGroupInvitationMain:FlyToClose()
  if self.flying then
    return
  end
  local ret, time = self.sa:PlayAnimationReturnTime("close")
  if ret then
    self.flying = true
    TimerManager:GetInstance():DelayInvoke(function()
      self.flying = false
      self:RealClose()
    end, time)
  else
    self:RealClose()
  end
end

function UILLGroupInvitationMain:OnBtnCloseClick()
  if self.view and self.view.OnBtnCloseClick then
    self.view:OnBtnCloseClick()
  end
end

function UILLGroupInvitationMain:OnBtnGiftClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Send,
    fromType = GiftSystemConst.fromType.LLGroupInvitation
  })
end

function UILLGroupInvitationMain:OnBtnGreenClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not self.isInvite or self.flying then
    return
  end
  if self.lastClickTime ~= nil and UITimeManager:GetInstance():GetServerSeconds() - self.lastClickTime < 2 then
    return
  end
  local serverId = self.sInfo ~= nil and self.sInfo.serverId or 0
  local tipStr
  local param = {}
  param.serverId = serverId
  if self.giftId then
    param.giftId = self.giftId
    if self.giftNum then
      param.giftNum = self.giftNum
    end
  end
  local alignment = CS.UnityEngine.TextAnchor.MiddleCenter
  if param.giftNum and 0 < param.giftNum then
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.giftId)
    tipStr = Localization:GetString("zonewar_landlord_desc_1015", param.serverId, Localization:GetString(template.name), param.giftNum or 0)
    alignment = CommonUtil.IsArabicAutoMirrorOpen() and CS.UnityEngine.TextAnchor.MiddleRight or CS.UnityEngine.TextAnchor.MiddleLeft
  else
    tipStr = Localization:GetString("zonewar_landlord_desc_1017", param.serverId)
  end
  if self.giftContext ~= nil and not string.IsNullOrEmpty(self.giftContext) then
    param.giftContext = self.giftContext
  end
  local msg = string.trim(self.compInputField:GetText())
  if not string.IsNullOrEmpty(msg) then
    param.msg = msg
  end
  UIUtil.ShowSecondMessageByParam({
    tipText = tipStr,
    btnNum = 2,
    showToggle = false,
    alignment = alignment,
    delayConfirm = {delayTime = 5},
    sureAction = function()
      self.lastClickTime = UITimeManager:GetInstance():GetServerSeconds()
      ActMgr:ReqServerInvite(param)
      self:FlyToClose()
    end
  })
end

function UILLGroupInvitationMain:SetData(view, info)
  self.view = view
  self.sInfo = info.sInfo
  self.isInvite = info.isInvite
end

function UILLGroupInvitationMain:OnInputFieldChanged(value)
  self.textInputCount:SetText(string.format("%s/%s", string.word_count(value), self.maxCount))
end

function UILLGroupInvitationMain:UpdateData()
  self.sa:Play("Default")
  if self.sInfo == nil then
    return
  end
  self:RefreshServer()
  self:RefreshPlayer()
  self:RefreshMsg()
  self:RefreshGift()
  self.textInputCount:SetActive(self.isInvite)
  self.btnGreen:SetActive(self.isInvite)
  self.compSuccess:SetActive(not self.isInvite)
  self.textDesc:SetLocalText(self.isInvite and "zonewar_landlord_limit_1060" or "zonewar_landlord_limit_1061")
  if self.isInvite then
    self.sa:Play("Default")
  end
end

function UILLGroupInvitationMain:CleanArrowDelay()
  if self.arrowDelay then
    self.arrowDelay:Stop()
    self.arrowDelay = nil
  end
end

function UILLGroupInvitationMain:RefreshServer()
  local group
  if self.isInvite then
    group = ActMgr:GetMyGroup()
  else
    local sInfo = ActMgr:GetServerInfo(self.sInfo.serverId)
    group = sInfo ~= nil and sInfo.group or LLConst.LandLordGroup.NONE
  end
  local cnt = ActMgr:GetCampMaxTeammateCount(group, true)
  local sList = ActMgr:GetServersByGroup(group)
  local targetIdx = self.isInvite and 0 or 1
  if self.isInvite then
    local gpIdx = ActMgr:GetCurGroupPartIndex()
    if gpIdx == 1 then
      targetIdx = 2
    elseif gpIdx == 2 then
      targetIdx = sList[2] == nil and 2 or 3
    elseif gpIdx == 3 then
      targetIdx = 3
    end
  end
  local target = self.compServerList[targetIdx]
  self.compArrow:SetActive(false)
  self.compArrow2:SetActive(false)
  self.compKingIcon:SetActive(not self.isInvite)
  self:CleanArrowDelay()
  if target ~= nil then
    self.arrowDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.compArrow:SetActive(true)
      local x = target:GetLocalPositionXYZ()
      local _, y, z = self.compArrow:GetLocalPositionXYZ()
      self.compArrow:SetLocalPositionXYZ(x, y, z)
      self.compArrow2:SetActive(self.isInvite)
      if self.isInvite then
        _, y, z = self.compArrow2:GetLocalPositionXYZ()
        self.compArrow2:SetLocalPositionXYZ(x, y, z)
      end
    end, 1)
  end
  for i, v in ipairs(self.compServerList) do
    v:SetActive(cnt >= i)
    if cnt >= i then
      local info = sList[i]
      if info ~= nil then
        v:SetServer(info, group, LLConst.LandlordStage.PREPARE)
        if i == 1 and not self.isInvite then
          v:HideTop()
          v:ShowMore(false)
        end
      else
        v:SetServer()
        v:ShowMore(true)
      end
    end
  end
end

function UILLGroupInvitationMain:RefreshPlayer()
  if self.sInfo == nil then
    return
  end
  local king = self.sInfo.king
  if king ~= nil then
    local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(king.headSkinId, king.headSkinET)
    if not string.IsNullOrEmpty(headBgImg) and not string.startswith(headBgImg, "Assets/") then
      headBgImg = ""
    end
    self.head:SetHead(king.uid, king.pic, king.picVer, false, headBgImg)
    self.textName:SetText(UIUtil.FormatServerAllianceName(self.sInfo.serverId, king.abbr, king.name, king.uid))
    self.textPower:SetText(string.GetFormattedSeparatorNum(king.power or 0))
  else
    self.head:SetHead()
    self.textName:SetText("")
    self.textPower:SetText("0")
  end
end

function UILLGroupInvitationMain:RefreshMsg()
  if self.isInvite then
    self.textLeave:SetLocalText("zonewar_landlord_limit_1042")
  else
    local kingName = ""
    local king2 = self.sInfo.king2
    if not table.IsNullOrEmpty(king2) then
      kingName = UIUtil.FormatAllianceAndName("", king2.name, king2.uid)
    end
    self.textLeave:SetLocalText("zonewar_landlord_limit_1088", kingName)
  end
  self.compInputField:SetActive(self.isInvite)
  self.scrollRectShowMsg:SetActive(not self.isInvite)
  local msg = self.sInfo ~= nil and self.sInfo.msg or ""
  if self.isInvite then
    self.compInputField:SetText(msg)
  else
    if string.IsNullOrEmpty(msg) then
      msg = Localization:GetString("zonewar_landlord_desc_1016")
    end
    self.textMsg:SetText(msg)
    self.scrollRectShowMsg:SetVerticalNormalizedPosition(1)
  end
end

function UILLGroupInvitationMain:RefreshGift(info)
  self.btnGift:SetInteractable(self.isInvite)
  local itemId = self.sInfo ~= nil and self.sInfo.giftId or 0
  local num = self.sInfo ~= nil and self.sInfo.giftNum or 0
  local itemTemplate
  if self.isInvite then
    if info ~= nil then
      self.giftId = info.template.id
      self.giftNum = info.num
      self.giftContext = info.context
      itemTemplate = info.template
      num = info.num
    end
  else
    itemTemplate = DataCenter.ItemTemplateManager:TryGetItemTemplate(itemId)
  end
  local showGift = true
  if itemTemplate then
    local bgImg = LLConst.GiftBG[itemTemplate.color]
    if string.IsNullOrEmpty(bgImg) then
      bgImg = LLConst.GiftBG_EMPTY
    end
    self.imgGift:LoadSpriteAuto(string.format(LoadPath.LandlordPath, bgImg))
    self.imgGiftIcon:SetActive(true)
    self.imgGiftIcon:LoadSpriteAuto(string.format(LoadPath.ItemPath, itemTemplate.icon))
    if 0 < num then
      self.textGitNum:SetText("\195\151" .. num)
    else
      self.textGitNum:SetText("")
    end
  elseif self.isInvite then
    self.imgGift:LoadSpriteAuto(string.format(LoadPath.LandlordPath, LLConst.GiftBG_EMPTY))
    self.imgGiftIcon:SetActive(false)
    self.textGitNum:SetText("")
  else
    showGift = false
  end
  self.imgGift:SetActive(showGift)
  self.compInputField:SetSizeDeltaX(showGift and 404 or 554)
  local w = showGift and 384 or 534
  self.scrollRectShowMsg:SetSizeDeltaX(w)
  self.textMsg:SetSizeDeltaX(w)
  return showGift
end

return UILLGroupInvitationMain
