local base = UIBaseContainer
local UIEBR_VsItem = BaseClass("UIEBR_VsItem", base)
local UIEBR_VsAlItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleResult.Component.UIEBR_VsAlItem")
local al1_path = "al/al1"
local al2_path = "al/al2"
local score_path = "score"
local player_path = "playerBg/player"
local win_path = "win"

function UIEBR_VsItem:OnCreate()
  base.OnCreate(self)
  self.al1 = self:AddComponent(UIEBR_VsAlItem, al1_path)
  self.al2 = self:AddComponent(UIEBR_VsAlItem, al2_path)
  self.score = self:AddComponent(UITextMeshProUGUIEx, score_path)
  self.player = self:AddComponent(UITextMeshProUGUIEx, player_path)
  self.win = self:AddComponent(UIImage, win_path)
end

function UIEBR_VsItem:OnDestroy()
  self.al1 = nil
  self.al2 = nil
  self.score = nil
  self.player = nil
  base.OnDestroy(self)
end

function UIEBR_VsItem:SetData(info, alList)
  self.al1:SetData(alList[1])
  self.al2:SetData(alList[2])
  self.score:SetText(string.GetFormattedSeparatorNum(info.score))
  local max = LuaEntry.DataConfig:TryGetNum("YiBianJinQu", "k6", 20)
  if self.al2:GetActive() then
    max = max * 2
  end
  self.player:SetText(info.member .. "/" .. max)
  self.win:SetActive(info.isWin)
end

return UIEBR_VsItem
