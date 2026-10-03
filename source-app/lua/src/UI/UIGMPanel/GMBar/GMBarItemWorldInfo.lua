local base = UIAsyncContainer
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local GMBarItemWorldInfo = BaseClass("GMBarItemWorldInfo", base)
local Localization = CS.GameEntry.Localization

function GMBarItemWorldInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshInfo()
  self:RefreshVisible()
end

function GMBarItemWorldInfo:OnDestroy()
  self:ClearTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GMBarItemWorldInfo:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpWorldInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnGMBarItemWorldInfo = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnGMBarItemWorldInfo:SetOnClick(function()
    self:OnBtnGMBarItemWorldInfoClick()
  end)
  self.compSplit = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
end

function GMBarItemWorldInfo:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpWorldInfo = nil
  self.btnGMBarItemWorldInfo = nil
  self.compSplit = nil
end

function GMBarItemWorldInfo:DataDefine()
end

function GMBarItemWorldInfo:DataDestroy()
end

function GMBarItemWorldInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AfterWorldCameraLodChanged, self.RefreshInfo)
  self:AddUIListener(EventId.OnEnterWorld, self.RefreshVisible)
  self:AddUIListener(EventId.OnEnterCity, self.RefreshVisible)
end

function GMBarItemWorldInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.AfterWorldCameraLodChanged, self.RefreshInfo)
  self:RemoveUIListener(EventId.OnEnterWorld, self.RefreshVisible)
  self:RemoveUIListener(EventId.OnEnterCity, self.RefreshVisible)
  base.OnRemoveListener(self)
end

function GMBarItemWorldInfo:RefreshVisible()
  self.visible = SceneUtils.GetIsInWorld() or false
  self.textTmpWorldInfo:SetActive(self.visible)
  self.compSplit:SetActive(self.visible)
  if self.visible then
    if not self.updateTimer then
      self.updateTimer = TimerManager:GetInstance():GetTimer(0.1, self.RefreshInfo, self, false, false, false)
      self.updateTimer:Start()
    end
  else
    self:ClearTimer()
  end
end

function GMBarItemWorldInfo:ClearTimer()
  if self.updateTimer ~= nil then
    self.updateTimer:Stop()
    self.updateTimer = nil
  end
end

function GMBarItemWorldInfo:GetInfo()
  local data = GMUtils.GetWorldInfo()
  if not data or data.init == false then
    return "..."
  end
  local centerTile = SceneUtils.IndexToTilePos(data.cameraCenter, ForceChangeScene.World)
  local info = string.format([[
Lod:%s(%s), Ct:%s,%s
Wp:%s,Ma:%s,Tr:%s,Tl:%s(%s)
Sq:%s,Ha:%s,DecNIC:%s,DecIC:%s,DecIDC:%s,DecHC:%s]], DisplaySettings.currentLod or 0, data.cameraZoom, centerTile.x, centerTile.y, data.worldObjCount, data.marchCount, data.troopCount, data.litTroopLineCount, data.troopLineCount, DisplaySettings.SquadCount, data.hahaDataEnable and "\226\136\154" or "\195\151", data.notInsCount, data.insCount, data.insDC, data.hideDecoCount)
  if data.hahaDataEnable then
    info = string.format("%s,%s", info, data.hahaDataDesc)
  end
  return info
end

function GMBarItemWorldInfo:RefreshInfo()
  if not self.visible then
    return
  end
  self.textTmpWorldInfo:SetText(self:GetInfo())
end

function GMBarItemWorldInfo:OnBtnGMBarItemWorldInfoClick()
  CommonUtil.CopyTextToClipboard(self:GetInfo())
  UIUtil.ShowTips("\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191")
end

return GMBarItemWorldInfo
