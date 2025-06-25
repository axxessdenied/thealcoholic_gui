function TheAlcoholic.UI.onRightClickItem(player, context, items)
    items = ISInventoryPane.getActualItems(items)
    local has_displayed = false
    for _, item in ipairs(items) do
        if item then
            if item:isAlcoholic() == true and has_displayed == false
            then
                local menu_str = TheAlcoholic.UI.visible and getText("UI_alcoholic_hide_button") or getText("UI_alcoholic_show_button")
                context:addOption(menu_str, player, ToggleAlcoholicGUI, item)
                has_displayed = true
            end
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(TheAlcoholic.UI.onRightClickItem)