local base = require("UI.BattleFieldBase.BattleFieldBaseView")
local LWMainWinterStormUIView = BaseClass("LWMainWinterStormUIView", base)
local LWMainWinterStormNoticeItem = require("UI.LWMainWinterStormUI.Component.LWMainWinterStormNoticeItem")
local LWMainWinterStormNoticeItemNew = require("UI.LWMainWinterStormUI.Component.LWMainWinterStormNoticeItemNew")
local top_layer_di_path = "safeArea/topLayerDi"
local notice_path = "safeArea/WinterStormNoticeItem"
local notice_new_path = "safeArea/WinterStormNoticeItemNew"

function LWMainWinterStormUIView:GetBfType()
  return BattleFieldType.WinterStorm
end

function LWMainWinterStormUIView:InitPolygonPoints()
  if self.centerE == nil then
    return
  end
  if self.polygonPoints then
    return self.polygonPoints
  end
  local points = {}
  local rect = self.centerE.rectTransform.rect
  local width, height = rect.width, rect.height
  local hr = 60
  table.insert(points, {
    100 + hr,
    200
  })
  table.insert(points, {
    width - 130 - hr,
    200
  })
  table.insert(points, {
    width - 130 - hr,
    540
  })
  table.insert(points, {
    width - 20 - hr,
    540
  })
  table.insert(points, {
    width - 20 - hr,
    height - 580
  })
  table.insert(points, {
    width - 220 - hr,
    height - 580
  })
  table.insert(points, {
    width - 220 - hr,
    height - 340
  })
  table.insert(points, {
    20 + hr,
    height - 340
  })
  table.insert(points, {
    20 + hr,
    640
  })
  table.insert(points, {
    100 + hr,
    640
  })
  self.polygonPoints = points
end

function LWMainWinterStormUIView:ComponentDefine()
  if self.textLeft then
    self.textLeft:SetLocalText("130065")
  end
  self.top_layer_di = self:AddComponent(UIBaseComponent, top_layer_di_path)
  self.top_layer_di:SetSiblingIndex(1)
  self.notice = self:AddComponent(LWMainWinterStormNoticeItem, notice_path)
  self.noticeNew = self:AddComponent(LWMainWinterStormNoticeItemNew, notice_new_path)
  self.noticeNew:CleanSeq()
end

function LWMainWinterStormUIView:ComponentDestroy()
  self.mini_map = nil
  self.battle_info = nil
  self.top_layer_di = nil
  self.notice = nil
  self.noticeNew = nil
end

function LWMainWinterStormUIView:OnBattleInfoReady()
  local testFlag = BattleFieldUtil.BTestJump()
  self.battle_info:SetOffsetMaxXY(0, 61)
  self.battle_info:SetOffsetMinXY(0, 0)
  self.battle_info:SetAnchoredPositionXY(0, -100)
  self.battle_info:ShowEndTime(not testFlag)
end

function LWMainWinterStormUIView:OnMiniMapReady()
  self.mini_map:SetMain()
end

function LWMainWinterStormUIView:DoBtnLeft()
  SFSNetwork.SendMessage(MsgDefines.WinterStormBattleRewardScoreInfo)
end

return LWMainWinterStormUIView
