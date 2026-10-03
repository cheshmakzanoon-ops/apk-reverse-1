local UIServerItemCell = BaseClass("UIServerItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIServerItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIServerItemCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIServerItemCell:OnEnable()
  base.OnEnable(self)
end

function UIServerItemCell:OnDisable()
  base.OnDisable(self)
end

function UIServerItemCell:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self._serverName_txt = self:AddComponent(UIText, "Txt_ServerName")
  self._serverState_img = self:AddComponent(UIImage, "Img_ServerState")
  self._new_img = self:AddComponent(UIBaseContainer, "NewDot")
  self.head_obj = self:AddComponent(UIBaseContainer, "PlayerBtn")
  self.headIconN = self:AddComponent(UICommonHead, "PlayerBtn/UIPlayerHead")
  self.headLevel = self:AddComponent(UIText, "PlayerBtn/LevelBg/LevelText")
end

function UIServerItemCell:ComponentDestroy()
  self.btn = nil
  self._serverName_txt = nil
  self._serverState_img = nil
  self._new_img = nil
  self.head_obj = nil
  self.headIconN = nil
  self.headLevel = nil
end

function UIServerItemCell:DataDefine()
  self.param = {}
end

function UIServerItemCell:DataDestroy()
  self.param = nil
end

function UIServerItemCell:ReInit(param)
  self.param = param
  self._serverName_txt:SetText(Localization:GetString("208236", param.id))
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local openTime = param.openTime
  local deltaTime = curTime - openTime
  local k1 = LuaEntry.DataConfig:TryGetNum("server_population", "k2")
  local checkTime = k1 * 24 * 60 * 60 * 1000
  if deltaTime < checkTime then
    self._new_img:SetActive(true)
    self._serverState_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_img_green_dot.png")
  else
    self._new_img:SetActive(false)
    self._serverState_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/UIBuild_red dot.png")
  end
  local playerParam
  local list = DataCenter.AccountManager:GetRolesList()
  self.uidList = {}
  if list ~= nil then
    for k, v in pairs(list) do
      if playerParam == nil and tostring(v.id) == tostring(param.id) then
        playerParam = v
      end
      if v ~= nil and v.gameUid ~= nil and v.gameUid ~= "" then
        self.uidList[tostring(v.id)] = v.gameUid
      end
    end
  end
  if playerParam ~= nil then
    self.head_obj:SetActive(true)
    local headBg = DataCenter.DecorationDataManager:GetHeadFrame(playerParam.headSkinId, playerParam.headSkinET, false)
    self.headIconN:SetData(playerParam.gameUid, playerParam.pic, playerParam.picVer, nil, headBg)
    if not string.IsNullOrEmpty(playerParam.gameUserLevel) then
      self.headLevel:SetText(playerParam.gameUserLevel)
    else
      self.headLevel:SetText("")
    end
  else
    self.head_obj:SetActive(false)
  end
end

function UIServerItemCell:OnBtnClick()
  if tonumber(self.param.status) ~= 0 then
    UIUtil.ShowTipsId(129012)
    return
  end
  if LuaEntry.Player.gmFlag == 1 then
    if self.param ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoleCreate, {anim = true}, self.param)
    end
  elseif self.param ~= nil and self.param.id ~= LuaEntry.Player.serverId and self.uidList[tostring(self.param.id)] == nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoleCreate, {anim = true}, self.param)
  else
    UIUtil.ShowTipsId(120624)
  end
end

return UIServerItemCell
