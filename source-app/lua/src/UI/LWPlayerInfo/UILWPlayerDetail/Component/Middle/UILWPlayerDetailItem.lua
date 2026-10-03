local UILWPlayerDetailItem = BaseClass("UILWPlayerDetailItem", UIScrollRect)
local base = UIScrollRect
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local Localization = CS.GameEntry.Localization
local UILWPlayerDetailPage = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Middle.UILWPlayerDetailPage")
local page_cell_path = "PageCell"
local page_list_path = "Viewport/PageList"
local content_path = "Viewport/Content"
local anim_path = "Viewport/anim"

function UILWPlayerDetailItem:OnCreate()
  base.OnCreate(self)
  self.eff_anim = self.transform:Find(anim_path):GetComponent(TypeParticleSystem)
  self.anim = self:AddComponent(UIBaseContainer, anim_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, "")
  self.page_list = self:AddComponent(UIBaseContainer, page_list_path)
  self.content = self:AddComponent(UIBaseComponent, content_path)
  self.theItem = self.transform:Find(page_cell_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.max_x = 0
  self.max_y = 0
  self.lockScroll = false
  self.event_trigger:OnBeginDrag(function()
    self.isInDrag = true
  end)
  self.event_trigger:OnEndDrag(function()
    self.isInDrag = false
    if self.lockScroll then
      return
    end
    if self.max_x >= 50 or 50 <= self.max_y then
      self:TryPlayFlipPageAnim()
    end
    self.max_x = 0
    self.max_y = 0
  end)
  self.event_trigger:OnPointerClick(function()
    if self.lockScroll or self.isInDrag then
      return
    end
    if self.activePage then
      self:OnBtnIconClick()
    end
  end)
  self:AddValueChangeListener(function()
    if self.lockScroll then
      return
    end
    local x, y, z = self.content:GetLocalPositionXYZ()
    self.max_x = math.max(self.max_x, math.abs(x))
    self.max_y = math.max(self.max_y, math.abs(y))
    self:OnScrollValueChange()
  end)
  self.anim:SetActive(false)
end

function UILWPlayerDetailItem:OnDestroy()
  self.page_list:RemoveComponents(UILWPlayerDetailPage)
  self.theItem:GameObjectRecycleAll()
  self.page_list = nil
  self.content = nil
  base.OnDestroy(self)
end

function UILWPlayerDetailItem:SetHeadInfo(data)
  self.uid = data.uid
  self.data = data
  self.isSelf = data.isSelf
  if string.IsNullOrEmpty(data.pic) then
    data.pic = ""
  else
    local pic_index = string.match(data.pic, "player_head_(%d+)")
    if pic_index == "1" then
      data.pic = "player_head_1_big.png"
    elseif pic_index == "3" then
      data.pic = "player_head_3_big.png"
    elseif pic_index == "25" then
      data.pic = "player_head_25_big.png"
    end
  end
  self:SetPageList()
  if self.uid == LuaEntry.Player.uid then
    if self.lastPhotoAlbumStrDes and (self.lastPic ~= self.data.pic or self.lastPicVer ~= self.data.picVer) then
      self.anim:SetActive(true)
      self.eff_anim:Play()
    end
  else
    self.anim:SetActive(false)
  end
  self.lastPic = self.data.pic
  self.lastPicVer = self.data.picVer
  self.lastPhotoAlbumStrDes = self.data.photoAlbumStrDes
end

function UILWPlayerDetailItem:HideAnim()
  self.anim:SetActive(false)
end

function UILWPlayerDetailItem:SetPageList()
  self.activePage = nil
  self.page_list:RemoveComponents(UILWPlayerDetailPage)
  self.theItem:GameObjectRecycleAll()
  local goItem, theItem
  local thePageList = {}
  local dataList = {}
  local picVerNow = 0
  if string.IsNullOrEmpty(self.data.pic) then
    picVerNow = self.data.picVer
    if self.data and self.data.slotInfo ~= nil then
      for _, picVer in ipairs(self.data.slotInfo) do
        if picVer ~= nil and picVer ~= 0 and picVerNow ~= picVer then
          table.insert(dataList, {
            uid = self.data.uid,
            pic = "",
            picVer = picVer
          })
        end
      end
      dataList = table.reverse(dataList)
    else
    end
  end
  table.insert(dataList, {
    uid = self.data.uid,
    pic = self.data.pic,
    picVer = picVerNow
  })
  local pageCount = #dataList
  for i, v in ipairs(dataList) do
    goItem = self.theItem:GameObjectSpawn(self.page_list.transform)
    goItem.name = "item_" .. i
    goItem:SetActive(true)
    theItem = self.page_list:AddComponent(UILWPlayerDetailPage, goItem.name)
    theItem:ReInit(i, pageCount, v.uid, v.pic, v.picVer)
    theItem:SetSiblingIndex(i - 1)
    theItem:ShowBlackMask()
    table.insert(thePageList, theItem)
  end
  self:SetEnable(1 < #thePageList)
  self.thePageList = thePageList
  self.activePage = theItem
  if theItem then
    theItem:HideBlackMask()
  end
end

function UILWPlayerDetailItem:OnScrollValueChange()
  if self.activePage then
    self.activePage:SetPosition(self.content:GetPosition())
  end
end

function UILWPlayerDetailItem:TryPlayFlipPageAnim()
  if self.activePage then
    self.lockScroll = true
    local lastItem
    for k, v in ipairs(self.thePageList) do
      if v ~= self.activePage then
        v:UpdateSiblingIndex(k)
        lastItem = v
      end
    end
    self.activePage:UpdateSiblingIndex(0)
    self.activePage:ShowBlackMask(0.25)
    self.activePage = lastItem
    self.nFlipPageAnimCounter = 3
    if lastItem then
      lastItem:HideBlackMask(0.25)
    end
    table.sort(self.thePageList, function(a, b)
      return a.pageIndex < b.pageIndex
    end)
  end
end

function UILWPlayerDetailItem:Update100MS()
  if self.lockScroll then
    if self.nFlipPageAnimCounter then
      self.nFlipPageAnimCounter = self.nFlipPageAnimCounter - 1
    end
    if self.isInDrag == false and toInt(self.nFlipPageAnimCounter) <= 0 then
      self.lockScroll = false
    end
  end
end

function UILWPlayerDetailItem:OnBtnIconClick()
  if self.uid == LuaEntry.Player.uid or LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SHOW_OTHER_PLAYER_BIG_ICON) > 0 then
    local picVerList = {}
    if self.thePageList then
      for k, v in ipairs(self.thePageList) do
        if v ~= self.activePage then
          table.insert(picVerList, v.picVer)
        end
      end
      picVerList = table.reverse(picVerList)
    end
    if self.activePage then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeadIconShow, {anim = true}, self.uid, self.activePage.pic, self.activePage.picVer, picVerList)
    end
  else
    UIUtil.ShowTips(Localization:GetString("2700007"))
  end
end

return UILWPlayerDetailItem
