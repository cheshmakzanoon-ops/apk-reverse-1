local base = UIBaseContainer
local UILWT11IdleGameBattleMain_NodeInfoItemComponent = BaseClass("UILWT11IdleGameBattleMain_NodeInfoItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textNum = nil
end

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:DataDefine()
  self.nodeType = nil
  self.infoData = nil
end

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:DataDestroy()
  self.nodeType = nil
  self.infoData = nil
end

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:SetData(nodeType, infoData)
  self.nodeType = nodeType
  self.infoData = infoData
  local iconPath = Const.MainBattleNodeInfoIconPath[self.nodeType]
  if not string.IsNullOrEmpty(iconPath) then
    self.imgIcon:LoadSprite(iconPath)
  end
  self:Refresh()
end

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:Refresh()
  if self.nodeType == nil or self.infoData == nil then
    return
  end
  local num = 0
  local passedDict = self.infoData:GetPassedNodeNumDict()
  for i, v in ipairs(passedDict) do
    if v.nodeType == self.nodeType then
      num = v.nodeNum
      break
    end
  end
  self.textNum:SetText(tostring(num))
end

function UILWT11IdleGameBattleMain_NodeInfoItemComponent:RefreshAfterShowFlyEffect(startPos)
  local path = "Assets/_Art_LastWar/Effect/Prefab/UI/Yingxiongxiangqing/Eff_ui_hero_xiangqing_shengji_jingyan.prefab"
  local parent = self.transform
  DataCenter.FlyController.DoFlyWithBezierFunc(path, startPos, self.transform.position, 1, parent, function()
    self:Refresh()
  end)
end

return UILWT11IdleGameBattleMain_NodeInfoItemComponent
