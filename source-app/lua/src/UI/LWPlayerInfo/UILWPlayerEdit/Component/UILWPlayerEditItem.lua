local UILWPlayerEditItem = BaseClass("UILWPlayerEditItem", UIToggle)
local base = UIToggle
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local lastUpdateTime = 0

function UILWPlayerEditItem:OnCreate()
  base.OnCreate(self)
  self.photo_btn = self:AddComponent(UIImage, "PhotoBtn")
  self.icon = self:AddComponent(UIPlayerHead, "PhotoBtn/icon")
  self.photo_bg = self:AddComponent(UIImage, "PhotoBtn/PhotoBg")
  self.selectImg = self:AddComponent(UIImage, "Select")
  self.bg = self:AddComponent(UIImage, "Bg")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "Bg/desc")
  self.btnDelete = self:AddComponent(UIButton, "Bg/BtnDelete")
  self.btnDelete:SetActive(false)
  self.desc:SetText("")
  self.desc:SetActive(true)
  local group = self.gameObject:GetComponentInParent(typeof(CS.UnityEngine.UI.ToggleGroup))
  self:SetGroup(group)
  self:SetOnValueChanged(function(isOn)
    if self.initFinish then
      if isOn then
        if self.empty then
          self:SetIsOn(false)
        end
        self:OnGotoClick()
      elseif not self.empty and not isOn then
        self.view:CheckSelectHeadIcon()
      end
    end
  end)
  self.btnDelete:SetOnClick(function()
    if self.slotId ~= nil and self.slotId ~= 0 then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      UIUtil.ShowMessage(Localization:GetString("avatar_tips007"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        if self.btnDelete then
          self.btnDelete:SetActive(false)
        end
        SFSNetwork.SendMessage(MsgDefines.NotifyPhotoAlbumDelete, self.slotId)
      end)
    end
  end)
  self.initFinish = false
end

function UILWPlayerEditItem:OnDestroy()
  base.OnDestroy(self)
end

function UILWPlayerEditItem:ReInit(slotIndex, pic, picVer)
  self.initFinish = false
  self.pic = pic
  self.picVer = picVer
  self.slotId = slotIndex
  if pic then
    if pic == LuaEntry.Player.pic then
      self:SetIsOn(true)
      self.desc:SetLocalText(128133)
    else
      self:SetIsOn(false)
      self.desc:SetText("")
    end
    self.btnDelete:SetActive(false)
    self.icon:UseSpecifiedRes("Assets/Main/Sprites/UI/UIHeadIcon/" .. pic)
    self.empty = false
  elseif toInt(picVer) > 0 then
    if picVer == LuaEntry.Player:GetPicVer() then
      self:SetIsOn(true)
      if string.IsNullOrEmpty(LuaEntry.Player.pic) then
        self.desc:SetLocalText(128133)
      else
        self.desc:SetText("")
      end
    else
      self:SetIsOn(false)
      self.desc:SetText("")
    end
    self.btnDelete:SetActive(true)
    self.icon:SetData(LuaEntry.Player.uid, pic, picVer)
    self.empty = false
  else
    self:SetIsOn(false)
    self.desc:SetText("")
    self.btnDelete:SetActive(false)
    self.empty = true
    self.icon:UseSpecifiedRes("Assets/Main/Sprites/UI/UISet/New/zyf_touxiang_shaungchuantouxiang.png")
  end
  self.initFinish = true
end

function UILWPlayerEditItem:HideDeleteBtn()
  self.btnDelete:SetActive(false)
end

function UILWPlayerEditItem:OnGotoClick()
  if self.empty then
    if LuaEntry.Player.modfiyPicStatus == true then
      local now = UITimeManager:GetInstance():GetServerTime()
      if LuaEntry.Player:IsPicUploading() and now - lastUpdateTime < 7000 then
        UIUtil.ShowTipsId("avatar_tips011")
        return
      end
      lastUpdateTime = now
      LuaEntry.GlobalData.serverPicSlotId = self.slotId
      if toInt(LuaEntry.GlobalData.serverPicVer) <= 0 then
        SFSNetwork.SendMessage(MsgDefines.FetchNewPicVer, FetchPicVerFuncType.PlayerHeadIcon)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerHeadIconSelect, {anim = true})
      end
    else
      local curData = DataCenter.MonopolyManager.dataManager:GetCurData()
      local level = LuaEntry.DataConfig:TryGetNum("uploadAvatar_active", "k1")
      if DataCenter.MonopolyManager:GetIsEnd() or curData and level < curData.id then
        GoToUtil.GotoOpenView(UIWindowNames.UIFirstPay, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllHide
        }, {delay = 0.1})
        return
      end
      local monopolyTemplate = DataCenter.MonopolyManager.dataManager:GetTemplate(level)
      if not monopolyTemplate then
        return
      end
      if not curData then
        UIUtil.ShowMessage(Localization:GetString("320301", Localization:GetString(monopolyTemplate.name, level)), 1, "110006", GameDialogDefine.CANCEL, function()
        end)
      elseif level >= curData.id then
        UIUtil.ShowMessage(Localization:GetString("320301", Localization:GetString(monopolyTemplate.name, level)), 1, "110006", GameDialogDefine.CANCEL, function()
        end)
      end
    end
  elseif self.picVer == 0 and not string.IsNullOrEmpty(self.pic) then
    self.view:SelectHeadIcon(self.slotId, self.pic, self.picVer)
  elseif self.picVer ~= 0 and string.IsNullOrEmpty(self.pic) then
    self.view:SelectHeadIcon(self.slotId, self.pic, self.picVer)
  else
    self.view:SelectHeadIcon(self.slotId, self.pic, self.picVer)
  end
end

function UILWPlayerEditItem:GetIsOn()
  if self.empty then
    return false
  end
  return base.GetIsOn(self)
end

return UILWPlayerEditItem
