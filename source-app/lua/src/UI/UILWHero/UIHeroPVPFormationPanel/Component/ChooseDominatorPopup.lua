local ChooseDominatorPopup = BaseClass("ChooseDominatorPopup", UIBaseContainer)
local base = UIBaseContainer
local DominatorUtils = require("DataCenter.Dominator.Main.DominatorUtils")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local DominatorCell = BaseClass("DominatorCell", UIBaseContainer)

function DominatorCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function DominatorCell:OnDestroy()
  self.clickCallback = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DominatorCell:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.using_icon = self:AddComponent(UIImage, "using")
  self.usingSquad_txt = self:AddComponent(UIText, "usingSquad_txt")
  self.name_txt = self:AddComponent(UIText, "name_txt")
  self.rank = self:AddComponent(UIBaseContainer, "rank")
  self.rank_icon = self:AddComponent(UIImage, "rank/rank_icon")
  self.rank_txt = self:AddComponent(UIText, "rank/rank_txt")
  self.heroCell = self:AddComponent(UIHeroCellSmall, "heroCell")
  self.bg = self:AddComponent(UIImage, "bg")
end

function DominatorCell:ComponentDestroy()
  self.btn = nil
  self.using_icon = nil
  self.usingSquad_txt = nil
  self.name_txt = nil
  self.rank = nil
  self.rank_icon = nil
  self.rank_txt = nil
  self.heroCell = nil
  self.bg = nil
end

function DominatorCell:Set(dominatorInfo, clickCallback)
  self.dominatorInfo = dominatorInfo
  self.clickCallback = clickCallback
  self.name_txt:SetText(dominatorInfo:GetUserName())
  local rankShowTemplate = dominatorInfo:GetCurRankShowTemplate()
  if rankShowTemplate then
    self.rank:SetActive(true)
    self.rank_icon:LoadSprite(rankShowTemplate:GetRankIconPathBig())
    self.rank_txt:SetText(rankShowTemplate:GetName())
  else
    self.rank:SetActive(false)
  end
  self.heroCell:SetDominatorConfig(dominatorInfo.dominatorId, dominatorInfo:GetCurRankLv(), false)
end

function DominatorCell:SetUsing(curSquadUsing, otherSquadUsing)
  self.using_icon:SetEnable(curSquadUsing)
  if not curSquadUsing and otherSquadUsing then
    self.usingSquad_txt:SetText(otherSquadUsing)
  else
    self.usingSquad_txt:SetText("")
  end
  if curSquadUsing or otherSquadUsing then
    self.bg:SetColorRGBA255(221, 242, 186, 255)
  else
    self.bg:SetColorRGBA255(241, 237, 235, 255)
  end
end

function DominatorCell:OnClick()
  if self.clickCallback then
    self.clickCallback(self.dominatorInfo.uuid)
  end
end

local content_path = "imgBg/dominators"
local img_bg_path = "imgBg"
local btn_close_path = "btnClose"
local arrow_path = "imgBg/imgArrow"

function ChooseDominatorPopup:OnDestroy()
  self:RemoveDominators()
  self.controllBtn = nil
  self.source = nil
  self.squadIdx = nil
  self.squadData = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChooseDominatorPopup:OnCreate(controllBtn, source, squadIdx, squadData)
  base.OnCreate(self)
  self.controllBtn = controllBtn
  self.source = source
  self.squadIdx = squadIdx
  self.squadData = squadData
  self:ComponentDefine()
  self.rectTransform:Set_offsetMax(0, 0)
  self.rectTransform:Set_offsetMin(0, 0)
  self.rectTransform:Set_anchorMin(0, 0)
  self.rectTransform:Set_anchorMax(1, 1)
  self.rectTransform:Set_localScale(1, 1, 1)
  self.rectTransform:Set_localPosition(0, 0, 0)
end

function ChooseDominatorPopup:SetData(source, squadIdx)
  self.source = source
  self.squadIdx = squadIdx
end

function ChooseDominatorPopup:SetSquadData(squadData)
  local prev = self.squadData
  self.squadData = squadData
  if prev == nil or prev:GetLocalDominatorUuid() ~= squadData:GetLocalDominatorUuid() then
    self:ShowDominators()
  end
end

function ChooseDominatorPopup:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.dominator_container = self:AddComponent(UIBaseContainer, content_path)
  self.imgBg = self:AddComponent(UIBaseContainer, img_bg_path)
  self.btnClose = self:AddComponent(UIButton, btn_close_path)
  self.btnClose:SetOnClick(function()
    self.controllBtn:HidePopup()
  end)
  self.arrow = self:AddComponent(UIBaseContainer, arrow_path)
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
end

function ChooseDominatorPopup:ComponentDestroy()
end

local DominatorCell_Path = "Assets/Main/Prefabs/UI/UIHero/LWHero/Formation/dominatorCell.prefab"

