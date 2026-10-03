local base = UIBaseContainer
local LWUIMigration_StarAlly = BaseClass("LWUIMigration_StarAlly", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIMigration_StarAlly:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIMigration_StarAlly:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_StarAlly:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgAllyFlag = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgRank = self.viewSkin:AddComponent(self, UIImage, 2)
  self.btnConnect = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnConnect:SetOnClick(function()
    self:OnBtnConnectClick()
  end)
  self.textTmpAllyName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpAllyAbbr = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpAllyRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnImgAllyFlag = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnImgAllyFlag:SetOnClick(function()
    self:OnBtnImgAllyFlagClick()
  end)
  self.textBtn:SetLocalText("migration_activity_recommend_btn_1001")
end

function LWUIMigration_StarAlly:ComponentDestroy()
  self.viewSkin = nil
  self.imgAllyFlag = nil
  self.imgRank = nil
  self.btnConnect = nil
  self.textTmpAllyName = nil
  self.textTmpAllyAbbr = nil
  self.textTmpAllyRank = nil
  self.textBtn = nil
  self.btnImgAllyFlag = nil
end

function LWUIMigration_StarAlly:DataDefine()
end

function LWUIMigration_StarAlly:DataDestroy()
  self.allianceInfo = nil
end

function LWUIMigration_StarAlly:OnAddListener()
  base.OnAddListener(self)
end

function LWUIMigration_StarAlly:OnRemoveListener()
  base.OnRemoveListener(self)
end

local __RankIcon = {
  [1] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png",
  [2] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png",
  [3] = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png"
}

function LWUIMigration_StarAlly:Setup(index, info, serverId)
  if not info then
    return
  end
  self.allianceInfo = info
  self.serverId = serverId
  self.textTmpAllyName:SetText(info.name)
  self.textTmpAllyAbbr:SetText(string.format("[%s]", info.abbr))
  self.textTmpAllyRank:SetText(index)
  self.imgAllyFlag:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, info.icon))
  self.imgRank:LoadSpriteAuto(__RankIcon[index] or __RankIcon[3])
end

function LWUIMigration_StarAlly:OnBtnConnectClick()
  if self.allianceInfo then
    EventManager:GetInstance():Broadcast(EventId.ActMigrationSearchAllianceByName, self.allianceInfo.name)
  end
end

function LWUIMigration_StarAlly:OnBtnImgAllyFlagClick()
  if not self.allianceInfo then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, self.allianceInfo.name, self.allianceInfo.uid, self.serverId)
end

return LWUIMigration_StarAlly
