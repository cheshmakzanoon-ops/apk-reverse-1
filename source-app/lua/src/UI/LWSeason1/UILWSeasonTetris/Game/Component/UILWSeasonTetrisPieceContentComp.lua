local base = UIBaseContainer
local pieceScriptPath = require("UI.LWSeason1.UILWSeasonTetris.Game.Component.UILWSeasonTetrisPieceItemComp")
local piecePrefabPath = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisPieceItem.prefab"
local ChildPieceNamePrefix = "PieceTemplate"
local UILWSeasonTetrisPieceContentComp = BaseClass("UILWSeasonTetrisPieceContentComp", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWSeasonTetrisPieceContentComp:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compPiecePos3 = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compPiecePos2 = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compPiecePos1 = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
end

function UILWSeasonTetrisPieceContentComp:ComponentDestroy()
  self.viewSkin = nil
  self.compPiecePos3 = nil
  self.compPiecePos2 = nil
  self.compPiecePos1 = nil
  self:ClearComp()
end

function UILWSeasonTetrisPieceContentComp:ClearComp()
  if not table.IsNullOrEmpty(self.PieceReq) then
    for pos, req in pairs(self.PieceReq) do
      if IsNotNull(req.gameObject) then
        self.PosTrans[pos]:RemoveComponent(req.gameObject.name, pieceScriptPath)
      end
      req:Destroy()
      req = nil
    end
  end
  self.PieceReq = {}
end

function UILWSeasonTetrisPieceContentComp:DataDefine()
  self.PieceReq = {}
  self.PosTrans = {
    [0] = self.compPiecePos1,
    [1] = self.compPiecePos2,
    [2] = self.compPiecePos3
  }
end

function UILWSeasonTetrisPieceContentComp:DataDestroy()
end

function UILWSeasonTetrisPieceContentComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonTetrisPieceContentComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonTetrisPieceContentComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTetrisPieceListUpdate, self.OnPieceListUpdate)
end

function UILWSeasonTetrisPieceContentComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTetrisPieceListUpdate, self.OnPieceListUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonTetrisPieceContentComp:OnPieceListUpdate(evt)
  self:ReInit()
end

function UILWSeasonTetrisPieceContentComp:ReInit()
  self:ClearComp()
  self.GameData = DataCenter.SeasonTetrisManager.GameData
  if self.GameData ~= nil then
    self.GameData:PrintMap()
  end
  self:TryGenPiece(0)
  self:TryGenPiece(1)
  self:TryGenPiece(2)
end

function UILWSeasonTetrisPieceContentComp:TryGenPiece(pos)
  if self.PieceReq[pos] ~= nil then
    self.PieceReq[pos]:Destroy()
    self.PieceReq[pos] = nil
  end
  local pieceData = self.GameData:GetPiece(pos)
  if pieceData == nil then
    return
  end
  local transRoot = self.PosTrans[pos]
  if transRoot == nil then
    return
  end
  local pieceReq = self:GameObjectInstantiateAsync(piecePrefabPath, function(req)
    local gameObject = req.gameObject
    if IsNull(gameObject) then
      return
    end
    local transform = gameObject.transform
    transform:SetParent(transRoot.gameObject.transform)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    transform:SetSiblingIndex(0)
    local name = ChildPieceNamePrefix .. "_" .. pos
    gameObject.name = name
    local comp = transRoot:AddComponent(pieceScriptPath, gameObject.name)
    gameObject:SetActive(true)
    comp:ReInit(pos, pieceData)
  end)
  self.PieceReq[pos] = pieceReq
end

function UILWSeasonTetrisPieceContentComp:DestroyPiece(pos)
  if self.PieceReq[pos] ~= nil then
    local transRoot = self.PosTrans[pos]
    if IsNotNull(transRoot) then
      local go = self.PieceReq[pos].gameObject
      if IsNotNull(go) then
        transRoot:RemoveComponent(go.name, pieceScriptPath)
      end
    end
    self.PieceReq[pos]:Destroy()
    self.PieceReq[pos] = nil
  end
end

function UILWSeasonTetrisPieceContentComp:GetFirstPieceTrans()
  for i = 0, 2 do
    local piece = self.GameData:GetPiece(i)
    if piece ~= nil and self.PosTrans[i] ~= nil then
      return self.PosTrans[i].transform
    end
  end
  return nil
end

return UILWSeasonTetrisPieceContentComp
