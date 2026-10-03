local UICommonHead = BaseClass("UICommonHead", UIBaseContainer)
local base = UIBaseContainer
local closeLoadingTime = 10
local isActiveAnonymityUid = "-1"
local WerewolfUid = "-2"

function UICommonHead:ComponentDefine()
  local head = self.transform:Find("HeadIcon")
  local loading = self.transform:Find("Imgloading")
  if loading then
    self.loading_img = self:AddComponent(UIImage, "Imgloading")
    self.loading_img:SetActive(false)
  end
  self.uiPlayerHead = head:GetComponent(typeof(CS.UIPlayerHead))
  self.circleImage = head:GetComponent(typeof(CS.CircleImage))
  self.frameBg = self:AddComponent(UIImage, "Foreground")
  self.headBtnRaycast = self:AddComponent(UIEmpty4Raycast, "")
  self.headBtn = self:AddComponent(UIButton, "")
  self.headBtn:SetOnClick(function()
    self:OnHeadClick()
  end)
  self.countryFlag = self:AddComponent(UIImage, "countryFlag")
  self.frameBg:SetActive(true)
end

function UICommonHead:ComponentDestroy()
  if not IsNull(self.uiPlayerHead) then
    self.uiPlayerHead:SetCustomLoadCallback(nil)
  end
  self.clickCallbackFun = nil
  self.uiPlayerHead = nil
  self.circleImage = nil
  self.frameBg = nil
  self.headBtn = nil
  self.countryFlag = nil
end

function UICommonHead:DataDefine()
  self.clickCallbackFun = nil
end

function UICommonHead:DataDestroy()
  self.clickCallbackFun = nil
  self.playerUid = nil
  self.picVer = nil
  self.pic = nil
  if self.loading_img and not IsNull(self.loading_img.gameObject) then
    self:HideLoadingAinmation()
  end
end

function UICommonHead:GetIsSystemHead()
  if not self.picVer then
    self.picVer = 0
  end
  return not string.IsNullOrEmpty(self.pic) or self.picVer <= 0 or self.picVer > 1000000
end

function UICommonHead:ShowLoadingAinmation()
  if self.loading_img and not IsNull(self.loading_img.gameObject) then
    self.loading_img:SetActive(true)
    if self.closeLoadingAction then
      self.closeLoadingAction:Stop()
      self.closeLoadingAction = nil
    else
      self.closeLoadingAction = TimerManager:GetInstance():DelayInvoke(function()
        if self.loading_img and not IsNull(self.loading_img.gameObject) then
          self.loading_img:SetActive(false)
        end
      end, closeLoadingTime)
    end
  end
end

function UICommonHead:HideLoadingAinmation()
  if self.closeLoadingAction then
    self.closeLoadingAction:Stop()
    self.closeLoadingAction = nil
  end
  if self.loading_img and not IsNull(self.loading_img.gameObject) then
    self.loading_img:SetActive(false)
  end
end

function UICommonHead:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
  self.__loadHeadCallback = nil
end

function UICommonHead:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UICommonHead:OnEnable()
  base.OnEnable(self)
end

function UICommonHead:OnDisable()
  base.OnDisable(self)
end

function UICommonHead:OnAddListener()
end

function UICommonHead:OnRemoveListener()
end

function UICommonHead:SetHead(uid, pic, picVer, useBig, headFramePath)
  if useBig == nil then
    useBig = false
  end
  self.playerUid = uid
  self.picVer = picVer
  self.pic = pic
  if uid then
    local specifiedRes
    if pic and pic ~= "" and type(pic) == "string" then
      local pic1, pic2 = string.match(pic, "(Assets/Main/.*)(Assets/Main/.*)")
      if pic1 and pic2 then
        specifiedRes = pic2
      elseif string.startswith(pic, "Assets/Main/") then
        specifiedRes = pic
      end
    end
    if specifiedRes then
      self.uiPlayerHead:UseSpecifiedRes(specifiedRes)
    elseif not pic and not picVer then
      self.uiPlayerHead:UseSystemHead()
    else
      self.uiPlayerHead:SetData(uid, pic, tonumber(picVer), useBig)
    end
  elseif pic and pic ~= "" and type(pic) == "string" and string.startswith(pic, "Assets/Main/") then
    self.uiPlayerHead:UseSpecifiedRes(pic)
    self:HideLoadingAinmation()
  elseif pic and pic ~= "" and type(pic) == "string" and string.startswith(pic, "player_head_") then
    self.uiPlayerHead:SetData("", pic, 0, false)
    self:HideLoadingAinmation()
  else
    self.uiPlayerHead:UseSystemHead()
    self:HideLoadingAinmation()
  end
  if self.frameBg then
    if not string.IsNullOrEmpty(headFramePath) then
      self.frameBg:LoadSpriteAuto(headFramePath)
    else
      self.frameBg:LoadSpriteAuto(DefaultHeadFramePath)
    end
  end
  self.countryFlag:SetActive(false)
