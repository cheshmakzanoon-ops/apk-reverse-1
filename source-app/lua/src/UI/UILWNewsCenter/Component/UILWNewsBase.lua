local UILWNewsBase = BaseClass("UILWNewsBase", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "imgTopBg/txtDate",
    name = "txtDate",
    type = UIText
  },
  {
    path = "imgTopBg/txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "imgTopBg/groupLike/imgNewIcon",
    name = "imgNewIcon",
    type = UIImage
  },
  {
    path = "imgTopBg/groupLike",
    name = "groupLike",
    type = nil
  },
  {
    path = "imgTopBg/groupLike/btnLike",
    name = "btnLike",
    type = UIButton
  },
  {
    path = "imgTopBg/groupLike/txtLike",
    name = "txtLike",
    type = UIText
  },
  {
    path = "txtComment",
    name = "txtComment",
    type = UIText
  }
}

function UILWNewsBase:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_UPLIKECOUNT, self.OnUpLike)
end

function UILWNewsBase:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_UPLIKECOUNT, self.OnUpLike)
  base.OnRemoveListener(self)
end

function UILWNewsBase:OnUpLike(info)
  if self.info.uuid == info.uuid then
    self:RefreshView(info)
  end
end

function UILWNewsBase:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  TimerManager:GetInstance():GetTimer(2, function()
    self:SetActive(false)
    self:SetActive(true)
  end, self, true, true):Start()
end

function UILWNewsBase:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.info = nil
end

function UILWNewsBase:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.btnLike:SetOnClick(function()
    if self.info then
      if self.info.hasLike > 0 then
        UIUtil.ShowTipsId(801142)
      else
        SFSNetwork.SendMessage(MsgDefines.NewsLike, self.info.uuid)
        self.view:ShowFloatLikeByPos(self.transform.position, true)
      end
      self.info.hasLike = 1
    end
  end)
end

function UILWNewsBase:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UILWNewsBase:RefreshView(info)
  self.info = info
  local second = math.floor(self.info.createTime / 1000)
  self.txtDate:SetText(UITimeManager:GetInstance():GetNewsDateTime(second))
  self.imgNewIcon:SetActive(self.info.isNew)
  self.txtLike:SetText(self.info.likeNum and self.info.likeNum > 0 and string.format("(%s)", string.GetFormattedStr(self.info.likeNum)) or "")
  TimerManager:GetInstance():GetTimer(2, function()
    if not IsNull(self.groupLike) then
      self.groupLike:SetActive(false)
      self.groupLike:SetActive(true)
    end
  end, self, true, true):Start()
end

return UILWNewsBase