function ChooseDominatorPopup:SetPosition(x, y)
  self.alignPosition = Vector3.New(x, y, 0)
end

local Pivot_Max = 1.0
local Pivot_Min = 0.0
local Pivot_Mid = 0.5

function ChooseDominatorPopup:CheckAlign()
  self.canvasGroup:SetAlpha(1)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.imgBg.transform)
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local _rect = self.imgBg.rectTransform.rect
  local BgWidth = _rect.width * scaleFactor
  local BgHeight = _rect.height * scaleFactor
  local position = Vector3.zero
  local _screenPos = Vector3.zero
  position = self.alignPosition
  _screenPos = PosConverse.UIWorldToScreenPos(position)
  local targetScreenPos = _screenPos
  targetScreenPos.y = targetScreenPos.y + 41 * scaleFactor
  local pivot = Vector2.New(0.5, 0.5)
  local offsetX = 0
  if _screenPos.x - BgWidth / 2 < 10 then
    offsetX = BgWidth / 2 - _screenPos.x
  elseif _screenPos.x + BgWidth / 2 > ScreenWidth - 10 then
    offsetX = ScreenWidth - _screenPos.x - BgWidth / 2
  end
  targetScreenPos.x = targetScreenPos.x + offsetX
  pivot.x = Pivot_Mid
  _arrowX = -offsetX / scaleFactor
  if _screenPos.y + BgHeight < ScreenHeight - 10 or _screenPos.y - BgHeight > 10 then
    if _screenPos.y + BgHeight < ScreenHeight - 10 then
      pivot.y = Pivot_Min
      _arrowY = -BgHeight / scaleFactor * 0.5
    elseif _screenPos.y - BgHeight > 10 then
      pivot.y = Pivot_Max
      _arrowY = BgHeight / scaleFactor * 0.5
    end
  else
    pivot.y = Pivot_Mid
  end
  _arrowY = _arrowY + 6 * scaleFactor
  _arrowX = _arrowX - 16 * scaleFactor
  self.arrow.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
  self.arrow:SetActive(true)
  self.imgBg.rectTransform.pivot = pivot
  local uiPos = PosConverse.ScreenToUIPos(self.root.transform, targetScreenPos)
  self.imgBg.transform.anchoredPosition = uiPos
end

function ChooseDominatorPopup:RemoveDominators()
  self.dominator_container:RemoveAllComponentes(DominatorCell)
  if self.dominatorReqs then
    for _, cell in ipairs(self.dominatorReqs) do
      self:GameObjectDestroy(cell)
    end
  end
  if self.dominatorReqs then
    table.clear(self.dominatorReqs)
  end
  if self.dominatorCells then
    table.clear(self.dominatorCells)
  end
end

function ChooseDominatorPopup:ShowDominators()
  local dominators = DominatorUtils.GetBattleDominatorInfos(self.source, self.squadData)
  if table.deep_compare(self.dominators, dominators) then
    for i = 1, #self.dominatorCells do
      self.dominatorCells[i]:SetUsing(dominators[i].usingSquadIdx and dominators[i].uuid == self.squadData:GetLocalDominatorUuid(), dominators[i].usingSquadIdx)
    end
    return
  end
  self:RemoveDominators()
  self.dominators = dominators
  if table.IsNullOrEmpty(dominators) then
    self:CheckAlign()
    return
  end
  self.canvasGroup:SetAlpha(0)
  for i = 1, #dominators do
    if self.onChooseDominator == nil then
      function self.onChooseDominator(dominatorUid)
        self:OnChooseDominator(dominatorUid)
      end
    end
    local req = self:GameObjectInstantiateAsync(DominatorCell_Path, function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local transform = obj.transform
      transform:SetParent(self.dominator_container.transform)
      transform:Set_localScale(1, 1, 1)
      local name = string.format("Cell_%d", i)
      transform.name = name
      local cell = self.dominator_container:AddComponent(DominatorCell, name)
      cell:SetSiblingIndex(i - 1)
      if self.dominatorCells == nil then
        self.dominatorCells = {}
      end
      table.insert(self.dominatorCells, cell)
      cell:Set(dominators[i].dominatorInfo, self.onChooseDominator)
      cell:SetUsing(dominators[i].usingSquadIdx and dominators[i].uuid == self.squadData:GetLocalDominatorUuid(), dominators[i].usingSquadIdx)
      if i == #dominators then
        self:CheckAlign()
      end
    end)
    if self.dominatorReqs == nil then
      self.dominatorReqs = {}
    end
    table.insert(self.dominatorReqs, req)
  end
end

function ChooseDominatorPopup:OnEnable()
  self:ShowDominators()
end

function ChooseDominatorPopup:OnChooseDominator(dominatorUid)
  self.controllBtn:OnChooseDominator(dominatorUid)
end

return ChooseDominatorPopup