end

function UICommonHead:SetFrameActive(isActive)
  if self.frameBg then
    self.frameBg:SetActive(isActive)
  end
end

function UICommonHead:SetAsMyself()
  local player = LuaEntry.Player
  local userPic = player:GetPic() or ""
  local userPicVer = player.picVer or 0
  self:SetData(player:GetUid(), userPic, userPicVer, nil, player:GetHeadBgImg())
end

function UICommonHead:SetData(uid, pic, picVer, useBig, headFramePath)
  self:SetHead(uid, pic, picVer, useBig, headFramePath)
end

function UICommonHead:SetHeadAndFrame(uid, pic, picVer, useBig, headSkinId, headSkinET)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(headSkinId, headSkinET)
  self:SetHead(uid, pic, picVer, useBig, headBgImg)
end

function UICommonHead:SetIsCircle(isCircle)
  self.circleImage.isCircle = isCircle
end

function UICommonHead:SetEnableClickShowInfo(status, notHideTop)
  self.enableClickShowInfo = status
  self.hideTopWhenClick = not notHideTop
  if self.headBtn then
    self.headBtn:SetInteractable(self.enableClickShowInfo)
  end
  if self.headBtnRaycast ~= nil then
    self.headBtnRaycast:SetEnable(not not status)
  end
end

function UICommonHead:OnHeadClick()
  if self.clickCallbackFun ~= nil and type(self.clickCallbackFun) == "function" then
    CommonUtil.ProtectCall(function()
      self.clickCallbackFun()
    end)
  elseif self.enableClickShowInfo == true and self.playerUid ~= nil then
    if self.playerUid == LuaEntry.Player.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
        anim = true,
        hideTop = self.hideTopWhenClick
      }, self.playerUid)
    else
      if self.playerUid == isActiveAnonymityUid then
        UIUtil.ShowTipsId("season_mastery_174")
        return
      elseif self.playerUid == WerewolfUid then
        UIUtil.ShowTipsId("season_s4_activity_1200011_desc7")
        return
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.playerUid)
    end
  end
end

function UICommonHead:SetFlag(country)
  if LuaEntry.Player:IsFromBIGCHINAorUsingLangZH() then
    self.countryFlag:SetActive(false)
    return
  end
  local _country = string.IsNullOrEmpty(country) and DefaultNation or country
  local template = DataCenter.NationTemplateManager:GetNationTemplate(_country)
  if template == nil then
    self.countryFlag:SetActive(false)
  elseif not LuaEntry.GlobalData:IsChina() then
    self.countryFlag:SetActive(true)
    self.countryFlag:LoadSprite(template:GetNationFlagPath())
  else
    self.countryFlag:SetActive(false)
  end
end

function UICommonHead:UseSpecifiedRes(imgPath)
  if imgPath then
    self.uiPlayerHead:UseSpecifiedRes(imgPath)
    self:HideLoadingAinmation()
  end
end

function UICommonHead:ShowMummyIcon()
  self.uiPlayerHead:UseSpecifiedRes("Assets/Main/SeasonRes/Shared/Sprites/UIMummy/ljq_saijis3_huanxing_munaiyi.png")
  self:HideLoadingAinmation()
end

function UICommonHead:ParseHeadInfo(cfg, ignoreHeadSkin)
  if cfg then
    if cfg.wolfEndTime then
      local wolfEndTime = toInt(cfg.wolfEndTime)
      if 0 < wolfEndTime and UITimeManager:GetInstance():GetServerTime() < tonumber(wolfEndTime) then
        self:ShowWerewolf()
        return
      end
    end
    if cfg.isActiveAnonymity then
      self:SetHead(isActiveAnonymityUid)
    else
      local headBgImg = cfg.frameBg
      if ignoreHeadSkin == true then
        headBgImg = nil
      else
        if headBgImg == nil and cfg.headSkinId then
          headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(cfg.headSkinId, cfg.headSkinET)
        end
        if headBgImg == nil and cfg.tHeadSkinId then
          headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(cfg.tHeadSkinId, cfg.tHeadSkinET)
        end
      end
      self:SetHead(cfg.uid or cfg.ownerUid or cfg.Uid or cfg.tUid, cfg.pic or cfg.headPic or cfg.tPic or "", cfg.picVer or cfg.headPicVer or cfg.picver or cfg.tPicVer or 0, nil, headBgImg)
    end
  end
end

function UICommonHead:SetCustomLoadCallback(callback)
  if not IsNull(self.uiPlayerHead) then
    self.uiPlayerHead:SetCustomLoadCallback(callback)
  end
end

function UICommonHead:SetCustomClickCallback(callback)
  self.clickCallbackFun = callback
end

function UICommonHead:ShowWerewolf()
  self:SetHead(WerewolfUid, WerewolfHeadPic)
end

return UICommonHead
