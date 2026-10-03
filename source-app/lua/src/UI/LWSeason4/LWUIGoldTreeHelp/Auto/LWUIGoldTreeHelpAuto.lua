local LWUIGoldTreeHelpAuto = BaseClass("LWUIGoldTreeHelpAuto")
local infotext_str = "root/view/infoText"
local lwuigoldtreehelp_str = ""
local root_str = "root"

function LWUIGoldTreeHelpAuto:bind(view)
  view.txt_infotext = view:AddComponent(UIText, infotext_str)
  view.btn_lwuigoldtreehelp = view:AddComponent(UIButton, lwuigoldtreehelp_str)
  view.root = view:AddComponent(UIBaseContainer, root_str)
end

function LWUIGoldTreeHelpAuto:unbind(view)
  view.txt_infotext = nil
  view.btn_lwuigoldtreehelp = nil
  view.root = nil
end

return LWUIGoldTreeHelpAuto
