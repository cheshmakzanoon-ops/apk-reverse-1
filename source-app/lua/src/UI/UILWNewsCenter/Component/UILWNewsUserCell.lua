local UILWNewsUserCell = BaseClass("UILWNewsUserCell", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "HeadBtn",
    name = "btnHead",
    type = UIButton
  },
  {
    path = "Image",
    name = "imgHead",
    type = UIImage
  },
  {
    path = "Foreground",
    name = "imgBorder",
    type = UIImage
  },
  {
    path = "countryFlag",
    name = "imgFlag",
    type = UIImage
  }
}

function UILWNewsUserCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.UpdatePlayerHead)
end

function UILWNewsUserCell:OnDestroy()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.UpdatePlayerHead)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWNewsUserCell:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.compPlayerHead = self.imgHead.gameObject:GetComponent(typeof(CS.UIPlayerHead))
  self.btnHead:SetOnClick(function()
    self:OnClickBtn()
  end)
end

function UILWNewsUserCell:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UILWNewsUserCell:Refresh(userId, userPic, userPicVer, headSkinId, headSkinET, country)
  self.userId = userId
  if userPic and userPicVer then
    self.compPlayerHead:SetData(userId, userPic, userPicVer)
    local frameImg = DataCenter.DecorationDataManager:GetHeadFrame(headSkinId, headSkinET)
    self.imgBorder:LoadSprite(frameImg or DefaultHeadFramePath or "")
  else
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(userId, true)
    if info then
      self.compPlayerHead:SetData(userId, info.pic, info.picVer)
      self.imgBorder:LoadSprite(info:GetHeadBgImg() or DefaultHeadFramePath or "")
    else
      SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, userId)
    end
  end
  if country and not LuaEntry.Player:IsFromBIGCHINAorUsingLangZH() then
    self.imgFlag:SetActive(true)
    local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(country)
    local flagPath = nationTemplate:GetNationFlagPath()
    self.imgFlag:LoadSprite(flagPath)
  else
    self.imgFlag:SetActive(false)
  end
end

function UILWNewsUserCell:OnClickBtn()
  if string.IsNullOrEmpty(self.userId) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.userId)
end

function UILWNewsUserCell:UpdatePlayerHead(uid)
  if uid ~= self.userId then
    return
  end
  local userinfo = ChatInterface.getUserData(uid, true)
  if userinfo ~= nil then
    local userPic = userinfo.headPic or ""
    local userPicVer = userinfo.headPicVer or 0
    self.compPlayerHead:SetData(uid, userPic, userPicVer)
    self.imgBorder:LoadSprite(userinfo:GetHeadBgImg() or DefaultHeadFramePath or "")
  end
end

return UILWNewsUserCell
