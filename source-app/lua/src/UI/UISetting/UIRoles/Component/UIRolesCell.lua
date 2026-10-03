local UIRolesCell = BaseClass("UIRolesCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIRolesCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIRolesCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIRolesCell:OnEnable()
  base.OnEnable(self)
end

function UIRolesCell:OnDisable()
  base.OnDisable(self)
end

function UIRolesCell:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self._server_txt = self:AddComponent(UIText, "Rect_Normal/Content/Txt_Server")
  self._name_txt = self:AddComponent(UIText, "Rect_Normal/Txt_Name")
  self._power_txt = self:AddComponent(UIText, "Rect_Normal/Content/Txt_Power")
  self._curAccount_img = self:AddComponent(UIImage, "Rect_Normal/Img_CurAccount")
  self._normal_rect = self:AddComponent(UIBaseContainer, "Rect_Normal")
  self._createNew_rect = self:AddComponent(UIBaseContainer, "Rect_CreateNew")
  self._createNew_txt = self:AddComponent(UIText, "Rect_CreateNew/Txt_CreateNew")
  self._createNewTips_txt = self:AddComponent(UIText, "Rect_CreateNew/Txt_CreateNewTips")
  self.player_head = self:AddComponent(UIPlayerHead, "Rect_Normal/PlayerBtn/UIPlayerHead/HeadIcon")
  self.playerHeadFg = self:AddComponent(UIImage, "Rect_Normal/PlayerBtn/UIPlayerHead/frameBg")
  self.player_level = self:AddComponent(UIText, "Rect_Normal/PlayerBtn/LevelBg/LevelText")
end

function UIRolesCell:ComponentDestroy()
  self.btn = nil
  self._server_txt = nil
  self._name_txt = nil
  self._power_txt = nil
  self.headIconN = nil
  self.headFgN = nil
  self._curAccount_img = nil
  self._createNew_rect = nil
  self._createNew_txt = nil
  self._createNewTips_txt = nil
end

function UIRolesCell:DataDefine()
  self.param = {}
end

function UIRolesCell:DataDestroy()
  self.param = nil
end

function UIRolesCell:ReInit(param)
  self.param = param
  if param.isEmpty then
    self._createNew_rect:SetActive(true)
    self._normal_rect:SetActive(false)
    self._createNew_txt:SetLocalText(208226)
    local num = LuaEntry.DataConfig:TryGetNum("server_population", "k1")
    self._createNewTips_txt:SetLocalText(208227, num)
  else
    self._createNew_rect:SetActive(false)
    self._normal_rect:SetActive(true)
    if param.alAbbr ~= nil and param.alAbbr ~= "" then
      self._name_txt:SetText("[" .. param.alAbbr .. "]" .. param.gameUserName)
    else
      self._name_txt:SetText(param.gameUserName)
    end
    self._server_txt:SetLocalText(208236, param.id)
    self._power_txt:SetLocalText(100392, string.GetFormattedSeperatorNum(param.power))
    local uid = param.gameUid
    local pic = param.pic
    local picVer = param.picVer
    self.player_head:SetData(uid, pic, picVer)
    if not string.IsNullOrEmpty(param.gameUserLevel) then
      self.player_level:SetText(param.gameUserLevel)
    else
      self.player_level:SetText("")
    end
    self._curAccount_img:SetActive(param.gameUid == LuaEntry.Player.uid)
  end
end

function UIRolesCell:OnBtnClick()
  if self.param.gameUid == LuaEntry.Player.uid then
    return
  end
  if self.param.isEmpty then
    if CS.ShumeiSdkManager.Instance:IsForbidCreateRole() then
      CS.ShumeiSdkManager.Instance:GotoStoreToUpgrade()
      PostEventLog.Track("s_shu_mei_create_role_ban", {
        s_para1 = "low_version"
      })
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseServer, {anim = true, hideTop = true})
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoleLogin, {anim = true}, self.param)
end

return UIRolesCell
