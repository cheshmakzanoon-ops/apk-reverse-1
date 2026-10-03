local UICD_FinalListGroup = BaseClass("UICD_FinalListGroup", UIAsyncContainer)
local base = UIAsyncContainer
local UICD_FinalListItem_Cls = "UI.UIChampionDuel.FinalList.Component.UICD_FinalListItem"
local UICD_FinalListItem_Prefab = "Assets/Main/Prefabs/UI/UIChampionDuel/Final/UICD_FinalListItem.prefab"
local text_rank_path = "RankDi/RankText"
local content_path = "ListContent"

function UICD_FinalListGroup:OnCreate()
  base.OnCreate(self)
  self.baseItem = nil
  self.items = {}
  self.text_rank = self:AddComponent(UIText, text_rank_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UICD_FinalListGroup:OnDestroy()
  self.idx = nil
  self.info = nil
  self.cb = nil
  self.items = nil
  self.text_rank = nil
  self.content = nil
  base.OnDestroy(self)
end

function UICD_FinalListGroup:SetData(idx, info, cb)
  self.idx = idx
  self.info = info
  self.cb = cb
  self:RefreshView()
end

function UICD_FinalListGroup:UpdateData()
  if self.idx == nil or self.info == nil then
    return
  end
  local rankS = self.info.s
  local rankE = self.info.e
  self.text_rank:SetLocalText("champion_duel_tips1062", rankS .. "-" .. rankE)
  local list = DataCenter.ChampionDuelManager:GetFinalRankList()
  local length = rankE - rankS + 1
  local cnt = 0
  for i = 1, length do
    local realI = rankS + i - 1
    local info = list[realI]
    local item = self.items[realI]
    if info ~= nil then
      if item == nil then
        item = self:LoadComponentAsync(UICD_FinalListItem_Cls, UICD_FinalListItem_Prefab, self.content, function()
          cnt = cnt + 1
          self:CheckFinish(cnt, length)
        end)
        item:SetSiblingIndex(i - 1)
        self.items[realI] = item
        item:SetName("item" .. i)
        item:SetActive(true)
        item:SetData(info)
      else
        item:SetActive(true)
        item:SetData(info)
        cnt = cnt + 1
        self:CheckFinish(cnt, length)
      end
    else
      if item ~= nil then
        item:SetActive(false)
      end
      cnt = cnt + 1
      self:CheckFinish(cnt, length)
    end
  end
end

function UICD_FinalListGroup:CheckFinish(cnt, lenght)
  if cnt < lenght then
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  if self.cb then
    self.cb()
  end
end

return UICD_FinalListGroup
