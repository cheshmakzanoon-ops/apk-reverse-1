local base = UIBaseContainer
local UILWSeasonTetrisPieceItemComp = BaseClass("UILWSeasonTetrisPieceItemComp", UIBaseContainer)
local block_prefab_path = "Assets/Main/Prefabs/UI/LWSeason1/Tetris/SeasonTetrisBlockItem.prefab"
local block_script_path = require("UI.LWSeason1.UILWSeasonTetris.Game.Component.UILWSeasonTetrisBlockItemComp")
local ChildBlockNamePrefix = "Piece_BlockTemplate"
local Localization = CS.GameEntry.Localization
local content_path = "Content"

function UILWSeasonTetrisPieceItemComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonTetrisPieceItemComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonTetrisPieceItemComp:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compTrigger = self.viewSkin:AddComponent(self, UIEventTrigger, 2)
  self.compSelf = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compTrigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.compTrigger:OnDrag(function(eventData)
    self:OnDragging(eventData)
  end)
  self.compTrigger:OnEndDrag(function(eventData)
    self:OnDragEnd(eventData)
  end)
end

function UILWSeasonTetrisPieceItemComp:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
  self.compTrigger = nil
  self.compSelf = nil
end

function UILWSeasonTetrisPieceItemComp:DataDefine()
  self.BlockGos = {}
  self.BlockReq = {}
  self.BlockState = {}
  self.Dragging = false
  self.BlockScale = DataCenter.SeasonTetrisManager.BlockScale
end

function UILWSeasonTetrisPieceItemComp:DataDestroy()
  for _, req in pairs(self.BlockReq) do
    if req ~= nil then
      req:Destroy()
      req = nil
    end
  end
  self.BlockReq = nil
  self.BlockGos = nil
  self.BlockState = nil
  self.Dragging = false
end

function UILWSeasonTetrisPieceItemComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonTetrisPieceItemComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonTetrisPieceItemComp:ReInit(pos, data)
  self.Pos = pos
  self.PieceData = data
  local dataSource = DataCenter.SeasonTetrisManager.DataSource
  self.ResetScale = dataSource:GetPieceItemResetScale()
  self.FixScale = dataSource:GetPieceItemFixScale()
  local centerX = self.PieceData.CenterX
  local sizeLarge = DataCenter.SeasonTetrisManager.BlockSizeLarge
  self.Offset = Vector3.New(-centerX * sizeLarge, 0, 0)
  local x = DataCenter.SeasonTetrisManager.PieceX
  local y = DataCenter.SeasonTetrisManager.PieceY
  local size = DataCenter.SeasonTetrisManager.BlockSizeSmall
  for i = 0, x - 1 do
    for j = 0, y - 1 do
      local blockState = self.PieceData.Map[i][j]
      if blockState ~= nil and blockState ~= 0 then
        do
          local blockReq = self:GameObjectInstantiateAsync(block_prefab_path, function(req)
            local go = req.gameObject
            local transform = go.transform
            transform:SetParent(self.compContent.gameObject.transform)
            transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            transform:Set_localPosition((i + 0.5) * size, (j + 0.5) * size, ResetPosition.z)
            transform:SetSiblingIndex(0)
            go.name = string.format("%s_%s_%s", ChildBlockNamePrefix, i, j)
            local comp = self.compContent:AddComponent(block_script_path, go.name)
            local blockData = {}
            blockData.BlockState = blockState
            comp:ReInit(blockData)
            go:SetActive(true)
          end)
          table.insert(self.BlockReq, blockReq)
          table.insert(self.BlockState, blockState)
        end
      end
    end
  end
  self:MoveToCenter()
end

function UILWSeasonTetrisPieceItemComp:MoveToCenter()
  if self.PieceData ~= nil then
    local centerX = self.PieceData.CenterX
    local centerY = self.PieceData.CenterY
    local halfY = DataCenter.SeasonTetrisManager.PieceY * 0.5
    local size = DataCenter.SeasonTetrisManager.BlockSizeSmall
    self.compContent.transform:Set_localPosition(-centerX * size, (halfY - centerY) * size, ResetPosition.z)
  end
end

function UILWSeasonTetrisPieceItemComp:MoveToCenterBottom()
  local centerX = self.PieceData.CenterX
  local size = DataCenter.SeasonTetrisManager.BlockSizeSmall
  local x = self.compContent.transform:Get_localPosition()
  self.compContent.transform:Set_localPosition(x, ResetPosition.y, ResetPosition.z)
end

function UILWSeasonTetrisPieceItemComp:OnBeginDrag(eventData)
  if self.Dragging then
    return
  end
  if self.view:HasWinOrFail() then
    return
  end
  if self.view.compGridMap ~= nil then
    self.view.compGridMap:SetCanGuide(false)
  end
  self.compSelf.transform:Set_localScale(self.BlockScale * self.FixScale, self.BlockScale * self.FixScale, 1)
  self:MoveToCenterBottom()
  DataCenter.LWSoundManager:PlaySound(1000017, false)
end

function UILWSeasonTetrisPieceItemComp:OnDragging(eventData)
  if self.view:HasWinOrFail() then
    self:OnDragEnd(nil)
    return
  end
  self.Dragging = true
  self.compSelf.transform.position = CS.GameEntry.UICamera:ScreenToWorldPoint(CS.UnityEngine.Input.mousePosition)
  self.view:ClearShadows()
  if self.view:CanPlace(self) then
    self.view:ShowShadows(self)
  end
end

function UILWSeasonTetrisPieceItemComp:OnDragEnd(eventData)
  if self.view.compGridMap ~= nil then
    self.view.compGridMap:SetCanGuide(true)
  end
  self.view:ClearShadows()
  if self.view:CanPlace(self) then
    DataCenter.LWSoundManager:PlaySound(1000018, false)
    self.view:PlacePiece(self)
  else
    self:MoveToCenter()
    self.compSelf.transform:Set_localScale(self.ResetScale, self.ResetScale, 1)
    self.compSelf.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end
  self.Dragging = false
end

return UILWSeasonTetrisPieceItemComp
