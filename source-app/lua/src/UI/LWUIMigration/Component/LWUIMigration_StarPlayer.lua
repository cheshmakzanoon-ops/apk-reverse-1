local base = UIBaseContainer
local LWUIMigration_StarPlayer = BaseClass("LWUIMigration_StarPlayer", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIMigration_StarPlayer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIMigration_StarPlayer:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_StarPlayer:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpPlayerName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTmpPlayerAbbr = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 3)
  self.textTmpPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compPlayerHead:SetEnableClickShowInfo(true, true)
end

function LWUIMigration_StarPlayer:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpPlayerName = nil
  self.textTmpPlayerAbbr = nil
  self.compPlayerHead = nil
  self.textTmpPower = nil
end

function LWUIMigration_StarPlayer:DataDefine()
end

function LWUIMigration_StarPlayer:DataDestroy()
end

function LWUIMigration_StarPlayer:OnAddListener()
  base.OnAddListener(self)
end

function LWUIMigration_StarPlayer:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIMigration_StarPlayer:Setup(index, info)
  self.textTmpPlayerName:SetText(info.name)
  if info.abbr then
    self.textTmpPlayerAbbr:SetText(string.format("[%s]", info.abbr))
  else
    self.textTmpPlayerAbbr:SetText("")
  end
  self.textTmpPower:SetText(string.GetFormattedStr(info.power))
  self.compPlayerHead:ParseHeadInfo(info)
end

return LWUIMigration_StarPlayer
