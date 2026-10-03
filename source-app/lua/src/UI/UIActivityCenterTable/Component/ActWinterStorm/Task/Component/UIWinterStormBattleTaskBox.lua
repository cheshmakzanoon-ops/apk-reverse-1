local base = UIAsyncContainer
local UIWinterStormBattleTaskBox = BaseClass("UIWinterStormBattleTaskBox", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function UIWinterStormBattleTaskBox:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormBattleTaskBox:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormBattleTaskBox:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compLight = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.simpleAnimation = self.viewSkin:AddComponent(self, UISimpleAnimation, 3)
  self.compDi = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
end

function UIWinterStormBattleTaskBox:ComponentDestroy()
  self.viewSkin = nil
  self.compLight = nil
  self.imgIcon = nil
  self.simpleAnimation = nil
  self.compDi = nil
  self.textNum = nil
end

function UIWinterStormBattleTaskBox:DataDefine()
end

function UIWinterStormBattleTaskBox:DataDestroy()
  self.config = nil
end

function UIWinterStormBattleTaskBox:OnAddListener()
  base.OnAddListener(self)
end

function UIWinterStormBattleTaskBox:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWinterStormBattleTaskBox:UpdateData()
  if self.config == nil then
    return
  end
  self.compDi:SetActive(false)
  self.compLight:SetActive(self.state == 2)
  self.simpleAnimation:Play(self.state == 2 and "open" or "Default")
  local iconName
  if self.state == 3 then
    iconName = "mjc_dongri_jiangli_jindutiao_jindu02.png"
  elseif DataCenter.ActWinterStormManager:IsRoundBox(self.config) then
    iconName = "mjc_dongri_jiangli_box_4.png"
  else
    local i = (self.idx - 1) % 3
    iconName = string.format("mjc_dongri_jiangli_box_%s.png", i + 1)
  end
  self.imgIcon:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldWinterPath, iconName), function()
    if self.imgIcon then
      self.imgIcon:SetNativeSize()
    end
  end)
end

function UIWinterStormBattleTaskBox:ReInit(idx, config, state)
  self.idx = idx
  self.config = config
  self.state = state
  self:SetActive(true)
  self:RefreshView()
end

function UIWinterStormBattleTaskBox:ShowScore()
  if not self:AsyncLoadDone() or self.config == nil then
    return
  end
  self.compDi:SetActive(true)
  self.textNum:SetText(string.GetFormattedSeperatorNum(toInt(self.config.score)))
end

return UIWinterStormBattleTaskBox
