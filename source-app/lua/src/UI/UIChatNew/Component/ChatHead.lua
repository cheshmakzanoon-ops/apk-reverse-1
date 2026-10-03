local ChatHead = BaseClass("ChatHead", UIBaseContainer)
local base = UIBaseContainer
local _cp_headImg = "Image"
local _cp_headBtn = "HeadBtn"
local _cp_headFg = "Foreground"
local _cp_countryFlag = "countryFlag"
local _cp_AI_head = "ImageAI"

function ChatHead:ComponentDefine()
  self._headImg = self.transform:Find(_cp_headImg):GetComponent(typeof(CS.UIPlayerHead))
  self._headImgGoWrap = UIGameObjectWrap.new(self._headImg.gameObject)
  if self._headImg ~= nil then
    if IsNull(self._headImg) then
      self.chatGameObjectIsNull = 1
    else
      self.chatGameObjectIsNull = 0
    end
    self.chatIsNull = 0
  else
    self.chatIsNull = 1
    self.chatGameObjectIsNull = 1
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.chatCreateTime = curTime
  self._imgUser = self:AddComponent(UIImage, _cp_headImg)
  self._imgCircleUser = self:AddComponent(CircleImage, _cp_headImg)
  self._chatHeadFg = self:AddComponent(UIImage, _cp_headFg)
  self._countryFlag = self:AddComponent(UIImage, _cp_countryFlag)
  self._headBtn = self:AddComponent(UIButton, _cp_headBtn)
  self._headBtn:SetOnClick(function()
    if self.canClick then
      self:OnClickBtn()
    end
  end)
  if self.transform:Find(_cp_AI_head) ~= nil then
    self._imgAI = self:AddComponent(UIImage, _cp_AI_head)
  end
  self.canClick = true
end

function ChatHead:SetCanClick(isOn)
  self.canClick = isOn
end

function ChatHead:DataDefine()
  self.chatCreateTime = 0
  self.chatIsNull = 1
  self.chatGameObjectIsNull = 1
  self.chatDestroyTime = 0
  self._chatdata = nil
  self._userInfo = nil
  self._lastUid = nil
  self._lastPic = nil
  self._lastPicVer = nil
end

function ChatHead:OnDestroy()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.chatDestroyTime = curTime
  base.OnDestroy(self)
end

function ChatHead:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ChatHead:OnEnable()
  base.OnEnable(self)
end

function ChatHead:OnDisable()
  base.OnDisable(self)
end

function ChatHead:OnAddListener()
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.UpdateHeadAfterCmdRecv)
end

function ChatHead:OnRemoveListener()
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.UpdateHeadAfterCmdRecv)
end

function ChatHead:ReInit(param)
  self._userInfo = param
  self._chatdata = nil
  self.canClick = true
  self._countryFlag:SetActive(false)
  self._chatHeadFg:SetActive(false)
  if self._imgAI ~= nil then
    if not IsNull(self._headImg.gameObject) then
      self._headImgGoWrap:SetActive(true)
    end
    self._imgAI:SetActive(false)
  end
  if self._userInfo ~= nil then
    local userId = self._userInfo.uid or ""
    local userPic = self._userInfo.headPic or ""
    if self._userInfo:IsGmUser() then
      userPic = self._userInfo:GetGMIcon()
    end
    local userPicVer = self._userInfo.headPicVer or 0
    self._headImg:SetData(userId, userPic, userPicVer)
  else
    self._headImg:UseSystemHead()
  end
end

function ChatHead:UpdateForAI(chatdata, character)
  self._userInfo = nil
  self._chatdata = chatdata
  self._countryFlag:SetActive(false)
  self._chatHeadFg:SetActive(false)
  if self._imgAI ~= nil then
    if not IsNull(self._headImg.gameObject) then
      self._headImgGoWrap:SetActive(false)
    end
    self._imgAI:SetActive(true)
    self._imgAI:LoadSprite(character:GetHeadIconPath())
  end
end

