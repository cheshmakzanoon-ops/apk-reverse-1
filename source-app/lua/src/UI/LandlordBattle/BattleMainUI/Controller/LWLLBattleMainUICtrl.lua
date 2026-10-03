local base = require("UI.LWMainUI.Controller.LWMainUICtrl")
local LWLLBattleMainUICtrl = BaseClass("LWLLBattleMainUICtrl", base)

function LWLLBattleMainUICtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWLLBattleMainUIView)
end

function LWLLBattleMainUICtrl:OnClickSearchBtn(self)
  GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.None)
end

function LWLLBattleMainUICtrl:IsRedPotShowByType(type)
  return 0
end

function LWLLBattleMainUICtrl:GetMarkListByTab(tab)
  local showList = {}
  local dataList = {}
  if tab == -1 then
    dataList = DataCenter.WorldFavoDataManager:GetAllBookList()
  else
    dataList = DataCenter.WorldFavoDataManager:GetBookListByType(tab)
  end
  if dataList ~= nil then
    table.walksort(dataList, function(leftKey, rightKey)
      return dataList[leftKey].createTime < dataList[rightKey].createTime
    end, function(k, v)
      if v.server == LuaEntry.Player:GetCurServerId() then
        table.insert(showList, v)
      end
    end)
  end
  return showList
end

function LWLLBattleMainUICtrl:DelBookMark(selectItem)
  if not self.curBookMarkType then
    return
  end
  if self.curBookMarkType ~= 3 then
    SFSNetwork.SendMessage(MsgDefines.WorldFavoDel, selectItem.pos, selectItem.type, selectItem.server)
  else
    if self.curBookMarkType and self.curBookMarkType == 3 then
      if not LuaEntry.Player:IsInAlliance() then
        UIUtil.ShowTipsId(390820)
        return
      elseif not DataCenter.AllianceBaseDataManager:IsR4orR5() then
        UIUtil.ShowTipsId(390822)
        return
      end
    end
    DataCenter.WorldFavoDataManager:TryDelAllianceMask(selectItem.type)
  end
end

function LWLLBattleMainUICtrl:ShareBookMark(selectItem)
  if self.curBookMarkType and self.curBookMarkType == 3 and not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(390820)
    return
  end
  local share_param = {}
  share_param.sid = selectItem.server
  share_param.pos = (selectItem.pos - selectItem.pos % 10) / 10
  share_param.uname = selectItem.name
  share_param.worldId = selectItem.worldId
  GoToUtil.GotoOpenView(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function LWLLBattleMainUICtrl:OnClickPosBtn(selectItem)
  if self.curBookMarkType and self.curBookMarkType == 3 and not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(390820)
    return
  end
  local point = (selectItem.pos - selectItem.pos % 10) / 10
  if BattleFieldUtil.InBattleField(self.bfType) then
    GoToUtil.GotoDragonPos(SceneUtils.TileIndexToWorld(point), -1, nil, function()
    end, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId())
  else
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(point), CS.SceneManager.World.InitZoom, nil, nil, selectItem.server)
  end
end

function LWLLBattleMainUICtrl:GetCurrentState()
  local showData = {}
  showData.serverId = LuaEntry.Player:GetCurServerId()
  local pos = CS.SceneManager.World.CurTarget
  local tile = SceneUtils.WorldToTileIndex(pos)
  local v2 = SceneUtils.IndexToTilePos(tile)
  showData.x = v2.x
  showData.y = v2.y
  return showData
end

function LWLLBattleMainUICtrl:SetCurBookMarkType(tempType)
  self.curBookMarkType = tempType
end

function LWLLBattleMainUICtrl:CheckCanGo(server, x, y)
  local canJump = false
  if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return false
  end
  if server ~= nil and x ~= nil and y ~= nil and 0 <= x and 0 <= y and x <= CS.SceneManager.World.TileCount.x - 1 and y <= CS.SceneManager.World.TileCount.y - 1 then
    local data = CS.UnityEngine.Vector2Int(x, y)
    if CS.SceneManager.World:IsInMap(data) then
      canJump = true
    end
  end
  return canJump
end

return LWLLBattleMainUICtrl
