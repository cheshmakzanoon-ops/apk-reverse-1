local base = UIBaseContainer
local ItemComponent = BaseClass("ItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.UIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.imgUnlock = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgUnlockFrame = self:AddComponent(UIImage, "imgUnlockFrame")
  self.imgLock = self.viewSkin:AddComponent(self, UIImage, 3)
end

function ItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.UIPlayerHead = nil
  self.imgUnlockFrame = nil
  self.imgUnlock = nil
  self.imgLock = nil
end

function ItemComponent:DataDefine()
end

function ItemComponent:DataDestroy()
end

function ItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function ItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ItemComponent:ReInit(player, unlock, total, index)
  self.imgLock.gameObject:SetActive(not unlock)
  self.imgUnlockFrame.gameObject:SetActive(unlock)
  if player then
    self.UIPlayerHead:SetData(player.uid, player.headPic, player.headPicVer)
    if player.uid == LuaEntry.Player.uid then
      local hasPlayedEffect = CommonUtil.PlayerPrefsGetBool(SettingKeys.AttackCityS0_Clue_Personal_Effect .. total .. index, false)
      if not hasPlayedEffect then
        self.imgUnlock.gameObject:SetActive(true)
        CommonUtil.PlayerPrefsSetBool(SettingKeys.AttackCityS0_Clue_Personal_Effect .. total .. index, true)
      else
        self.imgUnlock.gameObject:SetActive(false)
      end
    else
      self.imgUnlock.gameObject:SetActive(false)
    end
  end
end

function ItemComponent:UpdatePlayerState(state)
  self.UIPlayerHead.gameObject:SetActive(state)
end

return ItemComponent
