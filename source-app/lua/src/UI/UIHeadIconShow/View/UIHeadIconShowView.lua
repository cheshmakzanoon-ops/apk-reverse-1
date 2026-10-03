local UIHeadIconShowView = BaseClass("UIHeadIconShowView", UIBaseView)
local base = UIBaseView
local UIHeadIconShowPage = require("UI.UIHeadIconShow.Component.UIHeadIconShowPage")
local UITitleShowList = require("UI.LWTitle.Component.UITitleShowList")
local btnBg = "safearea/butBg"
local scroll_view_path = "safearea/Root/Head/ScrollView"
local content_path = "safearea/Root/Head/ScrollView/Viewport/Content"
local page_cell_path = "safearea/Root/Head/headIcon"

function UIHeadIconShowView:OnCreate()
  base.OnCreate(self)
  self.uid, self.pic, self.picVer, self.picVerList, self.headIconType = self:GetUserData()
  self.btnBg = self:AddComponent(UIButton, btnBg)
  self.loadingImg = self:AddComponent(UIImage, "safearea/Root/Head/imgLoading")
  self.scroll_view = self:AddComponent(UIScrollPage, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.thePageItem = self.transform:Find(page_cell_path).gameObject
  self.thePageItem:GameObjectCreatePool()
  self.btnBg:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self.scroll_view:SetPageChangedCallback(BindCallback(self, self.OnPageChanged))
  self.loadingImg:SetActive(true)
  self.titleRoot = self:AddComponent(UIBaseContainer, "safearea/Root/titleRoot")
  self.titleContent = self:AddComponent(UITitleShowList, "safearea/Root/titleRoot/Content")
  self.btnMore = self:AddComponent(UIButton, "safearea/Root/titleRoot/btnMore")
  self.btnMore:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITitleMain, {anim = true})
    self.ctrl:CloseSelf()
  end)
  self.headRoot = self:AddComponent(UIBaseContainer, "safearea/Root/Head")
  self.customIcon = self:AddComponent(UIRawImage, "safearea/Root/customIcon")
  self:Refresh()
end

function UIHeadIconShowView:OnDestroy()
  self.content:RemoveComponents(UIHeadIconShowPage)
  self.thePageItem:GameObjectRecycleAll()
  self.btnBg = nil
  self.uid = nil
  self.scroll_view = nil
  self.content = nil
  base.OnDestroy(self)
end

function UIHeadIconShowView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.Refresh)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.Refresh)
end

function UIHeadIconShowView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.Refresh)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.Refresh)
end

function UIHeadIconShowView:Refresh()
  self:OnUpdateHeadPic()
  self:OnUpDateTitle()
end

function UIHeadIconShowView:OnUpdateHeadPic()
  self.content:RemoveComponents(UIHeadIconShowPage)
  self.thePageItem:GameObjectRecycleAll()
  local headDataList = {}
  if self.headIconType ~= HeadIconType.Npc or not string.IsNullOrEmpty(self.picVer) then
    table.insert(headDataList, {
      uid = self.uid,
      pic = self.pic,
      picVer = self.picVer
    })
  end
  if self.picVerList then
    for _, picVer in ipairs(self.picVerList) do
      table.insert(headDataList, {
        uid = self.uid,
        pic = "",
        picVer = picVer
      })
    end
  end
  local headDataCount = #headDataList
  self.thePageNode = {}
  if 0 < headDataCount then
    for index, v in ipairs(headDataList) do
      local theName = "page_" .. index
      local goItem = self.thePageItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local itemNode = self.content:AddComponent(UIHeadIconShowPage, theName)
      table.insert(self.thePageNode, itemNode)
      itemNode:SetData(v, self.headIconType)
      if index == 1 then
        itemNode:ShowHeadIcon()
      end
    end
    self.loadingImg:SetActive(false)
  else
    self.loadingImg:SetActive(true)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self.scroll_view:SetPageCount(headDataCount)
  self.scroll_view:PageTo(1)
end

function UIHeadIconShowView:OnPageChanged(index)
  if self.thePageNode and self.thePageNode[index] then
    self.thePageNode[index]:ShowHeadIcon()
  end
end

function UIHeadIconShowView:OnUpDateTitle()
  if self.headIconType == HeadIconType.Npc then
    self.titleRoot:SetActive(false)
    return
  end
  local isSelf = self.uid == LuaEntry.Player.uid
  local data = UIUtil.GetPlayerInfoShowByUid(self.uid)
  if isSelf then
    if table.IsNullOrEmpty(DataCenter.PlayerInfoDataManager.titleList) then
      self.titleRoot:SetActive(false)
      return
    end
  elseif not data or table.IsNullOrEmpty(data.titleWall) then
    self.titleRoot:SetActive(false)
    return
  end
  self.btnMore:SetActive(isSelf)
  self.titleContent:Refresh(data.titleWall, data.uid, 0.7)
  self.titleRoot:SetActive(true)
end

return UIHeadIconShowView