function ChatHead:UpdateHead(userinfo, chatdata)
  self._userInfo = userinfo
  self._chatdata = chatdata
  self:__UpdateHead()
  self:CheckVipFrame()
  self:ShowCountryFlag()
  if self._imgAI ~= nil then
    if not IsNull(self._headImg.gameObject) then
      self._headImgGoWrap:SetActive(true)
    end
    self._imgAI:SetActive(false)
  end
end

function ChatHead:CheckVipFrame()
  if self._chatdata == nil or self._chatdata.isFromAI ~= nil and self._chatdata:isFromAI() then
    self._chatHeadFg:SetActive(false)
    return
  end
  if self._chatHeadFg then
    if self._userInfo then
      local tempFg = self._userInfo:GetHeadBgImg()
      self._chatHeadFg:SetActive(true)
      if tempFg then
        self._chatHeadFg:LoadSprite(tempFg)
      else
        self._chatHeadFg:LoadSprite(DefaultHeadFramePath)
      end
    else
      self._chatHeadFg:SetActive(false)
    end
  end
end

function ChatHead:ShowCountryFlag()
  if self._chatdata == nil or self._chatdata.isFromAI ~= nil and self._chatdata:isFromAI() or LuaEntry.Player:IsFromBIGCHINAorUsingLangZH() then
    self._countryFlag:SetActive(false)
    return
  end
  if self._userInfo and self._userInfo.uid ~= ChatGMUserId then
    local tempNation = self._userInfo and self._userInfo.nation or DefaultNation
    if not LuaEntry.GlobalData:IsChina() then
      self._countryFlag:SetActive(true)
      local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(tempNation)
      local flagPath = nationTemplate:GetNationFlagPath()
      self._countryFlag:LoadSprite(flagPath)
    else
      self._countryFlag:SetActive(false)
    end
  else
    self._countryFlag:SetActive(false)
  end
end

function ChatHead:__UpdateHead()
  if self._chatdata == nil or self._chatdata.isFromAI ~= nil and self._chatdata:isFromAI() then
    return
  end
  if self._userInfo ~= nil then
    local userId = self._userInfo.uid or ""
    local userPic = self._userInfo.headPic or ""
    if self._userInfo:IsGmUser() then
      userPic = self._userInfo:GetGMIcon()
    end
    local userPicVer = self._userInfo.headPicVer or 0
    self._headImg:SetData(userId, userPic, userPicVer)
  else
    self._headImg:UseSystemHead()
  end
end

function ChatHead:ShowGmImage()
  if self._chatdata == nil or self._chatdata.isFromAI ~= nil and self._chatdata:isFromAI() then
    return
  end
  if self._imgUser ~= nil and self._imgUser.unity_image ~= nil then
    self._imgUser:LoadSprite("Assets/Main/Sprites/UI/UIHeadIcon/player_head_1.png")
  elseif self._imgCircleUser ~= nil and self._imgCircleUser.unity_image ~= nil then
    self._imgCircleUser:LoadSprite("Assets/Main/Sprites/UI/UIHeadIcon/player_head_1.png")
  end
end

function ChatHead:UpdateHeadAfterCmdRecv()
  if self._chatdata == nil or self._chatdata.isFromAI ~= nil and self._chatdata:isFromAI() then
    return
  end
  self:__UpdateHead()
end

function ChatHead:OnClickBtn()
  if not self.view then
    return
  end
  if self.view._isAnim then
    return
  end
  if self.view._isLeft then
    self.view:SlideRight()
    return
  end
  if self._chatdata == nil or self._userInfo == nil then
    return
  end
  if self._chatdata == nil or self._chatdata.isFromAI ~= nil and self._chatdata:isFromAI() then
    return
  end
  local playerUid = self._userInfo.uid
  if string.IsNullOrEmpty(playerUid) then
    return
  end
  if playerUid == ChatGMUserId then
    return
  end
  if playerUid == ChatInterface.getPlayerUid() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, playerUid)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, playerUid, self._chatdata)
  local param = {}
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MAIN_VIEW_STOP_MOVEMENT)
end

return ChatHead
