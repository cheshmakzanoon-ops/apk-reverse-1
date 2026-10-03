local UILWMailDetailWarHelperItem = BaseClass("UILWMailDetailWarHelperItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWMailDetailWarHelperItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailWarHelperItem:ComponentDefine()
  self.layoutElement = self:AddComponent(UILayoutElement, "")
  self.showContent = self:AddComponent(UIBaseContainer, "ShowContent")
  self.scroll_view = self:AddComponent(UIScrollView, "ShowContent/Rect")
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.showToggleText = self:AddComponent(UIText, "ToggleText")
  self.toggle = self:AddComponent(UIToggle, "ToggleText/ShowToggle")
  self.toggle:SetOnValueChanged(function(tf)
    self:ToggleControlBorS(tf)
  end)
  self.toggle:SetIsOn(true)
  self:ToggleControlBorS(true)
  self.heroSpine_container = self:AddComponent(UIBaseContainer, "ShowContent/MonikaMask/HeroSpineContainer")
end

function UILWMailDetailWarHelperItem:DataDefine()
  self.finalKeyIdList = {}
end

function UILWMailDetailWarHelperItem:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIText, itemObj)
  local reportLine = self.finalKeyIdList[index]
  local txt = ""
  if table.IsNullOrEmpty(reportLine.textParas) then
    txt = Localization:GetString(reportLine.reportKey)
  else
    txt = Localization:GetString(reportLine.reportKey, SafeUnpack(reportLine.textParas))
  end
  cellItem:SetText(index .. "." .. txt)
end

function UILWMailDetailWarHelperItem:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIText)
end

function UILWMailDetailWarHelperItem:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIText)
end

function UILWMailDetailWarHelperItem:ToggleControlBorS(isShow)
  self.showContent:SetActive(isShow)
  if isShow then
    self.layoutElement:SetPreferredHeight(350)
  else
    self.layoutElement:SetPreferredHeight(50)
  end
end

function UILWMailDetailWarHelperItem:OnDestroy()
  self:UnloadSpine()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailWarHelperItem:DataDestroy()
  self.finalKeyIdList = nil
end

function UILWMailDetailWarHelperItem:SetData(helperIdList)
  self.finalKeyIdList = helperIdList
  if self.finalKeyIdList then
    if next(self.finalKeyIdList) then
      self.scroll_view:SetTotalCount(#self.finalKeyIdList)
      self.scroll_view:RefillCells()
    end
    self:LoadSpine()
  end
end

local MONICA_HERO_APPEARANCE_ID = 40020

function UILWMailDetailWarHelperItem:LoadSpine()
  if self.loadHeroSpineRequest then
    return
  end
  if not IsNull(self.spineObj) then
    self.spineObj:SetActive(true)
    return
  end
  local spinePath = HeroUtils.GetHeroIconPath(MONICA_HERO_APPEARANCE_ID, HeroIconType.spine_path)
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  self.loadHeroSpineRequest = self:GameObjectInstantiateAsync(spinePath, function(request)
    if IsNull(request) then
      return
    end
    local spineObj = request.gameObject
    if IsNull(spineObj) then
      return
    end
    local transform = spineObj.transform
    transform:SetParent(self.heroSpine_container.transform)
    transform.localPosition = Vector3.zero
    transform.localScale = Vector3.one
    spineObj:SetActive(true)
    self.spineObj = spineObj
  end)
end

function UILWMailDetailWarHelperItem:UnloadSpine()
  self.spineObj = nil
  if self.loadHeroSpineRequest then
    self:GameObjectDestroy(self.loadHeroSpineRequest)
    self.loadHeroSpineRequest = nil
  end
end

return UILWMailDetailWarHelperItem
