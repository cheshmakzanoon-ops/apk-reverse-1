local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local NoticePanel = {}

function NoticePanel.Create(loadingView, transform)
  assert(transform ~= nil, "LoadingNoticePanel.Create Error: transform is nil")
  local panel = setmetatable({}, {__index = NoticePanel})
  panel.loadingView = loadingView
  panel.transform = transform
  panel.gameObject = transform.gameObject
  panel:Init()
  return panel
end

function NoticePanel:Init()
  self.isActive = false
  self.isValid = true
  self.btnClose = self.transform:Find("Top/btn_close"):GetComponent(typeof(CS.UnityEngine.UI.Button))
  self.txtTop = self.transform:Find("Top/txt_top"):GetComponent(typeof(CS.UnityEngine.UI.Text))
  self.txtTop.text = Localization:GetString("2700004")
  self.transContent = self.transform:Find("Mid/Scroll View/Viewport/Content")
  self.txtTitle = self.transform:Find("Mid/txt_title"):GetComponent(typeof(CS.UnityEngine.UI.Text))
  self.txtBanner = self.transContent:Find("mask_banner/txt_banner"):GetComponent(typeof(CS.UnityEngine.UI.Text))
  self.txtDate = self.transContent:Find("mask_banner/txt_date"):GetComponent(typeof(CS.UnityEngine.UI.Text))
  self.txtTitle.text = ""
  self.txtBanner.text = ""
  self.txtDate.text = ""
  self.temp_h1 = self.transContent:Find("temp_h1").gameObject
  self.temp_h2 = self.transContent:Find("temp_h2").gameObject
  self.temp_h3 = self.transContent:Find("temp_h3").gameObject
  self.temp_text = self.transContent:Find("temp_text").gameObject
  self.temp_h1:SetActive(false)
  self.temp_h2:SetActive(false)
  self.temp_h3:SetActive(false)
  self.temp_text:SetActive(false)
  self.text_comps = {}
  
  function self.__onClickClose()
    self:OnClickClose()
  end
  
  self.btnClose.onClick:AddListener(self.__onClickClose)
end

function NoticePanel:Destroy()
  self.isActive = false
  self.isValid = false
  self.btnClose = nil
  self.txtTop = nil
  self.txtTitle = nil
  self.transContent = nil
  self.txtBanner = nil
  self.txtDate = nil
  self.temp_h1 = nil
  self.temp_h2 = nil
  self.temp_h3 = nil
  self.temp_text = nil
  self.text_comps = nil
  if not IsNull(self.btnClose) then
    self.btnClose.onClick:RemoveListener(self.__onClickClose)
  end
  self.__onClickClose = nil
  self.loadingView = nil
  self.transform = nil
  self.gameObject = nil
end

function NoticePanel:ParseJson(json)
  if not self.isValid then
    return
  end
  local jsonObj = rapidjson.decode(json)
  if jsonObj == nil then
    printError("Server Notice Error! json is invalid: " .. tostring(json))
    self:Close()
    return
  end
  self.txtTitle.text = tostring(jsonObj.title)
  self.txtBanner.text = tostring(jsonObj.banner)
  self.txtDate.text = tostring(jsonObj.date)
  local contents = jsonObj.contents
  if contents == nil then
    printError("Server Notice Error! content is nil: " .. tostring(json))
    self:Close()
    return
  end
  for _, item in ipairs(contents) do
    local func = self["CreateEntry_" .. item.style]
    if func == nil then
      printError("Server Notice Error! unknown style: " .. item.style)
      self:Close()
      return
    end
    func(self, item)
  end
end

function NoticePanel:Show()
  if not self.isValid then
    return
  end
  if self.isActive then
    return
  end
  self.gameObject:SetActive(true)
  self.transform.localScale = CS.UnityEngine.Vector3.one * 0.8
  self.transform:DOScale(CS.UnityEngine.Vector3.one, 0.2):SetEase(CS.DG.Tweening.Ease.OutBack)
  self.isActive = true
end

function NoticePanel:Close()
  if not self.isValid then
    return
  end
  self.gameObject:SetActive(false)
  self.isActive = false
  if self.OnClosed ~= nil then
    self.OnClosed()
  end
end

function NoticePanel:OnUpdate()
  if not self.isValid or not self.isActive then
    return
  end
  for i = #self.text_comps, 1, -1 do
    local textComp = self.text_comps[i]
    local height = textComp.transform.rect.height
    if 0 < height then
      textComp.transform.parent.sizeDelta = CS.UnityEngine.Vector2(textComp.transform.parent.sizeDelta.x, height)
      table.remove(self.text_comps, i)
    end
  end
end

function NoticePanel:OnClickClose()
  self:Close()
end

function NoticePanel:CreateEntry_h1(item)
  local entry = CS.UnityEngine.GameObject.Instantiate(self.temp_h1, self.transContent)
  entry:SetActive(true)
  entry:GetComponentInChildren(typeof(CS.UnityEngine.UI.Text)).text = tostring(item.text)
end

function NoticePanel:CreateEntry_h2(item)
  local entry = CS.UnityEngine.GameObject.Instantiate(self.temp_h2, self.transContent)
  entry:SetActive(true)
  entry.transform:Find("dot").gameObject:SetActive(item.dot)
  entry:GetComponentInChildren(typeof(CS.UnityEngine.UI.Text)).text = tostring(item.text)
end

function NoticePanel:CreateEntry_h3(item)
  local entry = CS.UnityEngine.GameObject.Instantiate(self.temp_h3, self.transContent)
  entry:SetActive(true)
  entry:GetComponentInChildren(typeof(CS.UnityEngine.UI.Text)).text = tostring(item.text)
end

function NoticePanel:CreateEntry_text(item)
  local entry = CS.UnityEngine.GameObject.Instantiate(self.temp_text, self.transContent)
  entry:SetActive(true)
  local textComp = entry:GetComponentInChildren(typeof(CS.UnityEngine.UI.Text))
  textComp.text = tostring(item.text)
  table.insert(self.text_comps, textComp)
end

return NoticePanel
