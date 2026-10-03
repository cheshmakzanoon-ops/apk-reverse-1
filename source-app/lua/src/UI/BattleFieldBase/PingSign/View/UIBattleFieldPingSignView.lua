local UIBattleFieldPingSignView = BaseClass("UIBattleFieldPingSignView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local sticker_path = "area/node_stickers/Sign"
local GROUP1 = {
  {
    0,
    0,
    0
  }
}
local GROUP2 = {
  {
    -59,
    10,
    -23.2
  },
  {
    59,
    10,
    23.2
  }
}
local GROUP3 = {
  {
    -108,
    46.5,
    -46.5
  },
  {
    0,
    0,
    0
  },
  {
    108,
    46.5,
    46.5
  }
}
local GROUP4 = {
  {
    -140,
    95,
    -70
  },
  {
    -59,
    10,
    -23.2
  },
  {
    59,
    10,
    23.2
  },
  {
    140,
    95,
    70
  }
}

function UIBattleFieldPingSignView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
end

function UIBattleFieldPingSignView:OnDestroy()
  self:GameObjectDestroy(self.garbage)
  self.garbage = nil
  for _, v in ipairs(self.signs) do
    v.btn:SetOnClick(nil)
  end
  self.signs = nil
end

function UIBattleFieldPingSignView:ComponentDefine()
  local panel = self:AddComponent(UIButton, panel_path)
  panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.signs = {}
  for i = 1, 4 do
    local btn = self:AddComponent(UIButton, sticker_path .. i)
    btn:SetOnClick(function()
      self:OnBtnClick(i)
    end)
    local icon = btn:AddComponent(UIImage, "Icon")
    local text = btn:AddComponent(UITextMeshProUGUIEx, "Icon/Text")
    self.signs[i] = {
      btn = btn,
      icon = icon,
      text = text
    }
  end
end

function UIBattleFieldPingSignView:DataDefine()
  self.pointId = self:GetUserData()
  local tType = 1
  local info = CS.SceneManager.World:GetPointInfo(self.pointId)
  local showGarbage = info == nil
  if not showGarbage then
    showGarbage = info.PointType == WorldPointType.Other
    if info.PointType == WorldPointType.PlayerBuilding then
      cast(info, typeof(CS.BuildPointInfo))
      local ez = LuaEntry.Player:GetCurWorldType()
      local bEnemy = true
      if ez == BattleFieldType.WinterStorm then
        bEnemy = BattleFieldUtil.IsBattleFieldEnemy(info.ownerUid, BattleFieldType.WinterStorm)
      else
        bEnemy = BattleFieldUtil.IsBattleFieldEnemy(info.allianceId, ez)
      end
      tType = bEnemy and 2 or 3
    else
      tType = 4
    end
  end
  CS.SceneManager.World:HideTouchEffect()
  if showGarbage then
    self.garbage = self:GameObjectInstantiateAsync(TouchTerrainEffect, function()
      if self.garbage.isError then
        self:GameObjectDestroy(self.garbage)
        self.garbage = nil
        return
      end
      self.garbage.gameObject:SetActive(true)
      local worldPointPos = SceneUtils.TileIndexToWorld(self.pointId)
      self.garbage.gameObject.transform:Set_localScale(1.3, 1.3, 1.3)
      self.garbage.gameObject.transform.position = worldPointPos
      self.garbage.gameObject.name = "CommanderSignGarbage"
    end)
  end
  self.ttList = BattleFieldUtil.GetCurPings(tostring(tType))
  table.sort(self.ttList, function(a, b)
    return a.id < b.id
  end)
end

function UIBattleFieldPingSignView:OnBtnClick(idx)
  local template = self.ttList[idx]
  local ez = LuaEntry.Player:GetCurWorldType()
  if ez == BattleFieldType.EpidemicZone then
    DataCenter.ActEpidemicZoneManager:ReqCommanderOrderAdd(template.id, self.pointId)
  else
    DataCenter.ActWinterStormManager:ReqWSOrderAdd(template.id, self.pointId)
  end
  self.ctrl:CloseSelf()
end

function UIBattleFieldPingSignView:RefreshUI()
  local cnt = #self.ttList
  local groupInfo = GROUP4
  if cnt == 1 then
    groupInfo = GROUP1
  elseif cnt == 2 then
    groupInfo = GROUP2
  elseif cnt == 3 then
    groupInfo = GROUP3
  end
  local autoMirror = CommonUtil.ArabicAutoMirrorFactor()
  for i, v in ipairs(self.signs) do
    local template = self.ttList[i]
    local gInfo = groupInfo[i]
    local btn = v.btn
    if template and gInfo then
      btn:SetActive(true)
      btn:SetLocalPositionXYZ(gInfo[1] * autoMirror, gInfo[2], 0)
      btn:SetEulerAnglesXYZ(0, 0, gInfo[3])
      btn:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldCommanderPath, template.bg))
      local icon = v.icon
      icon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldCommanderPath, template.icon))
      icon:SetEulerAnglesXYZ(0, 0, 0)
      v.text:SetLocalText(template.name)
    else
      btn:SetActive(false)
    end
  end
end

return UIBattleFieldPingSignView
